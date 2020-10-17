# 20201002

今天下午,我重新拾起OS,从interrupt开始.一个小时后,我躺到了床上.扒拉了半小时的手机,我起床喝水,心里想着'现在开始,一切皆有可能',查看了git的commit记录,发现了最近一次是9月6日,前一次有用的提交是6月14日,再之前一次也是最开始提交的commit是5月2号.我回顾了一下,自己OS做的最快学的最多的时候是在疫情期间(2-4月),有两次打的milestone(bootloader,memory management),五月返校之后就没有实质性的进展了. 对比现在,疫情那时候自己是每天(一开始每天,五天之后就隔三差五写一篇,最长的是十天写一篇)写diary.虽然有时一个问题让我纠结一两个星期,但是因为自己完善diary的执念,会找寻各种策略去解决问题.

总结一下,对我做OS最重要的几部分是diary(记录解决方法,寻找策略),theory(lecture from standford,berkeley,mit,some kernel tutorials),code source(xv6,pintos,JOS), technique mannaul(x86,clock,vga), time(每天6小时).对我最重要的milestones:1. bootloader的介绍(xv6还有yele大学的实验),VGA,print format的实现,2.明白gdt不是非常的重要(一开始觉得非常重要),3.thread 抽象CPU, paging抽象memory. 

some tips:

1. 做os一小时以上才休息.因为这样时间分散的情况会减少,集中的时间会增加.我发现虽然说45分钟休息10分钟,但是我按照这个去做,总是做半小时,休息半小时.所以做的时间最好超过一个小时. 并且每一小时,定下一个TODO term,不管是 term还是subterm.一天积攒至少6个TODO对勾.
2. 打字秘籍:jf key 凸起一定不要离开.


# 20201003

## Knowledge appear moment:
1. Paging is much better than segmentation. However, there is one thing that segmentation can do that paging can't, and that's set the ring level. 
    --> ring level is controlled by GDT. This also explains why GDT has sevaral entries. Because kernel and user has different rings(privilege level).so GDT contains
        kernel entry and user entry with different ring values
2. Code or picture should be self-explainary.

3. Instruction cycle with interrupt.
    1. fetch next instruction.
    2. execute instruction.
    3. check for interrupt.
        if no interrupt -> 1.
        else -> 
        — Suspend execution of current program 
        — Save context
        — Set PC to start address of interrupt handler routine
        — Process interrupt
        — Restore context and continue interrupted program

# 20201004

## knowledge appear moment:

1.[intel boot mannual](https://www.intel.cn/content/dam/www/public/us/en/documents/white-papers/minimal-intel-architecture-boot-loader-paper.pdf)
2. find material to support your decision or  improve automatibility:like x86 mannual to support bootloader.

# 20201005

## knowledge appear moment:

1. gdb `ni` and `si` instruction, not `n` and `s` instruction. when type `n` or `s`, Cannot find bounds of current function error appears

# 20201006

## knowledge appear moment:

1. use inline function to wrap inline assembly, assembly -> inline assembly -> inline function. write these functions in a header file;
   use define to replace the integer index which is not easy to remember, like page enable bit, or stack position, or page size.

2. Best [lecture slides](https://www.ics.uci.edu/~aburtsev/143A/2017fall/) about **XV6**, theory is common, but practice(code explaination) is the best I have seen.

3. explaination about xv6 boot, especially [Elf read from disk part](http://leenjewel.github.io/blog/2015/05/26/%5B%28xue-xi-xv6%29%5D-jia-zai-bing-yun-xing-nei-he/).

4. remember than asm file .S not .s.

5. [x86 Assembly Language
Reference Manual](https://docs.oracle.com/cd/E19253-01/817-5477/817-5477.pdf)

    operating system instructions
    ```
    arpl    ;adjust requested privilege level
    clts    ;clear the task-switched flag
    hlt     ; halt processor
    invd    ; invalidate cache, no write back
    invlpg  ; invalidate TLB entry
    lar     ; load access rights
    lgdt    ; load global descriptor table register
    lidt    ; load interrupt descriptor table register
    lldt    ; load local descriptor table register
    lock    ; lock bus

    ltr     ; load task register

    sgdt    ;
    sldt    ;

    ```

    I/O Instructions
    ```
    in  ; read from a port
    ins ; read string from a port
    insb; input byte string from port
    insl;
    insw;
    out ;
    outs;
    outsb,l,w;
    ```


lgdt, load the register with a 16-limit and a 32-bit base.

6. hard disk addressing mode, CHS and LBA, CHS mode uses geometry of disk to address, which is difficult to programmer, while LBA uses linear address, which is nice.
    There are no references about disk command registers work, but os three easy pieces book give an explaination.
   [How without operating system](http://web.cs.ucla.edu/classes/spring08/cs111/scribe/2/index.html).

# 20201007

## knowledge appear moment:

1. divide and conquer idea:  module -> submodule,  makefile--> submakefile, push the shared part to the father module like varaible or parameters.

# 20201008

## knowledge appear moment:

1. 今天晚上7点半也就是在宝能城吃过欢乐牧场后,我和逸飞,汪狗,贾哥等同学在电玩城玩飞车,抓娃娃还有投硬币推硬币游戏. 飞车游戏我和逸飞狂虐两个妹子和一个男生,感觉美滋滋.
抓娃娃抓了8把,一把没中. 回宿舍后,我在操场跑了12圈.洗完澡后在想怎么描述投硬币这个游戏. 从能直接看到的来讲,投入硬币后,硬币会落在盘子上,盘子一半是硬币,另一半是空的.一个推子从空的一头推到硬币与空地的交界处.
如果硬币落在硬币上,相当于叠罗汉,硬币不会被推下来.如果硬币落在空地上,推子会推着硬币到硬币堆里,硬币有概率的掉落.如果在仔细看,我们会发现,硬币在投掷的过程中会经过一个摆子,摆子下方还有个老虎,如果硬币砸中老虎,机子会随机弹出几个硬币.

# 20201008

## knowledge appear moment:

lab3 is kernel mode,user mode transition. four concepts:


# 20201010

## knowledge appear moment:

1. osdev contains hardware introuctions. like memory A20,detecting memories methods like CMOS, which is used at XV6.
2. roadmap confusion:
    - do the lab4, refer to github -> meets deadline, but suffer knowledge of hardware, and problem solving skill.
    - look for the hardware interface, bottom up. -> partly knowledge of hardware, refer to hardware mannual, problem solving, but may fall in holes.fall deadline.
    - in conclusion, refer to the compiler issues from github, but look for hardware interface.

3. my view for interface:
    - test for the complexity, then think the interface.
    - simulate in the head, think the interface, then test.

4. control,status,data register -> enable A20, or memory map, or disk access.\
    a course told about [hardware interfaces](https://www.cis.upenn.edu/~milom/cse240-Fall06/)

    QEMU uses IDE(ATA),not AHCI, xv6 uses IDE registers to control disk.