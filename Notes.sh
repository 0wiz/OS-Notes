### 1 System Permissions
  sudo -i # Enters root for the current terminal session.

  # 1.0 Slacken Terminal Password Security
    visudo # Opens the config for sudo password using nano, Ctrl+Shift+O to save and Ctrl+Shift+X to exit.
    # Setting "%admin    ALL=(ALL) NOPASSWD:ALL" appears to make password last until reboot.
    # Setting "%sudo     ALL=(ALL:ALL) NOPASSWD:ALL" appears to disable sudo password prompts.

  # 1.1 Slacken GUI Password Security
    # In "Passwords and Keys" goto Password->Login->Change, and leave it blank to prevent keyring password requests.
    # If no keyring is present, panic! Specific apps may want prompt new keyrings, but not for the software manager.

### 2 Other System Commands
  # 2.0 General
    # NOTE: Nautilus mounts drives in /media/<user>/
    dpkg --get-selections | grep <package>
    dconf dump / > dconfdump # Saves non-default gnome settings to file 'dconfdump'.
      | sed '/app-folders/,/^$/d' # Append to omit app folders from Gnome Activities Overview.
      | grep 'int[0-9]\+ [0-9]\{10\}' | sed '/]/N;/\n$/d' # Append to omit likely timestamps and empty schemas.
    dconf load / < dconfdump # Loads the gnome settings of file 'dconfdump' into the system.
    lsb_release -a # Prints the OS version
    systemctl reboot --firmware-setup # Restart and enter BIOS/UEFI, sometimes warned against.

  # 2.1 Changing hostname
    sudo nano /etc/hostname # Can potientailly be enough to change the hostname everywhere
    sudo hostnamectl set-hostname <name> # Sets the hostname used within hostnamectl
    sudo hostnamectl --static hostname <name> # Might be needed before previous line
    sudo nano /etc/hosts # Necessary when changing hostname via hostnamectl

  # 2.2 WSL
    # NOTE: It takes 8 seconds for the subsystem to reboot.
    sudo nano /etc/wsl.conf # Settings per WSL install

### 3 App Installation
  # 3.0 Node.js & TypeScript
    # Install Node Version Manager (nvm) as described on github.com/nvm-sh/nvm
    nvm install <version> # Specifying major version seems to get Node LTS.
    apt -y install node-typescript

  # 3.1 Beekeeper Studio
    flatpak -y install flathub io.beekeeperstudio.Studio
    flatpak override io.beekeeperstudio.Studio --filesystem=host

### 4 App Usage
  # 4.0 Wine
    # WARNING: Wine is very sensitive, haven't yet found a way to reset (other than to reinstall Linux).
    winecfg               #| Config GUI for wine with a few WinOS settings.
    wine uninstaller      #| Gives overview of successful installations and faciliates formal uninstallations.
    wineboot              #| Is supposed to simulate a windows restart, don't know how to verify success.
    winetricks            #| Additional functionality like wrappers for dependencies. Installed seperately.
  
  # 4.1 ffmpeg
    ffmpeg -i i.mkv       #| Performs an operation on the specified file, default only prints info. Put options after.
      -v <level>          #| Verbosity levels: quiet, panic, fatal, error, warning, info (default), verbose.
      -ss X -to X         #| Specifies the start and end seconds for operation. Put before crop.
      -vf “crop=X:X:X:X”  #| Specifies cropping for operation.
      -c:v <codec>        #| Specifies video encoding, for ex. libx265 for CPU. (GPU encoding not worth it?)
        -preset 6         #| 265/264: Sets compression efficiency, ultrafast (0) to veryslow (8), at default 5.
        -crf 15           #| 265/264: Constant Rate Factor sets compression quality from 1 to 51, at default 28.
      -c:a <codec>        #| Specifies audio encoding, normally "-c:a copy". At default it matches video codec.
    ffplay -i i.mkv       #| Plays the specified file.
      -vf cropdetect      #| Continuously prints detected stream black bars as "crop=3840:1920:0:120".
    ffprobe -i i.mkv
      -show-chapters

    pv i.mkv | ffmpeg -i pipe:0 -v warning {arguments} # TODO: Try pv

### 5 Thoughts
  # 5.0 Desktop Environments
    # DEs that feel refined are rare and the change takes energy, there's a reason that so many distros use Gnome.
    # That said, Gnome is rigid, tread carefully when customizing beyond normal tweaks.

  # 5.1 Distributions
    # Compatibility goes up every year, prioritize distros with a good release schedule, avoid year-old releases.
    # Derivatives may tardy when following primitives and even market the news of thier primitives as their own.
    # Ubuntu follows Debian closely, and kernel version is mentioned as the more important update in new releases.
    # Adoption is important for open source, getting the impression that a system is refined tends to mean that it is.
    # Try Ubuntu-derivatives for compatibility improvements or otherwise better refinement, otherwise just use Ubuntu.