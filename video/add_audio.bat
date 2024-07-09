@echo off
setlocal enabledelayedexpansion

set "video=%~1"
set "audio=%~2"

if "%video%"=="" (
    echo Please provide a video file as the first argument.
    goto :eof
)

if "%audio%"=="" (
    echo Please provide an audio file as the second argument.
    goto :eof
)

set "output=%~n1_with_new_audio.mp4"

:: Get precise video duration
for /f "delims=" %%i in ('ffprobe -v error -show_entries format^=duration -of default^=noprint_wrappers^=1:nokey^=1 "%video%"') do set "video_duration=%%i"

:: Set fade duration (in seconds)
set "fade_duration=10"

:: Convert video duration to an integer
for /f "delims=." %%i in ("%video_duration%") do set "video_duration_int=%%i"

:: Calculate fade out start time
set /a fade_out_start_int=video_duration_int-fade_duration

:: Use delayed expansion to set fade_out_start
set "fade_out_start=!fade_out_start_int!"

:: Process video with faded audio
ffmpeg -i "%video%" -i "%audio%" -filter_complex "[1:a]afade=t=in:st=0:d=%fade_duration%,afade=t=out:st=%fade_out_start%:d=%fade_duration%[a]" -map 0:v -map "[a]" -c:v copy -c:a aac -shortest "%output%"

echo Processing complete. Output file: %output%

echo Fade out start at !fade_out_start! seconds. Video duration: !video_duration! seconds.

timeout 10
