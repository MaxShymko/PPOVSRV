		.mmregs
			
		.def _c_int00
		.text
		
_c_int00:

N 		.set 256 
Sk 		.set 0
Ck		.set 32767
S1		.set 1607
C1      .set 32728
k       .set 63

		st      #k,AR0
		stm		#sinus, AR5
		SSBX 	OVM
GAR:	
		st     	#Sk,AR1
		st      #Ck,AR2
		st      #S1,AR3
		st      #C1,AR4
		st      #N,AR6
		st      #0,AR7
		ld      AR0,A
		sub     #k,A
		neg     A
		stlm	A, BRC	
		nop			
		rptb	search_Sk_Ck
search_Sn_Cn:		
						
		ld      AR1,A	
		stl 	A, T 	
		mpy 	AR4, A	
		
		ld      AR2,B	
		stl 	B, T 	
		mpy 	AR3, B	
		
		add     B,A		
		sftA    A,-15	
		ld      AR1,B	
		stl     A,AR1	
					
		ld 		AR2,A	
		stl 	A, T 
		mpy 	AR4, A	
		
		stl 	B, T 
		mpy 	AR3,B 
		
		sub     B,A		
		sftA    A,-15
		stl     A,AR2	
search_Sk_Ck: 
		nop
		banz    block,*AR7- 
		ld      AR1,A		
		stl		A,AR3
		ld      AR2,A
		stl     A,AR4
		st      #Sk,AR1    
		st      #Ck,AR2
		ld      #Ck,A		
block:		
		nop
		nop
		nop
		ld      AR1,A
		stl     A,*AR5+		
   		banz    search_Sn_Cn,*AR6-
   		nop
   		nop
   		nop
  		banz    GAR,*AR0-
  		nop	
	
		;filter
																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																				
																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																				
																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																				
																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																				
				
		stm     #2,AR7
		xor     B,B
main_loop:		
		
		stm		#sinus-2, AR5	;результат X
		rptz    A,#2
		stl     A,*AR5+
		stm 	#filter-2, AR4	;y[i]
		rptz    A,#2
		stl     A,*AR4+	
		stm		#sinus-2, AR5
		stm 	#filter-2, AR4			
		stm 	#N*k-1, brc
	
		rptb IIR
		
 		RSBX OVA
		
		stm     	#koef, AR3
		stlm        B,AR0
		nop
		nop
		ld          *AR3+0,A	
		st          #2,AR0
		
		xor  		A,A
						
		rpt #2
		mac *AR5+,*AR3+,A,A ;x[i-6:i]
		rpt #1
		mas *AR4+, *AR3+,A,A ;y[i-6:i]		
		SFTA A,1
		stl  A,-16, *AR4+     ;y[i]
		ld  *AR4-0,A
		ld  *AR5-0,A	
IIR:
		nop
		add     #5,B
		stm		#sinus, AR5	;результат X	
		stm 	#filter, AR4	;y[i]
		rpt    	#N*k-1	
		mvdd    *AR4+,*AR5+	
		banz    main_loop,*AR7-
		nop	
		nop
		nop
		
		;AFC
		
		xor     A,A
		stm 	#filter+N/2, AR4
		stm 	#AFC_arr, AR2 
		st      #N/2,AR0
		st      #k,AR7
AFC_loop:
		st 	    N/2-1, brc
		rptb 	AFC_point
		squr 	*AR4+,B
		add     B,-15,A	
AFC_point:	
		nop	
		stl     A,-7,T
		mpy 	#512,A
		sfta    A,-7
		
		st      #0,*AR3
sqrt_block:
		mas 	*AR3,*AR3,A,B	
		bc      sqrt_find,bleq
		addm    #1,*AR3
		b       sqrt_block
sqrt_find:
		nop	
		
		mpy 	#158, A	
		stl     A,*AR2+
		
		ld		*AR4+0,A
		xor     A,A     
		banz    AFC_loop,*AR7-
		nop
		
			
		.data
koef	
		.include  	koef.asm
sinus 	.space (N*k+2)*16
filter  .space (N*k+2)*16
AFC_arr	.space k*16 
