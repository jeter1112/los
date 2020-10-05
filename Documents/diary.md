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