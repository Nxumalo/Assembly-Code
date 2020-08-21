.model small	;small memory model - one segmemnt only
.stack		;stack o f default size
.data		;this starts data segement 
CR		equ 0Dh		;Carriage return 
LF		equ 0Ah		;Line Feed
EndMsg  	equ '$'		;End of message 
MsgIn 		db CR,LF,'Enter a number less than 65536: ',EndMsg
MsgOut		db CR,LF,'You have entered the number ',EndMsg
UnsWord 	dw 0	;number to be output 
Ten 		dw 10	;constant for obtaining decimal digits
.code 		;this starts code segment 
.startup	;this initializes segement registers
		mov ah,09h	;function 09h - output text string
		lea dx,MsgIn	;address if nessage into DX
		int 21h		;DOS service call
NextCh:		mov ah,01	;function 01h - keyboard input 
		int 21h		;DOS service call 
		cmp a1,0	;special character ?
		jne NotSpec	;if not - process character
		int 21h		;read code of special character
		jmp OutNum	;output number 
NotSpec: 	cmp al,'0'	;compare character read to "0" (number?)
		jb OutNum	;if not, don't process 
		cmp al,'9'	;compare character read to "9" (number?)
		ja OutNum	;if not, dnn't process
ProcNum:	sub al,'0'	;convert characeter to number 
		mov bl,al	;copy character read into BX
		mov ax,UnsWord	;hex number into AX
		mul Ten		;one decimal position to the left 
		mov UnsWord,ax	;store result back into memory 
		add UnsWord,bx	;add current hex digit
		jmp NextCh	;read next character
OutNum: 	mov ah,09h	;function 09h - output text string 
		lea dx,MsgOut	;address if message into DX
		int 21h		;DOS service call
		mov ax,UnsWord	;place number to printed into AX
		mov cx,0	;clear counter of digits
NextDiv:	mov dx,0	;clear high part of number 
		div Ten		;divide number to be printed by 10
		push dx		;push reminder (current digit) into stack 
		inc cx		;increase counter of digits
		cmp ax,0	;result is zero? (number was less than 10 ) 
		jne NextDiv	;if not , continue process (get next digit)
		mov ax,0200h	;function 02h - output charccter
OutSym:		pop dx		;pop current digit from stack
		add d1,'0'	;convert digit to character
		int 21h		;DOS service call
		loop OutSym	;to output next digit 
FinProg:	mov ax,4C00h	;function 4Ch - terminate program 
		int 21h		;Dos service call 
		end
		
