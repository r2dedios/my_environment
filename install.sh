#!/bin/bash

# Log File path
LOG_FILE="/tmp/avillegas_installer.log"

# Global Vars
modules=()
SCRIPTPATH="$( cd "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"
RUN_DATE="$(date +%s)"
CUSTOM_ALIASES_PATH=$HOME/.bash_custom_alias

# Install Packages
TO_INSTALL_RPM_PACKAGES="vim git tree ack git tmux curl wget jq yq fzf htop flameshot okular i3blocks dunst"

# Auxiliar function to backup dotfiles. Use absolut paths to avoid errors
function backup_file {
  local source=$1
  local dest=$source-$RUN_DATE.bck

  [[ -f "$source" && ! -L "$source" ]] && { mv $source $dest; }
}

# Auxiliar funciton to link dotfiles
function link_file {
  local source=$1
  local dest=$2

  # If the simlink already exists, remove it and then create it from scratch
  [[ -L $dest ]] && { unlink $dest; }
  ln -s -f $SCRIPTPATH/$source $dest
}

# Install Bash config
function install_bash_config {
  backup_file $HOME/.bash_profile
  link_file bash_config/bashrc $HOME/.bash_profile

  backup_file $HOME/.bashrc
  link_file bash_config/bashrc $HOME/.bashrc

  echo "-- Installed Bash config for user: '$USER'"
}

# Install Bash k8s aliases
function init_bash_custom_alias {
  mkdir -p $CUSTOM_ALIASES_PATH
}

function install_bash_k8s_alias {
  init_bash_custom_alias
  link_file bash_config/bash_k8s_alias $CUSTOM_ALIASES_PATH/bash_k8s_alias
  echo -e "-- Installed Bash k8s/OCP Aliases for user: '$USER'"
}

# Install vim config and update plugins
function install_vim_config {
  backup_file $HOME/.vimrc
  link_file vim_config/vimrc $HOME/.vimrc
  echo "-- Installed ViM config for user: '$USER'"

  mkdir -p $HOME/.vim/bundle
  curl -L -s -o /tmp/vundle.zip https://github.com/VundleVim/Vundle.vim/archive/refs/heads/master.zip 2>&1
  unzip -o -q /tmp/vundle.zip -d /tmp
  rm -Rf $HOME/.vim/bundle/Vundle.vim
  mv /tmp/Vundle.vim-master $HOME/.vim/bundle/Vundle.vim
  rm /tmp/vundle.zip
  echo "-- Installed Vundle ViM package manager"

  mkdir -p $HOME/.vim/colors
  link_file vim_config/color_schemes/villegas.vim $HOME/.vim/colors/villegas.vim
  echo "-- Installed Vundle ViM color schemes"

  vim -E -s +PluginInstall +qall
  echo "-- Installed ViM packages"
}

function install_dunst_config {
  mkdir -p $HOME/.config/dunst

  backup_file $HOME/.config/dunst/dunstrc
  link_file dunst_config/dunstrc $HOME/.config/dunst/dunstrc
  echo "-- Installed dunst config"
}


function install_i3wm_config {
  mkdir -p $HOME/.config/i3

  backup_file $HOME/.config/i3/config
  link_file i3wm_config/i3wm_config $HOME/.config/i3/config
  echo "-- Installed i3wm config"

  mkdir -p $HOME/.config/i3/i3status
  link_file i3wm_config/i3blocks_top_bar.conf $HOME/.config/i3/top_bar.conf
  link_file i3wm_config/i3status_bottom_bar.conf $HOME/.config/i3/bottom_bar.conf
  echo "-- Installed i3status config"

  link_file i3wm_config/scripts $HOME/.config/i3/scripts
  echo "-- Installed i3wm scripts"
}

function install_extra {
  local os_release=$(cat /etc/os-release | grep -e "^NAME=.*$" | sed 's/NAME=\(.*\)/\1/g')

  case $os_release in
    Fedora)
      echo "-- Installing packages"
      sudo dnf install $TO_INSTALL_RPM_PACKAGES ;;
    *) echo "Unsuported Linux Dist: $os_release" ;;
  esac
}

function install {
  for module in ${modules[@]}; do
    case $module in
      bash) install_bash_config ;;
      k8s_alias) install_bash_k8s_alias ;;
      vim) install_vim_config ;;
      i3wm) install_i3wm_config ;;
      dunst) install_dunst_config ;;
      extra) install_extra ;;
      *) echo $module; sleep 1 ;;
    esac
  done 2>&1 > $LOG_FILE
  echo "-- Installation Finished. Press ENTER to finish" >> $LOG_FILE
}

cmd=(dialog --title "Alejandro Villegas configuration installer" --separate-output --checklist "Select packages to install:" 22 76 16)
options=(
  1 "Bash" on
  2 "Bash K8s/OCP aliases" on
  3 "ViM" on
  4 "i3wm" on
  5 "dunst" on
  6 "Extra Packages (require sudo)" off
)
choices=$("${cmd[@]}" "${options[@]}" 2>&1 >/dev/tty)
[[ $? -eq 1 ]] && { dialog --title "Aborted" --msgbox "Installation Aborted" 7 80; clear; exit; }
clear

# Reviewing selected options
for choice in $choices
do
  case $choice in
    1) modules+=("bash") ;;
    2) modules+=("k8s_alias") ;;
    3) modules+=("vim") ;;
    4) modules+=("i3wm") ;;
    5) modules+=("dunst") ;;
    6) modules+=("extra") ;;
  esac
done

dialog --yesno "This script will overwrite $USER's previous configuration.\nAre you Sure?" 0 0
[[ $? -eq 1 ]] && { dialog --title "Aborted" --msgbox "Installation Aborted" 7 80; clear; exit; }

touch $LOG_FILE
install &

dialog --tailbox $LOG_FILE 50 150
rm $LOG_FILE
clear
