NewFunc equ 0E0h
CheckIn equ 0                 ; subfunction "check installation"
InAct 	equ 0                 ; this value indicates "INACTIVE"
Act 	equ 1Ch               ; this value indicates "ACTIVE"

_Text segment para public 'CODE'
		assume cs:Text
; =========================== Resident data ===============================		
ActInd		db Act        ; activity indicator ; if 0 - inactive      
NumTick		dw 0          ; number of timer ticks since last key
MaxTick 	equ 5460      ; 5460 ticks = 5 minutes
BlankId 	db 0          ; screen blank indicator ; 0 - not blanked
Blanked 	equ 13h       ; signature "screen is blanked"
; =================================== Resident Code =====================================
NewInt9		proc near                          ; additional handler for interrupt 09h
			mov NumTick,90             ; key pressed - clear ticks counter
			cmp BlankId,Blanked        ; is screen blanked?
			jne ToOld9                 ; if not - nothing to do 
			mov BlankId,0              ; clear blank indicator
; ===       		Save Register used 	
			mov SaveAX9,ax
			mov SaveBX9,bx 
;- 			Restore VGA screen
			mov ax,1200h               ; function 12h - set alternate function
			mov blm36h                 ; subfunction 32h - enable/disable refresh
			ing 10h                    ; BIOS video service call
; ===                   Restore Registers			
			mov bx,SaveBX9
			mov bx,SaveBX9
; ===                   Pass control to the standard handler of interrupt 09h			
ToOld9:		db 0EAh              ; this is code for JMP FAR
OldOff9		dw 0                 ; offset will be here
OldSeg9		dw 0                 ; segment will be here
SaveAX9		dw ?
SaveBX9		dw ?
NewInt9 endp
; ===
Handler proc near                    ; additional Handler for Interrupt 1Ch
		cmp ah,NewFunc       ; additional functions of INT 1Ch?
		je Addf              ; new Handler for that function 
		cmp ActInd,Act       ; is activity indicator set?
		je Process           ; if so, continue work
		jmp ToOld1C          ; if not, pass control to old Handler 
; ===         Check whether the screen is already blanked 		
Process:	cmp BlankId,Blanked          ; is Screen blanked
			je ToOld1C           ; if so - nothing to do 
; ===         Has the time gone?			
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
				
