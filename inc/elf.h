// format of executable and linkable format(elf)

#ifndef INC_ELF_H
#define INC_ELF_H

#include"inc/types.h"
#define ELF_MAGIC 0x464C457FU   // asicii .ELF


// elf header
struct elfhdr{
    uint magic;
    uchar elf[12];
    ushort type;
    ushort machine;
    uint version;
    uint entry;
    uint phoff;
    uint shoff;
    uint flags;
    ushort ehsize;
    ushort phentsize;
    ushort phnum;
    ushort shentsize;
    ushort shnum;
    ushort shstrndx;
};


// program header

struct proghdr{
    uint type;
    uint off;
    uint vaddr;
    uint paddr;
    uint filesz;
    uint memsz;
    uint flags;
    uint align;
};

// Values for Proghdr type
#define ELF_PROG_LOAD           1

// Flag bits for Proghdr flags
#define ELF_PROG_FLAG_EXEC      1
#define ELF_PROG_FLAG_WRITE     2
#define ELF_PROG_FLAG_READ      4


#endif