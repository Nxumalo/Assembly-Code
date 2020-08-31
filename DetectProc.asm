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
;=== 			Output initial message

			mov ah,09	;function 09h - output text string
			lea dx,InMsg	;address of initial message into DX
			int 21h		;Dos service call
;===			Try to clear bit 15 (to put 0 into it)
			pushf		;push original flags
			pop ax		;copy flag register omtp AX
			and ax,7FFFh	;keep all bits but 15 (clear bit 15)
			push ax		;push value with bit 15 clear
			popf		;load flags (bits 0-14 original), bit 15 = 0
			pushf		;push flag register
			pop ax		;read flags into AX
			sh1 ah,1	;if  bit 15 is set CF will be set
			jc Less286	;processor not 286 or above 
;===			Processor os 286 or above			
			pushf		;push original flags 
			pop ax		;copy flag regiser into AX
			or ah,40h	;set NT flag (bit 14)
			push ax		;push value with bit 14 set onto stack
			popf		;copy this value into flags (sets NT flag)
			pushf		;push flag register onto stack
			pop ax		;copy flag regiser into AX
			and ah,40h	;check bit 14 (NT flag)
			jnz Det386	;if it is actually set-at lleast 386 found
;===			Processor is 286
Det286:			lea dx,i286	;address of message "286" into DX
			jmp FinPgm	;to finish program 
;===			Processor is 386/486			
Det386:			lea dx,i386 	;address of message "386/486" into DX
FinPgm:			mov ah,09h	;function 09h - output text string 
			int 21h		;DOS service call
			lea dx,FinMsg	;address of message 'microprocessor found"
			int 21h		;DOS service call
;===			Processor is lower than 286			

Less286:		lea dx,i86	; address of text "86"
			mov ax,1	;set bit 1 of AX
			mov cx,32	;shift counter = 32
			sh1 ax,c1	;shift AX to the left by 32 bits
			jz FinPgm	;if AX is clear - i8086 found
;=== 			Processor is 186/188	
			lea dx,i186	;otherwise - i80186/i80188
			jmp FinPgm	;to finish program
			end							
