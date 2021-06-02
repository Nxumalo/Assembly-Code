NewFunc equ 0E0h
CheckIn equ 51h				; subfunction " check installation "

_Text segment para public 'CODE'	
		assume cs:_Text
; =========================== Resident Data ===================================		
NumFun		db ?				; number of interrupt 10h function 
SaveAx		dw ?				; register AX will be saved here 
SaveBx		dw ?				; register BX will be saved here
SaveCx		dw ?				; register CX will be saved here
SaveDx		dw ?				; register DX will be saved here 
; ========================== Resident Code ====================================
Handler proc near				; additional handler for interrupt 10h
		cmp 	ah,NewFunc		; additional function of INT 10h?
		je		Addf		; new handler for that function 					
Process:	pushf				; new handler for INT 10h starts here
			mov NumFun,ah		; save number of function called 
			cmp ah,1		; is it function "Set Cursor Type"
			jne VidCall		; if not call standard handler 
			cmp cl,8		; is cursor end line greater than 7 
			jb  VidCall		; if not, call standard handler 
			mov cl,7		; otherwise replace cursor end line with 7
			shr ch,1		; divide value of start line by 2 
			
VidCall: call dword ptr OldHand		;call BIOS video interrupt 
		cmp NumFun.0		;function 0 - Set Video Mode?
		je ModCurs		;if so, reprogram cursor 
		cmp NumFun,11h		;was it function 11 - Character set?
		je ModCurs		;if so, reprogram cursor 
		iret			;return from interrupt handler 
				
ModCurs: 	pushf
			mov SaveAx,ax			;save AX in memory, without using stack
			mov SaveBx,bx			;save BX in memory, without using stack  
			mov SaveCx,cx			;save CX in memory, without using stack
			mov SaveDx,dx			;save DX in memory, without using stack 
			mov ah,03h			;function 03 - get cursor position
			mov bx,0			;video page 0
			pushf				;imitate interrupt 
			call dword ptr OldHand		;call BIOS video interrupt 
			mov ah,ch			;cursor start line into AH
			and ah,1Fh			;bits 0 - 4 are significant
			cmp ah,6			;is start line greater than 6!
			jb ModCL			;if not, modify end line
			and ch,07h			;4 low bits (value 0 - 15)
			or ch,06h			;divide start line by 2			
ModCL:		mov cl,07h				;end line will always be 7
			mov ah,01h			;function 01 - get cursor position
			pushf				;imitate interrupt 
			call dword ptr OldHand		;call BIOS video interrupt 
			mov dx,SaveDx			;restore DX from memory
			mov cx,SaveCx			;restore CX from memory
			mov bx,SaveBx			;restore BX from memory 
			mov ax,SaveAx			;restore AX from memory 
			popf				;restore orginal flags 
	
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
		db CR,LF 'Copyright(C) 2020 F. Nxumalo Unversity of the Western Cape, South Africa '
		
CRLF	db CR,LF,EndMsg
AlrMsg  db CR,LF,'Program has been installed!',CR,LF,EndMsg
_Text ends 
			End Start
			
		 
			
