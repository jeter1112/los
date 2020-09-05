# boot:
# 	gcc  -std=gnu99  -m32  -ggdb -c   boot.S -o boot.o
# 	gcc  -std=gnu99  -m32  -ggdb -O -c   bootmain.c 
	
# 	## boot for ia32
# load: boot 
# 	ld -m    elf_i386   -Ttext 0x7C00  -e start boot.o bootmain.o -o boot.out
# 	## truncate elf_i386 elf header.
# 	objdump -S boot.out > bootsec.asm
# 	objcopy -S -O binary -j .text boot.out boot
# 	perl sign.pl boot

# kernel:load
# 	gcc -pipe -nostdinc -O1 -fno-builtin -I. -MD -fno-omit-frame-pointer -std=gnu99 -static -mno-accumulate-outgoing-args -Wall -Wno-format -Wno-unused -Werror -gstabs -m32 -fno-tree-ch -fno-stack-protector  -gstabs -c -o  entrypgdir.o entrypgdir.c
# 	gcc -pipe -nostdinc -O1 -fno-builtin -I. -MD -fno-omit-frame-pointer -std=gnu99 -static -mno-accumulate-outgoing-args -Wall -Wno-format -Wno-unused -Werror -gstabs -m32 -fno-tree-ch -fno-stack-protector  -gstabs -c -o  init.o init.c
# 	gcc -pipe -nostdinc -O1 -fno-builtin -I. -MD -fno-omit-frame-pointer -std=gnu99 -static -mno-accumulate-outgoing-args -Wall -Wno-format -Wno-unused -Werror -gstabs -m32 -fno-tree-ch -fno-stack-protector  -gstabs -c -o  vga.o vga.c
# 	gcc -pipe -nostdinc -O1 -fno-builtin -I. -MD -fno-omit-frame-pointer -std=gnu99 -static -mno-accumulate-outgoing-args -Wall -Wno-format -Wno-unused -Werror -gstabs -m32 -fno-tree-ch -fno-stack-protector  -gstabs -c -o  printk.o printk.c
# 	gcc -pipe -nostdinc -O1 -fno-builtin -I. -MD -fno-omit-frame-pointer -std=gnu99 -static -mno-accumulate-outgoing-args -Wall -Wno-format -Wno-unused -Werror -gstabs -m32 -fno-tree-ch -fno-stack-protector  -gstabs -c -o  kclock.o kclock.c
# 	gcc -pipe -nostdinc -O1 -fno-builtin -I. -MD -fno-omit-frame-pointer -std=gnu99 -static -mno-accumulate-outgoing-args -Wall -Wno-format -Wno-unused -Werror -gstabs -m32 -fno-tree-ch -fno-stack-protector  -gstabs -c -o  pmap.o pmap.c
# 	gcc -pipe -nostdinc -O1 -fno-builtin -I. -MD -fno-omit-frame-pointer -std=gnu99 -static -mno-accumulate-outgoing-args -Wall -Wno-format -Wno-unused -Werror -gstabs -m32 -fno-tree-ch -fno-stack-protector  -gstabs -c -o  string.o string.c
# 	gcc -pipe -nostdinc -O1 -fno-builtin -I. -MD -fno-omit-frame-pointer -std=gnu99 -static -mno-accumulate-outgoing-args -Wall -Wno-format -Wno-unused -Werror -gstabs -m32 -fno-tree-ch -fno-stack-protector  -gstabs -c -o  assert.o assert.c
# 	gcc  -std=gnu99  -m32  -ggdb -c   entry.S -o entry.o
	
# 	ld -o entry -m elf_i386 -T kernel.ld -nostdlib  entry.o entrypgdir.o init.o vga.o printk.o string.o pmap.o kclock.o assert.o /usr/lib/gcc/x86_64-linux-gnu/4.8/32/libgcc.a -b binary
# 	objdump -S entry > kentry.asm
# 	$(NM) -n entry.out > entry.sym
# 	dd if=/dev/zero of=kernel.img~ count=10000 2>/dev/null
# 	dd if=boot of=kernel.img~ conv=notrunc 2>/dev/null
# 	dd if=entry of=kernel.img~ seek=1 conv=notrunc 2>/dev/null
# 	mv kernel.img~ kernel.img

# qemu-gdb: kernel
# 	qemu-system-i386 kernel.img -gdb tcp::1234 -S
# qemu: kernel
# 	qemu-system-i386 kernel.img
# gdb:
# 	gdb -n -x .gdbinit

# clean:
# 	rm -rf *.o *.img boot.d boot entrys entry.sym kernel.sym kernel.img boot.out *.d entry

INC_DIR:=./
LIBDIR:=lib
KERNDIR:=kern
BOOTDIR:=boot
OBJDIR:=obj

