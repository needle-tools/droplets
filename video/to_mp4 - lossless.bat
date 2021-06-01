@echo off
:next
if "%~1" == "" goto done
ffmpeg.exe -i "%~1" -c:v libx264 -preset veryslow -crf 0 "%~n1-lossless.mp4"
shift
goto next
:done
timeout 10
exit