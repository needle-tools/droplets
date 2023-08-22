@echo off

:next
if "%~1" == "" goto done

@REM if its a audio
if "%~x1" == ".mp3" SET audio=%~1
if "%~x1" == ".wav" SET audio=%~1
@REM if its a video
if "%~x1" == ".mp4" SET video=%~1
if "%~x1" == ".mov" SET video=%~1
shift
goto next
:done

@REM print audio and vieo
echo audio: %audio%
echo video: %video%


@REM get name of the video file
for %%i in ("%video%") do set name=%%~ni

SET fadeout_start=10
SET fadeout_length=100

ffmpeg -i "%video%" -i "%audio%" -af "apad,afade=type=out:start_time=%fadeout_start%:duration=%fadeout_length%" -c:v copy -map 0 -map 1:a -shortest "%name%-audio.mp4"

timeout 10