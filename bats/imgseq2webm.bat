@echo off
setlocal ENABLEDELAYEDEXPANSION
:next
if "%~1" == "" goto done
set fileName=%~n1
set fileExtension=%~x1
set pos=0
set name="NULL"
set numcount=0
set separator="NULL"

REM loop filename
:NextChar
    REM find count of numbers after separator
    IF %name%=="NULL" (
        REM do nothing
    ) ELSE (
        set /a numcount=numcount+1
    )

    REM CHECK SEPARTORS
    IF "!fileName:~%pos%,1!"=="_" (
        set name=!fileName:~0,%pos%!
        set separator=!fileName:~%pos%,1!
    )
    IF "!fileName:~%pos%,1!"=="-" (
        set name=!fileName:~0,%pos%!
        set separator=!fileName:~%pos%,1!
    )
    IF "!fileName:~%pos%,1!"=="." (
        set name=!fileName:~0,%pos%!
        set separator=!fileName:~%pos%,1!
    )
    
    REM continue next char
    set /a pos=pos+1
    if "!fileName:~%pos%,1!" NEQ "" goto NextChar



IF EXIST %name%.webm (
    echo SKIP because exists already "%name%.webm"
) ELSE (
    REM auto overwrite because of -y parameter 
    echo found name: %name% numbers: %numcount% separator: %separator%
    ffmpeg -start_number 1 -framerate 30 -i %name%%separator%%%%numcount%d%fileExtension% -y -c:v libvpx-vp9 -pix_fmt yuv420p -crf 10 -b:v 0 %name%.webm
)

shift
goto next
:done
timeout 10
exit