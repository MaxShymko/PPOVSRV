		.mmregs

		.def _c_int00
		.text		
_c_int00:

N_DBC 	.set 	128
K       .set 	10
N   	.word   1
step    .word   128
;;;;;;;;инициализация;;;;;;;;;;;		
		xor     B,B 
		stm     #N_DBC*2-2,AR7
		stm     #sinus,AR3
		stm		#output_r, AR5 
		ld      *AR3+,A
;;;;;;;;инициализация;;;;;;;;;;;
		
;;;;;;;;;;;;DBC;;;;;;;;;;;;;;
DBC:		
		ld      #N_DBC,A	;A=N/2, для алгоритма Рэйдера
		sth     B,1,AR1		;сохранение текущей позиции			
		sftl    B,#K		;сдвиг этой позиции, чтобы узнать ее старший бит(бит С) 
		bc     	new_pos,NC	;если в старшем разряде 1, смотрим следующий бит
RADER:		
		ld      A,-1,A		;алгоритм Рэйдера
		sub     #N_DBC,A	;алгоритм Рэйдера
		sftl    B,1			;сдвиг позиции еще на 1 разряд, чтобы узнать ее старший бит(бит С) 
		bc     	RADER,C		;если в старшем разряде 1, смотрим следующий бит
new_pos:
		add     AR1,A		;узнаем новую позицию	
		ld      A,15,B		;сохряняем новую позицию в B
		stlm    A,AR0		;загружаем ее в AR0
		ld      *AR5+0,A	;устанавливаем указатель в новом массиве на adr+AR0
		mvdd    *AR3+,*AR5  ;перенос значения из adr+1 старого массива в adr+AR0 нового массива
		stm		#output_r, AR5 ;устанавливаем указатель в новом массиве на adr = 0
		banz    DBC,*AR7-
;;;;;;;;;;;;DBC;;;;;;;;;;;;;;

;;;;;;;;инициализация;;;;;;;;;;;			
		nop
		stm		#output_i, AR3
		stm		#output_r, AR5 
		stm     #SIN,AR4
		stm		#COS, AR2 
		ld      #N,DP
		stm		#7, AR1 ; log(N_DBC)
		ld      step,A
		SUB     #1,A
		stlm    A,AR7	
		ld      N,A
		stlm    A,AR0
		SUB     #1,A
;;;;;;;;инициализация;;;;;;;;;;;

;;;;;;;;начальная мнимая часть;;;;;;;;	
		rpt     #N_DBC*2-1
		st      #0,*AR3+
		stm		#output_i, AR3
;;;;;;;;начальная мнимая часть;;;;;;;; 
		nop			
		;rpt     #N_DBC*2-1
		;st      #32767,*AR5+
		;stm	 #output_r, AR5
																				
block_step:		
;;;;;;;;;;;BPF;;;;;;;;;;;;;;;;;;;;	
		stlm     A,BRC
		nop
		rptb     BPF
		ld       *AR3+0,-1,A  	;A = PI/2	
		ld       *AR5+0,-1,A  	;A = PR/2
		mpy      *AR5,*AR2,B
		mac	 	 *AR3,*AR4,B,B	;B = QR*cosx+QI*sinx
		sftl     B,-16			;B = (QR*cosx+QI*sinx)/2
		ld       *AR5-0,T  		;A = QR
		add      B,A       		;A = PR/2+B/2 = PR
		stl      A,*AR5+0		;PR = A
		sub      B,A			;A = PR/2
		neg      B				;B = -(QR*cosx+QI*sinx)
		add      B,A			;A = PR/2-(QR*cosx+QI*sinx)/2
		mpy      *AR3,*AR2,B
		mas	 	 *AR5,*AR4,B,B	;B = QI*cosx-QR*sinx
		sftl     B,-16			;B = (QI*cosx-QR*sinx)/2
		stl      A,*AR5-0 		;QR = A
		
		ld       *AR3-0,A  		;A = QI
		ld       *AR3,-1,A  	;A = PI/2
		add      B,A       		;A = PI/2+B/2 = PI
		stl      A,*AR3+0		;PI = A
		sub      B,A
		neg      B				;B = -(QI*cosx-QR*sinx)/2
		add      A,B			;B = PI/2-(QI*cosx-QR*sinx)/2
		stl      B,*AR3-0		;QI = B
		ld       *AR3+,A 		;переход к следующей паре четного/нечетного ДПФ
		ld       *AR5+,A		
		
		ld      step,A			;переход к следующему поворотному коэффициенту
		stlm    A,AR0
		nop
		nop
		ld      *AR2+0,B
		ld      *AR4+0,B
		ld      N,A				
		stlm    A,AR0		
BPF:
;;;;;;;;;;;;BPF;;;;;;;;;;;;;;;;;;;;;;
		nop
		nop
		ld      *AR3+0,B
		ld      *AR5+0,B
		stm		#COS, AR2 
		stm		#SIN, AR4 
		sub     #1,A
		banz    block_step,*AR7-
;;;;;;;кол-во N-точечных ДПФ;;;;;;;
		nop
		ld      step,A
		sfta    A,-1
		stl     A,step
		sub     #1,A
		stlm    A,AR7
		ld      N,A
		sfta    A,1
		stl     A,N 
		stlm    A,AR0
		stm		#output_r, AR5 
		stm		#output_i, AR3
		stm		#COS, AR2 
		stm		#SIN, AR4 
		sub     #1,A
		banz    block_step,*AR1-
		nop
;;;;;;;Изменение кол-ва n-точечных ДПФ;;;;;;;		
		nop
		
		;.align 512
sinus 	.include SIN256.asm         ;выделение памяти под синусоиду
output_r 
		.space (N_DBC*2)*16
output_i 
		.space (N_DBC*2)*16
SIN 	.include SIN256.asm         ;выделение памяти под синусоиду
COS 	.include COS256.asm         ;выделение памяти под синусоиду
