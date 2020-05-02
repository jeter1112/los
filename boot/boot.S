## Since we have a sense of BIOS loading program,
# let's set segment register to flat model and enable A20

#include "inc/mmu.h"



.set PROT_MODE_CSEG, 0x8         # kernel code segment selector
.set PROT_MODE_DSEG, 0x10        # kernel data segment selector
.set CR0_PE_ON,      0x1         # protected mode enable flag



.global start

## boot program entry
start:
    .code16
    cli     ## diable interrupts, because BIOS interrupts won't make sense,but may behave incorrectly
    cld     ## increment string operation from low address to high address, while ctd is reverse.
    
    # set segments registers to 0
    xorw %ax,%ax
    movw %ax, %ds # data segment
    movw %ax, %ss # stack segment
    movw %ax, %es # extra segment
                  # why not code segment, because, cs is 0x00 now, do not have to set it.
    
# enable A20:there several methods ,here is the keyboard controller method. 
 
seta20.1:
    inb $0x64, %al  
    testb $0x2, %al
    jnz seta20.1    ## busy wait a20

    movb $0xd1,%al 
    outb %al, $0x64  # 0xd1 -> port 0x64

seta20.2:
  inb $0x64, %al
  testb $0x2, %al
  jnz seta20.2    ## busy wait a20

  movb $0xdf, %al
  outb %al, $0x60 # 0xdf -> port 0x60


## load gdt table
## gdt structure 
#    -----------------------------------------------------------------------------------
#    base[24:31] |  G,D/B,L,AVL  |  limit[16:19]  | P,  DPL   ,s|  type  |  base[16:23] 
#                    1,1,1,1 bit                    1,2,1 bit
#    -----------------------------------------------------------------------------------
#    base[0:15]                                   | limit[0:15]
#    -----------------------------------------------------------------------------------
lgdt gdtdesc  # load gdtr
movl %cr0, %eax
orl CR0_PE_ON, %eax
movl %eax, %cr0

ljmp $PROT_MODE_CSEG, $s32
## to protected mode

.code32
s32:
  movw    $PROT_MODE_DSEG, %ax    # Our data segment selector
  movw    %ax, %ds                # -> DS: Data Segment
  movw    %ax, %es                # -> ES: Extra Segment
  movw    %ax, %ss                # -> SS: Stack Segment

  movw    %ax, %fs                # -> FS
  movw    %ax, %gs                # -> GS
  


  # Set up the stack pointer and call into C.
  #movl    $_start, %esp
  movl    $start, %esp
  call    bootmain

spin:
  jmp     spin

.p2align 2
gdt:
  SEG_NULL   #null descriptor
  SEG(STA_X|STA_R, 0x0, 0xffffffff)	# code seg
  SEG(STA_W, 0x0, 0xffffffff)	        # data seg
gdtdesc:
 .word 0x17   # size of table -1
 .long gdt   # base address of gdt table