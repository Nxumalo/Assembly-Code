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
KbdRDF	db 00h			;Read Character function number
KbdGSF	db 01h			;Get Status function number 
KbdGFF 	db 02h			;Get flag function number
IndEnh 	db 0
CNumL	equ 20h
CCapl	equ 40h

WORKFUNCS		

ChecKbd		proc near
;
;This procedure checks if an enhanced keyboard is being used 
;All registers are preserved after returning from the procedure.
;Result: The variable IndEnh (byte) is non-zero 
;
			push es				;Save the segment register 
			push ax				;Save tje accumulator register
			mov  ax,BiosDat			;Address of BIOS data segment 
			mov  es,ax			;Now ES points to the BIOS data
			mov	 al,es:KbdFl3		;Take the KEYBOARD FLAG  3 ([0496h])
			mov  IndEnh,al			;Store it into the memory 
			and  IndEnh,10h			;Bit 5 - sign of enhanced keyboard 
			pop  ax				;Restore the accumulator 
			pop  es 			;Restore the segment register 
			ret				;Return to the caller 
ChecKbd endp

GetFl12 proc near
;
; This procedure extracts the keyboard flgas 1 and 2 
; (bytes 0040:0017h and 0040:0018hh) from the BIOS data area and 
; puts them into AX register (AH-flag 1 , AL-flag 2).
; All registers except AX - registers are preserved after returning 
; from the procedure 
;
		push    es 				;Save the segment register
		mov	ax,BiosDat			;Address of BIOS data segment
		mov	es,ax				;Now ES points to the BIOS data
		mov     ah,es:KbdFl1			;Take KEYBOARD FLAG 1 ([00040:0017h])
		mov     al,es:KbdFl2			;Take KEYBOARD FLAG 2 ([00040:0018hh])
		pop	es				;Restore the segment register
		ret					;Return to the caller 

PutFl12	proc near
;
;This procedure writes the values from the AX register
;(AH - flag 1, AL - flag 2) into the keyboard flags 1 and 2 
;(bytes 0040:0017h and 0040:0018hh) in the BIOS data area
;All registers preserved after return from this procedure
		push 	es				;Save the segments register
		push 	ax				;Save the work register
		mov 	ax,BiosDat			;Address of BIOS data segment 
		mov 	es,ax				;Now ES points to the BIOS data
		pop	ax				;Restore the work register
		mov 	es:KbdFl1,ah			;Put KEYBOARD FLAG 1 ([0040:0017h])
		mov 	es:KbdFl2,al			;Put KEYBOARD FLAG 2 ([0040:0018hh])
		pop 	es				;Restore the segment register
		ret					;Return to the caller

PutFl12 endp

		ENDWORK
		
		CLFunc 	log isKbdEnh
		CLcode
		mov 	ax,FALSE			;Set the keyboard type to STANDARD
		call 	ChecKbd				
		cmp 	IndEnh,0			;Is enhanced keyboard present?
		je 	IsKbdEnhR			;If not - return
		mov 	ax,TRUE				;Set the keyboard type to ENHANCED
		
IsKbdEnhR:		
		CLret	ax				;AX contains the value to be returned
		CLFunc	log GnumLock
		Clcode
		mov 	dx,FALSE			;Set the Numlock indicator to OFF 
		call	GetFl12				;Get the Keyboard Flags
		test	ah,CNumL			;Is the NumLock state on? (bit 5)
		jz      GnumLockr			;If not - return 
		mov 	dx,TRUE				;Set the NumLock indicator to ON
		
GnumLockr:
			
		CLret	dx				;DX contains the value to be returned 
		CLFunc  log Gcapslock
		Clcode	
		mov 	dx,FALSE			;Set the CapsLock indicator to OFF
		call	GetFl12				;Get the Keyboard flags
		test	ah,Ccapl			;Is the CapsLock state on? (bit 6)
		jz	GCapslockR			;If not - return 
		mov	dx,TRUE				;Set the CapsLock indicator to ON
		
GCapslockR:
			
		CLret	dx				;DX contains the value to be returned
		
		CLFunc	log Snumlock <int SnLP>
		CLcode
		
		call	GetFl12				;Get the Keyboard Flags
		and 	ah,not CNumL			;Clear the Numlock state (bit 5)
		mov 	dx,SnLP				;Copy the parameter to return value
		cmp	dx,1				;Is it request for setting?
		jne 	SnumlockR			;If not - return 
		or      ah,CNumL			;Set the NumLock state (bit 5)
		
SnumlockR: 

		call	PutFl12				;Write the Keyboard Flags
		CLret	dx				;DX contains the value to be returned 	
		CLFunc 	log Scapslock<int SCplP>
		Clcode
		call 	GetFl12				;Get the Keyboard Flags
		and 	ah,not Ccapl			;Clear the CapsLock state (bit 6)
		mov	dx,SCplP			;Copy the parameter to returned value
		cmp 	dx,1				;Is it request for setting?
		jne 	SCapsLockR			;If not - return 
		or	ah,CCapl			;Set the CapsLock state (bit 6)
		
SCapsLockR
		 call PutFl12				;Write the Keyboard Flags
		 Clret dx				;DX contains the value to be returned
		 
END		 
