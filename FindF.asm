.model small
.stack 
.data
DTA db 21 dup (?)
Attrib (db) ?
Time 	dw	?
Date 	dw 	?
Fsize	dd	?
NameF	db	13 dup('')
		db 	85 (?)
FName	db 	80 dup(0)

.code 
.startup

			mov ah,51h
			int 21h
			mov es,bx
			mov bx,0
			mov cl,es:[80h]
			mov ch,0
			cmp cl,3
			jb ExProg

GetParm:	mov al,es:[bx+82h]
			cmp al,0Dh
			jne TestCR
			mov al,0
			jmp CopChar

TestLF:		cmp al,0Ah
			jne CopChar
			mov al,0
			
CopChar:	mov FName[bx],al
			inc bx
			loop GetParm
			
			lea dx,DTA
			mov ah,1Ah
			int 21h
			
			lea dx,FName
			mov cx,3Fh
			mov ah,4Eh
			int 21h
			
Next: 		jc ExProg
			mov byte ptr NameF[12],0Dh
			mov byte ptr NameF[13],0Ah
			mov byte ptr NameF[14],'$'
			
			mov dx,offset NameF
			mov ah,09
			int 21h
			
			push cx
			mov  cx,12
			mov  bx,0
			
Clear: 		mov NameF[bx]
			inc bx
			loop Clear
			
			pop cx
			mov ah,4Fh
			int 21h
			
			jmp Next
			
 ExProg: 	mov ax,4C00h
			int 21h
			end
			
			  