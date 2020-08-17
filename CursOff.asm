.model small
.code
		org 100h

begin:
	
		mov ax,0
		mov es,ax
		mov bh,es:[462h]
		
		mov ah,03h
		int 10h
		
		mov ah,01h
		or  ch,30h
		int 10h
		
		mov ax,4C00h
		int 21h
		end begin