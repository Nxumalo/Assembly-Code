.model small
.stack
.data 
TitMsg		byte 'Your computer has Rom BIOS version '
Vers		byte 64 dup
.code 
.startup
		mov DatSeg,ds
		mov es,ROM_BIOS
		mov di,0FFF5h
		mov cx,64
		mov al,0

repne		scash
		jnz Exprog
		mov cx,di
		sub cx,0FFF5h
		cmp cx,9
		jb ExProg
		mov bx,cx	
		mov ds,ROM_BIOS
		mov es,DatSeg
		lea di,Vers
		mov si,0FFF5h

rep		movsb
		mov ds,DatSeg
		mov Vers[bx-1],'$'
		lea dx,TitMsg
		mov ah,09h
		int 21h
ExtProg:.exit	0
ROM_BIOS dw
DatSeg   dw	0
		end
		 	