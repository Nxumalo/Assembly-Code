BiosDat segment at 40h
		org 17h
KbdFl1 	db ?
KbdFl2  db ?
		org 96h
KbdFl3	db ?
BiosDat ends 
		CODESEG keybServ
		DATASEG
CLpublic <IsKbdEnh,GnumLock,Gcapslock,Snumlock,Scapslock>
CLstatic
$define FALSE 0000h
$define TRUE 0001h
KbdRDF	db 00h
KbdGSF	db 01h
KbdGFF 	db 02h
IndEnh 	db 0
CNumL	equ 20h
CCapl	equ 40h

WORKFUNCS		

ChecKbd		proc near

			push es
			push ax
			mov  ax,BiosDat
			mov  es,ax
			mov	 al,es:KbdFl3
			mov  IndEnh,al
			and  IndEnh,10h
			pop  ax
			pop	 es 
			ret
ChecKbd endp

GetFl12 proc near
		
		push    es 
		mov	    ax,BiosDat
		mov	    es,ax
		mov	    ah,es:KbdFl1
		mov	    al,es:KbdFl2
		pop		es
		ret

PutFl12	proc near

		push 	es
		push 	ax
		mov 	ax,BiosDat
		mov 	es,ax
		pop		ax
		mov 	es,ax
		pop 	ax
		mov 	es:KbdFl1,ah
		mov 	es:KbdFl2,al
		pop 	es
		ret

PutFl12 endp

		ENDWORK
		CLFunc 		log isKbdEnh
		CLcode
		mov 	ax,FALSE
		call 	ChecKbd
		cmp 	IndEnh,0
		je 		IsKbdEnhR
		mov 	ax,TRUE
		
IsKbdEnhR:
				
		CLret	ax
		CLFunc	log GnumLock
		Clcode
		mov 	dx,FALSE
		call	GetFl12
		test	ah,CNumL
		jz		GnumLock
		mov 	dx,TRUE
		
GnumLockr:
			
		CLret	dx
		CLFunc  log Gcapslock
		Clcode	
		mov 	dx,FALSE
		call	GetFl12
		test	ah,CCapl
		jz		GCapslockR
		mov		dx,TRUE
		
GCapslockR:
			
		CLret	dx
		CLFunc	log Snumlock <int SnLP>
		CLcode
		call	GetFl12
		and 	ah,not CNumL
		mov 	dx,SnLP
		cmp		dx,1
		jne 	SnumlockR
		or		ah,CNumL
		
SnumlockR: 

		call	PutFl12
		CLret	dx
		CLFunc 	log Scapslock<int SCplP>
		Clcode
		call 	GetFl12
		and 	ah,not Ccapl
		mov		dx,SCplP
		cmp 	dx,1
		jne 	SCapsLockR
		or		ah,CCapl
		
SCapsLockR
		 call PutFl12
		 Clret dx
		 
END		 