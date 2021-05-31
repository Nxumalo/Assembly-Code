;**************************************************************************************
;
;	The program for outputting text string onto the printer 
; 	
;	Author: 3538264, University of the Western Cape, 2020
;
;	The BIOS service (INT 17h, function 00h) is  used
;
;*************************************************************************************

.MODEL SMALL
.STACK
.DATA
;------------------------------------------------------------
CR EQU 13		; Carriage Return 
LF EQU 10		; Line Feed 
MSG1 DB 'Output a string to the printer (BIOS,INT 17h)'
	 DB CR,LF
LMSG1 EQU $-MSG1
MSG2 DB 13,10,'Error while outputting the string!', 13,10,'$'
MSG3 DB 13,10,'Printer not ready!',13,10,'$'
MSG4 DB 13,10,'Error during printer initialization!',13,10,'$'
;-------------------------------------------------------------
.CODE 
.startup
			mov ah,02h		;function 02h - get printer state byte 
			xor dx,dx		;DX = 0 corresponds to LPT1
			int 17h			;BIOS printer service 
			cmp ah,90h		;check bits 7 and 4 of status byte
			jz Init			;if printer is OK - initialize it 
			lea dx,MSG3		;address of message "not ready"
			jmp Text		;output message and exit 
;- Initialize the printer 
Init: mov ah,1			;function 01h - initialize printer 
	  xor dx,dx		;DX=0 denotes LPT1
	  int 17h		;BIOS printer service 
	  cmp ah,00h		;check printer status 
	  jz Print		;
	  lea dx,MSG4		;address of message "Printer is not ready" 
	  jmp Text		;output message and exit 
;------------------------------------------------------
;- Send ASCII - String onto the printer 
Print: mov cx,LMSG1		;length of string into CX
	   lea si,MSG1		;DS:SI - address of string 
	   cld			;direction - forward!
	   xor dx,dx		;DX=0 stands for LPT1	   
Next: xor ah,ah			;clear AH (function 0 - print character)
	  lodsb			;send current character into AL 
	  int 17h		;BIOS printer service
	  test ah,08h		;was there an error?
	  jnz Error 		;if so - put message and exit 
	  loop Next		;print next character 
	  jmp Exit		;exit program (normal exit)	  
Error: lea dx,MSG2		;DS:DX - address of error messages
;-------------------------------------------------------
;- Exit the program (normal or error)
Text: mov ah,9			;function 09h - ouput text string 
	  int 21h		;DOS service call 	  
Exit: mov ax,4C00h		;Return Code = 0
	  int 21h		;Return to MS - DOS 
	  END
	  
	  
	  
	 
