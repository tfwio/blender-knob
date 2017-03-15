<!--Author:tfw
Author-meta:tfw
Title:Blender Knob
Subtitle: and Post-Processing with ImageMagick
Date:20160306
Encoding:utf8
version:tfwio.wordpress.com
mainfont:Roboto Slab
monofont:FreeMono
monoscale:0.8
dh:8in
dw:5in
top:0.75in
bottom:0.75in
lr:0.35in-->

> Rendering a knob in blender is simply something that I have thought about doing for VST instruments and effects for quite some time and I'm sure I'm not the only one.  Obviously I'm not the only dude out there with this thought given the various plug-ins which have gotten this sort of attention regardless of the tools used.
> 
> This is a basic outline of the things that I've learned while attempting to do this with blender and ImageMagick.
> 
> Like a few of my other drafts/posts, they may be a little drafty but I hope they might make you happy anyways ;)
> This (I don't beleive) isn't really going to be one of those copy/paste type of things.  You're going to need to become if not allready familiar with [Blender](http://blender.org) and perhaps (of course) have use for interest in knobs in IPLUG or something like.  The blender files use blender's "Cycles" renderer and a minimal amount of compositing which if you're new to can be a bit mind-bending to wrap your mind around at first glance—but, as you may find... The results are well worth it.
> 
> There may well be errors in some of the process I jotted down here (a while back).  This is just an initial dump of my notes with a little editing and I'm glad I jotted everything down since I had to re-read it a few times to catch back up to par—so please do bare with me as I refurbish over time!

![Example 33'rd frame; frame 32 of 64]

![Another Example (flipped 90deg for readability)]

## THINGS I MIGHT FORGET AGAIN (Blender)

**COPY STUFF FROM AN OBJECT TO MULTIPLE...**

- Select all your (target) objects
- Select the object you're copying (linking) properties from.
- Hit `Ctrl+L` to bring up the links menu. Choose Materials.

## BLENDING

Scripts and the blender process(s) are known to be working with ...

![Blender Version]

|3D View: Keyboard Shortcuts|keys|description|
|-----------------------|-------|-----|
|Apply Transformation   | `Ctrl+A`| Applies transformations such as location<br/>and rotation to an object's mesh|
|Layer Show    | `[0-9]` (alpha-num)  | show layer |
|Layer Toggle  | `Shift+[0-9]`| toggle layer on\|off |


- **INITIAL STEP**
    - Start up blender.
    - Delete the box.
    - Set up the scene size.  I used a w/h of `256 x 256`.
    - Change Render settings modifying output path to `//` so that any images rendered will be in the same directory as the blend.
    - Save your file.
- **LIGHT SOURCE**
    - Select the default light.
    - Change it to a Sun lamp.
    - Change the X `Location` to 0.
    - Change the Y `Location` to 1 or whatever you like.
    - Change the Z `Location` to 2 or whatever you like.
    - Change the Rotations `X=32, Y=0 and Z=0`.
    - Note: You are going to want to customize the lighting settings when adjusting your knob's materials and finalizing (most likely).
- Set up your rendering settings.
    - Press the camera button
    - Goto the `Film` category and check the "Transparent" check-box so that we can have a transparent background.
    - Switch the renderer to cycles for later applying to your (knob's) materials.
- Design your knob
    - press 2 to go the second layer.
    - add plane (you can enlarge it now or later to fill the camera view).
    - press 1 to return to the first layer.
    - make your knob however you like.
        - you can generally as a rule of thumb just make sure you keep the cursor in the center of the object or knob that you're designing.
- Setup Animation Settings for the Knob
    - Go to your Time-line and Frame `0` within
    - Set this as your first frame or press `S`
    - Go to frame `64`
    - Set this as your last frame or press `E`
    - Note that we are only looking to animate the Z-axis of our knob.
    - Go back to your main Design or Default view
    - Next we'll create key-frames @`0`, `32` and `64` containing rotations: -30, -180 and -330 or as noted below, -33, -180 and -327.  It can be a bit confusing to use those actual values so we're going to want to set the initial rotation to -30 deg and then apply our keyframes to the z-rotation.  Once you set the initial rotation angle you want to **Apply Tranformation** pressing `Ctrl+A` within the mesh view.
        - we want a middle keyframe pointed directly up or centered, so it would be best to use an odd number of frames such as the 33 used here, targeting 32 frames with the center piece.
        - Go to Frame  0 and change Z rotation to -33 degrees. Press I and select Rotation.
        - Go to Frame 32 and change Z Rotation to -180. Press I and select Rotation.
        - Go to Frame 64 and change Z Rotation to -327 (360 - 33). Press I and select Rotation.
    - Return back to the Time-line (or animation) view ('Dopesheet').  Expand the 'action' pertaining to your knob which we just set.
    - If you would like, you can select and delete `X Euler Rotation` and `Y Euler Rotation` leaving `Z Euler Rotation`.
    - Within the 'Dopesheet' view, select `Z Euler Rotation` by clicking on it and press `T` and select `Linear` interpolation.

![blender screen 1]

# Scripts Overview

There are two basic scripts – though duplicates due to the whole x86 vs x64 thing.

They're designed so that you can drag-drop your blender file into them in windows.

1. `do-blender-render-*.cmd` Uses blender and render each frame of our mesh-animation.
2. `do_magick_*-64.cmd` Uses Image Magick to tile and stitch each exported PNG file into a single image and resizes several dimensions vertically (for IPLUG graphics).

Vertical tile image size widths generated are 96, 72, 64, 48, 40, 36, 32, 24 and 20.
The height depends on the number of images used to create the tile.
Look toward the bottom of `ren.sh` to add whatever dimension you like.

Its important to note the names of the scripts because I'm using a x64 machine and its possible that we have a Win32 user reading this so...

A SCRIPT FOR RENDERING FROM BLENDER COMMAND-LINE

- scripts with 'native' appended to the end of the file-name will call
    - on 64-bit platform, will call `c:\program files\blender\blender`
    - on 32-bit platform, will call `c:\program files\blender\blender`
- scripts with x86_64 appended to the end of the file-name will call
    -  `c:\program files (x86)\blender\blender`
- Mac or 'nix users are going to have to write their own shell script to render based on whatever windows command file.

```bash
#!/usr/bin/sh
BLEND=$1
OFILE=
blender -b "${BLEND}" -o "${OFILE}" -a

```

# TIPS

SOME TEXTURING NOTES
--------------------

 - [Blender Quick Tip - Transparent Shadow in Final Render - YouTube](https://www.youtube.com/watch?v=nattlrdnEPM)
 - [Texture Nodes --- Blender Reference Manual](https://www.blender.org/manual/render/cycles/nodes/textures.html)


SOME MATH
--------------------------

Say you want to round a 7 (or other) pointed knob.

> You always want an odd number of nodal (or rotational) points.  
> NB: otherwise, there is not going to be a center-point (point straight up for example)

Grab your calculator and prep some calculations...

```
# Basic (first) angle

360 / 7 = ...

So...

[1] = 0
[2] = 51.428571428571428571428571428571
[3] = 102.85714285714285714285714285714
[4] = 154.28571428571428571428571428571
[5] = 205.71428571428571428571428571428
[6] = 257.14285714285714285714285714286
[7] = 308.57142857142857142857142857143
```

So as shown in the following figure, when 'meshing', we would simply create the first element in the perceived (y-axis) top, with the mesh's zero point set to the scene's 0,0,0 vector at which point we can just duplicate and rotate per interval above.  A plug-in would be nice for this, but I don't think a knob factory is really in order as you can just save your results for repeating once done.

Once the mesh is completed, we would apply a boolean difference (might want to recalculate normals first on the above created mesh).

![Bitwise Mask]

# Scripts

## About them

There are a few scripts in here and I hadn't messed with em in a while.  
I'm a windows user who is a fan of 'nix or FSF's GPL, not to mention cross-platform man-tality which for me—equates to msys2 bash scripting.

There are a few useful windows commands, but for the most part they just call the bash scripts.

These scripts are designed on a windows 7 machine, though with little intervention, you should be able to make a few tweaks to how this is used to use it as simply on your machine.

The goal of the scripts was to make them drag-drop capable as there are two scripts.

## Image-Magick under msys2

You're going to want to kick me reading this knowing full well that image-magick is broke in several distributions; Just skip below and download/install a working version silly.  I'm not a 'nix user, so you're going to have to consult your package-management (or managers) to figure out what versions are going to work for you.  Chances are, if you're on linux (or mac) the package managers aren't lazy and patched the issues or filed a bug report AND of course one would hope that those reports were acted upon by Image-Magick builders/devs.  Its not your package manager's responsibilty to fix issues like this---and they bring you everyhing you use, so be respectful ;)

For a windows user on msys2 to manually install your msys2 imagemagick package, load up msys2 bash and

```bash
# assuming the package is in your downloads directory...
cd /c/users/[your-username-on-your-machine]/downloads

pacman -U [your-package-name].pkg.tar.xz

# if you only downloaded one package and its in your downloads directory...
# pacman -U *.pkg.tar.xz

# or even
# pacman -U *.xz

# you get the idea
```

and follow along the ^provided instruction^ once running pacman's update command.

## How I got the following list of files...

You'll notice the following lists.  If you're ever looking to find a (further) downstream package for msys2, you might want to do as I did and download the appropriate FILES page so you can search for what you're looking for much faster using something like sublime-text and regular expressions.

In this particular case, I knew I was looking for `imagemagick`

- right-click, download the single html file and load in your regex-search capable text-editor.
    - https://sourceforge.net/projects/msys2/files/REPOS/MINGW/i686/
    - https://sourceforge.net/projects/msys2/files/REPOS/MINGW/x86_64/

Once I found the package-uri, it was simple to convert it into a regex query that would allow me to find each release.

for example: `href="https://sourceforge.net/projects/msys2/files/REPOS/MINGW/x86_64/mingw-w64-x86_64-imagemagick-[^]["]*` or for i686, `href="https://sourceforge.net/projects/msys2/files/REPOS/MINGW/i686/mingw-w64-x86_64-imagemagick-[^]["]*`

## Working x86 Image Magick for msys2

These are on the source-forge files section of msys2... I'm sure one of these will do—just forgot which one. I've got money on [mingw-w64-i686-imagemagick-6.9.3.7-1-any.pkg.tar.xz] one of the v6.x ;)

Emboldened is the working version.

*guessing you don't really care about the sig files...*  
*If you want to download one, just copy/paste one of the following links and append `.sig`*  
*note: you're not going to want to r-click/save-as these as they're redirect pages.*

- [mingw-w64-i686-imagemagick-7.0.4.4-1-any.pkg.tar.xz]
- [mingw-w64-i686-imagemagick-7.0.3.5-2-any.pkg.tar.xz]
- [mingw-w64-i686-imagemagick-7.0.3.5-2-any.pkg.tar.xz]
- [mingw-w64-i686-imagemagick-7.0.3.1-1-any.pkg.tar.xz]
- [mingw-w64-i686-imagemagick-7.0.1.10-1-any.pkg.tar.xz]
- [mingw-w64-i686-imagemagick-7.0.1.9-1-any.pkg.tar.xz]
- [mingw-w64-i686-imagemagick-7.0.1.8-1-any.pkg.tar.xz]
- **[mingw-w64-i686-imagemagick-6.9.3.7-1-any.pkg.tar.xz]**
- [mingw-w64-i686-imagemagick-6.9.2.10-1-any.pkg.tar.xz]
- [mingw-w64-i686-imagemagick-6.9.2.0-1-any.pkg.tar.xz]
- [mingw-w64-i686-imagemagick-6.9.1.8-1-any.pkg.tar.xz]

## Working x64 Image Magick for msys2

*guessing you don't really care about the sig files...*  
*If you want to download one, just copy/paste one of the following links and append `.sig`*  
*note: you're not going to want to r-click/save-as these as they're redirect pages.*

- [mingw-w64-x86_64-imagemagick-7.0.5.0-1-any.pkg.tar.xz]
- [mingw-w64-x86_64-imagemagick-7.0.4.4-1-any.pkg.tar.xz]
- [mingw-w64-x86_64-imagemagick-7.0.3.5-2-any.pkg.tar.xz]
- [mingw-w64-x86_64-imagemagick-7.0.3.1-1-any.pkg.tar.xz]
- [mingw-w64-x86_64-imagemagick-7.0.1.10-1-any.pkg.tar.xz]
- [mingw-w64-x86_64-imagemagick-7.0.1.9-1-any.pkg.tar.xz]
- [mingw-w64-x86_64-imagemagick-7.0.1.8-1-any.pkg.tar.xz]
- **[mingw-w64-x86_64-imagemagick-6.9.3.7-1-any.pkg.tar.xz]**
- [mingw-w64-x86_64-imagemagick-6.9.2.10-1-any.pkg.tar.xz]
- [mingw-w64-x86_64-imagemagick-6.9.2.0-1-any.pkg.tar.xz]
- [mingw-w64-x86_64-imagemagick-6.9.1.8-1-any.pkg.tar.xz]


[mingw-w64-i686-imagemagick-7.0.4.4-1-any.pkg.tar.xz]:    https://sourceforge.net/projects/msys2/files/REPOS/MINGW/i686/mingw-w64-i686-imagemagick-7.0.4.4-1-any.pkg.tar.xz/download
[mingw-w64-i686-imagemagick-7.0.3.5-2-any.pkg.tar.xz]:    https://sourceforge.net/projects/msys2/files/REPOS/MINGW/i686/mingw-w64-i686-imagemagick-7.0.3.5-2-any.pkg.tar.xz/download
[mingw-w64-i686-imagemagick-7.0.3.5-2-any.pkg.tar.xz]:    https://sourceforge.net/projects/msys2/files/REPOS/MINGW/i686/mingw-w64-i686-imagemagick-7.0.3.5-2-any.pkg.tar.xz/download
[mingw-w64-i686-imagemagick-7.0.3.1-1-any.pkg.tar.xz]:    https://sourceforge.net/projects/msys2/files/REPOS/MINGW/i686/mingw-w64-i686-imagemagick-7.0.3.1-1-any.pkg.tar.xz/download
[mingw-w64-i686-imagemagick-7.0.1.10-1-any.pkg.tar.xz]:   https://sourceforge.net/projects/msys2/files/REPOS/MINGW/i686/mingw-w64-i686-imagemagick-7.0.1.10-1-any.pkg.tar.xz/download
[mingw-w64-i686-imagemagick-7.0.1.9-1-any.pkg.tar.xz]:    https://sourceforge.net/projects/msys2/files/REPOS/MINGW/i686/mingw-w64-i686-imagemagick-7.0.1.9-1-any.pkg.tar.xz/download
[mingw-w64-i686-imagemagick-7.0.1.8-1-any.pkg.tar.xz]:    https://sourceforge.net/projects/msys2/files/REPOS/MINGW/i686/mingw-w64-i686-imagemagick-7.0.1.8-1-any.pkg.tar.xz/download
[mingw-w64-i686-imagemagick-6.9.3.7-1-any.pkg.tar.xz]:    https://sourceforge.net/projects/msys2/files/REPOS/MINGW/i686/mingw-w64-i686-imagemagick-6.9.3.7-1-any.pkg.tar.xz/download
[mingw-w64-i686-imagemagick-6.9.2.10-1-any.pkg.tar.xz]:   https://sourceforge.net/projects/msys2/files/REPOS/MINGW/i686/mingw-w64-i686-imagemagick-6.9.2.10-1-any.pkg.tar.xz/download
[mingw-w64-i686-imagemagick-6.9.2.0-1-any.pkg.tar.xz]:    https://sourceforge.net/projects/msys2/files/REPOS/MINGW/i686/mingw-w64-i686-imagemagick-6.9.2.0-1-any.pkg.tar.xz/download
[mingw-w64-i686-imagemagick-6.9.1.8-1-any.pkg.tar.xz]:    https://sourceforge.net/projects/msys2/files/REPOS/MINGW/i686/mingw-w64-i686-imagemagick-6.9.1.8-1-any.pkg.tar.xz/download
[mingw-w64-x86_64-imagemagick-7.0.5.0-1-any.pkg.tar.xz]:  https://sourceforge.net/projects/msys2/files/REPOS/MINGW/x86_64/mingw-w64-x86_64-imagemagick-7.0.5.0-1-any.pkg.tar.xz/download
[mingw-w64-x86_64-imagemagick-7.0.4.4-1-any.pkg.tar.xz]:  https://sourceforge.net/projects/msys2/files/REPOS/MINGW/x86_64/mingw-w64-x86_64-imagemagick-7.0.4.4-1-any.pkg.tar.xz/download
[mingw-w64-x86_64-imagemagick-7.0.3.5-2-any.pkg.tar.xz]:  https://sourceforge.net/projects/msys2/files/REPOS/MINGW/x86_64/mingw-w64-x86_64-imagemagick-7.0.3.5-2-any.pkg.tar.xz/download
[mingw-w64-x86_64-imagemagick-7.0.3.1-1-any.pkg.tar.xz]:  https://sourceforge.net/projects/msys2/files/REPOS/MINGW/x86_64/mingw-w64-x86_64-imagemagick-7.0.3.1-1-any.pkg.tar.xz/download
[mingw-w64-x86_64-imagemagick-7.0.1.10-1-any.pkg.tar.xz]: https://sourceforge.net/projects/msys2/files/REPOS/MINGW/x86_64/mingw-w64-x86_64-imagemagick-7.0.1.10-1-any.pkg.tar.xz/download
[mingw-w64-x86_64-imagemagick-7.0.1.9-1-any.pkg.tar.xz]:  https://sourceforge.net/projects/msys2/files/REPOS/MINGW/x86_64/mingw-w64-x86_64-imagemagick-7.0.1.9-1-any.pkg.tar.xz/download
[mingw-w64-x86_64-imagemagick-7.0.1.8-1-any.pkg.tar.xz]:  https://sourceforge.net/projects/msys2/files/REPOS/MINGW/x86_64/mingw-w64-x86_64-imagemagick-7.0.1.8-1-any.pkg.tar.xz/download
[mingw-w64-x86_64-imagemagick-6.9.3.7-1-any.pkg.tar.xz]:  https://sourceforge.net/projects/msys2/files/REPOS/MINGW/x86_64/mingw-w64-x86_64-imagemagick-6.9.3.7-1-any.pkg.tar.xz/download
[mingw-w64-x86_64-imagemagick-6.9.2.10-1-any.pkg.tar.xz]: https://sourceforge.net/projects/msys2/files/REPOS/MINGW/x86_64/mingw-w64-x86_64-imagemagick-6.9.2.10-1-any.pkg.tar.xz/download
[mingw-w64-x86_64-imagemagick-6.9.2.0-1-any.pkg.tar.xz]:  https://sourceforge.net/projects/msys2/files/REPOS/MINGW/x86_64/mingw-w64-x86_64-imagemagick-6.9.2.0-1-any.pkg.tar.xz/download
[mingw-w64-x86_64-imagemagick-6.9.1.8-1-any.pkg.tar.xz]:  https://sourceforge.net/projects/msys2/files/REPOS/MINGW/x86_64/mingw-w64-x86_64-imagemagick-6.9.1.8-1-any.pkg.tar.xz/download

[Example 33'rd frame; frame 32 of 64]: doc/001.jpg
[Another Example (flipped 90deg for readability)]: doc/002.png
[Blender Version]: 003.jpg
[blender screen 1]: 004.jpg
[Bitwise Mask]: doc/knob_corners.png
