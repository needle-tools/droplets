@echo off
:next
if "%~1" == "" goto done
ffmpeg -i "%~1" -vcodec libwebp -vf scale=320:240 -loop 0 -preset default -an -vsync 0 "%~n1.webp"
shift
goto next
:done
timeout 10
exit