@echo off

SET logo_path=%~dp0logo.png
SET corner_radius=1

REM check if logo exists
IF NOT EXIST %logo_path% (
    echo Logo file %logo_path% does not exist, please add it to the same directory as this script
    pause
)

REM check if any file was added
if "%~1" == "" (
    echo Please drop an image file or invoke with the path to an image
    echo You can also add this as a post screenshot action to ShareX.
    echo See https://github.com/needle-tools/droplets/tree/master/Images for instructions
    pause
)

:next
if "%~1" == "" goto done
SET input="%~1"
@REM dp1 is directory with drive of current file that is being processed
SET result="%~dp1%~n1-needle%~x1"
SET tempfile="%~dp1needle-%~n1-temp.txt"
SET ext0=%~x1
SET extension=%ext0:~1%

@REM make corners round
@REM get input image size and save to temp file /variable
magick identify -format "%%[width]x%%[height]" %input% > %tempfile% &
@REM read back text file to variable
SET /p size=<%tempfile%
@REM save round corner command to file / variable
magick identify -format "roundrectangle 0,0,%%[width],%%[height],%corner_radius%,%corner_radius%" %input% > %tempfile% &
@REM read back text file to variable
SET /p clip_command=<%tempfile%
magick -size %size% xc:none -draw "%clip_command%" %extension%:- | magick %input% -alpha Set - -compose DstIn -composite %result%


@REM add logo
magick %result% ( %logo_path% -thumbnail x50 -alpha set -channel A -evaluate multiply 1.0 ) -gravity SouthEast -geometry  +14+7 -composite %result%

@REM copy to clipboard
magick  %result% clipboard:
@REM remove temporary text file
DEL /F %tempfile%
shift
goto next
:done
exit



