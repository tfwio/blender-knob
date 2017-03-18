#!/usr/bin/sh
# only useful if you do-render for ffmpeg which generates filenames like 000.* 001.* etc...
DPAT=/e/dev/home/projects/blender-knob-git/gen/demo_f64-2
PATH=/c/DEV/avcvt-utils/bin:$PATH ffmpeg -pix_fmt rgb24 -i ${DPAT}/%03d.png output.gif