#!/bin/bash

# Log File path
LOG_FILE="$(mktemp --suffix=-avillega-env-log)"

# Global Vars
modules=()
SCRIPTPATH="$( cd "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"
RUN_DATE="$(date +%s)"
CUSTOM_ALIASES_PATH=$DEST_USER_HOME_DIR/.bash_custom_alias

# Install Packages
PACKAGES_BASIC="vim git tmux curl wget gcc make"
PACKAGES_EXTRA="tree ack jq yq fzf htop flameshot okular i3blocks i3status dunst"

# Suckless software configs
SUCKLESS_GIT_URL="https://git.suckless.org/"

# Auxiliar function to backup dotfiles. Use absolut paths to avoid errors
function backup_file() {
  local source=$1
  local dest=$source-$RUN_DATE.bck

  [[ -f "$source" && ! -L "$source" ]] && { mv $source $dest; chown $DEST_USER:$DEST_USER $dest ; }
}

# Auxiliar funciton to link dotfiles
function link_file() {
  local source=$1
  local dest=$2

  # If the simlink already exists, remove it and then create it from scratch
  [[ -L $dest ]] && { unlink $dest; }
  ln -s -f $SCRIPTPATH/$source $dest
  chown -h $DEST_USER:$DEST_USER $dest
}

function create_dir() {
  local dir=$1

  mkdir -p $dir
  chown $DEST_USER:$DEST_USER $dir
}

# Install Bash config
function install_bash_config() {
  backup_file $DEST_USER_HOME_DIR/.bash_profile
  link_file bash_config/bashrc $DEST_USER_HOME_DIR/.bash_profile

  backup_file $DEST_USER_HOME_DIR/.bashrc
  link_file bash_config/bashrc $DEST_USER_HOME_DIR/.bashrc

  echo "-- Installed Bash config for user: '$DEST_USER'"
}

# Install Bash k8s aliases
function init_bash_custom_alias() {
  create_dir $CUSTOM_ALIASES_PATH
  chown $DEST_USER:$DEST_USER $CUSTOM_ALIASES_PATH
}

function install_bash_k8s_alias() {
  init_bash_custom_alias
  link_file bash_config/bash_k8s_alias $CUSTOM_ALIASES_PATH/bash_k8s_alias
  echo -e "-- Installed Bash k8s/OCP Aliases for user: '$DEST_USER'"
}

# Install vim config and update plugins
function install_vim_config() {
  backup_file $DEST_USER_HOME_DIR/.vimrc
  link_file vim_config/vimrc $DEST_USER_HOME_DIR/.vimrc
  echo "-- Installed ViM config for user: '$DEST_USER'"

  create_dir $DEST_USER_HOME_DIR/.vim/bundle
  curl -L -s -o /tmp/vundle.zip https://github.com/VundleVim/Vundle.vim/archive/refs/heads/master.zip 2>&1
  unzip -o -q /tmp/vundle.zip -d /tmp
  rm -Rf $DEST_USER_HOME_DIR/.vim/bundle/Vundle.vim
  mv /tmp/Vundle.vim-master $DEST_USER_HOME_DIR/.vim/bundle/Vundle.vim
  rm /tmp/vundle.zip
  echo "-- Installed Vundle ViM package manager"

  create_dir $DEST_USER_HOME_DIR/.vim/colors
  link_file vim_config/color_schemes/villegas.vim $DEST_USER_HOME_DIR/.vim/colors/villegas.vim
  echo "-- Installed Vundle ViM color schemes"

  vim -E -s +PluginInstall +qall
  echo "-- Installed ViM packages"
}

function install_i3wm_config() {
  create_dir $DEST_USER_HOME_DIR/.config/i3

  backup_file $DEST_USER_HOME_DIR/.config/i3/config
  link_file i3wm_config/i3wm_config $DEST_USER_HOME_DIR/.config/i3/config
  echo "-- Installed i3wm config"

  create_dir $DEST_USER_HOME_DIR/.config/i3/i3status
  link_file i3wm_config/i3blocks_top_bar.conf $DEST_USER_HOME_DIR/.config/i3/top_bar.conf
  link_file i3wm_config/i3status_bottom_bar.conf $DEST_USER_HOME_DIR/.config/i3/bottom_bar.conf
  echo "-- Installed i3status config"

  link_file i3wm_config/scripts $DEST_USER_HOME_DIR/.config/i3/scripts
  echo "-- Installed i3wm scripts"
}

function install_basic_packages() {
  install_packages $PACKAGES_BASIC
  echo "-- Basic packages installed correctly"
}

function install_extra_packages() {
  install_packages $PACKAGES_EXTRA
  echo "-- Extra packages installed correctly"
}

