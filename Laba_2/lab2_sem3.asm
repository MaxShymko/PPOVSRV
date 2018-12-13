	.mmregs
		
	.def _c_int00
	.text
		
_c_int00:	
N 		.set 136
k		.set 5
delta   .set 47

	xor A, A
	xor B, B
	
	stm sin, AR2
	stm cos, AR3
	st #delta, AR1
	st #N, AR6		
	stm	#result, AR5
	st #0, *AR5+

	rpt #k-1		
	add AR1, A;a=a+ar1
	nop

	stl A, AR4 
	stl A, AR1

main_loop:
	ld AR1, 16, A
	exp A
	st T, *AR2
	ld #9, B ; 5(min angle) + 5(scale) - 1
	sub *AR2, B ; B = B - AR2
	stl B, AR7
	add #1, B
	neg B
	stl B, T
	nop
	norm	A
	stl A, -11, *AR2 ;sin ;shift -16, mult scale 5
	mpy *AR2, *AR2, A
	ld #32767, B
	sub A, -16, B ;cos
	stl B, *AR3

get_angle:
	mpy *AR3, *AR2, A ;cos(a(n))*sin(a(n))
	mpy *AR2, *AR2, B ;sin^2(a(n))
	stl A, -14, *AR2 ;(2cos*sin)
	ld #32767, A
	sub B, -14, A ;1-2*sin(a)^2
	stl A, *AR3
	banz get_angle, *AR7-

	nop
	nop
	mvdd *AR2, *AR5+
	ld AR1, A
	add AR4, A
	stl A, AR1
	banz main_loop, *AR6-
	
	nop	
	nop
	nop

	.data
sin .word 1
cos .word 1
result .space N*16
