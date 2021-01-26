@echo off
:next
if "%~1" == "" goto done
ffmpeg -i "%~1" -pix_fmt yuv420p -an "%~n1-yuv420p.mp4"
shift
goto next
:done
exit