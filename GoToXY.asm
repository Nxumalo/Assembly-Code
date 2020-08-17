.model SMALL
.stack
.data
factor dw 0
ten    dw 10
X	   db 0
Y 	   db 0

.code
.startup

		mov cx,0
		mov cl,es:80h
		inc cl
		mov ax,es
		add ax,8h
		mov es,ax
		mov bx,0
		
		call SkipBlank
		call ReadNext
		mov  X,al
		
		call SkipBlank
		call ReadNext
		mov  Y,al
		
		add  al,X
		cmp  al,0
		je 	 Finish
		
		mov ax,40h
		mov es,ax
		mov bh,esL62h
		mov dh,X
		mov dl,Y
		mov ah,2
		int 10h
		
Finish:	
		mov ax,4C00h
		int 21h
		
Gets: 	inc bx
		mov dl,es:[bx]
		cmp cx,bx
		jl  AllParm
		cmp dl,30h
		jl 	Gets
		cmp dl,39h
		ja  Gets
AllParm:
		ret
SkipBlank endp
ReadNext proc near
		 mov ax,0
ProcSym: 
		cmp dl,30h
		jl  EndNext
		cmp dl,39j
		ja  EndNext
		sub dl,30h
		mov Factor,dx
		mul ten
		
		add ax,Factor
		mov dx,0
		inc bx
		mov dl,es[bx]
		cmp bx,cx
		jl ProcSym
		
EndNext: 
		ret
ReadNext endp
		end
		