CFLAGS:=-pipe -nostdinc -O1 -fno-builtin -I. -MD -fno-omit-frame-pointer -std=gnu99 -static -mno-accumulate-outgoing-args -Wall -Wno-format -Wno-unused -Werror -gstabs -m32 -fno-tree-ch -fno-stack-protector   -gstabs  
C_ASMFLAGS:=-std=gnu99  -m32  -ggdb -I$(INC_DIR)
C_BOOTFLAGS:=-std=gnu99  -m32  -ggdb -O -I$(INC_DIR)

LD_BOOTFLAGS:=-m    elf_i386   -Ttext 0x7C00  -e entry
LD_KERNFLAGS:=-m elf_i386 -T $(KERNDIR)/kernel.ld -nostdlib 

QEMU:=qemu-system-i386


LIBSRC:=$(wildcard $(LIBDIR)/*.c)
LIBOBJ:=$(patsubst $(LIBDIR)/%.c,$(OBJDIR)/$(LIBDIR)/%.o,$(LIBSRC))
KERNSRC:=$(wildcard $(KERNDIR)/*.c)
KERNASM:=$(wildcard $(KERNDIR)/*.S)
KERNOBJ:=$(patsubst $(KERNDIR)/%.c,$(OBJDIR)/$(KERNDIR)/%.o,$(KERNSRC))
KERNOBJ+=$(patsubst $(KERNDIR)/%.S,$(OBJDIR)/$(KERNDIR)/%.o,$(KERNASM))

BOOTSRC:=$(wildcard $(BOOTDIR)/*.c)
BOOTASM:=$(wildcard $(BOOTDIR)/*.S)


##boot obj place can not replace, because of 'ld' is stupid to recognize .S compiled file first. If not 'Ttext' will link to wrong address.
BOOTOBJ:=$(patsubst $(BOOTDIR)/%.S,$(OBJDIR)/$(BOOTDIR)/%.o,$(BOOTASM))
BOOTOBJ+=$(patsubst $(BOOTDIR)/%.c,$(OBJDIR)/$(BOOTDIR)/%.o,$(BOOTSRC))






# BOOTLOADER compile and 512 byte.
$(OBJDIR)/$(BOOTDIR)/boot:$(BOOTOBJ)
	ld $(LD_BOOTFLAGS) $^ -o $@.out 
	
	
	objdump -S $@.out > $@.asm
	objcopy -S -O binary -j .text $@.out $@
	perl $(BOOTDIR)/sign.pl $@

#boot comiple
$(OBJDIR)/$(BOOTDIR)/%.o:$(BOOTDIR)/%.S 
	mkdir -p $(@D)
	
	gcc $(C_ASMFLAGS) -c   $< -o  $@	
$(OBJDIR)/$(BOOTDIR)/%.o:$(BOOTDIR)/%.c	
	mkdir -p $(@D)
	
	gcc $(C_BOOTFLAGS) -c   $< -o  $@



#KERNEL compile
$(OBJDIR)/$(KERNDIR)/kernel: $(KERNOBJ) $(LIBOBJ)

	ld $(LD_KERNFLAGS) $^ `find /usr/lib/gcc/x86_64-linux-gnu |grep /32/libgcc.a` -b binary -o $@
	objdump -S $@ > $@.asm
	nm -n $@ >$@.sym
	dd if=/dev/zero of=$@.img~ count=10000 2>/dev/null
	dd if=$(OBJDIR)/$(BOOTDIR)/boot of=$@.img~ conv=notrunc 2>/dev/null
	dd if=$@ of=$@.img~ seek=1 conv=notrunc 2>/dev/null
	mv $@.img~ $@.img



$(OBJDIR)/$(KERNDIR)/%.o:$(KERNDIR)/%.S 
	mkdir -p $(@D)
	gcc $(C_ASMFLAGS) -c   $< -o  $@	

$(OBJDIR)/$(KERNDIR)/%.o:$(KERNDIR)/%.c	
	mkdir -p $(@D)
	gcc $(CFLAGS) -c   $< -o  $@

$(OBJDIR)/$(LIBDIR)/%.o:$(LIBDIR)/%.c	
	mkdir -p $(@D)
	gcc $(CFLAGS) -c   $< -o  $@


qemu-gdb: $(OBJDIR)/$(BOOTDIR)/boot  $(OBJDIR)/$(KERNDIR)/kernel

	$(QEMU) $(OBJDIR)/$(KERNDIR)/kernel.img -gdb tcp::1234 -S
qemu: $(OBJDIR)/$(BOOTDIR)/boot  $(OBJDIR)/$(KERNDIR)/kernel
	$(QEMU) $(OBJDIR)/$(KERNDIR)/kernel.img
gdb:
	gdb -n -x .gdbinit

clean:
	rm -rf obj