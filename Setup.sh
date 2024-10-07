#!/bin/sh -u

### 1 Permissions
  sudo -i # Enters root for the current terminal session.
  visudo # Opens the config for terminal password requests using nano.
  # Set "%admin    ALL=(ALL:ALL) NOPASSWD:ALL", then Ctrl+Shift+O to save and Ctrl+Shift+X to exit nano.
  # In "Passwords and Keys" goto Password->Login->Change, and leave it blank to prevent keyring password requests.
  apt-mark manual gdm3 gnome-shell gnome-browser-connector # Protects the specified packages from auto-removal.

### 2 Uninstalls
  # 2.0 Identify Specific Package Names
    list='libreoffice geary evince brasero zorin-connect evolution totem'
    gnome_list='calender characters contacts photos weather'
    list="$(for v in $list; do printf "$v|"; done)$(for v in $gnome_list; do printf "gnome-$v|"; done)"
    apt list --installed | grep -E '(${list%|})'

  # 2.1 Update List & Purge
    apt -y purge *libreoffice* *geary* *evince* *brasero* *zorin-connect* *evolution*
    apt -y purge *gnome-calendar* *gnome-characters* *gnome-contacts* *gnome-photos* *gnome-weather* *totem*
    apt -y purge *libreoffice-calc* *libreoffice-draw* *libreoffice-impress* *libreoffice-math* *libreoffice-writer*

### 3 Update & Clean
  apt -y update
  apt -y upgrade
  apt -y dist-upgrade
  fwupdmgr get-devices
  fwupdmgr get-updates
  fwupdmgr -y update
  flatpak update
  rm -rf ~/.cache/gnome-software
  apt -y autoremove
  apt clean
  read -p 'Press [Enter] to reboot system' && reboot now

### 4 Setup Software
  # 4.0 Simple Installs
  apt -y install ffmpeg
  snap install --classic code spotify
  flatpak install flathub org.gnome.Loupe com.github.rafostar.Clapper

  # 4.1 Firefox
  # Copy profile files into ~/.mozilla/firefox/xxxxxxxx.default-release/

  # 4.2 Git
    git config --global user.name Owiz
    git config --global user.email owiz@protonmail.com

  # 4.3 Python
    apt -y install python3 # Consider using a pre-installed version, Ubuntu has Python among its dependencies.
    echo "alias py=python3" >> ~/.bashrc
    source ~/.bashrc

  # 4.4 Node.js & TypeScript
    # Install Node Version Manager (nvm) as described on github.com/nvm-sh/nvm
    nvm install <version> # Specifying major version seems to get Node LTS.
    apt -y install node-typescript

### 5 Zorin 17
  # 5.0 WinTile
    # Goto extensions.gnome.org and install WinTile.
    # Drag using Ctrl to individual tiles and Ctrl+Super to combined tiles.
    # Seems WinTile reconfigures Ctrl+Super+Arrow hotkeys.

  # 5.1 Steam
    # Get Steam and steam-devices via software manager.
    # Start controllers before starting games. Update controllers via Windows.

  # 5.2 Windows Apps
    # Try "Windows App Support" in software manager.

### 6 Miscellaneous
  # 6.0 Shortcuts
    chmod +x ~/Documents/GitHub/Bash-scripts/Toggle_GNOME-topbar.sh
    # Add keyboard shortcut "bash /home/admin/Documents/GitHub/Bash-scripts/Toggle_GNOME-topbar.sh".
    # Install dconf Editor and set /org/desktop/wm/keybindings/always-on-top to ['<Super>A'].