### System
  systemctl reboot --firmware-setup # Restart and enter BIOS/UEFI, sometimes warned against.
  
  dpkg --get-selections | grep <package>
  apt list --installed <package>
  flatpak list --app | grep  <package>
  snap list <package>

### App Usage
  # Wine (UNSTABLE)
  winecfg               #| Config GUI for wine with a few WinOS settings.
  wine uninstaller      #| Gives overview of successful installations and faciliates formal uninstallations.
  wineboot              #| Is supposed to simulate a windows restart, don't know how to verify success.
  winetricks            #| Additional functionality like wrappers for dependencies. Installed seperately.
  
  # ffmpeg
  ffmpeg -i i.mkv o.mkv #| Performs an operation on the specified file, default only prints info.
    -v <level>          #| Verbosity: -8 (quiet), 16 (error), 24 (warning), 32 (info), 40 (verbose). At default 32.
    -hide_banner        #| Prevents all the flags & library versions from being printed. Redundant below "-v info".
    -stats              #| Specify to print progress regardless of verbosity level. Antonym is -nostats.
    -ss X -to X         #| Set start and end times (S or HH:MM:SS) for cutting. Put before crop & input.
    -avoid_negative_ts  #| Handle timestamp origo: -1 (auto), 0 (disabled), 1 (make_non_negative), 2 (make_zero).
    -filter             #| Specify comma-seperated filters. Stream :v & :a can be abbreviated as -vf & -af resp.
    -filter_complex     #| Specify filtergraph for multiple in/out, for ex. [0:v] specifies video for input 0.
    -vf “crop=X:X:X:X”  #| Set encoding crop (Width:Height:X:Y).
    -vf "scale=X:X"     #| Set encoding resolution (Width:Height). Keep aspect using -1 or trunc(), iw & ih.
    -vf "transpose=1"   #| Set encoding rotation (1 for clockwise & 2 for counterclockwise).
    -r X                #| Set encoding framerate, with constant or variable rate depending on format.
    -c:v <codec>        #| Specify video encoding, for ex. libx265 (CPU). At default libx264.
      -preset 6         #| 265/264: Sets compression efficiency, 0 (ultrafast) to 8 (veryslow), at default 5.
      -crf 15           #| 265/264: Constant Rate Factor sets compression quality loss from 0 to 51, at default 28.
      -x265-params      #| 265: Specify parameters to pass to libx265. Put after encoding.
        log-level=X     #| Verbosity: 0 (error), 1 (warning), 2 (info), 3 (debug), 4 (full). At default 2.
    -frames:v X         #| Stop writing to the stream after framecount frames.
    -q:v X              #| Set fixed quality scale (VBR) value, 0 (HQ) to 10 (LQ). Alias for qscale.
    -c:a <codec>        #| Specify audio encoding. At default it matches video codec.
    -af "volume=X"      #| Set volume scaling, for ex. 0.5 for half or 2 for double volume.
    -af "highpass=f=X"  #| Set highpass filter frequency.
    -af "lowpass=f=X"   #| Set lowpass filter frequency.
    -an                 #| Exclude audio streams in encoding. Same for vn, sn, dn in video, subtitles & data resp.
    -movflags <flags>   #| Set various muxing switches. The mov, mp4, and ismv muxers support fragmentation.
      faststart         #| Set web-optimized, runs a second pass moving the index to the beginning of the file.
    -metadata <key>     #| Set a metadata key-value pair.
      comment=<value>   #| Set the metadata comment-line. Leave blank to clear comment.
      :s:<stream> <key> #| Specify a stream to set a metadata key-value pair for. For ex. ':s:a:3 title="English"'.
    -strict unofficial  #| Specify to not apply a strict YUV, removes "Non full-range YUV is non-standard" error.
    -lavfi 
      showspectrumpic   #| Creates an audio frequency spectogram and saves it as the output file.
  ffmpeg -i i.mp4 -vsync vfr -vf "select='eq(pict_type,I)'" -q:v 2 o%d.jpg #| Extract I-frames
  ffplay -i i.mkv       #| Plays the specified file. Can be used to preview settings.
    -vf cropdetect      #| Continuously prints detected stream black bars in the crop format.
    -af lowpass=X,highpass=X #| Apply audio lowpass and highpass filters on playback.
  ffprobe -i i.mkv      #| Prints information gathered from multimedia streams.
    -show-chapters      #| Show information about chapters stored in the format. 
    -show_streams       #| Show information about each media stream contained in the input multimedia stream.
    -select_streams v:0 #| Select only the streams specified, solely affects the options related to streams.

  # ImageMagick (Winget version lacks support for legacy utilities and may have trouble with adding path)
  magick [] i.ext o.ext #| Performs an image conversion on the input, formerly "magick convert".
    -quality X          #| Set JPEG/MIFF/PNG compression level, at default 95.
    -strip              #| Specify the conversion to clear metadata and comments.
    -interlace <scheme> #| Specify type of image interlacing scheme, for ex. Plane.
    -gaussian-blur X    #| For ex. 0.05
    compare i1 i2 i3    #| Compares i1 & i2, marking differences as red in i3 (use NULL: as i3 to not save).
      -metric <stat>    #| Prints a statistic to represent the difference with a value, for ex. MAE, MSE or RMSE.
      -density X        #| Specify DPI to use when comparing, at default 72.
  magick *.jpg o.gif    #| Animation example, takes all jpg images in current folder and creates a gif.
      -delay X          #| Set the delay between frames, at default 0, open to gif viewer interpretation.
      -loop X           #| Specify looping for animations, at default 0, meaning indefinitely.
  mogrify               #| Similar to "magick" but with different options, overwrites the input file.
    -layers 'optimize'  #| Attempts to optimize the animation, short for 'optimize-frame' & 'optimize-plus'.
    -fuzz X             #| Colors within this distance (absolute or percent) are considered equal.

