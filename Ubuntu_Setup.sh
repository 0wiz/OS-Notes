[ "$EUID" -eq 0 ] && echo -e "$0: Do not run script as root!" >&2 && exit $EXIT_FAILURE
[ -z "$BASH_VERSION" ] && echo -e "$0: Source the script with bash, don't run it!" >&2 && exit $EXIT_FAILURE

### Declarations
  ans=''
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

### Uninstalls
  section 'Uninstalls'
  list=(
    gnome-calculator
    gnome-characters
    gnome-clocks
    gnome-font-viewer
    nautilus-sendto
  )

  sudo apt -qq purge ${list[@]} 2>&1 | filter 'not removed' 'purge'
  sudo apt -qqy autoremove 2>&1 | filter 'null' 'autoremove'
  echo -e '\nThese similar packages were NOT REMOVED:'
  sudo dpkg --get-selections | grep -E "($(IFS="|"; echo "${list[*]}"))"
  echo -e 'Press [Ctrl+C] to cancel and [Enter] to continue.' && read

### Updates
  section 'Updates'
  subsection 'Preparing apt...'
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
  
### Installs
  section '\nInstalls'

  # Standard Apps
  sudo snap install --classic code
  sudo snap install spotify
  sudo snap install vlc
  #flatpak -y install flathub com.google.Chrome org.gnome.Loupe com.github.rafostar.Clapper
  sudo apt -qqy install git ffmpeg gnome-browser-connector -full 2>&1 | filter 'null' 'install'
  echo "alias py=python3" >> ~/.bashrc
  git config --global user.name Owiz
  git config --global user.email owiz@protonmail.com

### Finalizing
  section '\nFinalizing'
  # Configuration
  gsettings set org.gnome.mutter check-alive-timeout 60000
  
  # Clean-Up
  section 'Clean-Up'
  sudo apt -qqy autoremove 2>&1 | filter 'null' 'autoremove'
  sudo apt clean
  read -p 'Press [Ctrl+C] to cancel and [Enter] to reboot system.' && sudo reboot now
