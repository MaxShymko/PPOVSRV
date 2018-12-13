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
		
		st #0, AR1 ; �����
		
		st #32767, AR2 ; �������
		
		st #min_a, AR4
		ld AR4, A
		exp A
		st T, AR4
		ADDM 1, AR4 ;���������� ���������� ����� min_a
		
		stm #result, AR5
		st #0, *AR5+ ; ����� 0���. = 0
		
		stm #N-2, AR6 ; -1 �.�. banz �� 1 ������ � -1 �.�. ������ ���� (0) ���������������

		ld #delta, A
		dst A, angle
		;dld angle, A

		ld #delta, B

main_cycle:

		;dld angle, A
		;dld angle, B
		exp A ; ��������� � T ����. ���� ����
	
		add #delta, A
		dst A, angle ; ���������������� ���� �� delta
	
		st T, AR3 
		ld AR3, A ; ��������� T (����. ����) � A
		
		sub AR4, A
		stl A, AR3
		ld AR3, T
		norm B
		
		neg A
		sub #2, A
		stlm A, BRC ; ��������� ����. ���� � BRC
		
		stl B, AR1 ; ��������� sin(alpha)
		
		stl B, -1, AR3
		ld AR3, B
		ld AR3, T ; ����� �������� �� 2
		
		; ��������� ������� 1 - (alpha^2)/2
		mpy AR3, A
		sfta A, -15
		stl A, AR7
		ld #32767, A
		sub AR7, A
		;? �� ��������
		;ld #32767, 16, A ; ��������� �������
		;mas AR1, A ; ��������� ������� 1 - (alpha^2)/2
		
		stl A, AR2 ; ��������� cos(alpha)
		
		rptb search_sin
	
		ld AR1, T ; ��������� �����
		ld AR1, A
		mpy AR2, B
		sfta B, -14 ; ����� sin(2*alpha)
		
		stl B, AR1 ; ��������� sin(alpha)
		
		mpy AR1, A
		sfta A, -14
		stl A, AR7
		ld #32767, A
		sub AR7, A ; ����� cos(2*alpha)
		
		stl A, AR2 ; ��������� cos(alpha)

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
