#ifndef PRINTK_H
#define PRINTK_H
#include"stdarg.h"


int printk(const char*,...);
int vcprintf(const char *fmt, va_list ap);

#endif