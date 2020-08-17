.model tiny
.code
		mov ax,0305h
		mov bx,0
		
		int 16h
		mov ax4C00h
		int 21h
		end
		