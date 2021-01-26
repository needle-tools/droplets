
@echo off
:next
if "%~1" == "" goto done
ffmpeg.exe -i "%~1" -c copy -an "%~1-noaudio.mp4"
shift
goto next
:done
exit

