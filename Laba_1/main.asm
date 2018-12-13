        .mmregs
		
		.def _c_int00
		.text
		
_c_int00:

N 		.set 136
k		.set 17
S1		.set 23170 ; sin(2pi/N*k)*32768
C1      .set 23170
Sk 		.set 0
Ck		.set 32767

		st     	#Sk, AR1
		st      #Ck, AR2
		st      #S1, AR3
		st      #C1, AR4
		st      #N, AR6
		
		st      #0, AR7
		
		stm		#array, AR5
		
		st		#k-1, BRC
		rptb	cycle_1

main_cycle:		
		ld      AR1, A
		stl 	A, T
		mpy 	AR4, A
		
		ld      AR2,B
		stl 	B, T
		mpy 	AR3, B
		
		add 	B, A
		
		sftA    A, -15
		
		ld      AR1, B
		stl     A, AR1
		
		ld 		AR2, A
		stl 	A, T
		mpy 	AR4, A
		
		stl 	B, T 
		mpy 	AR3, B
		
		sub     B, A
		
		sftA    A, -15
		
		stl     A, AR2
		
cycle_1:
		nop
		
		banz    flag, *AR7-
		ld      AR1, A
		stl		A, AR3
		ld      AR2, A
		stl     A, AR4
		st      #Sk, AR1
		st      #Ck, AR2

flag:
		nop
		
		ld      AR1, A
		stl     A, *AR5+
		
		banz    main_cycle, *AR6-	
		
		nop
		nop
		nop
		
		
		.data
array 	.word  N
