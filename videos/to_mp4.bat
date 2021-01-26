@echo off
:next
if "%~1" == "" goto done
ffmpeg.exe -i "%~1" -vcodec libx264 -f mp4 -acodec aac -b:a 192k -b:v 1600k -ac 2 "%~n1.mp4"
shift
goto next
:done
timeout 10
exit