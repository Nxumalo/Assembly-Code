; This program installs additional handlers for interrupt 13h

; NEW function 0EFh of interrupt 13h has been added.
; This function has 3 subfunctions:
; 00 - installation check
; 01 - activates the driver
; 02 - deactives the driver
; 03 - report the driver state

; returns the state in AH ( 1 - on, 2 - off)
; To call new function put its number into the AH register,
; The subfunction number into AL and call interrupt 13h
;

NewFunc equ 0E0h        
CheckIn equ 0            ; subfunction "check installation"
IdSwOn 	equ 1            ; subfunction "turn program on"
IdSwOff equ 2            ; subfunction "turn program off"
RepSt	equ 3            ; subfunction "report status"
IdUnIn	equ 4            ; subfunction "get resident PSP address"
InAct	equ 0            ; this value indicates "INACTIVE"
Act		equ 13h                ; this value indicates "ACTIVE"

_Text segment para public 'CODE'
	assume cs:_Text
; ========================= RESIDENT DATA ===============================
ActInd db Act              ; activity indicator if 0 - inactive 
ResPSP dw ?                ; address of resident PSP
ResOff dw ?                ; offset of resident part
ResSeg dw ?                ; segment of resident part 
; ========================= RESIDENT CODE ===============================

Handler proc near          ; additional handler for interrupt 13h
		pushf 
		cmp ah,NewFunc          ; additional function of INT 13h?
		je Addf                 ; new handler for that function 
		cmp ActInd,Act          ; is activity indicator set?
		jne ToOld13             ; if so, continue work
; ===           Check whether the screen is already blanked 		

Process:	        cmp dl,79h               ; is floppy disk requested?
			ja ToOld13               ; if not, jump to old handler
			cmp ah,03h               ; function 03 - write sector 
			je RepCod                ; new handler for function 03
			cmp ah,0Bh               ; function 0B - write long sector 
			je RepCod                ; new handler for function 0Bh
			jmp ToOld13              ; others processed by older handler
; ===           Process write commands 		

RepCod:		cmp ActInd,Act              ; is active mode set?
		jne ToOld13                 ; if not, jump to old handler
		mov ah,04h                  ; function 04h - verify sector 
; ===           Pass control to the standard handler of interrupt 13h			

ToOld13:
  	   db 0EAh        ; this is code for JMP FAR				
OldOff     dw 0           ; offset will be here
OldSeg     dw 0           ; segment will be here 
; ===      Process additional function of interrupt 13h

Addf:	         cmp al,CheckIn       ; is installation check required?
		 je Inst
		 cmp al,IdSwOn        ; turn driver ON?
		 je SwOn
		 cmp al,IdSwOff       ; turn driver OFF?
		 je Swoff
		 cmp al,RepSt         ; report status?
		 je Report
		 cmp al,IdUnIn
		 je RetPSP
		 jmp ToOld13          ; unknown command-pass to old handler 

Inst:		 mov ah,CheckIn       ; value to be returned into AH
		 jmp ExHand           ; exit handler			

SwOn:	         mov ActInd,Act       ; set indicator to ACTIVE (ON)
		 mov ah,IdSwOn        ; value to be returned into AH
		 jmp ExHand           ; exit handler		

ResPSP: 	        mov ah,IdUnIn            ; value to be returned into AX
			mov dx,ResPSP
			mov es:[bx+0],dx         ; segement address of resident PSP
			mov dx,OldOff
			mov es:[bx+2],dx         ; offset address of old handler 
			mov dx,OldSeg
			mov es:[bx+4],dx         ; segment address of old handler 
			mov dx,ResOff
			mov es:[bx+6],dx         ; offset address of this handler 
			mov dx,ResSeg
			mov es:[bx+8],dx         ; segment address of this handler
			jmp ExHand               ; exit handler 		

Report:		        mov ah,IdSwOff           ; prepare "INACTIVE" code for returning
			cmp ActInd,Act           ; is activity indicator set?
			jne ExHand               ; if not, exit handler 
			mov ah,IdSwOn            ; return "Active" code
					
ExHand: 	mov al,NewFunc           ; return additional signature in AL
		popf
		iretf          ; return from handler
		
Handler endp
; === Installation part of the program
BegInst label byte
ParmInd db 0
PspAddr dw ?
ComSeg	dw ?
ResArea dw 5 dup(?)            ; buffer subfunction "return PSP"
RetCode db 0
Start:		        mov PspAddr,es             ; save address of PSP
			mov sp,0F000h		   ; set stack at end of program's area
; ===   Free the enviroment memory block			
			mov es,es:[2Ch]            ; address of enviroment block int ES
			mov ah,49h                 ; function 49h - free memory block
			int 21h                    ; DOS service call
; ===   			
			mov es,PspAddr             ; set ES to point to PSP
			mov ComSeg,es              ; save current command segment
			mov ds,ComSeg              ; DS = CS - data and code are the same
