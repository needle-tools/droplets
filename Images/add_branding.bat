@echo off

:next
if "%~1" == "" goto done
@REM dp1 is directory with drive of current file that is being processed
SET result=%~dp1/%~n1-needle.png
echo result %result%
SET tempfile="%~dp1\needle-%~n1-temp.txt"
echo tempfile %tempfile%
@REM add dropshadow to image and save to file
magick "%~1" ( +clone -background black -shadow 50x9+0+0 ) +swap -background none -layers merge +repage %result% &
@REM get resulting image with shadow dimensions and save to temporary text file
magick identify -format "%%[width]x%%[height]" "%result%" > %tempfile% &
@REM read back text file to variable
SET /p size=<%tempfile%
@REM remove temporary text file
DEL /F %tempfile%
@REM add background gradient and save again
magick %result% ( -size %size% -define gradient:angle=45 gradient:#99CC33-#F3E600 ) +swap -background none -layers merge %result% 
echo %result%
@REM copy to clipboard
magick  %result% clipboard:
shift
goto next
:done
timeout 3
exit



