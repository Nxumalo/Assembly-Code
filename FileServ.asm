DTA db 21 dup (?)
Attrib	db ?	;=========	; 01 - Read Only 
				; 02 - Hidden 
				; 04 - System 
				; 08 - Volume Id 
				; 10h - Directory 
				; 20h - Archive 
Time 	dw ?
Date 	dw ?
SizeF	dd 1951
NameF 	db 13 dup ('')
		db 90 dup (0)
		db 0
Attrib 	db 2
SrcFile db 76 dup (0)

			WORKFUNCS
			
FindF	proc near
AccPrm: 					;
		mov al,es:[si+bx]		; Take one byte from file name 
		cmp al,''			; Is it blank?
		jnew NotBlank			; If not - proceed the next byte
		mov al,0			; Else replace it with 0
NotBlank: 					;
			mov SrcFile[bx],al	; Copy the byte into work area 
			inc bx			; Increase  the counter 
			loop AccPrm		; Next byte 
						;
			lea dx,DTA		;Load address pf DTA omtp DS:DX 
			mov ah,1Ah		;Function 1Ah - 
			int 21h			;DOS service call 
						;
			lea dx,SrcFile		;Address of ASCIIZ file name into DS:DX
			mov cx,3Fh		;Attribute 3Fh - any file 
			mov ah,4Eh		;Function 4Eh - FindFirst 
			int 21h			;Dos service call 
			ret
FindF 		endp

			ENDWORK
			
			CLfunc long FileSize<char fname>
			CLcode
			
			mov bx,0		;
			mov cx,80		; Maximal length of file name 
			les si,fname		; File name address into ES:SI
			
			call FindF
			
			jnx Success			;If CARRY flag isn't set - successful
			mov word ptr SizeF,-1		;else set return value t -1 
			mov word ptr SizeF[2],-1	;to signal that file not found 
			
Success:
			mov ax,word ptr SizeF		;Place length of file into DX:AX
			mov dx,word ptr, SizeF[2]	;to return as FORTRAN function 
			mov word ptr FILELEN[0],ax
			mov word ptr FILELEN[2],dx
			CLret  FILELEN 
			
			CLfunc long FileAttr <char fname>
			CLcode
			
			mov bx,0
			mov cx,80			;Maximal length of file name 
			les si,fname			;File name address into ES:SI 
		
			mov word ptr FATTR[0],0
			mov word ptr FATTR[2],0
			Call FindF
			
			jc RetFlwn 			;If CARRY flag isn't set - successful 
			mov ah,0
			mov al,byte ptr Attrib		;Place length of file into DX:AX
			mov word ptr FATTR[0],ax
			
RetFlen:	Clret FATTR
			CLfunc long CurDisk<>
			CLcode
			push ds
			mov ah,32h			;function 32h - get drive parameters
			mov dl,0			; 0 - current drive 
			int 21h
			mov al,ds:[bx]
			pop ds
			mov word ptr NDisk[2],0
			mov ah,0
			mov word ptr NDisk[0],ax			
RetNDisk:
			CLret NDisk
			END
			
