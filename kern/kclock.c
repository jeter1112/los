/* See COPYRIGHT for copyright information. */

/* Support for reading the NVRAM from the real-time clock. */

/**
 * @file kclock.c
 * @author Jeter
 * @brief kclock.c uses CMOS(IO) to provide memory information and timer information.
 * @version 0.1
 * @date 2020-05-02
 * 
 * @copyright Copyright (c) 2020
 * 
 * klock port 0x70
 * offset meaning
偏移值(Offset)	数据字段的意义描述(Description)
00h
01h
02h
03h
04h
05h
06h
07h
08h
09h
目前系统时间的“秒数”字段
预约警铃时间的“秒数”字段
目前系统时间的“分钟”字段
预约警铃时间的“分钟”字段
目前系统时间的“小时”字段
预约警铃时间的“小时”字段
星期几（星期一＝01，星期二＝02，依次类推）
目前系统日期字段（0～31）
目前系统月份字段（0～12）
系统公元纪年的后两位（00～99；00＝2000，01＝2001，以此类推）
0Ah	
Status Register A（状态寄存器A）
Bit7	指示位。0＝目前可读取日期/时间,1=日期/时间更新中，稍后读取
Bit6-4	计时频率除法器的填值，BIOS默认为010b，指定32.768KHz的计数频率
Bit3-0	设置闹钟警示中断频率。BIOS默认为1024Hz,每次中断间隔为1/1024秒
0Bh	
Status Register B（状态寄存器B）
Bit7	停止系统频率设定时间（0＝直接设定时间，实时系统仍在计时状态）（1＝停止CRT计时并设定时间）
Bit6	周期性中断（0=Disable，1=Enable）
Bit5	Alarm Interrupt（0=Disable，1=Enable）
Bit4	Update-Ended Interrupt（0=Disable，1=Enable）
Bit3	Square wave 方波设定（0=关掉方波，1=依Status Reg A 设定产生方波）
Bit2	Date and Time Mode （0＝使用BCD格式，为默认值。1＝binary二进制值）
Bit1	24 或 12 小时计时制（0＝指定12小时制，1＝设定24小时制）
Bit0	日光节约时间（0=Disable，1=Enable）
0Ch	
Status Register C（状态寄存器C），以下为只读状态
Bit7	IRQ Flag (read-only)
Bit6	Periodic Interrupt Flag (read-only)
Bit5	Alarm Interrupt Flag (read-only)
Bit4	Update Interrupt Flag (read-only)
Bit3-0	保留未用，应该设为 0。
0Dh	
Status Register D（状态寄存器D）
Bit7	CMOS RAM内容合法（0＝CMOS电池储电量偏低，RAM内容正常）（0＝CMOS电池储电量偏低，RAM内容异常）
Bit6-0	保留未用，应该设为 0。
0Eh	
Diagnostic Status（诊断状态记录值）
Bit7	CMOS/RTC芯片电源（0＝电源正常，1＝电源不正常）
Bit6	CMOS RAM checksum加总检查值状态（0＝检查值正常，1＝检查值不符）
Bit5	CMOS RAM组态（0＝CMOS记录的组态与目前检测到的一致，1＝组态不一致）
Bit4	CMOS RAM 记录的内存状态（0＝CMOS记录的内存跟目前检测到的一致，1＝组态不一致）
Bit3	硬盘C:起始状态（0＝启动通过，准备boot。1＝硬盘C:启动失败，无法boot）
Bit2	时间状态指示（0＝记录时间正常。1＝记录时间异常）
Bit1-0	保留未用，应该设为 0。
0Fh	
shutdown status byte 当机复位指示字节，指示值如下：
00h	软件或其他不知名状态下的复位（reset）
01h	正在真实/保护模式下检查内存时发生reset或者重新进入真实模式下做芯片组initialization时发生reset
02h	在真实/保护模式下内存家传通过后的系统复位
03h	在真实/保护模式下内存家传通失败的系统复位
04h	通过INT 19h重新开机（boot）
05h	清除键盘中断（产生一个EOI信号）并且跳到40h:0067h记录的跳跃位置
06h	在保护模式下完成所有测试后的系统复位或在未产生EOI信号下跳到40h:0067h记录的跳跃位置
07h	在保护模式下没有通过所有测试后的系统复位
08h	由POST切到保护模式下进行内存家测时所使用
09h	由BIOS INT 1h 的 AH="87h"（区块移动功能）所使用
0Ah	返回并跳跃到40h:0067h记录的程序进入点地址
0Bh	以IRET方式回到40h:0067h记录的程序进入点
0Ch	以RETF方式回到40h:0067h记录的程序进入点
0Dh-FFh	系统电源刚打开时的复位
10h	

值	软驱类型
00	None
01	360K 5.25 in.
02	1.2M 5.25 in.
30	720K 3.5 in.
40	1.44M 3.5 in.
50	2.88M 3.5 in.
11h～13h	可供其他用途
14h	
Bits7-6	软盘驱动器数目（00＝1 Drive,01＝2 Drives）
Bits5-4	Monitor Type 显示器型号（00＝Monochrome,01=40*25 CGA,10=80*25 CGA,11=VGA/EGA）
Bit3	显示功能位（0＝不显示，1＝启用并显示））
Bit2	键盘功能位（0＝关掉键盘，1＝启用键盘）
Bit1	协处理器（x87）（0＝不具备FPU,1＝具备）
Bit0	软盘机Drive（0Disabled，1＝Enabled）
15h	传统主存储器KB数，低字节
16h	传统主存储器KB数，高字节C0280h＝640K
17h	与IBM PC 兼容的总内存KB数，低字节
18h	与IBM PC 兼容的总内存KB数，高字节（最大值仅FFFF=65535=64M）
19h～2Dh	可供其他用途
2Eh	标准CMOS RAM 加总检查值，低字节
2Fh	标准CMOS RAM 加总检查值，高字节
30h	与IBM PC 兼容的扩展内存KB数，低字节
31h	与IBM PC 兼容的扩展内存KB数，高字节
32h	公元年号除以100后的BCD字段（20h＝2000～2099，跟09h字段凑成整个公元纪年）
33h～34h	保留未用
35h	POST所检测到扩展内存K数，除以64KB后的数值（低字节）
36h	POST所检测到扩展内存K数，除以64KB后的数值（高字节）
37h～3Dh	可供其他用途
3Eh	扩展CMOS加总检查值的（低字节，从34h计算到3Dh）
3Fh	扩展CMOS加总检查值的（高字节，从34h计算到3Dh）
40h～7Fh	供AMI BIOS动态配置使用

 * 
 * 
 */


#include "inc/x86.h"

#include "kern/kclock.h"


unsigned
mc146818_read(unsigned reg)
{
	outb(IO_RTC, reg);
	return inb(IO_RTC+1);
}

void
mc146818_write(unsigned reg, unsigned datum)
{
	outb(IO_RTC, reg);
	outb(IO_RTC+1, datum);
}
