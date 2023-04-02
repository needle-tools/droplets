@echo off
:next
if "%~1" == "" goto done

ffmpeg -i "%~1" -f s16le -acodec pcm_s16le "%~n1.raw"
shift
goto next
:done
exit