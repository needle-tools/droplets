@echo off
:next
if "%~1" == "" goto done
ffmpeg.exe -i "%~1" -ss 00:00:20 -to 00:2:30 -async 1 "%~n1-cut.mp4"
shift
goto next
:done
timeout 10
exit