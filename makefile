

INC_DIR:=./
LIBDIR:=lib
KERNDIR:=kern
BOOTDIR:=boot
USERDIR:=user

OBJDIR:=obj

CFLAGS:=-pipe -nostdinc -O1 -fno-builtin -I. -MD -fno-omit-frame-pointer -std=gnu99 -static -mno-accumulate-outgoing-args -Wall -Wno-format -Wno-unused -Werror -gstabs -m32 -fno-tree-ch -fno-stack-protector   -gstabs  
C_ASMFLAGS:=-std=gnu99  -m32  -ggdb -I$(INC_DIR)
C_BOOTFLAGS:=-std=gnu99  -m32  -ggdb -O -I$(INC_DIR)

LD_BOOTFLAGS:=-m    elf_i386   -Ttext 0x7C00  -e entry
LD_KERNFLAGS:=-m elf_i386 -T $(KERNDIR)/kernel.ld -nostdlib 
LD_USERFLAGS := -T user/user.ld  -m    elf_i386 -nostdlib 
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


KERN_BINFILES :=	user/hello \
			user/buggyhello \
			user/buggyhello2 \
			user/evilhello \
			user/testbss \
			user/divzero \
			user/breakpoint \
			user/softint \
			user/badsegment \
			user/faultread \
			user/faultreadkernel \
			user/faultwrite \
			user/faultwritekernel

KERN_BINFILES := $(patsubst %, $(OBJDIR)/%, $(KERN_BINFILES))

KERN_OBJFILES:= kern/entry.o 	kern/entrypgdir.o  		kern/init.o     kern/pmap.o     kern/trap.o       kern/kclock.o      kern/trapentry.o \
				kern/env.o       kern/syscall.o      kern/printf.o   kern/console.o		lib/printfmt.o		lib/readline.o		lib/string.o 	lib/assert.o

KERN_OBJFILES := $(patsubst %, $(OBJDIR)/%, $(KERN_OBJFILES))
USER_LIBFILES := lib/entry.o  lib/console.o   lib/exit.o  lib/libmain.o  lib/printf.o  lib/printfmt.o   lib/syscall.o
USER_LIBFILES  := $(patsubst %, $(OBJDIR)/%, $(USER_LIBFILES ))

USER_OBJ := $(patsubst %, %.o, $(KERN_BINFILES))
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





KERN_LDFLAGS := $(LDFLAGS) -T kern/kernel.ld -nostdlib

# entry.S must be first, so that it's the first code in the text segment!!!
#
# We also snatch the use of a couple handy source files
# from the lib directory, to avoid gratuitous code duplication.


## /usr/lib/gcc/x86_64-linux-gnu/4.8/32/libgcc.a
#KERNEL compile
$(OBJDIR)/$(KERNDIR)/kernel: $(KERNOBJ) $(LIBOBJ) $(KERN_BINFILES)

	ld -o $@ $(LD_KERNFLAGS) $(KERN_OBJFILES)  /usr/lib/gcc/x86_64-linux-gnu/7.5.0/32/libgcc.a -b binary $(KERN_BINFILES)
	objdump -S $@ > $@.asm
	nm -n $@ >$@.sym
	dd if=/dev/zero of=$@.img~ count=10000 2>/dev/null
	dd if=$(OBJDIR)/$(BOOTDIR)/boot of=$@.img~ conv=notrunc 2>/dev/null
	dd if=$@ of=$@.img~ seek=1 conv=notrunc 2>/dev/null
	mv $@.img~ $@.img



$(OBJDIR)/$(KERNDIR)/%.o:$(KERNDIR)/%.S 
	mkdir -p $(@D)
	gcc $(CFLAGS) -c   $< -o  $@	

$(OBJDIR)/$(KERNDIR)/%.o:$(KERNDIR)/%.c	
	mkdir -p $(@D)
	gcc $(CFLAGS) -c   $< -o  $@


$(OBJDIR)/$(LIBDIR)/%.o:$(LIBDIR)/%.c	
	mkdir -p $(@D)
	gcc $(CFLAGS) -c   $< -o  $@

$(OBJDIR)/usr/%.o:$(LIBDIR)/%.S	
	mkdir -p $(@D)
	gcc $(CFLAGS) -c   $< -o  $@

$(OBJDIR)/$(USERDIR)/%.o: $(USERDIR)/%.c
	mkdir -p $(@D)
	gcc $(CFLAGS) -c   $< -o  $@

$(OBJDIR)/user/%: $(OBJDIR)/user/%.o $(OBJDIR)/usr/entry.o 
	ld -o $@ $(LD_USERFLAGS) $(USER_LIBFILES)  /usr/lib/gcc/x86_64-linux-gnu/7.5.0/32/libgcc.a
	objdump -S $@ > $@.asm
	nm -n $@ >$@.sym


qemu-gdb: $(OBJDIR)/$(BOOTDIR)/boot  $(OBJDIR)/$(KERNDIR)/kernel

	$(QEMU) $(OBJDIR)/$(KERNDIR)/kernel.img -gdb tcp::1234 -S
qemu: $(OBJDIR)/$(BOOTDIR)/boot  $(OBJDIR)/$(KERNDIR)/kernel
	$(QEMU) $(OBJDIR)/$(KERNDIR)/kernel.img
gdb:
	gdb -n -x .gdbinit

clean:
	rm -rf obj