REM droplet for folder
echo using imagemagick
@echo off
:next
if "%~1" == "" goto done
SET FOLDER=%~n1
SET SIZE=300x
if not exist %FOLDER% goto next
cd %FOLDER%
magick mogrify *.jpg -resize %SIZE% *
shift
goto next
:done
pause


