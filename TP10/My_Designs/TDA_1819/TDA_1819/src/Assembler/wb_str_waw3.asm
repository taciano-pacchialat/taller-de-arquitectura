		.data
A:		.float	5.0
B:		.float	6.0
C:		.word	20
D:		.word	6
		.code
		lf f1, A(r0)
		lf f2, B(r0)
		lw r1, C(r0)
		lw r2, D(r0)
		nop
		mulf f4, f1, f2
		lf f4, A(r0)
		dsub r4, r1, r2
		dmul r5, r1, r2
		ddiv r6, r5, r2
		sw r1, D(r2)
		halt
	