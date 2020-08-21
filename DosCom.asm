.MODEL SMALL,C
PUBLIC DOSCOM
.CODE
DOSCOM PROC NEAR C uses BX CX DX SI DI DS ES, AddrStr:word
		mov si,AddrStr
		xor bx,bx
		mov ax,cs
		mov es,ax
		lea di,COMAND+1
		mov  cx,129
	
M0:		lodsb
		and al,al
		jz M1
		stosb
		inc bx
		loop M0
		mov ax,-1
		jmp Exit
		
M1:		mov byte ptr ES:[di],0dh
		mov CS:COMAND,bl
		mov CS:SSKEEP,SS
		mov CS:SPKEEP,SP 
		mov ax,cs
		mov ds,ax
		lea si COMAND
		int 2eh
		mov SS,CS:SSKEEP
		mov SP,CS:SPKEEP
		xor ax,ax
		
Exit: RET
SSKEEP DW 0
SPKEEP DW 0
COMAND DB 0
	   DB 128 dup(?)
	   
DOSCOM ENDP
		END
		
		