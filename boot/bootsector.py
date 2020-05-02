## BIOS loads the first sector, the sectorsize is 512byte, ended with 0xaa55 magic number
#  This program truncate the boot.img to 512 byte, ended with 55aa.


import binascii as bias
import os
fsize=os.path.getsize('boot.img')
if fsize>512:
    exit(-1)
with open('boot.img','a') as f:
    for  i in range(0,510-fsize):
        f.write(bias.unhexlify('00'))
    f.write(bias.unhexlify('55'))
    f.write(bias.unhexlify('aa'))