function install_packages() {
  local packages=$1
  local os_release=$(cat /etc/os-release | grep -e "^NAME=.*$" | sed 's/NAME=\(.*\)/\1/g')

  case $os_release in
    "Fedora"|"Fedora Linux")
      echo "-- Installing packages"
      sudo dnf install -y --quiet $packages ;;
    *) echo "Unsuported Linux Dist: $os_release" ;;
  esac
}

function install_dunst_config() {
  create_dir $DEST_USER_HOME_DIR/.config/dunst

  backup_file $DEST_USER_HOME_DIR/.config/dunst/dunstrc
  link_file dunst_config/dunstrc $DEST_USER_HOME_DIR/.config/dunst/dunstrc
  echo "-- Installed dunst config"
}

function install_suckless_packages() {
  create_dir $DEST_USER_HOME_DIR/.local/bin

  install_suckless_dmenu
  install_suckless_st

  echo "-- Installed Suckless Software components"
}

function install_suckless_dmenu() {
  local dmenu_dir=$SCRIPTPATH/suckless/dmenu
  create_dir $dmenu_dir/build

  [[ -d $dmenu_dir/build ]] && { rm -Rf $dmenu_dir/build/* ; }
  git clone $SUCKLESS_GIT_URL/dmenu  $dmenu_dir/build 2>&1
  cd $dmenu_dir/build
  git apply ../patches/dmenu-highlight-20201211-fcdc159.diff
  git apply ../patches/dmenu-center-20250407-b1e217b.diff
  make
  cp dmenu $DEST_USER_HOME_DIR/.local/bin
  make clean
  cd -

  echo "-- Installed custom Suckless Dmenu"
}

function install_suckless_st() {
  echo "-- Installed custom Suckless ST"
}

function select_target_user() {
	# Getting user list with UID >= 1000
  local users
  users=$(awk -F: '$3 >= 1000 && $1 != "nobody" {print $1}' /etc/passwd)

	# Transforming user list into 'dialog' list format
  local opts=()
  for u in $users; do
    opts+=("$u" "")
  done

  local outfile
  outfile=$(mktemp)

  dialog --clear \
    --title "Select target user" \
    --menu "Choose the user for the environment installation:" 15 50 8 \
    "${opts[@]}" 2>"$outfile"

  local rc=$?
  if [ "$rc" -ne 0 ]; then
    rm -f "$outfile"
    echo ""
    return 1
  fi

  local selected
  selected=$(cat "$outfile")
  rm -f "$outfile"

	DEST_USER="$selected"
}

function install() {
  DEST_USER_HOME_DIR="$(getent passwd "$DEST_USER" | cut -d: -f6)"
	CUSTOM_ALIASES_PATH=$DEST_USER_HOME_DIR/.bash_custom_alias

  echo "-- Preparing installation for user '$DEST_USER'" > $LOG_FILE
  for module in ${modules[@]}; do
    case $module in
      basic_packages) install_basic_packages ;;
      bash) install_bash_config ;;
      k8s_alias) install_bash_k8s_alias ;;
      vim) install_vim_config ;;
      i3wm) install_i3wm_config ;;
      dunst) install_dunst_config ;;
      suckless) install_suckless_packages ;;
      extra) install_extra_packages ;;
      *) echo "-- Missing module: '$module'"; sleep 1 ;;
    esac
  done 2>&1 >> $LOG_FILE
  echo "-- Installation Finished. Press ENTER to finish" >> $LOG_FILE
}

select_target_user

cmd=(dialog --title "Alejandro Villegas configuration installer" --separate-output --checklist "Select components to install (target user: $DEST_USER):" 22 76 16)
options=(
  1 "Basic Packages" on
  2 "Bash" on
  3 "Bash K8s/OCP aliases" on
  4 "ViM" on
  5 "i3wm" on
  6 "dunst" on
  7 "Suckless software tools (Requires: git, make, gcc)" off
  8 "Extra Packages (require sudo)" off
)
choices=$("${cmd[@]}" "${options[@]}" 2>&1 >/dev/tty)
[[ $? -eq 1 ]] && { dialog --title "Aborted" --msgbox "Installation Aborted" 7 80; clear; exit; }
clear

# Reviewing selected options
for choice in $choices
do
  case $choice in
    1) modules+=("basic_packages") ;;
    2) modules+=("bash") ;;
    3) modules+=("k8s_alias") ;;
    4) modules+=("vim") ;;
    5) modules+=("i3wm") ;;
    6) modules+=("dunst") ;;
    7) modules+=("suckless") ;;
    8) modules+=("extra") ;;
  esac
done

dialog --yesno "This script will overwrite user: '$DEST_USER' previous configuration.\nAre you Sure?" 0 0
[[ $? -eq 1 ]] && { dialog --title "Aborted" --msgbox "Installation Aborted" 7 80; clear; exit; }

touch $LOG_FILE
install &

dialog --tailbox $LOG_FILE 50 150

rm $LOG_FILE
clear
