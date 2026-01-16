@echo off
:next
if "%~1" == "" goto done
ffmpeg -i "%~1" -vf scale="960:trunc(ow/a/2)*2" -c:v libx264 -crf 18 -preset veryslow -c:a copy "%~n1-960p.mp4"
shift
goto next
:done
timeout 10
exit