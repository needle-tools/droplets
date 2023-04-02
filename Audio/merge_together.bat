@echo off

Set FilCnt=0
Set Lst=

:next
if "%~1" == "" goto done
REM files ending with wav or mp3
if not "%~x1" == ".wav" if not "%~x1" == ".mp3" goto next
REM count and add to list
Set FilCnt=%FilCnt%+1
Set Lst=%Lst% -i "%~1"
shift
goto next
:done

Rem Concat and Convert sources to target
ffmpeg %Lst% -filter_complex concat=n=%FilCnt%:v=0:a=1 -vn merge_together_OUT.wav
