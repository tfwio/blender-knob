@ECHO off
SET BLENDERPATH=%PROGRAMFILES%\Blender Foundation\Blender
SET PATH=%PATH%;"%BLENDERPATH%"
SET BLEND=%~1
SET OFILE=//gen/%~n1/###.png
SET OFILE=//gen/%~n1/%~n1####.png
blender -b "%BLEND%" -o "%OFILE%" -a
