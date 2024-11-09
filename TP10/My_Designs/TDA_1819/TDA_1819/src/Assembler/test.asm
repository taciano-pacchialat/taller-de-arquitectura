        .data
op1:    .hword 9677
op2:    .hword 3588
bin:    .hword 0b10101110
hex:    .hword 0xB5C9
res1:   .hword 0
res2:   .hword 0
resx1:  .hword 0
resx2:  .hword 0
        .code
        lh r1, op1(r0)
        lh r2, op2(r0)
        lb r3, bin(r0)
        lh r4, valorhex(r0)
        nop
        dsubi r5, r1, 3588 
        sh r5, res1(r0)
        slti r6, r5, 0
        beqz r6, pos1
        xnor r7, r5, r3
        jmp guar1
        nop
pos1: xnor r7, r5, r4
guar1:  sh r7, resx1(r0)
        nop
        dsubi r5, r2, 9677 
        sh r5, res2(r0)
        slti r6, r5, 0
        beqz r6, pos2
        xnor r7, r5, r3
        jmp guar2
        nop
pos2: xnor r7, r5, r4
guar2:  sh r7, resx2(r0)
        nop
        halt

