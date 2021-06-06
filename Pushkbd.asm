.model small
.stack
.data
.code
.startup
		mov 	 cx,10
LP: 	
		push	 cx			
		mov 	 ah,05			;Function 05h - Push scan/ASCII code
		mov 	 ch,20h			;Scan code for key "D"
		mov  	 cl,'d'			;ASCII cpde for key "D"
		int 	 16h			;BIOS keyboard service 
		
		mov 	 ah,05			;Function 05h - Push scan/ASCII code
		mov      ch,17h			;Scan code for key "I"
		mov 	 cl,'i'			;ASCII cpde fpr key "I"
		int 	 16h			;BIOS keyboard service 
		
		mov 	 ah,05			;Function 05h - Push scan/ASCII code
		mov  	 ch,13h			;Scan code for key "R"
		mov 	 cl,'r'			;ASCII code fpr key "R"
		int 	 16h			;BIOS keyboard service
			
		mov 	 ah,05			;Function 05h - Push scan/ASCII code 
		mov      ch,1Ch			;Scan code for ENTER key
		mov 	 cl,13			;ASCII code for ENTER key
		int 	 16h		`	;BIOS keyboard service 
		pop      cx
		loop 	 lp
		
Finish:	
		mov 	 ax,4C00h		;Function 4Ch - terminate process
		int 	 21h			;DOS service call
		end
