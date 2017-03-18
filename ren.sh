#/bin/sh

# Example input (from a windows command): "stitch=v ./ren.sh %~n1 32"
# %~n1 or ${1} provides the name used for input and output files.
#   - see ${ref} as it is defined below
# 32 or ${2} provides the desired number of tile images.
#   - see ${siz} as it is defined below

# (quick reference)
# extension="${filename##*.}"
# filename="${filename%.*}"
# filename="${fullfile##*/}"
# https://www.gnu.org/software/bash/manual/html_node/Shell-Parameter-Expansion.html#Shell-Parameter-Expansion

function do_convert ()
{
  # image count
  if [[ "X$1" != "X" ]]; then img_n=$1 ; else img_n=33 ; fi
  # tile size depth of a single (square) frame
  if [[ "x$IMG_W" != "x" ]]; then img_w=$IMG_W ; fi

  # output file name
  img_resize=$dir_out/${IMG_O}${U}${img_w}-${stitch}${img_x}

  # horiz or vert depth
  depth=$(( ${img_w} * (${img_n} + 1 ) ))

  # calculate the size of our output image
  if [[ "x$stitch" == "xh" ]]; then img_size_i=${depth}x${img_w}
  else img_size_i=${img_w}x${depth}
  fi

  # write our resized output image file
  echo "resize to $img_size_i (${stitch})"
  convert $img_append -resize $img_size_i $img_resize
}

# default settings
# -----------------------------------------------------------

# stitch: set to h or v.  default is v
if [[ "x$stitch" == "v" ]]; then smode=+ ; else stitch=h ; smode=- ; fi

# holds input image size
img_size_i=unknown

# holds output image size
img_size_o=unknown
ref=$1 ; siz=$2

# in and out image references
IMG_I=$ref ; IMG_O=$ref

stitch=v ; dir_out=generated ; start_path=gen/ ; img_x=.png ; img_input=00
img_append=accum$img_x
# (temporary) placeholder for $IMG_W
img_w=18

# underscore
U=_

# -----------------------------------------------------------

if [[ "x$IMG_W" != "x" ]]; then img_w=$IMG_W ; fi
if [[ "x$IMG_I" != "x" ]]; then img_input=$start_path/$IMG_I/$IMG_I ; fi
if [[ "x$IMG_O" != "x" ]]; then img_append=$dir_out/$IMG_O$img_x ; fi
# output image path
img_resize=$dir_out/${IMG_O}${U}${img_w}${img_x}
# input file filter
#   - produces something like "${img_input}-1.png ${img_input}-2.png ${img_input}-[...].png"
img_input=${img_input}*${img_x}

depth=$(( ${img_w} * (${img_n} + 1 ) ))

if [[ "x$stitch" == "xh" ]]; then img_size_o=${depth}x${img_w} ; else img_size_o=${img_w}x${depth} ; fi

echo stitching initial image...
convert ${img_input} ${smode}append ${img_append}

for i in 96 72 64 48 40 36 32 24 20 ; do
  IMG_W=$i do_convert $siz
done

#sleep 10
