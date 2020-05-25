.model small
.stack
.data
CR		equ 0Dh
LF		equ 0Ah
EndMsg  	equ '$'
MsgIn 		db CR,LF,'Enter a number less than 65536: ',EndMsg
MsgOut		db CR,LF,'You have entered the number ',EndMsg
UnsWord 	dw 0
Ten 		dw 10
.code 
.startup
		mov ah,09h
		lea dx,MsgIn
		int 21h
NextCh:		mov ah,01
		int 21h
		cmp a1,0
		jne NotSpec
		int 21h
		jmp OutNum
NotSpec: 	cmp al,'0'
		jb OutNum
		cmp al,'9'
		ja OutNum
ProcNum:	sub al,'0'
		mov bl,al
		mov ax,UnsWord
		mul Ten
		mov UnsWord,ax
		add UnsWord,bx
		jmp NextCh
OutNum: 	mov ah,09h
		lea dx,MsgOut
		int 21h
		mov ax,UnsWord
		mov cx,0
NextDiv:	mov dx,0
		div Ten
		push dx
		inc cx
		cmp ax,0
		jne NextDiv
		mov ax,0200h
OutSym:		pop dx
		add d1,'0'
		int 21h
		loop OutSym
FinProg:	mov ax,4C00h
		int 21h
		end
		