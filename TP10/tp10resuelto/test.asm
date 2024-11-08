		.data
legajo:	.hword	24975
dni:	.hword	1761
neg:	.hword	0b10101110
pos:	.hword	0xB5C9
res1:	.hword	0x0
res2:	.hword	0x0
resultx1:	.hword	0x0
resultx2:	.hword	0x0
		.code
		lh r1, legajo(r0)
		lh r2, dni(r0)
		lh r5, neg(r0)
		lh r6, pos(r0)
op1:	dsubi r3, r1, 1761
		sh r3, res1(r0)
		slti r4, r3, 0
neg1:	beqz r4, pos1
		xnor r7, r3, r5
		sh r7, resultx1(r0)
		jmp op2
pos1:	xnor r7, r3, r6
		sh r7, resultx1(r0)
op2:	dsubi r3, r2, 24975
		sh r3, res2(r0)
		slti r4, r3, 0
neg2:	beqz r4, pos2
		xnor r8, r3, r5
		sh r8, resultx2(r0)
		jmp fin
pos2:	xnor r8, r3, r6
		sh r8, resultx2(r0)
fin:	halt
	halt