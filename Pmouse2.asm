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
		
WaitKey macro 		;==== Wait for keypressed 
		xor ah,ah		; function 0 - wait for key pressed 
		int 16h			; BIOS keyboard service 
endm

SetCurs MACRO ROW,Column		; 
		mov ah,2
		xor bh,bh
		mov dh,&ROW
		mov dl,&Column
		int 10h
		
ENDM

PutStr MACRO Row,Column,Text,Leng,Attrib
			Local M0
			push si 
			mov cx,Leng
			lea si,Text
			mov dl,Column
			cld

			M0: SetCurs Row,dl
			lodsb
			mov bl Attrib
			mov ah,9
			xor bh,bh
			push cx
			mov cx,1
			int 10h
			pop cx
			inc dl
			loop M0
			pop si
			ENDM
	
.STARTUP
				mov ah,0Fh
				int 10h
				mov VMODE,al
				mov ah,0
				mov al,3
				int 10h
				
				OutMsg TEXT0
				WaitKey
				
				mov  ax,03533h
				int 21h
				mopv ax,es
				or ax,bx
				jz Nomouse
				mov bl,es:[bx]
				cmp bl,0CFh
				jne Begin
				
Nomouse:	
				OutMsg TEXT1
				WaitKey
					jmp Exit
					
Begin: 		OutMsg TEXT2
		WaitKey 
		
Func0:		
		xor ax,ax
		int 33h
		cmp ax,0
		jnz Clear25
		jmp Exit

Clear25:	SetCurs 0,0
		mov ah,9
		xor bh,bh
		mov al,20h
		mov bl,1Eh
		mov cx,2000
		int 10h
		
		PutStr 2,16,TEXT3,Ltxt3,1Eh
		PutStr 8,20,TEXT8,Ltxt8,1Eh
		PutStr 10,20,TEXT10,Ltxt10,1Fh
		PutStr 11,20,TEXT11,Ltxt11,1Fh
		PutStr 12,20,TEXT12,Ltxt12,1Fh
		PutStr 13,20,TEXT13,Ltxt13,1Fh
		PutStr 14,20,TEXT14,Ltxt14,1Fh
		PutStr 15,20,TEXT15,Ltxt15,1Fh
SetCurs 25,80

Func10: 	mov ax,10
		xor bx,bx
		mov cx,0FFFFh
		mov dx,4700h
		int 33h
		
Func1:		mov ax,1
		int 33h
		
Func3:		mov ah,1
		int 16h
		jz ContF3
		jmp Exit
		
ContF3:		mov ax,3
		int 33h
		mov CX0,cx
		mov DX0,dx
		test bx,1
		jnz X_Range
		jmp short Func3
		
X_Range:	mov ax,CX0
		mov cl,3
		shr ax,cl
		cmp ax,20
		jb Func3
		cmp ax,36
		ja Func3
		
Y_Range:	mov ax,DX0
		mov cl,3
		shr ax,cl
		cmp ax,10
		jb Func3
		cmp ax,15
		ja Func3
		
		mov ax,DX0
		mov cl,3
		shr ax,cl
		cmp ax,15
		je Exit
		sub ax,9
		or al,30h
		mov Numsel,al
		SetCurs 17,20
		OutMsg TXT3L
		jmp short Func3
		
Exit:		mov al,VMODE
		mov ah,0
		int 10h
		Call CLRKEY
		mov ax,4C00h
		int 21h
		
CLRKEY 		PROC Near uses ax es
		mov ax,40h
		mov ES,ax
		cli
		mov ax,ES:[1Ah]
		mov ES:[1Ch],ax
		sti
		ret
		
CLRKEY		ENDP
		END
		
					
			
