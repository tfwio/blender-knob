@ECHO off
::
:: APP PATH CONFIG
:::::::::::::::::::::::::::::::
REM BLENDERPATH=%PROGRAMFILES(X86)%\Blender Foundation\Blender
SET BLENDERPATH=%PROGRAMFILES%\Blender Foundation\Blender
SET PATH=%PATH%;"%BLENDERPATH%"
::
:: FILE PATH CONFIG
:::::::::::::::::::::::::::::::
SET BLEND=%~1


:: ffmpeg compatible
SET OFILE=//gen/%~n1/###.png
::
:: DO THIS
:::::::::::::::::::::::::::::::

blender -b "%BLEND%" -o "%OFILE%" -a

