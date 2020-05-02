
#include "inc/mmu.h"
#include "inc/memlayout.h"


################################################################################################# 
# this program is the entrypart of kernel, which is to build environment for later main procedure.
# the kernel is linked to address ~(KERNEL_BASE+1M), but the bootloader loads it to ~(1M).
#
# RELLOC() function set linker address to load address to help bootloader find the entry point.
# how to map linker address to load address, here we will use easy paging to map 0xf0100000 to 100000.

# Shift Right Logical   (var >> shamt)  & {111111111}  length=shamt

#define SRL(val, shamt)		(((val) >> (shamt)) & ~(-1 << (32 - (shamt))))

#define	RELOC(x) ((x) - KERNBASE)

#define MULTIBOOT_HEADER_MAGIC (0x1BADB002)
#define MULTIBOOT_HEADER_FLAGS (0)
#define CHECKSUM (-(MULTIBOOT_HEADER_MAGIC + MULTIBOOT_HEADER_FLAGS))


.text
# The Multiboot header  grub

.align 4
.long MULTIBOOT_HEADER_MAGIC
.long MULTIBOOT_HEADER_FLAGS
.long CHECKSUM

####################################################################################################
# _start specifies the entry point for ELF. since we have not setup paging to translate virtual 
#  memory, we just calculate the loaded address of _start.

.global     _start
_start=RELOC(entry)

.global entry
entry:
    movw       $0x1234,0x472# warm boot warm boot：
                            # 即告诉BIOS检测程序“不要做内存检测”。该子程序往物理内存地址0x472处写值0x1234。
                            # 该位置是启动模式（reboot_mode）标志字。在启动过程中ROM BIOS会读取该启动模式标志值并根据其值来指导下一步的执行。
                            # 如果该值是0x1234，则BIOS 就会跳过内存检测过程而执行热启动（Warm-boot）过程。
                            # 如果若该值为0，则执行冷启动（Cold-boot）过程。


    ################################################################################################
    # we have not set up virtual memory yet, so we are runing from the physical memory the bootloader 
    # loaded the kernel at: 1MB(plus a few later). however, the C code is linked to run at KERNELBASE+1MB.
    # hence we setup a trival page directory to translate virtual memory(KERNELBASE, KERNELBASE+4MB) to
    # (0,4MB). This 4MB region will be sufficient until we set up our real page table in mem_init in lab 2.

    #load page directory address into cr3.entry_pgdir
	# is defined in entrypgdir.c.

    movl $(RELOC(entry_pgdir)),%eax
    movl %eax, %cr3
    #turn on paging
    movl	%cr0, %eax
    orl	$(CR0_PE|CR0_PG|CR0_WP), %eax
    movl	%eax, %cr0

    ###############################################################################################
    # Now paging is enabled, but we are still running at low address(why this is ok), jump above 
    # KERNBASE before entering C code.

    mov	$relocated, %eax
    jmp	*%eax

relocated:
    
    #Clear the stack frame pointer , so once we debug our code, stack backtrace will terminate properly.
    movl $0x0, %ebp  # nuke frame pointer.
    # Set the stack pointer
	movl	$(bootstacktop),%esp  # set stack pointer top

    # now to C code
    call init
    # TO do

# Should never get here, but in case we do, just spin.
spin:	jmp	spin


.data
###################################################################
# boot stack
###################################################################
	.p2align	PGSHIFT		# force page alignment
	.globl		bootstack
bootstack:
	.space		KSTKSIZE       ##可以看出，栈的设置方法是在数据段中预留出一些空间来用作栈空间。memlayout.h 97行定义的栈的大小:
	.globl		bootstacktop   ### define PGSIZE      4096        // bytes mapped by a page  #define KSTKSIZE    (8*PGSIZE)          // size of a kernel stack                            
bootstacktop:

