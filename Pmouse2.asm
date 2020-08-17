NAME PMOUSE2
.DOSSEG
.MODEL SMALL
.STACK 100h
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
	   
VMODE DB 0
ATTR  DB 0
ROW0  DB 0
COL0  DB 0
CX0   DW 0
DX0   DW 0
.CODE

OutMsg macro Txt
		lea dx,Txt
		mov ah,09h
		int 21h
		endm
		
WaitKey macro 
		xor ah,ah
		int 16h
endm

SetCurs MACRO ROW,Column
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
					
			