        .mmregs
		
		.def _c_int00
		.text
		
_c_int00:
;çàäàíèå íà÷àëüíûõ çíà÷åíèé äëÿ ðàññ÷åòà ñèíóñîèäû è êîñèíóñîèäû		
N 		.set 136
k		.set 5
Sk 		.set 0
Ck		.set 32767
S1		.set 1513
C1      .set 32733
;çàãðóçêà íà÷ çíà÷åíèé â âñïîìîãàòåëüíûå ðåãèñòðû		
		st     	#Sk,AR1
		st      #Ck,AR2
		st      #S1,AR3
		st      #C1,AR4
		st      #N,AR6
		st      #0,AR7		
		stm		#sinus, AR5	;ðåçóëüòàò
		st		#k-1, BRC	;ñ÷åò÷èê, êîë-âî èòåðàöèé öèêëà		
		rptb	search_Sk_Ck	;càì öèêë
search_Sn_Cn:		
						;ïîäñ÷åò ñèíóñà
		ld      AR1,A	;çàãðóçêà â À Sk
		stl 	A, T 	;çàãðóçêà â Ò À
		mpy 	AR4, A	;À = AR4*T=AR4*AR1
		
		ld      AR2,B	;çàãðóçêà â B Ck
		stl 	B, T 	;çàãðóçêà â T B
		mpy 	AR3, B	;B = AR3*T=AR3*AR2
		
		add     B,A		;À = À+Â
		sftA    A,-15	;A/(2^15)
		ld      AR1,B	;çàãðóçêà â B ïðåäûäóùåé òî÷êè Sk
		stl     A,AR1	;çàãðóçêà â ÀR1 íîâîé òî÷êè Sk
						;ïîäñ÷åò êîñèíóñà
		ld 		AR2,A	;
		stl 	A, T 	;çàãðóçêà â T A
		mpy 	AR4, A	;À = AR4*T=AR4*AR2
		
		stl 	B, T 
		mpy 	AR3,B ; òî æå ñàìîå
		
		sub     B,A		
		sftA    A,-15
		stl     A,AR2	;çàãðóçêà â ÀR2 íîâîé òî÷êè Ck
search_Sk_Ck: 
		nop
		nop
		banz    block,*AR7- ;ïåðåõîä íà ìåòêó, ïîêà AR7 != 0(ïðîéäåò îäèí ðàç) 
		ld      AR1,A		;çàíåñåíèå êîíñòàíòíîãî øàãà èç AR1 È AR2 Â AR3 È AR4 
		stl		A,AR3
		ld      AR2,A
		stl     A,AR4
		st      #Sk,AR1     ;çàíåñåíèå â AR1 È AR2 íóëåâûõ çíà÷åíèé ñèíóñà è êîñèíóñà
		st      #Ck,AR2
		;ld      #Ck,A		
block:		
		nop
		nop
		ld      AR1,A
		stl     A,*AR5+		;çàíåñåíèå òî÷åê êîñèíóñîèäû â AR5(ðåçóëüòàò)
   		banz    search_Sn_Cn,*AR6- ;îñíîâíîé öèêë, íà 120 èòåðàöèé(òî÷åê)
		nop	
		nop
		nop
		
		
		.data
sinus 	.word  N         ;âûäåëåíèå ïàìÿòè ïîä ñèíóñîèäó/êîñèíóñîèäó
