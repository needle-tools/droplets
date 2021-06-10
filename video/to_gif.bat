@echo off

SET ffmpeg="%LocalAppData%/Needle/Shell/Video/ffmpeg.exe"
echo %ffmpeg%

:next
if "%~1" == "" goto done
%ffmpeg% -i "%~1" -pix_fmt yuv420p -an "%~n1-temp.mp4"
%ffmpeg% -i "%~n1"-temp.mp4 -vf palettegen=stats_mode=diff "%~n1-palette.png"
%ffmpeg% -i "%~n1"-temp.mp4 -i "%~n1-palette.png" -filter_complex "paletteuse" -r 14 "%~n1.gif"
del "%~n1-palette.png"
del "%~n1-temp.mp4"
shift
goto next
:done
exit