@echo off
setlocal enabledelayedexpansion

SET maxdur=6
SET ffmpeg="%~dp0ffmpeg.exe"
SET ffprobe="%~dp0ffprobe.exe"

:next
if "%~1" == "" goto done

REM Get duration to temp file
%ffprobe% -v error -show_entries format=duration -of default=noprint_wrappers=1:nokey=1 "%~1" > "%TEMP%\dur.txt"
set /p rawdur=<"%TEMP%\dur.txt"
del "%TEMP%\dur.txt"

REM Extract integer part
for /f "tokens=1 delims=." %%a in ("!rawdur!") do set "dur=%%a"

echo Duration: !dur! seconds

REM Compare and run appropriate command
if !dur! GTR !maxdur! (
    echo Speeding up: !dur!s to !maxdur!s
    %ffmpeg% -i "%~1" -vf "setpts=PTS*!maxdur!/!dur!,fps=14,scale=504:-1:flags=lanczos" -c:v libwebp -lossless 0 -q:v 75 -loop 0 -y "%~n1.webp"
) else (
    echo No speedup needed
    %ffmpeg% -i "%~1" -vf "fps=14,scale=504:-1:flags=lanczos" -c:v libwebp -lossless 0 -q:v 75 -loop 0 -y "%~n1.webp"
)

shift
goto next

:done
pause
exit