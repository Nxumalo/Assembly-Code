ReqHeader	segment at 0
Headerlen	db	?
UnitCode	db	?
CommandCode	db 	?
Status		dw	?
Reserved	db  8 dup(?)
Units		db 	?			;Number of units
EndOffset	dw      ?			;Segments:Offset address of 
EndSegment	dw 	?			;the end of resident part
ArgOffset	dw	?			;Segment:Offset address of
ArgSegment	dw	?			;the parameter string 
ReqHeader 	ends				
;
;		BIOS data segment
;
BiosData	segment at 40h
		org 1Ah
BufHead		dw  ?				;Buffer head ptr
BufTail		dw  ?				;Buffer tail ptr
		org 80h
BufStart	dw 	?			;Points to the buffer start
BufEnd		dw	?			;Points to the buffer end 
BiosData	ends

CR		equ 0Dh			;Carriage return code
LF		equ 0Ah			;Line feed code
EndMsg		equ 24h			;Dollar sign code
Space		equ 20h			;Blank code
InitCommand equ 0			;Command "INIT driver"
DoneRep		equ 0100h		;Code "Device ready"
FailRep		equ 8003h		;Code "Error-unknown command"
BufferDef	equ 80			;Buffer default length 
BufferMin	equ 16			;Buffer minimal length 
BufferMax	equ 512			;Buffer maximal length 

_TEXT		segment public 'CODE'
			assume cs:_TEXT,ds: _TEXT,es:ReqHeader,ss:_TEXT
			org 0

NextDev 	dd 0FFFFFFFh;		;Pointer to the next driver
DevAttr		dw 8000h		;Character device 

Dev_Strat	dw Strategy		;Offset of STRATEGY proc
Dev_int 	dw Interrupt		;Offset of INTERRUPT proc
Dev_name 	db 'KbdBuf '		;Driver name (8 characters)

ReqOffset	dw ?
ReqSegment 	dw ?
StackSeg	dw ?
StackPtr	dw ?
ThisSeg		dw ?
ThisOff		dw ?
ParamVal	dw 0
Ten		db 10
Sixteen		dw 16
BufLen 		dw 0
StatusWord 	dw DoneRep

Strategy 	proc far
;
; The procedure STRATEGY is called while installing the driver 
; This procedure is a dummy procedure because the driver
; doesn't control any real device.
;
			mov	ThisSeg,cs				;Save the current segment 
			mov 	ThisOff,offset NextDev			;Save offset of beginning 
			mov 	ReqSegment,es				;Save the segment of REQUEST
			mov 	ReqOffset,bx				;Save the offset of REQUEST
			push 	ax
			push 	dx
			push 	ds
			mov 	ah,09
			mov 	ds,ThisSeg
			mov 	dx,offset HeadMsg
			int 	21h
			pop 	ds
			pop		dx
			pop		ax
			ret
HeadMsg		db 'Keyboard buffer extender ' ,EndMsg
Strategy	endp

Interrupt 	proc far
			push ax
			push bx
			push cx 
			push dx
			push ds
			pushf
			
			mov al,CommandCode[bx]				;Get the command code
			mov MsgAddr,offset InstMsg			;
			cmp al,InitCommand				;Is it the INIT command?
			je  ProcessCommand				;If so, continue the work  	
			mov StatusWord,FailRep				;If not, report error 
			mov MsgAddr,offset FailMsg			
			jmp ReturnToDos					;and exit the driver 
			
ProcessCommand:
			
			mov StatusWord,DoneRep				;Report "DONE" to DOS
			mov EndSegment[bx],cs				;Return address of the end 
			mov EndOffset					
			
			mov cs:StackSeg,ss				;Save the stack segment 
			mov cs:StackPtr,sp				;Save the stack pointer
			mov ax,cs					;Get the current segment 
			
			cli						;No interrupts allowed while 
									;changing stack registers
			mov ss,ax					;Stack is in current segment 
			mov sp,0FFFEh					;Stack is at the top of seg 
			sti						;Interrupts are now allowed
			
			push es						;
			push si						;
			push bp						;
			
			call ReadParm					; Read parameter string 
			
			call CountEnding				; Address of buffer end 		
			
			jc   NotInstall					; If Carry Flag is set driver 
									; is not located in first 64K
