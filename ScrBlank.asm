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
			inc NumTick             ; increase ticks counter
			cmp NumTick,MaxTick     ; is it time to blank screen
			j1  ToOld1C             ; if not, proceed to standard handler 
; ===                Blank the screen			
			mov BlankId,Blanked     ; set blank indicator 
			mov NumTick,0           ; clear ticks counter 
; ===                Save Registers			
			mov SaveAXC,ax          
			mov SaveBXC,bx
;-                   Blank VGA screen		
			mov ax,1210h            ; function 12h - set alternate function
			mov bl,36h              ; subfunction 32h - enable/disable refresh
			int 10h                 ; BIOS video service call
;- 		     Restore Register 	
			mov bx,SaveBXC
			mov ax,SaveAXC
	
ToOld1C:
		db 0EAh                         ; this is code for JMP FAR		
OldOffC		dw 0                            ; offset will be here 
OldSegC		dw 0                            ; segment will be here
;===            Process additional functions of interrupt 1Ch
Addf:		mov ah,CheckIn                  ; value to be returned into AH
			mov al,NewFunc
			iret                    ; return from handler 
SaveAXC dw ?
SaveBXC dw ?			

Handler endp
;===        Process additional functions of interrupt 1Ch
Start: 		        push cs            
			pop  ds                 ; DS = CS - data and code are the same
;=== 	    Check whether the program is already installed		
			mov ah,NewFunc          ; new function of INT 1Ch
			mov al,CheckIn          ; AL - installation check 
			int 1Ch                 ; call interrupt 1Ch - timer tick 
			cmp ah,CheckIn          ; does AH contain function number?
			je Already              ; if YES, handler is already installed 
;===  	    Installation part
Install: 	mov ax,351Ch                    ; function 35 - Get Interrupt Vector 
			int 21h                 ; DOS service call 
			mov cs:OldOffC,bx       ; save offset of old handler for 1Ch
			mov cs:OldSegC,es       ; save segment of old handler for 1Ch 
			mov al,09h              ; AL - interrupt number, AH keeps 35h
			int 21h                 ; DOS service call 
			mov cs:OldOff9,bx       ; seoffset of old handler for 09h
			mov cs:OldSeg9,es       ; save segment of old handler for 09h
			cli                     ; caution! critical part of program 
			mov dx,offset Handler            ; address of handler 
			mov ax,251Ch                     ; function 25h - Set new Handler 
			int 21h                 ; DOS Service call 
			mov dx,offset NewInt9            ; critical part finishes here
			mov al,09h              ; address of new INT 09 Handler 
			int 21h                 ; DOS Service call 
			sti                     ; critical part finishes here
			
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
				
