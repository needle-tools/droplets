@echo off
:next
if "%~1" == "" goto done
ffmpeg.exe -i "%~1" -ss 00:00:9 -to 00:00:47 -async 1 "%~n1-cut.mp4"
shift
goto next
:done
timeout 10
exit