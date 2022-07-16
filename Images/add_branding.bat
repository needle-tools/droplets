@REM magick -size 256x128 -define gradient:angle=45 gradient:black-white linear_gradient_east.png &
magick input.png ( +clone -background black -shadow 90x5+0+0 ) +swap -background none -layers merge +repage output.png &
@REM SET DIMENSION=$(identify -format %wx%h output.png) & 
magick output.png ( -size 100x100 -define gradient:angle=45 gradient:#f80-#08f ) +swap -background none -layers merge output.png
@REM magick convert input.png ( +clone -background black -shadow 90x8+0+0 ) +swap -background none -layers merge output.png

