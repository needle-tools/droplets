@echo off

SET logo_path=%~dp0logo.png
SET logo_size=40
SET start_time=0
SET end_time=99999
SET temp=%~dp0temp

REM check if logo exists
if not exist %logo_path% (echo Logo file not found at %logo_path% & timeout 10 & exit)

REm make sure temp exists
if not exist %temp% mkdir %temp%

:next
if "%~1" == "" goto done
SET filename_without_path=%~n1
SET file_ext = %~x1
REM add logo and we need to copy to a temp target because of access rights
ffmpeg -i "%~1" -i %logo_path% -filter_complex "[1:v]scale=%logo_size%:-1 [ovrl], [0:v][ovrl] overlay=W-w-15:H-h-10:enable='between(t,%start_time%,%end_time%)'" -c:a copy "%temp%\%filename_without_path%-logo.mp4"
REM copy to original location
echo Copying "%temp%\%filename_without_path%-logo.mp4" to "%~dp1%~n1-logo.mp4"
copy "%temp%\%filename_without_path%-logo.mp4" "%~dp1%~n1-logo.mp4"
REM output the new path for other apps to use
echo "%~dp1%~n1%file_ext%"
REM delete temp file
del "%temp%\%filename_without_path%-logo.mp4"
shift
goto next
:done
@REM timeout 5

REM delete temp directory
rmdir %temp%