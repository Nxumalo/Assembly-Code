.MODEL SMALL
.STACK
.DATA
CR EQU 13 
LF EQU 10
LPT1 DW 0
MSG1 DB 'Output string onto the printer (low-level technique)'
	 DB CR,LF
	 
LMSG1 EQU $-MSG1
MSG2 DB 13,10, 'Error while outputting the string!!',13,10,'$'
MSG3 DB 13,10, 'Printer not ready!',13,10,'$'
MSG4 DB 13,10, 'Error during printer initialization!',13,10,'$'
.CODE
.startup
		mov ax,40h
		mov ES,ax
		mov dx,ES:[8]
		mov LPT1,dx
		inc dx
		in al,dx
		jmp $+2
		test al,80h
		jnz Init 
		lea dx,MSG3
		jmp Text

Init: 	mov dx,LPT1
		add dx,2
		mov al,0Ch
		out dx,al
		mov cx,3000
		loop $
		mov al,08h
		out dx,al
		
Print: 	mov cx,LMSG1
		lea si,MSG1
		cld
		
Next:	lodsb
		mov dx,LPT1
		out dx,al
		inc dx
		inc dx
		mov al,0Dh
		out dx,al
		dec al
		out dx,al
		
		dec dx
		in al,dx
		test al,08h
		jz Error
		
Wait0: in al,dx
	   test al,80h
	   jz Wait0
	   loop Next
	   jmp Exit
	   
Error: lea dx,MSG2

Text:  mov ah,9
	   int 21h
	   
Exit:  mov ax,4C00h
	   int 21h
END	   
	   
	   
	   
		
