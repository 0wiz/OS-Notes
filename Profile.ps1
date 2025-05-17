function ffm { ffmpeg -hide_banner -i $args }
function ffm265 {
$flags = @('-v', 'error', '-stats') + $args[0..($args.Length-2)] + @('-c:v', 'libx265', '-x265-params', 'log-level=1', '-preset', 'ultrafast', $args[$args.Length-1])
ffmpeg @flags
}