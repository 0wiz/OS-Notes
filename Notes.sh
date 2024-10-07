### 1 Permissions
  sudo -i                   #| Enters root for the current terminal session.

### 2 File management
  dpkg --list *<package>*
  apt-get -y purge <package>*
  find / -iname "*<package>*" -exec rm -rf {} \;
  # Nautilus mounts drives in /media/<user>/

### 3 Wine
  # WARNING: Wine is very sensitive, haven't yet found a way to reset (other than to reinstall Linux).
  winecfg                   #| Config GUI for wine with a few WinOS settings.
  wine uninstaller          #| Gives overview of successful installations and faciliates formal uninstallations.
  wineboot                  #| Is supposed to simulate a windows restart, don't know how to verify success.
  winetricks                #| Additional functionality like wrappers for dependencies. Installed seperately.

### 4 ffmpeg
  ffmpeg -i i.mkv           #| Performs an operation on the specified file, default only prints info.
    -v <level>              #| Verbosity levels: quiet, panic, fatal, error, warning, info (default), verbose.
    -vf “crop=X:X:X:X”      #| Specifies cropping for operation.
    -c:v <codec>            #| Specifies video encoding, for ex. libx265 for CPU, h265_nvenc for GPU. CPU might
                            #| have higher compression efficiency compared to file size, according to ChatGPT.
      -preset 6             #| 265/264: Sets compression efficiency, ultrafast (0) to veryslow (8), at default 5.
      -crf 15               #| 265/264: Constant Rate Factor sets compression quality from 1 to 51, at default 28.
    -c:a <codec>            #| Specifies audio encoding, normally "-c:a copy". At default it matches video codec.
  ffplay -i i.mkv           #| Plays the specified file.
    -vf cropdetect          #| Continuously prints detected stream black bars as "crop=3840:1920:0:120".