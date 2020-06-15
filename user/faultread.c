// buggy program - faults with a read from location zero

#include <inc/lib.h>
#include "inc/stdio.h"
void
umain(int argc, char **argv)
{
	cprintf("I read %08x from location 0!\n", *(unsigned*)0);
}

