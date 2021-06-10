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
			lea dx,BegMsg              ; DX - address of message 
			int 21h                    ; DOS service call 
			mov ResPSP,es              ; save offset of older handler for 13h
			mov ax,3513h               ; function 35h - Get Interrupt Vector 
			int 21h                    ; DOS service call
			mov OldOff,bx              ; save offset of old handler for 13h
			mov OldSeg,es              ; save segment of old handler for 13h
			mov ResOff,offset Handler        ; offset of resident part
			mov resSeg,ds              ; save segment of resident part
			cli                        ; caution! critical part of program
			mob dx,ResOff              ; address of handler 
			mov ax,2513h               ; function 25h - set new handler
			int 21h                    ; DOS service call 
			sti                        ; critical part finishes here 
; ===                   output the message "program is installed"			
			mov ActInd,Act             ; set activity indicator (TSR "ON")
			lea dx,Loaded              ; DX - address of message 
			mov ah,09h                 ; function 25h - set new handler 
			int 21h                    ; DOS service call
; ===                   calculate the size of the resident part			
			lea dx,Install
			add dx,110h                ; PSP length plus 16 bytes (reserve)
			mov cx,4                   ; set counter for shift
			shr dx,cl                  ; 4 bits to right (dividing by 16)
			mov ax,3100h               ; 31h - terminate and stay resident 
			int 21h                    ; DOS service call
; ===                   Normal exit from program (return code 0)			
NormEx:		        mov ds,ComSeg              ; restores DS (can be destroyed)
			mov ah,09h                 ; function 09 - output string 
			int 21h                    ; DOS service call
			mov ah,4Ch                 ; function 4Ch - terminate process
			mov RetCode,al             ; return code into AL 
			int 21h                    ; DOS service call
; ===                   Process situation "Resident part is already installed"			
Already:	        mov es,PspAddr             ; address is already installed 
			cmp byte ptr es:[80h],1             ; are there parameters
			jle NoParm                 ; if not, set the indicator "NoParm"
			mov bx,82h                 ; BX - beginning of parameter string
			cmp byte ptr es:[bx],'/'             ; parameters begin with "/"?         
			jne CheckS                 ; if not, check for "-"			
SkipSep: 	        inc bx                     ; increase counter (skip separator)
			jmp ChkLtr
			
CheckS: 	cmp byte ptr es:[bx],'-'           ; parameters begin with "-"
			je SkipSep                 ; to skipping separator 			
ChkLtr:		cmp byte ptr es:[bx],'?'           ; parameters begin with "?"
			je Help                    ; if so, "Help" function requested
			and byte ptr es:[bx],0DFh            ; first letter into uppercase   
			cmp byte ptr es:[bx],'H'             ; is first letter 'H'
			je  Help                    ; if so, process "Help"
			cmp byte ptr es:[bx],'D'             ; is first letter 'D'
			je  UnInst                  ; if so, process "DEINSTALL"
			cmp byte ptr es:[bx],'O'             ; is first letter 'O'
			jne InvParm                 ; if not - missing or valid 
			add byte ptr es:[bx+1],0DFh          ; second letter into uppercase
			cmp byte ptr es:[bx+1],'N'           ; is second letter 'N'
			je  TurnOn                  ; if so, process "ON"
			cmp byte ptr es:[bx+1],'F'           ; is second letter 'F'
			jne InvParm                 ; if not - invalid parameter 
			and byte ptr es:[bx+2],0DFh          ; third letter into uppercase
			cmp byte ptr es:[bx+2],'F'           ; is third letter 'F'
			jne InvParm                 ; if not, process "INVALID PARMS"
			mov al,IdSwOff              ; code for subfunction "OFF" into AL
			jmp Switch                  ; switch program
; ===      deinstall new handler 			
Uninst:		        mov ah,NewFunc		    ; AH - code for additional function	
; -        get information about the resident part (PSP, segment, offset)
                        mov al,IdUnIn               ; AL - subfunction "deinstallation"
			mov es,ComSeg               ; ES points to current segment 
			mov bx,offset ResArea            ; ES:BX - buffer for "return PSP"
; -        get information about current handler of interrupt 13			
			int 13h                     ; call new handler of interrupt 13h
			mov ax,3513h                ; function 35h - get interrupt vector 
			int 21h                     ; DOS service call
; -        is the resident part of this program last handler of INT 13h?			
			mov ax,es                   ; AX - segment of current handler 
			cmp ax,ResArea[8]           ; segment of resident part
			jne Over           ; if not equal - res. part overridden      
			cmp bx,ResArea[6]           ; compare offsets
			jne Over           ; if not equal - res. part overridden
; -        free memory occupied by the resident part of TSR			
			mov es,ResArea[0]           ; address of resident PSP into ES
			mov ah,49h                  ; function 49h - free memory block 
			int 21h            ; DOS service call 
; -        make previous handler of interrupt 13 current 			
			mov ds,ResArea[4]          ; DS - segment of old handler 
			mov dx,ResArea[2]          ; DX - offset of old handler 
			mov acm2513h               ; function 25h - set interrupt vector 
			int 21h            ; DOS service call
			mov ds,ComSeg              ; restore data segement register 
; -        leave program			
			lea dx,UnInMsg             ; DS:DX - point to message "deinstalled"
			jmp NormEx                 ; leave program
; -        process situation "TSR Overridden"			
Over:		lea dx,OverMsg                     ; DS:DX - point to message "overridden"
		jmp NormEx                 ; leave program
; ===      Turn the program ON			
TurnOn: 	mov al,IdSwOn              ; subfunction "TURN ON"
; ===      This block switches program state			
Switch:		mov ah,NewFunc             ; AH - code for additional function
		int 13h            ; call new handler of interrupt 13h
; ===      Process the situation "no parameter"			
NoParm: 	mov ah,NewFunc             ; AH - code for additional function
		mov al,RepSt               ; AL - subfunction "report status"
		int 13h            ; call new handler of interrupt 13h
		lea dx,MakeOff             ; DS:DX - message "turn OFF"
		cmp ah,IdSwOn              ; is code "turned ON" returned?
		jne FinTst         ; if not, exit;  "OFF" will be output
		lea dx,MakeOn              ; DS:DX - message "turned ON"			
FinTst: 	jmp NormEx         ; to print message and exit 
; ===      Output help message			
Help:		lea dx,BegMsg              ; DS:DX - address of initial message
Help2:		mov ah,09h         ; function 09 - output text string 
		int 21h            ; DOS service call 
		lea dx,ParmTxt             ; DS:DX - address of HELP message
		jmp NormEx         ; to print message and exit 
; ===	   Process the situation "INVALID PARAMETERS"		
InvParm:	lea dx,Invalid             ; DS:DX address of message "invalid"
		mov retCode,1              ; return code = 1 
		jmp Help2                  ; to print message and exit 
; ===      Data for non-resident part of the program			
CR		equ 0Ah
LF		equ 0Dh
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
