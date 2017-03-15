@ECHO off
SET MSYS2_BASE=C:\msys64
SET MSYS2_SHELL=%MSYS2_BASE%\msys2_shell.cmd -mingw64
SET PATH=%PATH%;%CD%
SET OFILE=//gen/%~n1/%~n1-####.png
%MSYS2_SHELL% -c "cd $( cygpath \"%CD%\" ) ; stich=v ./ren.sh %~n1 64"
PAUSE