; ===                   check whether the program is already installed			
			mov ah,NewFunc             ; new function of INT 13h
			mov al,CheckIn             ; AL - installation check
			int 13h                    ; call interrupt 13h - timer
			cmp ah,CheckIn             ; does AH contain function number?
			je  Already                ; if YES, handler is already installed
; ===                   installation part 			
Install:        	mov ah,09                  ; function 09 - text string output
			lea dx,BegMsg
			int 21h
			mov ResPSP,es
			mov ax,3513h
			int 21h
			mov OldOff,bx
			mov OldSeg,es
			mov ResOff,offset Handler
			mov resSeg,ds
			cli
			mob dx,ResOff
			mov ax,2513h
			int 21h
			sti
			mov ActInd,Act
			lea dx,Loaded
			mov ah,09h
			int 21h
			
			lea dx,Install
			add dx,110h
			mov cx,4
			shr dx,cl
			mov ax,3100h
			int 21h
			
NormEx:		mov ds,ComSeg
			mov ah,09h
			int 21h
			mov ah,4Ch
			mov RetCode,al
			int 21h
			
Already:	mov es,PspAddr
			cmp byte ptr es:[80h],1
			jle NoParm
			mov bx,82h
			cmp byte ptr es:[bx]
			jne CheckS
			
SkipSep: 	inc bx
			jmp ChkLtr
			
CheckS: 	cmp byte ptr es:[bx]
			je SkipSep
			
ChkLtr:		cmp byte ptr es:[bx]
			je Help
			and byte ptr es:[bx],0DFh
			cmp byte ptr es:[bx],'H'
			je Help
			cmp byte ptr es:[bx],'0'
			jne InvParm
			add byte ptr es:[bx+1],0DFh
			cmp byte ptr es:[bx+1],'N'
			je TurnOn
			cmp byte ptr es:[bx+1],'F'
			jne InvParm
			and byte ptr es:[bx+2],0DFh
			cmp byte ptr es:[bx+2],'F'
			jne InvParm
			mov al,IdSwOff
			jmp Switch
			
Uninst:		mov ah,NewFunc
			
			mov al,IdUnIn
			mov es,ComSeg
			mov bx,offset ResArea
			
			int 13h
			mov ax,3513h
			int 21h
			
			mov ax,es
			cmp ax,ResArea[8]
			jne Over
			cmp bx,ResArea[6]
			jne Over
			
			mov es,ResArea[0]
			mov ah,49h
			int 21h
			
			mov ds,ResArea[4]
			mov dx,ResArea[2]
			mov acm2513h
			int 21h
			mov ds,ComSeg
			
			lea dx,UnInMsg
			jmp NormEx
			
Over:		lea dx,OverMsg
			jmp NormEx
			
TurnOn: 	mov al,IdSwOn
			
Switch:		mov ah,NewFunc
			int 13h
			
NoParm: 	mov ah,NewFunc
			mov al,RepSt
			int 13h
			lea dx,MakeOff
			cmp ah,IdSwOn
			jne FinTst
			lea dx,MakeOn
			
FinTst: 	jmp NormEx
			
Help:		lea dx,BegMsg
Help2:		mov ah,09h
			int 21h
			lea dx,ParmTxt
			jmp NormEx
			
InvParm:	lea dx,Invalid
			mov retCode,1
			jmp Help2
			
CR			equ 0Ah
LF			equ 0Dh
EndMsg		equ 24h
Invalid 	db CR,LF,'Cannot interpret parameters specified.'
			db CR,LF,'Command line is:'CR,LF,EndMsg
BegMsg		db CR,LF,'The disk security system 2.5 17/08/2020'
			db CR,LF,'South Africa'
CRLF		db CR,LF,EndMsg
Loaded 		db CR,LF,'Program installed ',CR,LF,EndMsg
MakeOn		db CR,LF,'Disk guard is now ACTIVE',CR,LF,EndMsg
HelpTxt		db CR,LF,CR,LF,'Call: '
ParmTxt		db CR,LF,'FSecret [on|off|u|/?|/h|-?|-h] ',CR,LF
			db CR,LF,'Parmeters : '
			db CR,LF,'On - make the floppy disk guard active '
			db CR,LF,'Off-make the floppy disk guard active '
			db CR,LF,'d - deinstall the disk guard; it must be '
			db CR,LF,'the last handler for interrupt 13h '
			db CR,LF,'rest of list- pitput is test. ' ,CR,LF
			db CR,LF,'First call always means installation. '
			db CR,LF,'Call without parameters to determine '
			db 'Current state. ',CR,LF,EndMsg
OverMsg 	db CR,LF,'FSecret is not last handler of INT 13h.'
			db CR,LF,'Self - deinstalling impossible'
			db CR,LF,EndMsg
UnInMsg 	db CR,LF,'Program FSecret deinstalled.',EndMsg
_Text		ends
			end Start
				
			
			
			
			
			
			
			
			
			
			
