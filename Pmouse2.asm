;*************************************************************************************************************
;
; The demo program for mouse (the menu selection,Text Mode)
;
; Author: F.Nxumalo, Unversity of the Western Cape, 2020
;
; The Interrupt 33h (mouse service is used)
;
; Mouse driver must be installed 
; 
;*************************************************************************************************************
NAME PMOUSE2
.DOSSEG
.MODEL SMALL
.STACK 100h
;________________________________________________________________
.DATA
BELL EQU 07
LF EQU 10
CR EQU 13
TEXT0 DB " The MOUSE demo program (INT 33h)."
	  DB "Press any key to continue ...",BELL,CR,LF,"$"
TEXT1 DB "The mouse driver is not installed !!!."
	  DB "Press any key ...",BELL,CR,LF,"S"
TEXT2 DB "An active mouse driver found."
	  DB "Press any key ...",BELL,CR,LF,"S"
TEXT3 DB 'The menu command selection using the mouse (text mode).'
Ltxt3 EQU $-TEXT3
TEXT8 DB "Select Command and press Left Button:"
Ltxt8 EQY $-TEXT8

TEXT10 DB "1 - Command one "	
Ltxt10 EQU $-TEXT10
TEXT11 DB "2 - Command two "
Ltxt11 EQU $-TEXT11
TEXT12 DB "3 - Command three "
Ltxt12 EQU $-TEXT12
TEXT13 DB "4 - Command four "
Ltxt13 EQU $-TEXT13
TEXT14 DB "5 - Command five "  
Ltxt14 EQU $-TEXT14
TEXT15 DB "6 - Exit "
Ltxt15 EQU $-TEXT15

TXT3L DB "Left button pressed. Command "
NumSel DB 20h
	   DB " selected."
	   DB BELL,"$"
	   
VMODE DB 0			; video mode saved 
ATTR  DB 0			; 
ROW0  DB 0
COL0  DB 0
CX0   DW 0
DX0   DW 0
;____________________________________________________
.CODE

OutMsg macro Txt	;===== output text message 
		lea dx,Txt		; address of message
		mov ah,09h		; function 09h - output text string 
		int 21h			; DOS service call
		endm			
		
WaitKey macro 		;==== Wait for key pressed 
		xor ah,ah		; function 0 - wait for key pressed 
		int 16h			; BIOS keyboard service 
endm

SetCurs MACRO ROW,Column		; ==== Move the cursor 
		mov ah,2		; function 02h - set cursor position
		xor bh,bh		; video page 0 is used
		mov dh,&ROW		; cursor row 
		mov dl,&Column		; cursor column
		int 10h			;BIOS video service call
		
ENDM

PutStr MACRO Row,Column,Text,Leng,Attrib
			Local M0
			push si 
			mov cx,Leng			;string length 
			lea si,Text			;DS:SI - address of text string 
			mov dl,Column			;initial position (column)
			cld				;process string from left to right 

			M0: SetCurs Row,dl		
			lodsb				;AL - character to be output 
			mov bl Attrib			;BL - attribute 
			mov ah,9			;function 09 - output char+ attr 
			xor bh,bh			;video page 0 is used 
			push cx				;save cycle counter 
			mov cx,1			;number of characters output 
			int 10h				;BIOS video service call
			pop cx				;restore cycle counter 
			inc dl				;next position for output 
			loop M0				;next cycle step 
			pop si				;
			ENDM
;___________________________________________________________	
.STARTUP
				mov ah,0Fh		;function 0Fh - get video mode 
				int 10h			;BIOS video service call
				mov VMODE,al		;save current video mode 
				mov ah,0		;function 0 - set video mode 
				mov al,3		;80x25 Text
				int 10h			;BIOS video service call
;	Output initial message						
				OutMsg TEXT0		;output initial message 
				WaitKey			
; 	check for mouse driver present 				
				mov  ax,03533h		;function 35h - get interrupt vector 
				int 21h			;DOS service call
				mopv ax,es		;segment address of handler 
				or ax,bx		;AX - segment .OR. offset of int 33
				jz Nomouse		;if full address is 0 - no mouse 
				mov bl,es:[bx]		;get first instruction of handler 
				cmp bl,0CFh		;is this IRET instruction?
				jne Begin		;if not - driver installed 				
Nomouse:	
				OutMsg TEXT1		;output message "driver not found"
				WaitKey			;wait for key to be pressed
					jmp Exit	;Exit program
;__________________________________________________					
Begin: 		OutMsg TEXT2				;output message "driver installed"
		WaitKey 				;wait for key to be pressed 
			jmp Exit 			;Exit program 
