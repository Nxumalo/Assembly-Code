;*************************************************************************************
;
;	The program for outputting text string onto the printer 
;
; 	Author: F. Nxumalo, University of the Western Cape, 2020
;
;	The MS-DOS service (INT 21h, function 40h ) is use
;
;************************************************************************************
;----------------------------------------------------
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
;----------------------------------------------------
CODE SEGMENT 'CODE'
		ASSUME CS:CODE,DS:DATA
; === Check whether printer is ready 		
Begin:	mov ax,DATA
		mov DS,ax			;DS points to data segment 
		mov ah,02h			;function 02h - get printer status byte
		xor dx,dx			;DX = 0 corresponds to LPT1
		int 17h				;BIOS printer service
		cmp ah,90h			;check bits 7 and 4 of status byte
		je Print 			;if printer is OK - print 
		lea dx,MSG3			;address of message "not ready"
		jmp Text			;output message and exit 
;----------------------------------------------------
; === Output ASCII string onto the printer 
Print:  mov cx,LMSG1				;length of string to be output 	
		lea dx,MSG1			;DS:DX - address of begining of string 
		mov bx,4			;4 is value of file handle for LPT1
		mov ah,40h			;function 40h - write file with handle 
		int 21h				;DOS service call 
		jnc Exit			;if Carry Flag is clear, exit 		
Error:  lea dx,MSG2				;else output error message
;----------------------------------------------------
; === This is the final block 
Text:  	mov ah,9				; function 09h - output text 
		int 21h				;DOS service call 
Exit:	mov ax,4c00h				;Function 4Ch - terminate process
		int 21h				;Return to MS-DOS 
	
CODE ENDS 
	 ENG Begin
