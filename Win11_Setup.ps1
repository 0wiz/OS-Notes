# Things to try, and find out where --scope="machine" works.
$list = @(
  'Microsoft.PowerToys',
  'Microsoft.Powershell',
  'Microsoft.Sysinternals.PsTools',
  'Microsoft.VisualStudioCode',
  'Mozilla.Firefox',
  'Git.Git',
  'Python.Python.3.12',
  'MiKTeX.MiKTeX',
  'Gyan.FFmpeg.Essentials',
  'ArtifexSoftware.mutool',
  'OliverBetz.ExifTool',
  'ImageMagick.Q16-HDRI',
  'DuongDieuPhap.ImageGlass',
  'Daum.PotPlayer',
  'Spotify.Spotify',
  'Valve.Steam',
  'Discord.Discord',
  'qBittorrent.qBittorrent'
) # ImageMagick 2025-03-17: Winget version not fully functional, install legacy via executeable.

winget update --all
winget add $list

git config --global user.name Owiz
git config --global user.email owiz@protonmail.com

#  To remove animation for virtual desktop switching and Win+Tab:
#    Run "sysdm.cpl" -> Advanced/Performance Settings -> disable "Animate controls and elements inside windows"

#  Disable lock screen:
#    reg add HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows /f /t REG_SZ /v "Personalization"
#    reg add HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\Personalization /f /t REG_DWORD /v "NoLockScreen" /d 1
#    Run "gpedit.msc" -> Computer Configuration/Administrative Templates/Control Panel/Personalization -> enable "Do not display the lock screen"

#  Disable gamebar (to resolve error-popup after uninstalling gamebar)
#    reg add HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\GameDVR /f /t REG_DWORD /v "AppCaptureEnabled" /d 0
#    reg add HKEY_CURRENT_USER\System\GameConfigStore /f /t REG_DWORD /v "GameDVR_Enabled" /d 0

#  PowerShell installs requiring Administrator privilages:
#    Install-Module -Name Microsoft.WinGet.Client
#    Install-Module -Name Microsoft.WinGet.CommandNotFound