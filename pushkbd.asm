.model small
.stack
.data
.code
.startup
		mov 	 cx,10
LP: 	
		push	 cx
		mov 	 ah,05
		mov 	 ch,20h
		mov  	 cl,'d'
		int 	 16h
		
		mov 	 ah,05
		mov      ch,13h
		mov 	 cl,'r'
		int 	 16h
		
		mov 	 ah,05
		mov  	 ch,13h
		mov 	 cl,'r'
		int 	 16h
		
		mov 	 ah,05
		mov      ch,1Ch
		mov 	 cl,13
		int 	 16h
		pop      cx
		loop 	 lp
		
Finish:	
		mov 	 ax,4C00h
		int 	 21h
		end