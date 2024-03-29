#include"inc/assert.h"
#include"inc/printk.h"
#include"inc/stdarg.h"
/*
 * Variable panicstr contains argument to first call to panic; used as flag
 * to indicate that the kernel has already called panic.
 */
const char *panicstr;

/*
 * Panic is called on unresolvable fatal errors.
 * It prints "panic: mesg", and then enters the kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
	va_list ap;

	if (panicstr)
		goto dead;
	panicstr = fmt;

	// Be extra sure that the machine is in as reasonable state
	asm volatile("cli; cld");

	va_start(ap, fmt);
	printk("kernel panic at %s:%d: ", file, line);
	vcprintf(fmt, ap);
	printk("\n");
	va_end(ap);

dead:
	/* break into the kernel monitor */
	while (1)
		;
}

/* like panic, but don't */
void
_warn(const char *file, int line, const char *fmt,...)
{
	va_list ap;

	va_start(ap, fmt);
	printk("kernel warning at %s:%d: ", file, line);
	vcprintf(fmt, ap);
	printk("\n");
	va_end(ap);
}
