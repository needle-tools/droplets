@echo off
:next
if "%~1" == "" goto done



ffmpeg.exe -i "%~1" -vf "zoompan=z='if(lte(mod(time,10),3),2,1)':d=1:x=iw/2-(iw/zoom/2):y=ih/2-(ih/zoom/2):fps=29.97" "%~n1-zoom-x2.mp4"
shift
goto next
:done
timeout 10
exit