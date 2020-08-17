ReqHeader	segment at 0
Headerlen	db	?
UnitCode	db	?
CommandCode	db 	?
Status		dw	?
Reserved	db  8 dup(?)
Units		db 	?
EndOffset	dw  ?
EndSegment	dw 	?
ReqHeader 	ends

BiosData	segment at 40h
			org 1Ah
BufHead		dw  ?
BufTail		dw  ?
			org 80h
BufStart	dw 	?
BufEnd		dw  ?
BiosData	ends

CR			equ 0Dh
LF			equ 0Ah
EndMsg		equ 24h
Space		equ 20h
InitCommand equ 0
DoneRep		equ 0100h
FailRep		equ 8003h
BufferDef	equ 80
BufferMin	equ 16
BufferMin	equ 512

_TEXT		segment public 'CODE'
			assume cs:_TEXT,ds: _TEXT,es:ReqHeader,ss:_TEXT
			org 0

NextDev 	dd 0FFFFFFFh
DevAttr		dw 8000h

Dev_Strat	dw Strategy
Dev_int 	dw Interrupt
Dev_name 	db 'KbdBuf '

ReqOffset	dw ?
ReqSegment 	dw ?
StackSeg	dw ?
StackPtr	dw ?
ThisSeg		dw ?
ThisOff		dw ?
ParamVal	dw 0
Ten			db 10
Sixteen		dw 16
BufLen 		dw 0
StatusWord 	dw DoneRep

Strategy 	proc far

			mov		ThisSeg,cs
			mov 	ThisOff,offset NextDev
			mov 	ReqSegment,es
			mov 	ReqOffset,bx
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
			
			mov al,CommandCode[bx]
			mov MsgAddr,offset InstMsg
			cmp al,InitCommand
			je 	ProcessCommand 
			mov StatusWord,FailRep
			mov MsgAddr,offset FailMsg
			jmp ReturnToDos
			
ProcessCommand:
			
			mov StatusWord,DoneRep
			mov EndSegment[bx],cs
			mov EndOffset
			
			mov cs:StackSeg,ss
			mov cs:StackPtr,sp
			mov ax,cs
			
			cli
			
			mov ss,ax
			mov sp,0FFFEh
			sti
			
			push es
			push si
			push bp
			
			call ReadParm
			call CountEnding
			jc   NotInstall
			
			mov  es,ReqSegment
			mov  bx,ReqOffset
			mov  ax,ParamVal
			add  EndOffset[bx]
			sub  ax,400h
			
			assume es:BiosData
			mov    dx,BiosData
			mov    es,dx
			
			cli
			
			mov    es:BufEnd,ax
			sub	   ax,ParamVal
			mov    es:BufStart,ax
			mov    es:BufHead,ax
			mov    es:BufTail,ax
			
			sti
			
			pop    es
			
			assume es:ReqHeader
			
NotInstall:
			
			pop 	bp
			pop		si
			pop		es
			
			cli
			
			mov 	ss,cs:StackSeg
			mov 	sp,cs:StackPtr
			sti
			
ReturnToDos:			
			
			push 	cs
			pop		ds
			mov 	ah,09
			mov 	dx,MsgAddr
			int 	21h
			mov 	es,ReqSegment
			mov 	bx,ReqOffset
			mov 	ax,StatusWord
			mov 	Status[bx],ax
			
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

DriverEnd 	label dword

ReadParm	proc near
			
			mov es,ReqSegment
			mov bx,ReqOffset
			mov si,es:ArgOffset[bx]
			mov es,es:ArgSegment[bx]
			mov BlankId,0
			mov bx,0
			
CopyParm: 	mov al,es:[si+bx]
			cmp al,CR
			je 	EndParm
			cmp al,LF
			je 	EndParm
			cmp al,0
			cmp al,'0'
			jl  NonDigit
			cmp al,9
			ja	NonDigit
			push	ax
			sub		al,'0'
			mov 	ah,0
			mov 	CurNum,ax
			mov 	ax,ParamVal
			mul		Ten
			add		ax,CurNum
			mov 	ParamVal,ax
			pop		ax
			
NonDigit:	inc bx
			cmp BlankId,0
			jne	EndParm
			jmp	CopyParm
			
EndParm:	cmp ParamVal,0
			jne PresentParm
			mov ParamVal,BufferDef
			
PresentParm: cmp ParamVal,BufferMin
			 ja  GreaterMin
			 mov ParamVal,BufferMin

GreaterMin:	 cmp ParamVal,BufferMax
			 jb  EndAccParm

TooBig:		 mov ParamVal,BufferMax
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
			 jc	  EscapeProc
			 add  ax,ParamVal
			 
EscapeProc:	 pop bx
			 pop es
			 ret
			
CountEnding endp
TxtParm (64)('$'),CR,LF,EndMsg
_TEXT		ends
			end
			
			
			
			