NewFunc equ 0E0h
CheckIn equ 51h

_Text segment para public 'CODE'
		assume cs:_Text
		
NumFun		db ?
SaveAx		dw ?
SaveBx		dw ?
SaveCx		dw ?
SaveDx		dw ?

Handler proc near
		cmp 	ah,NewFunc
		je		Addf
		
Process:	pushf
			mov NumFun,ah
			cmp ah,1
			jne VidCall
			cmp cl,8
			jb  VidCall
			mov cl,7
			shr ch,1
			
VidCall: 	call dword ptr OldHand
				cmp NumFun.0
				je ModCurs
				cmp NumFun,11h
				je ModCurs
				iret
				
ModCurs: 	pushf
			mov SaveAx,ax
			mov SaveBx,bx
			mov SaveCx,cx
			mov SaveDx,dx
			mov ah,03h
			mov bx,0
			pushf
			call dword ptr OldHand
			mov ah,ch
			and ah,1Fh
			cmp ah,6
			jb ModCL
			and ch,07h
			or ch,06h
			
ModCL:		mov cl,07h
			mov ah,01h
			pushf
			call dword ptr OldHand
			mov dx,SaveDx
			mov cx,SaveCx
			mov bx,SaveBx
			mov ax,SaveAx
			popf
	
NoMod: iret

ToOld10: kmp dword ptr OldHand
OldHand dw ?,?
OldOff equ OldHand[+0]
OldSeg equ OldHand[+2]

Addf: cmp al,CheckIn
		jne ToOld10
		
Inst:	xchg ah,al
			iret
			
Handler endp

ComSeg dw ?
PSPAddr dw ?
Start:	 mov PSPAddr,es
			mov sp,0F000h
			mov es,es:[2Ch]
			mov ah,49
			int 21h
			
			mov es,PSPAddr
			mov ComSeg,cs
			mov ds,ComSeg
			
			mov ah,NewFunc
			mov al,CheckIn
			int 1Ch
			cmp ah,CheckIn
			je Already
			
			mov ax,3510h
			int 21h
			mov OldOff,bx
			mov OldSeg,es
			mov dx,offset Handler
			mov ax,2510h
			omt 21h
			
			lea dx,BegMsg
			mov ah,09h
			int 21h
			
			lea dx,BegInst
			add dx,110h
			mov cx,4
			shr dx,cl
			mov ax,3100h
			int 21h
			
NormEx: 	mov al,0
FullEx: 	mov ah,4Ch
			int 21h
			
Already: 	mov ah,09h
			lea dx,AlrMsg
			omt 21h
			mov al,1
			jmp FullEx			
			
CR	equ 0Ah
Lf	equ 0Dh
EndMsg equ 24h
BegMsg	db CR,LF 'resident cGA-compatible cursor keeper.'
		db CR,LF 'Copyright(C) 1992 V.B. Maljugin, Voronezh'
		
CRLF	db CR,LF,EndMsg
AlrMsg  db CR,LF,'Program has been installed!',CR,LF,EndMsg
_Text ends 
			End Start
			
		 
			