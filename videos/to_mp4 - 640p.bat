@echo off
:next
if "%~1" == "" goto done
ffmpeg.exe -i "%~1" -filter:v scale=640:-1 -c:a copy "%~n1-640p.mp4"
shift
goto next
:done
timeout 10
exit