; Following tow lines put SEGMENT:OFFSET address of the driver's
; resident part into the DATA field for INIT command

			mov  es,ReqSegment				
			mov  bx,ReqOffset
			mov  ax,ParamVal				;Buffer length into AX
			add  EndOffset[bx],ax				;Offset address of buffer end 
			
			push es
			mov  ax,EndSegment[bx]				;Segment address of buffer 
			
			mul Sixteen 					;Right shit by 1 hex digit 
			add ax,EndOffset[bx]				;Effective address
			sub ax,400h					;Subtract start address of 
									;BIOS data area
			
			assume es:BiosData				
			mov    dx,BiosData
			mov    es,dx					;ES points to BIOS data seg
			cli						;No interrupts allowed!
			mov    es:BufEnd,ax				;New BUFFER END PTR 
			sub    ax,ParamVal				;Subtract length of buffer 
			mov    es:BufStart,ax				;New BUFFER START PTR
			mov    es:BufHead,ax				;New BUFFER HEAD PTR
			mov    es:BufTail,ax				;New BUFFER TAIL PTR 
			
			sti						;Pointers are set - allow INT  
			pop    es	
			assume es:ReqHeader
			
NotInstall:
			
			pop 	bp
			pop	si
			pop	es
			
			cli
			mov 	ss,cs:StackSeg				;Restore the stack segment 
			mov 	sp,cs:StackPtr				;Restore the stack pointer 
			sti
			
ReturnToDos:			
			
			push 	cs
			pop	ds
			mov 	ah,09					;Functiion 09 - output string 
			mov 	dx,MsgAddr				;DX - Address of initial message
			int 	21h					;DOS service call
			mov 	es,ReqSegment				;ES:BX point to the request 
			mov 	bx,ReqOffset				;header area
			mov 	ax,StatusWord				;Remember the status word
			mov 	Status[bx],ax				;and return it to the DOS 
			
			popf
			pop		ds				
			pop		dx
			pop		cx
			pop		bx
			pop		ax
			
			ret
			
InstMsg db 'is successfully installed ',CR,LF,EndMsg
FailMsg	db 'failed - not in the first 64k of memory',CR,LF,EndMsg

MsgAddr 	dw ?
Interrupt	endp

DriverEnd 	label dword						;This marks the END of the driver 

ReadParm	proc near
				
			mov es,ReqSegment				;ES:BX point to the request 
			mov bx,ReqOffset				;data field 
			mov si,es:ArgOffset[bx]				;ES:SI - offset of arguments
			mov es,es:ArgSegment[bx]
			mov BlankId,0
			mov bx,0
			
CopyParm: 		mov al,es:[si+bx]
			cmp al,CR
			je  EndParm
			cmp al,LF
			je  EndParm
			cmp al,0
			je  EndParm
			cmp al,'0'
				jl  NonDigit
				cmp al,9
				ja	NonDigit
				push	ax
				sub	al,'0'			;Characters to number 
				mov 	ah,0			;Clear high part of AX
				mov 	CurNum,ax		;Store current value 
				mov 	ax,ParamVal
				mul	Ten
				add	ax,CurNum
				mov 	ParamVal,ax
				pop	ax

NonDigit:		inc bx
			cmp BlankId,0
			jne	EndParm
			jmp	CopyParm
			
EndParm:		cmp ParamVal,0				;Is parameter set?
			jne PresentParm				;If so,process its value 
			mov ParamVal,BufferDef			;Else set default value
			
PresentParm: 	 	 cmp ParamVal,BufferMin			;Compare to minimal value 
			 ja  GreaterMin				;Continue if it is bigger
			 mov ParamVal,BufferMin			;Else set minimal value 

GreaterMin:	 cmp ParamVal,BufferMax				;Compare to maximal value 
		 jb  EndAccParm					;If less-accept the value

TooBig:		 mov ParamVal,BufferMax				;Else set maximal value 
EndAccParm:
			 ret
BlankId		 db ?
CurNum		 dw ?
ReadParm	 endp

CountEnding  proc near
			 push es
			 push bx
			 mov  es,ReqSegment
			 mov  bx,ReqOffset
			 mov  ax,EndSegment[bx]
			 mul  Sixteen
			 jc   EscapeProc
			 add  ax,EndOffset[bx]
			 jc   EscapeProc 
			 add  ax,ParamVal
			 
EscapeProc:	 pop bx
		 pop es
		 ret						;Ax now contains the effective
			
CountEnding endp						;address of buffer end 
TxtParm (64)('$'),CR,LF,EndMsg
_TEXT		ends
		end
			
			
			
			
