#include "inc/vga.h"

#include "inc/types.h"
#include "inc/x86.h"


static uint16_t* videomem=(uint16_t*)0xf00b8000;
static uint16_t cursor_x=0;
static uint16_t cursor_y=0;



static void lmove_cursor()
{
    //25 rows, 80 columns;
    uint16_t cursor_location=cursor_y*80+cursor_x;

    outb(0x3D4,14);
    outb(0x3D5,cursor_location>>8);
    outb(0x3D4,15);
    outb(0x3D5,cursor_location);
    
}

// scroll mehod wrap the content when the content size over the page size
//
//
static void lscroll()
{
    //check the content size;
    //move the last 24 lines upwards
    // update cursor;

    uint8_t attribute_byte = (0 << 4) | (15 & 0x0F);
    uint16_t blank = 0x20 | (attribute_byte << 8);  // space 是 0x20

    if(cursor_y>=25) //check the content size;
    {
        for(int i=0;i<24*80;++i)
        {
            videomem[i]=videomem[i+80];
        }

        for( int i=24*80;i<25*80;++i)
        {
             videomem[i]=blank;
        }
        cursor_y=24;
    }


    
}


void console_clear()
{   
    uint8_t attribute=(0<<4)|(15&0x0f);
    uint16_t blank= 0x20 |(attribute<<8);

    
    for(int i=0; i< 80*25;i++)
    {
        videomem[i]=blank;
    }

    cursor_x=0;
    cursor_y=0;
    lmove_cursor();
}


void lputc(char c)
{
    
    uint16_t attribute=((0<<4)|(15&0x0f))<<8;
    
    // 0x08 是退格键的 ASCII 码
    // 0x09 是tab 键的 ASCII 码
    if (c == 0x08 && cursor_x) {
          cursor_x--;
    } else if (c == 0x09) {
          cursor_x = (cursor_x+8) & ~(8-1);
    } else if (c == '\r') {
          cursor_x = 0;
    } else if (c == '\n') {
        cursor_x = 0;
        cursor_y++;
    } else if (c >= ' ') {
        videomem[cursor_y*80 + cursor_x] = c | attribute;
        cursor_x++;
    }

    // 每 80 个字符一行，满80就必须换行了
    if (cursor_x >= 80) {
        cursor_x = 0;
        cursor_y ++;
    }

    // 如果需要的话滚动屏幕显示
    lscroll();

    // 移动硬件的输入光标
    lmove_cursor();
}

void putstr(char* cstr)
{
    while(*cstr)
    {
        lputc(*cstr++);
    }
}