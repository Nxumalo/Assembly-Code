DATA SEGMENT 
CR EQU 13
LF EQU 10
MSG1 DB 'Output a string onto the printer (MS-DOS,INT 21h,AH=40h)'
	 DB CR,LF
LMSG1 EQU $-MSG1
MSG2 DB 13,10,'Error while outputting the string !',13,10,'$'
MSG3 DB 13,10,'Printer not ready!',13,10,'$'
MSG4 DB 13,10,'Error during printer initialization!',13,10,'$'
DATA ENDS 

CODE SEGMENT 'CODE'
		ASSUME CS:CODE,DS:DATA
		
Begin:	mov ax,DATA
		mov DS,ax
		mov ah,02h
		xor dx,dx
		int 17h
		cmp ah,90h
		je Print 
		lea dx,MSG3
		jmp Text
		
Print:  mov cx,LMSG1
		lea dx,MSG1
		mov bx,4
		mov ah,40h
		int 21h
		jnc Exit
		
Error:  lea dx,MSG2

Text:  	mov ah,9
		int 21h
	
Exit:	mov ax,4c00h
		int 21h
	
CODE ENDS 
	 ENG Begin