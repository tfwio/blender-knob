set PATH=c:/progra~1/inkscape;%PATH%
::inkscape --help
inkscape "%~1" --export-png=%~dpn1.png --export-dpi=90
