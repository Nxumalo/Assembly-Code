.model small
.code 
		org 100h
		
begin: 
			int 11h
			and al,30h
			cmp al,30h
			je 	mono
			
			mov ah,11h
			mov al,0
			mov bl,34h
			
			int 10h
			mov cx,0607h
			jmp SetCur
			
mono:		mov cx,0B0Dh
			
SetCur: 	mov ax,40h
			mov es,ax
			mov al,es:49h
			mov bh,es:62h
			mov ah,01h
			int 10h
			
ExProg: 	mov ax,4C00h
			int 21h
			end begin