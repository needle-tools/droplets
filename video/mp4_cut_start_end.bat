@echo off
:next
if "%~1" == "" goto done
ffmpeg.exe -i "%~1" -ss 00:00:1 -to 00:00:3.3 -async 1 "%~n1-cut.mp4"
shift
goto next
:done
exit