### Lexicon
  # Powershell-to-Bash                   Psh | Bash
  cat (Get-PSReadlineOption).HistorySavePath   | History
  findstr str                                  | grep str
  gi -LiteralPath                              | wc -c
  $list.ForEach({ echo $_ })                   | for i in $list; do echo $i; done
  Test-Path 'file.ext'                         | [ -f 'file.ext' ]
  Write-Host -NoNewLine 'str'                  | echo -n 'str'
  psshutdown -d -t 0 (requires PSTools)        | shutdown now

  # Get all filenames (with extensions) matching a pattern
  $list = ls | foreach Name | where { $_ -match '(jpg|png)$' -and $_ -notmatch '^\d{4}-\d\d-\d\d\s\d\d.\d\d.\d\d' }

  # Compress files in list to mp4 (rm extra streams) with 150th frame as thumbnail & print size reductions
  $list = ls | foreach {[PSCustomObject]@{ in=$_.Name; out=$_.BaseName+"_crf22.mp4" }}
  $list.ForEach({
    $frame = [math]::Min(150, (ffprobe -v error -select_streams v:0 -show_entries stream=nb_frames -of default=nokey=1:noprint_wrappers=1 $_.in) - 1)
    ffmpeg -v error -i $_.in -vf "select=eq(n\,$frame), scale=trunc(iw*144/ih/2)*2:144" -frames:v 1 -q:v 7 -f image2pipe -
    | ffmpeg -v error -stats -i $_.in -i - -map 0 -map 1 -c:v:0 libx265 -x265-params log-level=1 -crf 22 -c:v:1 png -disposition:v:1 attached_pic $_.out
    echo ("{0:N2}% '$($_.in)'" -f ((1 - (gi -LiteralPath $_.out).Length / (gi -LiteralPath $_.in).Length) * 100))
  })

  # Cut files with induvidual timestamps (leave as zero to skip) & convert to mp4 without re-encoding
  $ss = @( @("00:00:00","00:00:00"), @("00:00:00","00:00:00") ) # Add one sub-array for each file.
  $list = ls | foreach -Begin { $i=0 } {
    [PSCustomObject]@{ in=$_.Name; out=$_.BaseName+"_cut.mp4"; ss=$ss[$i][0]; to=$ss[$i++][1] }
  }
  $list.ForEach({ ffmpeg -v warning -ss $_.ss -to $_.to -i $_.in -c copy $_.out })