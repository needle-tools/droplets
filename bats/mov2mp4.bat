@echo off
:next
if "%~1" == "" goto done
ffmpeg -i "%~1" -vcodec h264 -acodec mp2 "%~n1.mp4"
shift
goto next
:done
exit