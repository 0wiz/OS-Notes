### 1 System Permissions
  sudo -i # Enters root for the current terminal session.

  # 1.0 Slacken Terminal Password Security
    sudo visudo # Opens the config for terminal password requests using nano.
    # Set "%admin    ALL=(ALL:ALL) NOPASSWD:ALL", then Ctrl+Shift+O to save and Ctrl+Shift+X to exit nano.

  # 1.1 Slacken GUI Password Security
  # In "Passwords and Keys" goto Password->Login->Change, and leave it blank to prevent keyring password requests.
  # If no keyring is created, logging into VS Code will prompt one, or just goto Add->'Password Keyring'.

### 2 Other System Commands
  # FYI: Nautilus mounts drives in /media/<user>/
  dpkg --get-selections | grep <package>
  dconf dump / > dconfdump # Saves a bunch of gnome-managed settings to file 'dconfdump'.
  dconf load / < dconfdump # Loads the gnome-managed settings of file 'dconfdump'.
  lsb_release -a # Prints the OS version

### 3 App Installation
  # 3.0 Node.js & TypeScript
    # Install Node Version Manager (nvm) as described on github.com/nvm-sh/nvm
    nvm install <version> # Specifying major version seems to get Node LTS.
    apt -y install node-typescript

  # 3.1 Beekeeper Studio
    flatpak -y install flathub io.beekeeperstudio.Studio
    sudo flatpak override io.beekeeperstudio.Studio --filesystem=host

### 4 App Usage
  # 4.0 Wine
    # WARNING: Wine is very sensitive, haven't yet found a way to reset (other than to reinstall Linux).
    winecfg               #| Config GUI for wine with a few WinOS settings.
    wine uninstaller      #| Gives overview of successful installations and faciliates formal uninstallations.
    wineboot              #| Is supposed to simulate a windows restart, don't know how to verify success.
    winetricks            #| Additional functionality like wrappers for dependencies. Installed seperately.
    apt install zorin-windows-app-support # Wine & Bottle helper for ZorinOS (efficacy unknown).
                          #| Zorin comes with an installation shortcut, "Windows App Support" in the start menu.
  
  # 4.1 ffmpeg
    ffmpeg -i i.mkv       #| Performs an operation on the specified file, default only prints info.
      -v <level>          #| Verbosity levels: quiet, panic, fatal, error, warning, info (default), verbose.
      -vf “crop=X:X:X:X”  #| Specifies cropping for operation.
      -c:v <codec>        #| Specifies video encoding, for ex. libx265 for CPU, h265_nvenc for GPU. CPU might
                          #| have higher compression efficiency compared to file size, according to ChatGPT.
        -preset 6         #| 265/264: Sets compression efficiency, ultrafast (0) to veryslow (8), at default 5.
        -crf 15           #| 265/264: Constant Rate Factor sets compression quality from 1 to 51, at default 28.
      -c:a <codec>        #| Specifies audio encoding, normally "-c:a copy". At default it matches video codec.
    ffplay -i i.mkv       #| Plays the specified file.
      -vf cropdetect      #| Continuously prints detected stream black bars as "crop=3840:1920:0:120".