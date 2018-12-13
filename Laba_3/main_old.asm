       .mmregs
		
		.def _c_int00
		.text
		
_c_int00:
N   .set   816 
	stm #sinus+4, AR5 ;x[i]
	
	stm #sinus+3, AR4 ;x[i-1]
	
	stm #sinus+2, AR3 ;x[i-2]
	
	;stm #sinus+1, AR2 ;x[i-3]
	
	stm #sinus, AR1 ;x[i-4]
	
	stm #output+4, AR6 ;y[i]
	
	stm #output+2, AR7 ;y[i-2]
	
	stm #output, AR2 ;y[i-4]
	
	stm #N/3-1, brc
	
	rptb p
	
	ld #0, A
	
	ld #0, B
	
	mac *AR1+, #3080, A, A;x[i-4]*b4
	
	mac *AR1,  #12283, A, A;x[i-3]*b3
	
	mac *AR3+, #18427, A, A;x[i-2]*b2
	
	mac *AR4+, #12283, A, A;x[i-1]*b1
	
	mac *AR5+, #3080, A, A;x[i]*b0
	
	mac *AR7+, #578, A, A;y[i-4]*a4
	
	mac *AR2+, #15881, A, A;y[i-2]*b2
	
	sth A, *AR6+
	
p: nop
	
	nop
	
.align
	
.data
	
freq .word 15680

min_sin .word 0x400

sin1 .word 0

cos1 .word 0

a_store .long 0

m_store .word 0
	
sinus .include sin.asm
	
cosinus .space 16*N
	
output .space 16*N
