@echo off
:next
if "%~1" == "" goto done
ffmpeg.exe -i "%~1" -filter:v scale=420:-1 -c:a copy -map 0:0 "%~n1-420p.mp4"
shift
goto next
:done
timeout 10
exit