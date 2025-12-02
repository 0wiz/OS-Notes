function ff265 {
  if ($args.Length -lt 3) { throw "Required arguements: ff265 -i in.mp4 out.mp4" }
  $video = [System.IO.Path]::GetTempFileName() + ".mp4"
  $thumb = [System.IO.Path]::GetTempFileName() + ".png"

  # Compress video and handle custom args
  $inArgs = "-y -v error -stats -hwaccel cuda -hwaccel_output_format cuda" -split ' ' 
  $outArgs = "-map_metadata:g 0 -c:v hevc_nvenc -cq:v 28 -preset p5" -split ' '
  $flags = $verb + $args[0..($args.Length-2)] + $x265 + @($video)
  ffmpeg @flags

  # Process thumbnail from compressed video
  $frames = [int](ffprobe -v error -select_streams v:0 -show_entries stream=nb_frames -of default=nokey=1:noprint_wrappers=1 $video)
  $filter = "select=eq(n\,"+[math]::Min(150, $frames - 1)+"), scale=trunc(iw*144/ih/2)*2:144"
  ffmpeg -y -v error -i $video -vf $filter -frames:v 1 -q:v 7 $thumb

  # Put everything together and clean up
  $ct = ffprobe -v error -show_entries format_tags=creation_time -of default=nokey=1:noprint_wrappers=1 $video
  ffmpeg -y -v error -i $video -i $thumb `
  -map 0 -map 1 -metadata creation_time="$ct" `
  -c:v:0 copy -c:v:1 png -disposition:v:1 attached_pic $args[$args.Length-1]
  Remove-Item -force $video, $thumb
}