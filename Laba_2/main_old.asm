        .mmregs
		
		.def _c_int00
		.text
		
_c_int00:

N 		.set 136
k 		.set 5
min_a	.set 1024 ;минимальный угол
delta	.set 32768/N*k
scale	.set -5 ; 2^scale

		SSBX SXM
		
		st #0, AR1
		
		st sinus, AR2 ; sin
		st cosinus, AR3 ; cos
		
		st #min_a, AR4
		ld AR4, A
		exp A
		st T, AR4
		ADDM 4, AR4 ;количество незначащих нулей min_a
		
		stm	#result, AR5
		
		st #0, *AR5+
		
		st #N-1, AR6
	
main_cycle:
		
		addm #236, AR1
		
		ld AR1, T ; загрузить delta в T
		
		;ld #N, 16, A ; сдвиг на 16 для MPYA
		;sub AR6, 16, A ; текущий отсчет
		
		;MPYA A ; текущий шаг (n*ka)
		
		ld AR1, A
		
		exp A
		
		st T, AR7
		ld AR4, B
		sub AR7, B
		neg B
		stl B, AR7 ; сколько раз поделить на 2
		ld AR7, T
		norm A
		
		;st #scale, AR7
		;ld AR7, T
		;norm A
		
		neg B
		sub #1, B
		stlm B, BRC
		
		stl A, AR2 ; sin
		
		ld AR2, T
		mpy AR2, A
		sfta A, -6
		sub #32767, A
		neg A
		stl A, AR3 ; cos
		
		rptb get_sin_cycle
		
		ld AR3, T
		mpy AR2, A
		sfta A, -9
		stl A, AR2 ; save sin(2a)
;		stl A,*AR5+		
		
		mpy AR3, A
		sfta A, -14
		sub #32767, A
		stl A, AR3 ; save cos(2a)
				
get_sin_cycle:
		nop
				
		ld AR2, A
		stl A, *AR5		
		ld *AR5+, B
		

		banz main_cycle, *AR6-
		
		nop	
		nop
		nop
		
		
		.data
sinus   .data  1
cosinus .data  1
result 	.word  N
