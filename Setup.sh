#!/bin/bash -u

ans=''

### 1 Permissions
  sudo visudo # Opens the config for terminal password requests using nano.
  # Set "%admin    ALL=(ALL:ALL) NOPASSWD:ALL", then Ctrl+Shift+O to save and Ctrl+Shift+X to exit nano.
  # In "Passwords and Keys" goto Password->Login->Change, and leave it blank to prevent keyring password requests.
  sudo apt-mark manual gdm3 gnome-shell gnome-browser-connector # Protects the specified packages from auto-removal.

### 2 Uninstalls
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
    
    sudo apt purge ${list[@]} # Read before approving operation.
    echo -e '\nThese similar packages were NOT REMOVED:'
    sudo dpkg --get-selections | grep -E "($(IFS="|"; echo "${list[*]}"))"
    echo -e '\nPress [Ctrl+C] to cancel and [Enter] to continue.' && read

### 3 Installs
  # 3.0 Updates
  sudo apt -y update && sudo apt -y dist-upgrade
  fwupdmgr get-devices >/dev/null
  fwupdmgr get-updates && fwupdmgr -y update
  flatpak update
  rm -rf ~/.cache/gnome-software
  
  # 3.1 Standard Apps
  snap install --classic code
  snap install spotify
  flatpak -y install flathub org.gnome.Loupe com.github.rafostar.Clapper
  apt -y install git ffmpeg
  git config --system user.name Owiz
  git config --system user.email owiz@protonmail.com
  
  # 3.2 Optional Apps
  while [[ ! $ans =~ (y|n) ]]; do read -p 'Install Steam (y/n): ' ans; done
  if [[ $ans == 'y' ]]; then
    flatpak -y install flathub com.valvesoftware.Steam
    apt -y install steam-devices
  fi
  
  # 3.3 Clean
  sudo apt -y autoremove
  sudo apt clean
  read -p 'Press [Ctrl+C] to cancel and [Enter] to reboot system.' && sudo reboot now

### 4 Setup Software
  # 4.0 Firefox
  # Copy profile files into ~/.mozilla/firefox/xxxxxxxx.default-release/

  # 4.1 Python
    apt -y install python3 # Consider using a pre-installed version, Ubuntu has Python among its dependencies.
    echo "alias py=python3" >> ~/.bashrc
    source ~/.bashrc

  # 4.2 Node.js & TypeScript
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
