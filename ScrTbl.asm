.model small
.stack
.data
CR equ 00Dh
LF equ 00Ah
Con16 db 16
EndMsg equ 024h
StMsg db CR,LF,LF
		db 'screen font shoow utility 14 Jun 82 version 1.2',CR,LF
		db 'copyright (C) 2020 V.B.Maljugin,Voronezh,CIS',CR,LF
CrLf	db CR,LF,EndMsg
Pattern db 'xx-',EndMsg
HexSym 	db '0','1','2','3','4','5','6','7'
		db '8','9','A','B','C','D','E','F'
CodSym 	db 0
.code 
.startup
			mov ax,40h
			mov es,ax
			lea dx,StMsg
			mov ag,09
			int 21h
			mov cx,16
			
PrtTable:
			push cx
			
			mov cx,16
			
rows:
			push cx
			mov al,CodSym
			
ToHex:
			mov ah,0
			div Con16
			mov bx,offset HexSym
			xlat
			mov byte ptr Pattern,al
			mov al,ah
			xlat
			mov byte ptr Pattern[1],al
			mov ah,09
			lea dx,Pattern
			int 21h
			
			mov bh,es:[62h]
			mov bl,0
			mov ah,0Ah
			mov al,CodSym
			mov cx,1
			int 10h
			
			mov ah,03
			int 10h
			mov ah,02
			add dl,2
			int 10h
			pop cx
			add CodSym,16
			loop Rows
			
			lea dx,CrLf
			mov ah,09h
			int 21h
			pop cx
			inc CodSym
			
	EndMain: loop PrtTable

			mov ax,4C00h
			int 21h
			end
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			