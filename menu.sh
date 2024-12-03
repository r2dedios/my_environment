#!/bin/bash
LOG_FILE="/tmp/avillegas_installer.log"

modules=()
SCRIPTPATH="$( cd "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"

function install_bash {
  echo "Installing Bash Config"
  [[ -f ~/.bash_profile ]] && { mv ~/.bash_profile /tmp/bashrc_old; }
  ln -s $SCRIPTPATH/bash_config/bash_profile ~/.bash_profile
  sleep 1
}
function install_vim {
  echo "Installing ViM Config"
  [[ -f ~/.vimrc ]] && { mv ~/.vimrc /tmp/vimrc_old; }
  ln -s $SCRIPTPATH/vim_config/vimrc ~/.vimrc
  echo "Installing VundleVim"
  curl -L "https://github.com/VundleVim/Vundle.vim/archive/master.zip" -o /tmp/vundlevim.zip 2>&1
  mkdir -p ~/.vim/bundle
  unzip -o /tmp/vundlevim.zip -d /tmp/
  [[ -d ~/.vim/bundle/Vundle.vim ]] && { rm -Rf ~/.vim/bundle/Vundle.vim; }
  mv /tmp/Vundle.vim-master ~/.vim/bundle/Vundle.vim 2>&1
  echo "Installing Vim Plugins"
  bash -c "exec $(which vim) --not-a-term -c \"syntax off\" -c \":PluginInstall\"" 2>&1 >/dev/null
  echo -e "\nViM installed and configured"
  rm /tmp/vundlevim.zip
  sleep 1
}
function install_i3wm {
  echo "Installing i3wm Config"
  [[ -f ~/.config/i3/config ]] && { mv ~/.config/i3/config /tmp/i3_config_old; } || { mkdir -p ~/.config/i3/config; }
  ln -s $SCRIPTPATH/i3wm_config/i3wm_config ~/.config/i3/config
  ln -s $SCRIPTPATH/i3wm_config/scripts ~/.config/i3/scripts

}
function install_extra {
  echo "Installing extra packages (require sudo)"
  local os_release=$(cat /etc/os-release | grep -e "^NAME=.*$" | sed 's/NAME=\(.*\)/\1/g')
  case $os_release in
    Fedora) sudo dnf install tree ack git vim ;;
    *) echo "Unsuported Linux Dist: $os_release" ;;
  esac
}

function install {
  for module in ${modules[@]}; do
    case $module in
      bash) install_bash ;;
      vim) install_vim ;;
      i3wm) install_i3wm ;;
      extra) install_extra ;;
      *) echo $module; sleep 1 ;;
    esac
  done 2>&1 > $LOG_FILE
  echo "-- Installation Finished. Press ENTER to finish" >> $LOG_FILE
}



#[[ $(id -u) -ne 0 ]] && { dialog --title "Permission Denied" --msgbox "This script needs sudo permissions to install some system packages.\nTry it again running as root" 10 80; clear; exit; }



cmd=(dialog --title "Alejandro Villegas configuration installer" --separate-output --checklist "Select packages to install:" 22 76 16)
options=(1 "Bash" on
         2 "ViM" on
         3 "i3wm" on
         4 "Extra tools (require sudo)" off)
choices=$("${cmd[@]}" "${options[@]}" 2>&1 >/dev/tty)
[[ $? -eq 1 ]] && { dialog --title "Aborted" --msgbox "Installation Aborted" 7 80; clear; exit; }
clear
for choice in $choices
do
  case $choice in
    1) modules+=("bash") ;;
    2) modules+=("vim") ;;
    3) modules+=("i3wm") ;;
    5) modules+=("extra") ;;
  esac
done

dialog --yesno "This script will overwrite $USER's previous configuration.\nAre you Sure?" 0 0
[[ $? -eq 1 ]] && { dialog --title "Aborted" --msgbox "Installation Aborted" 7 80; clear; exit; }

touch $LOG_FILE
install &

dialog --tailbox $LOG_FILE 50 150
rm $LOG_FILE
clear
