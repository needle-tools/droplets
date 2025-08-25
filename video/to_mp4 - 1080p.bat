@echo off
:next
if "%~1" == "" goto done
ffmpeg.exe -i "%~1" -filter:v scale=-1:920 -c:a copy "%~n1-920p.mp4"
shift
goto next
:done
timeout 10
exit