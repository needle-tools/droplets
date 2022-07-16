@Echo OFF

@REM add dropshadow to image and save to file
magick input.png ( +clone -background black -shadow 90x9+0+0 ) +swap -background none -layers merge +repage output.png &
@REM get resulting image with shadow dimensions and save to temporary text file
magick identify -format "%%[width]x%%[height]" output.png > output.txt &
@REM read back text file to variable
SET /p size=<output.txt
@REM remove temporary text file
DEL /F output.txt
@REM add background gradient and save again
magick output.png ( -size %size% -define gradient:angle=45 gradient:#99CC33-#F3E600 ) +swap -background none -layers merge output.png

