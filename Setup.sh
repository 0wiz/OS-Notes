[ "$EUID" -eq 0 ] && echo -e "$0: Do not use script as root!" >&2 && exit $EXIT_FAILURE
[ -z "$BASH_VERSION" ] && echo -e "$0: Source the script with bash, don't run it!" >&2 && exit $EXIT_FAILURE

### 0 Declarations
  # 0.0 General
    dir=$(dirname "${BASH_SOURCE[0]}")
    firefox_dir="/home/$USER/.mozilla/firefox"
    [[ $(snap list firefox 2>&1) ]] && firefox_dir="/home/$USER/snap/firefox/common/.mozilla/firefox"
    ans=''

  # 0.1 Printing
    NC='\033[0m'
    R='\033[0;31m'
    G='\033[0;32m'
    B='\033[0;34m'
    bf=$(tput bold)
    nf=$(tput sgr0)
    section() {
      echo -e "\n$B$bf$1$nf$NC"
    }
    subsection() {
      echo -e "$G$1$NC"
    }
    sumsed() {
      sed "s/\(Summary\)/\1 ($1)/"
    }
    filter() {
      grep -Ev "$1|caution in scripts|^$" | sumsed $2
    }

### 1 Uninstalls
  section 'Uninstallations'
  list=(
    brasero brasero-common nautilus-extension-brasero
    cheese
    eog
    evince evince-common
    evolution evolution-data-server
    geary
    gnome-calendar
    gnome-characters
    gnome-clocks
    gnome-contacts
    gnome-font-viewer
    gnome-logs
    gnome-photos
    gnome-sound-recorder
    gnome-weather
    libreoffice-common libreoffice-core libreoffice-style-yaru
    remmina
    rhythmbox
    totem
  )
  
  sudo apt -qq purge ${list[@]} 2>&1 | filter 'not removed' 'purge'
  sudo apt -qqy autoremove 2>&1 | filter 'null' 'autoremove'
  echo -e '\nThese similar packages were NOT REMOVED:'
  sudo dpkg --get-selections | grep -E "($(IFS="|"; echo "${list[*]}"))"
  echo -e 'Press [Ctrl+C] to cancel and [Enter] to continue.' && read

### 2 Updates
    section 'Updates'
    subsection 'Looking for system updates...'
    sudo apt-get -qy update
    sudo apt -y full-upgrade 2>&1 | filter '...' 'upgrade'

    subsection '\nPreparing flatpak and snap...'
    sudo apt -qqy install flatpak snapd 2>&1 | filter 'null' 'install'
    sudo flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
    flatpak -y update | filter 'Looking for updates' 'flatpak'
    sudo snap refresh

    subsection '\nLooking for firmware updates...'
    fwupdmgr get-devices >/dev/null
    fwupdmgr get-updates && fwupdmgr -y update
    rm -rf ~/.cache/gnome-software
  
### 3 Installs
    section '\nInstallations'
  # 3.0 Standard Apps
    sudo snap install --classic code
    sudo snap install spotify
    flatpak -y install flathub org.gnome.Loupe com.github.rafostar.Clapper
    sudo apt -qqy install git ffmpeg pipx firefox 2>&1 | filter 'null' 'install'
    echo "alias py=python3" >> ~/.bashrc
    git config --global user.name Owiz
    git config --global user.email owiz@protonmail.com
    #pipx -q install numpy gnome-extensions-cli
    #gext install wintile@nowsci.com # Drag using Ctrl to individual tiles and Ctrl+Super to combined tiles.
    dconf load / < "$dir/dconf_backup"
    profile=$(grep 'Path=.*default-release' $firefox_dir/profiles.ini | sed s/^Path=//)
    cp -a "$dir/Firefox/." "$firefox_dir/$profile/" # Currently: Bookmark icons & cookie-exception settings
  
  # 3.1 Optional Apps
    if ! dpkg -s steam &>/dev/null; then
      while [[ ! $ans =~ (y|n) ]]; do read -p 'Install Steam? [Y/n] ' ans; done
      if [[ $ans == 'y' ]]; then
        flatpak -y install flathub com.valvesoftware.Steam
        sudo apt -qqy install steam-devices
      fi
    fi
  
  # 3.2 Clean-Up
    section '\nClean-Up'
    sudo apt -qqy autoremove 2>&1 | filter 'null' 'autoremove'
    sudo apt clean
    read -p 'Press [Ctrl+C] to cancel and [Enter] to reboot system.' && sudo reboot now
