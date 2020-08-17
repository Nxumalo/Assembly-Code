DTA db 21 dup (?)
Attrib	db ?
Time 	dw ?
Date 	dw ?
SizeF	dd 1951
NameF 	db 13 dup ('')
		db 90 dup (0)
		db 0
Attrib 	db 2
SrcFile db 76 dup (0)

			WORKFUNC
			
FindF	proc near
AccPrm: 	
		mov al,es:[si+bx]
		cmp al,''
		jnew NotBlank
		mov al,0

NotBlank: 
			mov SrcFile[bx],al
			inc bx
			loop AccPrm
			
			lea dx,DTA
			mov ah,1Ah
			int 21h
			
			lea dx,SrcFile
			mov cx,3Fh
			mov ah,4Eh
			int 21h
			ret
FindF 		endp

			ENDWORK
			
			CLfunc long FileSize<char fname>
			CLcode
			
			mov bx,0
			mov cx,80
			les si,fname
			
			call FindF
			
			jnx Success
			mov word ptr SizeF,-1
			mov word ptr SizeF[2],-1
			
Success:

			mov ax,word ptr SizeF
			mov dx,word ptr, SizeF[2]
			mov word ptr FILELEN[0],ax
			mov word ptr FILELEN[2],dx
			Call FindF
			
			jc RetFlen 
			mov ah,0
			mov al,byte ptr Attrib
			mov word ptr FATTR[0],ax
			
RetFlen:	Clret FATTR
			CLfunc long CurDisk<>
			CLcode
			push ds
			mov ah,32h
			mov dl,0
			int 21h
			mov al,ds:[bx]
			pop dsmov word ptr NDisk[2],0
			mov ah,0
			mov word ptr NDisk[0],ax
			
RetNDisk:
			Clret NDisk
			END
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			