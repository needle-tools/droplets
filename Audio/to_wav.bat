@echo off
:next
if "%~1" == "" goto done
ffmpeg -i "%~1" -acodec pcm_s16le -ar 16000 -ac 1 "%~n1.wav"
shift
goto next
:done
exit