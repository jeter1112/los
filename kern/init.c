

#include"inc/vga.h"
#include"inc/printk.h"
#include"pmap.h"

void init()
{
   console_clear();
   printk("hello world\n");
   putstr("-----------------------------Welcome to-----------------------------------------\n\n\n\
            -------           -----               -----\n\
               |              |   |               |\n\
               |              |   |               -----\n\
               |              |   |                   |\n\
            ----              -----               -----\n\
   ");
   mem_init();
}


