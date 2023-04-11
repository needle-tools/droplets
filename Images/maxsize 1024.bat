@echo off

:next
if "%~1" == "" goto done

REM replace backslash with forward slash
set input=%~1
set "input=%input:\=/%"

REM output path
set outPath=%~dp1
set filename=%~n1
set extension=%~x1
set output=%outPath%%filename%%extension%

echo "%input% -> %output%"
cmd /c npx sharp-cli -i "%input%" -o "%output%" resize 1024
@REM npx sharp-cli -i "C:/git/droplets/Images/img1.jpeg" -o "C:/git/droplets/Images/_test.jpeg" --mozjpeg --quality 80

shift
goto next
:done

echo DONE
timeout 3