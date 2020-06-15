


#include "inc/stdio.h"
#include "kern/pmap.h"
#include "kern/env.h"
#include "kern/trap.h"
#include "inc/string.h"
#include "inc/console.h"
void init()
{
   extern char edata[], end[];

	// Before doing anything else, complete the ELF loading process.
	// Clear the uninitialized global data (BSS) section of our program.
	// This ensures that all static/global variables start out zero.
	memset(edata, 0, end - edata);
   cons_init();
   printk("hello world\n");
   printk("-----------------------------Welcome to-----------------------------------------\n\n\n\
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

   ENV_CREATE(user_hello, ENV_TYPE_USER);
   env_run(&envs[0]);

}


