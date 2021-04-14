@echo off
echo using ffmpeg
:next
if "%~1" == "" goto done
REM create folder if not exists with name of dropped file
SET FOLDER=%~n1-3fps
if not exist %FOLDER% mkdir %FOLDER%
ffmpeg -i "%~1" -f image2 -vf fps=fps=3 %FOLDER%/%%03d.jpg
shift
goto next
:done
pause
