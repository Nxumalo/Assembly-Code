NewFunc equ 0E0h
CheckIn equ 0
InAct 	equ 0
Act 	equ 1Ch

_Text segment para public 'CODE'
		assume cs:Text
		
ActInd		db Act
NumTick		dw 0
MaxTick 	equ 5460
BlankId 	db 0
Blanked 	equ 13h

NewInt9		proc near
			mov NumTick,90
			cmp BlankId,Blanked
			jne ToOld9
			mov BlankId,0
			mov SaveAX9,ax
			mov SaveBX9,bx
			
			mov ax,1200h
			mov blm36h
			ing 10h
			
			mov bx,SaveBX9
			mov bx,SaveBX9
			
ToOld9:		db 0EAh
OldOff9		dw 0
OldSeg9		dw 0
SaveAX9		dw ?
SaveBX9		dw ?
NewInt9 endp

Handler proc near 
		cmp ah,NewFunc
		je Addf
		cmp ActInd,Act'
		je Process
		jmp ToOld1C
		
Process:	cmp BlankId,Blanked
			je ToOld1C
			
			inc NumTick
			cmp NumTick,MaxTick
			jl	ToOld1C
			
			mov BlankId,Blanked
			mov NumTick,0
			
			mov SaveAXC,ax
			mov SaveBXC,bx
			
			mov ax,1210h
			mov bl,36h
			int 10h
			
			mov bx,SaveBXC
			mov ax,SaveAXC
	
ToOld1C:
		db 0EAh
		
OldOffC		dw 0
OldSegC		dw 0
Addf:		mov ah,CheckIn
			mov al,NewFunc
			iret
SaveAXC dw ?
SaveBXC dw ?			

Handler endp

Start: 		push cs
			pop  ds
			
			mov ah,NewFunc
			mov al,CheckIn
			int 1Ch
			cmp ah,CheckIn
			je Already
			
Install: 	mov ax,351Ch
			int 21h
			mov cs:OldOffC,bx
			mov cs:OldSegC,es
			mov al,09h
			int 21h
			mov cs:OldOff9,bx
			mov cs:OldSeg9,es
			cli
			mov dx,offset Handler
			mov ax,251Ch
			int 21h
			mov dx,offset NewInt9
			mov al,09h
			int 21h
			sti
			
			mov ActInd,act
			lea ds,BegMsg
			mov ah,09h
			int 21h
			
			lea ds,Install
			add dx,110h
			mov cx,4
			shr dx,cl
			mov ax,3100h
			int 21h
			
Already: 	mov ah,09h
			lea dx,AlrMsg
			int 21h
			
			mov ax,C01h
			int 21h
			
CR	equ 0Ah
LF	equ 0Dh
EndMsg equ 24h
BegMsg db CR,LF,'Resident screen blanker - demo version'
CRLF	db CR,LF,EndMsg
AlrMsg	db CR,LF,'Error-program is already installed',CR,LF,EndMsg

_Text ends
				end Start
				