;__________________________________________________
; Initialize mouse and report status (function 0 of INT 33h)
Func0:							
		xor ax,ax				;Initialize mouse 
		int 33h					;mouse service call
		cmp ax,0				;is mouse installed 
		jnz Clear25				;if so, pass to function 10
		jmp Exit				;if not,exit program 
; Fill the screen (yellow character on blue background)
Clear25:	SetCurs 0,0				;cursor to left upper corner
		mov ah,9				;function 09h - output char+attr
		xor bh,bh				;video page 0 is used 
		mov al,20h				;character to be output 
		mov bl,1Eh				;attribute - yellow on blue 
		mov cx,2000				;number of character to be output 
		int 10h					;BIOS video service call
;___________________________________________________
;  Output the header and the menu text onto the screen
		PutStr 2,16,TEXT3,Ltxt3,1Eh
		PutStr 8,20,TEXT8,Ltxt8,1Eh
		PutStr 10,20,TEXT10,Ltxt10,1Fh
		PutStr 11,20,TEXT11,Ltxt11,1Fh
		PutStr 12,20,TEXT12,Ltxt12,1Fh
		PutStr 13,20,TEXT13,Ltxt13,1Fh
		PutStr 14,20,TEXT14,Ltxt14,1Fh
		PutStr 15,20,TEXT15,Ltxt15,1Fh
SetCurs 25,80		; move cursor out of screen 
;___________________________________________________
; Function 10 - define text cursor 
Func10: 	mov ax,10				;define text cursor 
		xor bx,bx				;software cursor is used 
		mov cx,0FFFFh				;screen Mask 
		mov dx,4700h				;cursor Mask 
		int 33h					;mouse service call
;______________________________________________________	
; Function 1 - show the mouse cursor 
Func1:		mov ax,1				;function 01 - show mouse cursor 
		int 33h					;mouse service call
;______________________________________________________
; Determining mouse keys pressed 
Func3:		mov ah,1				;function 01h - check keyboard buffer
		int 16h					;BIOS keyboard service
		jz ContF3				;if no key pressed, continue 
		jmp Exit				;exit if key pressed 		
ContF3:		mov ax,3				;func. 03 - button status and location 
		int 33h					;mouse service call
		mov CX0,cx				;save X coordinate (column)
		mov DX0,dx				;save Y coordinate (row)
		test bx,1				;left button pressed?
		jnz X_Range				;Ok!
		jmp short Func3				; no button pressed - check again
; Check horizontal cursor location 		
X_Range:	mov ax,CX0				;X coordinate (Column)
		mov cl,3				;number bits to shift 
		shr ax,cl				;shifts by 3 - divide by 8
		cmp ax,20				;cursor on the left ?
		jb Func3				;not - continue check 	
		cmp ax,36				;cursor on the right?
		ja Func3				;not - continue check
; Check vertical cursor location		
Y_Range:	mov ax,DX0				;X coordinate (Column)
		mov cl,3				;number bits to shift 
		shr ax,cl				;shift by 3 - divide by 8
		cmp ax,10				;cursor on the top?
		jb Func3				;not - continue check 
		cmp ax,15				;cursor on the bottom?
		ja Func3				;not - continue check 
; report the number of the command selected 		
		mov ax,DX0				;Y coordinate (Column)
		mov cl,3				;number bits to shift
		shr ax,cl				;shift by 3 - divide by 8
		cmp ax,15				;line 15 (Exit)?
		je Exit					;if so - finish 
		sub ax,9				;number of command selected
		or al,30h				;convert ASCII character 
		mov Numsel,al				;out number to output message
		SetCurs 17,20				;move cursor 
		OutMsg TXT3L				;output message "command selected"
		jmp short Func3				;check again
;______________________________________________
Exit:		mov al,VMODE				;remember video mode on entry
		mov ah,0				;function 0 - set video mode 
		int 10h					;BIOS video service 
		Call CLRKEY				;clear keyboard buffer 
		mov ax,4C00h				;function 4Ch - terminate process
		int 21h					;DOS service call
;______________________________________________
;
; This procedure cleas the keyboard buffer
;
;______________________________________________
CLRKEY 		PROC Near uses ax es
		mov ax,40h				;address of BISO data segment 
		mov ES,ax				;ES points to BIOS data
		cli					;no interrupts - system data modified 
		mov ax,ES:[1Ah]				;buffer head printer
		mov ES:[1Ch],ax				;clear buffer (head ptr = tail ptr)
		sti					;buffer clear allow interrupts
		ret
		
CLRKEY		ENDP
		END
		
				
