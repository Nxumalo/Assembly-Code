.MODEL SMALL
.STACK
.DATA

CR EQU 13
LF EQU 10
MSG1 DB 'Output a string to the printer (BIOS,INT 17h)'
	 DB CR,LF
LMSG1 EQU $-MSG1
MSG2 DB 13,10,'Error while outputting the string!', 13,10,'$'
MSG3 DB 13,10,'Printer not ready!',13,10,'$'
MSG4 DB 13,10,'Error during printer initialization!',13,10,'$'

.CODE 
.startup
			mov ah,02h
			xor dx,dx
			int 17h
			cmp ah,90h
			jz Init
			lea dx,MSG3
			jmp Text
			
Init: mov ah,1
	  xor dx,dx
	  int 17h
	  cmp ah,00h
	  jz Print
	  lea dx,MSG4
	  jmp Text
	  
Print: mov cx,LMSG1
	   lea si,MSG1
	   cld
	   xor dx,dx
	   
Next: xor ah,ah
	  lodsb
	  int 17h
	  test ah,08h
	  jnz Error 
	  loop Next
	  jmp Exit
	  
Error: lea dx,MSG2

Text: mov ah,9
	  int 21h
	  
Exit: mov ax,4C00h
	  int 21h
	  END
	  
	  
	  
	 