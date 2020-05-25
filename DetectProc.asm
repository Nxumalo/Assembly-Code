.model small
.stack
.data 
InMsg 			db 0Dh,0Ah,'You have an i80$'
FinMsg 			db 'microproce3ssor.',0Dh,0Ah,'$'
i86			db '86$'
i186			db '186$'
i286			db '286$'
i386			db '386/486'
.code
.startup
			mov ah,09
			lea dx,InMsg
			int 21h

			pushf
			pop ax
			and ax,7FFFh
			push ax
			popf
			pop ax
			sh1 ah,1
			jc Less286
			
			pushf
			pop ax
			or ah,40h
			push ax
			popf
			pushf
			pop ax
			and ah,40h
			jnz Det386

Det286:			lea dx,i286
			jmp FinPgm

Det386:			lea dx,i386

FinPgm:			mov ah,09h
			int 21h
			lea dx,FinMsg
			int 21h
			lea dx,FinMsg
			int 21h
			mov ax,4C00h
			int 21h

Less286:		lea dx,i86
			mov ax,1
			mov cx,32
			sh1 ax,c1
			jz FinPgm

			lea dx,i186
			jmp FinPgm
			end							
