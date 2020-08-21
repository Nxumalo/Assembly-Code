.model medium,BASIC
IFDEF ?? VERSION
public Qsound 
		ELSEIF @version EQ 600
Qsound 	PROTO BASIC freq: PTR WORD, durat: PTR WORD
				ELSE
public 	Qsound
		ENDIF
		
.data
Nticks 	dw 0
.code

Qsound 	PROC BASIC uses ax bx cx dx es di, freq: PTR WORD,
			durat: PTR WORD
			
			mov ax,5000
			mov bx,durat
			mov bx,[bx]
			cmp bx,0
			je Accept
			cmp ax,5000
			jg Accept
			mov ax,bx
			
Accept: 	mov Nticks,ax
			
			mov al,00110110b
			out 43h,al
			mov ax,1193
			out 40h,al
			mov al,ah
			out 40h,al
			
			mov bx,freq
			mov di,[bx]
			cmp di,0
			jg sound
			
			in al,61h
			and al, not 00000011b
			out 61h,al
			jmp ToTicks
			
Sound: 		mov al,1011011b
			out 43h,al
			mov dx,12h
			mov ax,34dch
			div di
			out 42h,al
			mov al,ah
			out 42h,al
			
			in al,61h
			or al,00000011b
			out 61h,al
			
ToTicks:	mov ax,40h
			mov es,ax
			
			mov bx,es:[6Ch]
			add bx,Nticks
			mov dx,es:[6Eh]
			
Delay:		cmp es:[6Eh],dx
			jb Delay
			cmp es:[6Ch],bx
			jb Delay
			
IsTime:		in al,61h
			and al, not 0000011b
			out 61h,al
			
			mov al,00110110b
			out 43h,al
			mov al,0FFh
			out 40h,al
			out 40h,al
			
			ret
Qsound		endp
			end
