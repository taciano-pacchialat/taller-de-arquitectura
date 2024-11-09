		.data
legajo:	.hword	9677
dni:	.hword	3358
bin:	.hword	0b10101110
pos:	.hword	0xB5C9
res1:	.hword	0
res2:	.hword	0
resx1:	.hword	0
resx2:	.hword	0
		.code
		lh r1, legajo(r0)
		lh r2, dni(r0)
		lh r5, bin(r0)
		lh r6, pos(r0)
op1:	dsubi r3, r1, 9677
		sh r3, res1(r0)
		slti r4, r3, 0
neg1:	beqz r4, pos1
		xorr r7, r3, r5
        notr r7, r7
		sh r7, resx1(r0)
		jmp op2
pos1:	xorr r7, r3, r6
        notr r7, r7
		sh r7, resx1(r0)
op2:	dsubi r3, r2, 3358
		sh r3, res2(r0)
		slti r4, r3, 0
neg2:	beqz r4, pos2
		xorr r8, r3, r5
        notr r8, r8
		sh r8, resx2(r0)
		jmp fin
pos2:	xorr r8, r3, r6
        notr r8, r8
		sh r8, resx2(r0)
fin:	halt
	halt