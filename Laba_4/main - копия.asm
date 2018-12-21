		.mmregs
			
		.def _c_int00
		.text
		
_c_int00:
;задание начальных значений для рассчета синусоиды и косинусоиды
step    .word 0	
N 		.set 272 
Sk 		.set 0
Ck		.set 32767
S1		.set 1513
C1      .set 32733

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;1-ая лаба(рисование 3-ех синусоид, в качестве входного сигнала);;;;;;;;;;;;;;;

;загрузка нач значений в вспомогательные регистры
		st      #68,AR0
		stm		#sinus, AR5
		SSBX 	OVM ; нет коррекции переполнения
GAR:	
		st     	#Sk,AR1
		st      #Ck,AR2
		st      #S1,AR3
		st      #C1,AR4
		st      #N,AR6
		st      #0,AR7
		ld      AR0,A
		sub     #68,A
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
	
		;;;;;;;;;;;;;;;;;;;;;;;;;ФИЛЬТР;;;;;;;;;;;;;;;;;;;;;;;;;;;;
					
		stm     #2,AR7

main_loop:		
		
		stm		#sinus-2, AR5	;результат X
		rptz    A,#2
		stl     A,*AR5+
		stm 	#filter-2, AR4	;y[i]
		rptz    A,#2
		stl     A,*AR4+	
					
		stm 	#18495, brc
	
		rptb IIR
		
 		RSBX OVA ; сброс бита переполнения
		
		stm     	#koef, AR3
		mvdm        step,AR0
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
		xor     A,A
		ld      AR7,B
		sub     #1,B
		bc      go,beq
		add     #5,A
		b       go_2
go:     
		add     #10,A
go_2:
		stl     A,step
		stm		#sinus, AR5	;результат X	
		stm 	#filter, AR4	;y[i]
		rpt    	#18495	
		mvdd    *AR4+,*AR5+	
		banz    main_loop,*AR7-
		nop	
		nop
		nop
		
		;;;;;;;;;;;;;;;АЧХ;;;;;;;;;;;;;;;;;;;
		xor     A,A
		stm 	#filter+136, AR4;y[i]
		stm 	#output, AR2	;y[i] 
		st      #136,AR0
		st      #68,AR7
AFC:
		st 	    135, brc
		rptb 	AFC_point
		squr 	*AR4+,B
		add     B,-15,A	
AFC_point:	
		nop	
		stl     A,-7,T
		mpy 	#482,A
		sfta    A,-8
		
		st      #0,*AR3	  ;Первое приближение корня из A	
sqrt_block:			     
		mas 	*AR3,*AR3,A,B  	
		bc      sqrt_find,bleq
		addm    #1,*AR3
		b       sqrt_block
sqrt_find:
		nop	
		
		mpy 	#181, A	
		stl     A,*AR2+
		
		ld		*AR4+0,A
		xor     A,A     
		banz    AFC,*AR7-
		nop
		
			
		.data
koef	
		.include  	koef.asm

		.space 30*16
sinus 	.space 18500*16         ;выделение памяти под синусоиду/косинусоиду
filter  .space 18500*16		  	;под фильтр
output  .space 68*16 
