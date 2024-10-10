[ "$EUID" -eq 0 ] && echo -e "$0: Do not use script as root!" >&2 && exit $EXIT_FAILURE
[ $0 != 'bash' ] && echo -e "$0: Source the script with bash, don't run it!" >&2 && exit $EXIT_FAILURE

### 0 Declarations
  # 0.0 General
    dir=$(dirname "${BASH_SOURCE[0]}")
    ans=''

  # 0.1 Printing
    NC='\033[0m'
    R='\033[0;31m'
    B='\033[0;34m'
    bf=$(tput bold)
    nf=$(tput sgr0)
    section() {
      echo -e "$B$bf$@$nf$nc"
    }

### 1 Uninstalls
  list=(
    brasero brasero-common nautilus-extension-brasero
    cheese
    eog
    evince
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
    zorin-connect gnome-shell-extension-zorin-connect gnome-shell-extension-zorin-connect-browsers
    zorin-os-upgrader
  )
  
  section '\nUninstalling Apps'
  sudo apt purge ${list[@]} # Read before approving operation.
  echo -e '\nThese similar packages were NOT REMOVED:'
  sudo dpkg --get-selections | grep -E "($(IFS="|"; echo "${list[*]}"))"
  echo -e 'Press [Ctrl+C] to cancel and [Enter] to continue.' && read

### 2 Installs
  # 2.0 Updates
    section 'Updating System'
    echo 'Looking for updates...'
    sudo apt -qqy update && sudo apt -qqy dist-upgrade
    flatpak update
    fwupdmgr get-devices >/dev/null
    fwupdmgr get-updates && fwupdmgr -y update
    rm -rf ~/.cache/gnome-software
  
  # 2.1 Standard Apps
    section '\nInstalling Apps'
    sudo snap install --classic code
    sudo snap install spotify
    flatpak -y install flathub org.gnome.Loupe com.github.rafostar.Clapper
    sudo apt -y install git ffmpeg python3 python3-pip firefox
    echo "alias py=python3" >> ~/.bashrc
    git config --global user.name Owiz
    git config --global user.email owiz@protonmail.com
    pip -q install numpy gnome-extensions-cli
    gext install wintile@nowsci.com # Drag using Ctrl to individual tiles and Ctrl+Super to combined tiles.
    dconf load / < "$dir/dconf_backup"
    firefox_profile=$(grep 'Path=.*default-release' ~/.mozilla/firefox/profiles.ini | sed s/^Path=//)
    cp -a "$dir/Firefox/." ".mozilla/firefox/$firefox_profile/" # Currently: Bookmark icons & cookie-exception settings
  
  # 2.2 Optional Apps
    while [[ ! $ans =~ (y|n) ]]; do read -p 'Install Steam? [Y/n] ' ans; done
    if [[ $ans == 'y' ]]; then
      flatpak -y install flathub com.valvesoftware.Steam
      sudo apt -qqy install steam-devices
    fi
  
  # 2.3 Clean
    section '\nCleaning Up'
    sudo apt -y autoremove
    sudo apt clean
    read -p 'Press [Ctrl+C] to cancel and [Enter] to reboot system.' && sudo reboot now
