        .mmregs
		
		.def _c_int00
		.text
		
_c_int00:

N 		.set 136
k 		.set 5
min_a	.set 1024
delta	.set 7569
scale	.set -5 ; 2^scale

		SSBX SXM
		
		;ld	#result, DP
		
		st #0, AR1 ; синус
		
		st #32767, AR2 ; косинус
		
		st #min_a, AR4
		ld AR4, A
		exp A
		st T, AR4
		ADDM 1, AR4 ;количество незначащих нулей min_a
		
		stm #result, AR5
		st #0, *AR5+ ; синус 0рад. = 0
		
		stm #N-2, AR6 ; -1 т.к. banz на 1 больше и -1 т.к. первый угол (0) инициализирован

		ld #delta, A
		dst A, angle
		;dld angle, A

		ld #delta, B

main_cycle:

		;dld angle, A
		;dld angle, B
		exp A ; сохранить в T незн. нули угла
	
		add #delta, A
		dst A, angle ; инкрементировать угол на delta
	
		st T, AR3 
		ld AR3, A ; сохранить T (незн. нули) в A
		
		sub AR4, A
		stl A, AR3
		ld AR3, T
		norm B
		
		neg A
		sub #2, A
		stlm A, BRC ; сохранить незн. нули в BRC
		
		stl B, AR1 ; сохранить sin(alpha)
		
		stl B, -1, AR3
		ld AR3, B
		ld AR3, T ; чтобы поделить на 2
		
		; выполнить формулу 1 - (alpha^2)/2
		mpy AR3, A
		sfta A, -15
		stl A, AR7
		ld #32767, A
		sub AR7, A
		;? мб обрезать
		;ld #32767, 16, A ; загрузить единицу
		;mas AR1, A ; выполнить формулу 1 - (alpha^2)/2
		
		stl A, AR2 ; сохранить cos(alpha)
		
		rptb search_sin
	
		ld AR1, T ; загрузить синус
		ld AR1, A
		mpy AR2, B
		sfta B, -14 ; найти sin(2*alpha)
		
		stl B, AR1 ; сохранить sin(alpha)
		
		mpy AR1, A
		sfta A, -14
		stl A, AR7
		ld #32767, A
		sub AR7, A ; найти cos(2*alpha)
		
		stl A, AR2 ; сохранить cos(alpha)

search_sin:
		nop
		
		ld AR1, A
		stl A, *AR5+
	
		banz main_cycle, *AR6-
		
		nop	
		nop
		nop
		
		
		.align 100h
		.data
angle 	.space 32
result 	.space 16*N
