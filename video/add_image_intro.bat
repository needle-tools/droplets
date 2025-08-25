@echo off
setlocal enabledelayedexpansion

if "%~2"=="" (
    echo Usage: Drop an image file and a video file onto this script
    echo The image will be added as 5 frames at the start of the video
    pause
    exit /b 1
)

rem Check if files exist
if not exist "%~1" (
    echo Error: File not found: %~1
    pause
    exit /b 1
)

if not exist "%~2" (
    echo Error: File not found: %~2
    pause
    exit /b 1
)

rem Auto-detect which file is image and which is video
set "file1_ext=%~x1"
set "file2_ext=%~x2"

rem Check if first file is an image
echo %file1_ext% | findstr /i "\.jpg \.jpeg \.png \.webp \.bmp \.gif" >nul
if !errorlevel! equ 0 (
    set "image_file=%~1"
    set "video_file=%~2"
) else (
    rem Check if second file is an image
    echo %file2_ext% | findstr /i "\.jpg \.jpeg \.png \.webp \.bmp \.gif" >nul
    if !errorlevel! equ 0 (
        set "image_file=%~2"
        set "video_file=%~1"
    ) else (
        echo Error: No image file found. Supported formats: jpg, jpeg, png, webp, bmp, gif
        pause
        exit /b 1
    )
)

rem Get the video file name and extension, and image name
for %%i in ("!video_file!") do (
    set "video_name=%%~ni"
    set "video_ext=%%~xi"
    set "video_path=%%~dpi"
)
for %%i in ("!image_file!") do set "image_name=%%~ni"
set "output_file=!video_path!!video_name!+!image_name!!video_ext!"

echo Adding image intro to video...
echo Image: %image_file%
echo Video: %video_file%
echo Output: %output_file%

rem Get video resolution
for /f %%i in ('ffprobe -v error -select_streams v:0 -show_entries stream^=width -of csv^=p^=0 "%video_file%"') do set "video_width=%%i"
for /f %%i in ('ffprobe -v error -select_streams v:0 -show_entries stream^=height -of csv^=p^=0 "%video_file%"') do set "video_height=%%i"

rem Create intro video matching the source video resolution (use default 25fps)
ffmpeg -i "%image_file%" -filter_complex "[0:v]scale=!video_width!:!video_height!:force_original_aspect_ratio=decrease,pad=!video_width!:!video_height!:(ow-iw)/2:(oh-ih)/2,fps=25[v]" -map "[v]" -t 0.2 -c:v libx264 -pix_fmt yuv420p temp_intro.mp4 -y
if !errorlevel! neq 0 (
    echo Error creating intro video from image
    pause
    exit /b 1
)

rem Check if video has audio
ffprobe -v error -select_streams a:0 -show_entries stream=codec_type -of csv=p=0 "%video_file%" >nul 2>&1
if !errorlevel! equ 0 (
    rem Video has audio - concatenate with audio handling
    ffmpeg -i temp_intro.mp4 -i "%video_file%" -filter_complex "[0:v][1:v]concat=n=2:v=1[outv];[1:a]apad=pad_dur=0.2[outa]" -map "[outv]" -map "[outa]" -c:v libx264 -c:a aac "%output_file%" -y
) else (
    rem Video has no audio - concatenate video only
    ffmpeg -i temp_intro.mp4 -i "%video_file%" -filter_complex "[0:v][1:v]concat=n=2:v=1[outv]" -map "[outv]" -c:v libx264 "%output_file%" -y
)
if !errorlevel! neq 0 (
    echo Error concatenating videos
    del temp_intro.mp4 2>nul
    pause
    exit /b 1
)

rem Clean up temporary file
del temp_intro.mp4 2>nul

echo.
echo Success! Output saved as: %output_file%
pause