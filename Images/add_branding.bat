@echo off


:next
if "%~1" == "" goto done
SET input="%~1"
@REM dp1 is directory with drive of current file that is being processed
SET result="%~dp1/%~n1-needle.png"
echo result %result%
SET tempfile="%~dp1\needle-%~n1-temp.txt"
echo tempfile %tempfile%


@REM make corners round
@REM get input image size and save to temp file /variable
magick identify -format "%%[width]x%%[height]" %input% > %tempfile% &
@REM read back text file to variable
SET /p size=<%tempfile%
@REM save round corner command to file / variable
magick identify -format "roundrectangle 0,0,%%[width],%%[height],8,8" %input% > %tempfile% &
@REM read back text file to variable
SET /p clip_command=<%tempfile%
magick -size %size% xc:none -draw "%clip_command%" png:- | magick %input% -alpha Set - -compose DstIn -composite %result%


@REM add dropshadow to image and save to file
magick %result% ( +clone -background black -shadow 50x12+0+0 ) +swap -background none -layers merge +repage %result% &
@REM get resulting image with shadow dimensions and save to temporary text file
magick identify -format "%%[width]x%%[height]" %result% > %tempfile% &
@REM read back text file to variable
SET /p size=<%tempfile%
@REM add background gradient and save again
magick %result% ( -size %size% -define gradient:angle=45 gradient:#62D399-#D7DB0A ) +swap -background none -layers merge %result%

@REM @REM make corners round
@REM magick identify -format "roundrectangle 0,0,%%[width],%%[height],4,4" "%result%" > %tempfile% &
@REM @REM read back text file to variable
@REM SET /p clip_command=<%tempfile%
@REM echo size %size%
@REM magick -size %size% xc:none -draw "%clip_command%" png:- | magick %result% -alpha Set - -compose DstIn -composite %result%

@REM add logo
magick %result% ( logo.png -thumbnail x14 -alpha set -channel A -evaluate multiply 0.4 ) -gravity SouthEast -geometry  +5+3 -composite %result%

@REM copy to clipboard
magick  %result% clipboard:
@REM remove temporary text file
DEL /F %tempfile%
shift
goto next
:done
timeout 20
exit



