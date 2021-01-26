REM droplet for folder
echo using imagemagick
@echo off
:next
if "%~1" == "" goto done
REM create folder if not exists with name of dropped file
SET FOLDER=%~n1
if not exist %FOLDER% goto next
cd %FOLDER%
REM montage is an image magick command
montage -background transparent -geometry +0+0 -tile 3x *.jpg %~n1.png
shift
goto next
:done
exit


