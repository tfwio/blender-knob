#! /usr/bin/env python
# coding: utf-8
from PIL import Image
from os import listdir, path
from os.path import abspath, basename

DEFAULT_FILE_OUT = ".\\stitched.png"
DEFAULT_FILE_EXT = "png"
DEFAULT_IMAGE_PATH = ".\\gen\\simple_e"
DEFAULT_IMAGE_WIDTH_HEIGHT = 24

class util:
  @staticmethod
  def getExt(filepath, lower=True): x = basename(filepath).split('.')[1] ; return x.lower() if lower else x

class App:

  def calculate_image_size(self, **para):
    self.path_list = [path.join(para['dir'], f) for f in sorted(listdir(para['dir']))] # sorted list of images #[ for p in ixl]
    self.breadth = len(self.path_list) * para['size'] # frame-width * frame-count
    self.img_out_size = (para['size'], self.breadth) if not para['horiz'] else (self.breadth, para['size'])
    self.img_frame_size = (para['size'], para['size']) # get size of a frame

  def main(self, **para):
    '''
    `image_path` is that: at the very least we need the input directory containing images named 0.png...65.png, we are expecting.

    It would be fairly easy to modify the script to adhere to additional scenarios where we have less images or want another size or something.

    `size` = `DEFAULT_IMAGE_WIDTH_HEIGHT` `24` if not provided.  
    `ext`  = `DEFAULT_FILE_EXT` `'png'` if not provided.  
    `out`  = `DEFAULT_FILE_OUT` `".\\stitched.png"` by default otherwise provide a file-name including extension.  
    `horiz` = `DEFAULT_USE_HORIZ` (default=False)
    '''

    self.calculate_image_size(**para)

    img_output = Image.new('RGBA', self.img_out_size) # output image
    offset_wh = 0
    
    for y in self.path_list:
      if (util.getExt(y) == para['ext'].lower()):
        img_location = (0, para['size'] * offset_wh) if not para['horiz'] else (para['size'] * offset_wh, 0)
        img_frame = Image.open(y).resize(self.img_frame_size, Image.LANCZOS)
        offset_wh = offset_wh + 1
        img_output.paste(img_frame, img_location)
        img_frame.close()
    
    img_output.save(para['out'])
    img_output.close()

  def get_ops(self):
    from argparse import ArgumentParser
    dsc='''Specify input path (`dir`).  input path should contain no more or less than the images you want stitched.
    ---
    We are expecting images named something like 0.png...65.png.
    ---
    the script calculates the number of frames based on the count of images found in the provided directory/path.
    '''
    parser = ArgumentParser(description=dsc)

    parser.add_argument('--horiz', '-hz', action='store_true', help='Flag: stitch horizontally')
    parser.add_argument('--ext', '-x', default=DEFAULT_FILE_EXT, dest='ext', help='[default=`png`] file extension sought in search directory')
    parser.add_argument('--out', '-o', default=DEFAULT_FILE_OUT, dest='out', help='[default=`./stitched.png`] provide full path to png file including extension')
    parser.add_argument('--size', '-s', default=DEFAULT_IMAGE_WIDTH_HEIGHT, type=int, dest='size', help='(default=24)  is used by default (implying 24x24 generated frame-images)')
    parser.add_argument('dir', help='supply one input directory', default=DEFAULT_IMAGE_PATH) #, nargs='*'

    args = parser.parse_args()
    # create, filter and/or parse input parameters before sending off to our "stitcher" class.
    args = {
      'out': DEFAULT_FILE_OUT if not 'out' in args else args.out,
      'ext': DEFAULT_FILE_EXT if not 'ext' in args else args.ext,
      'size': DEFAULT_IMAGE_WIDTH_HEIGHT if not 'size' in args else args.size,
      'horiz': args.horiz,
      'dir': None if not 'dir' in args else args.dir
    }

    if args['dir'] == None:
      parser.print_usage()

    # we could check for errors here or in the following app class.
    if (not path.exists(args['dir'])):
      print("\nERROR:\n  please check your input path: \"{}\"\n\n".format(args['dir']))
      parser.print_usage()
      exit()
    
    self.main(**args)

  def __init__(self): self.opts = self.get_ops()

app = App()
