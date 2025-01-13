# Things to try, and find out where --scope="machine" works.
$list = @(
  'Microsoft.PowerToys',
  'Mozilla.Firefox',
  'Internxt.Drive',
  'Microsoft.VisualStudioCode',
  'Git.Git',
  'Python.Python.3.12',
  'MiKTeX.MiKTeX',
  'Gyan.FFmpeg.Essentials',
  'Daum.PotPlayer',
  'Spotify.Spotify',
  'Valve.Steam',
  'ImageMagick.Q16-HDRI',
  'DuongDieuPhap.ImageGlass',
  'ArtifexSoftware.mutool'
)
$list = $list -join " "

winget update --all
winget add $list

git config --global user.name Owiz
git config --global user.email owiz@protonmail.com