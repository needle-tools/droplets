@echo off

SET logo_path=%~dp0logo.png
SET logo_size=25
SET start_time=0
SET end_time=99999

REM check if logo exists
if not exist %logo_path% (echo Logo file not found at %logo_path% & timeout 10 & exit)

:next
if "%~1" == "" goto done
ffmpeg -i "%~1" -i %logo_path% -filter_complex "[1:v]scale=%logo_size%:-1 [ovrl], [0:v][ovrl] overlay=W-w-15:H-h-10:enable='between(t,%start_time%,%end_time%)'" -c:a copy "%~n1-logo.mp4"
shift
goto next
:done
@REM timeout 5
timeout 5
exit