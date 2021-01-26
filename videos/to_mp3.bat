@echo off
:next
if "%~1" == "" goto done
ffmpeg -i "%~1" "%~n1.mp3"
shift
goto next
:done
exit