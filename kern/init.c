

#include "inc/vga.h"
#include "inc/printk.h"
#include "kern/pmap.h"
#include "kern/env.h"
#include "kern/trap.h"
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

   //virtual mem_init;
   mem_init();
   
   //process init;
   env_init();
   //
   trap_init();

}


