.model tiny
.stack
.data
CR equ 00Dh				; Carriage return code 
LF equ 00Ah				; Line feed code 
EscScan equ 001h			; Scan code ESC key 
EndMsg	equ 024h			; Dollar sign - end of message for DOSservice
Ten 	db 10				; Constant to convert binary to string 
StMsg	db CR,LF,LF,'The Hard Disk Parking utility 12/08/2020'
		db 'Version 1.4',CR,LF
		db 'Copyright (C) 2020 3538264, Cape Town,CR,LF,LF'
Ndrives db '0'
		db 'hard disk drives (s) found',CR,LF,EndMsg
PrkMsg 	db CR,LF,'Heads of the hard disk Drive '
DrNum1 	db '/'
		db 'have been positioned at the cylinder ',EndMsg
FinMsg	db CR,LF,LF
		db 'Turn off power or press ESC key to return to DOS' 
		db CR,LF,LF,EndMsg
LandZone 	dw	0
Drive 		db 7Fh
HexTab 	db '0','1','2','3','4','5','6','7'
		db '8','9','A','B','C','D','E','F'
		
.code 						; The CODE segment stars here 
.startup					; This is a standard prologue 
		org 100h
; === Getting the number of drives installed 			
		mov cx,0			;Clear CX
		mov es,cx			;ES points to segment 0000h
		mov cl,es:[475h]		;Get number of drives from BIOS area 
		add Ndrives,cl			;Form text for number of drives 
; === Outputting the initial message 		
		lea dx,StMsg			;Address of message into DX
		mov ah,09			;Function 09h - output text string 
		int 21h				;Dos service call 
; === Checking whether there are drives to be processed 		
ToNext: 
		add DrNum1,1			;Text for message about parking 
		add Drive,01h			;Take the next disk drive 1 
		mov al,DrNum1			;Load current drive number (char)
		cmp al,Ndrives			;Compare it with the number of drives 
		jb ProcDrives			;If not all the drives - continue 
		jmp Finish 			;Otherwise proceed to the exiting 		
ProcDrives: 	; === Processing the current drive starts from here ===
; === Recalibrate the current drive 
			mov ah,11h		;Function 11h - recalibrate drive
			mov dl,Drive		;DL - drive number (80h for drive 1)
			int 13h			;BIOS disk service call
			jnc DriveOK		;If calibration successful - continue 
			jmp ToNext		;If failed, proceed to the next drive 
; === Getting the maxium number of cylinders 			
DriveOK:
			mov ah,08		;Function 08 - Get drive parameter 
			int 13h			;BIOS disk service 
			mov al,ch		;Low part of maxium cylinder number 
			shl cx,1		;Bits 7 of CL into bit 0 of CH
			shl cx,1		;Bits 6,7 of CL into bits 0,1 of CH 
			and ch,3		;Bits 0,1 of CH will be used
			mov ah,ch		;Form maximum number of cylinder 
			add ax,2		;One cylinder farher maximum 
			cmp ax,1023		;Is it above  1023?
			jle le1023		;If not - process this number 
; === Replace the number of cylinders greater than 1023 with 1023			
			mov ax,1023		;If it is so - replace it with 1023 
; === Prepare input parameters for positioning the heads 			
le1023:						;
			mov LandZone,az		;Store Landzone to be output 
			mov ch,ah		;CH - low byte of cylinder number,
			shr cx,1		;Shifts bits 0 and 1 of CH into 
			shr cx,1		;bits 6 and 7 of CL (high bits)
			mov ch,al		;Low bits of LandZone 
; === Positioning the heads 			
			mov ah,0Ch		;Function 0Ch - heads positioning 		
			mov dh,0		;Head number = 0
			mov dl,Drive		;Drive number (80h for drive 0 )
			int 13h			; BIOS disk service call 
; === Outputting the message "parked at ..."			
			lea dx,PrkMsg		;Address of message "parked" into DX
			mov ah,09		;Function 09h - output text string 
			int 21h			;Dos Service call 
; === Convert the number of landing cylinder into text for printing 			
			mov ax,LandZone		;Place number to be printed into AX.
			mov cx,0		;Initial value for counter of digits
NexDiv:		div byte ptr Ten		;Division the number by 10. Result in 
						;AL register and remainder in AH.
			push ax			;Push Remainder into stack.
			mov ah,0
			inc cx			;Increase counter 
			cmp al,0		;Check if result is zero 
			jne NexDiv		;If not, get the next digit 
; === Outputting the number of landing zone 			
			mov ah,02h		;Function 02h - output symbol 
OutSym: 	pop dx				;Pop next digit of result 
			mov dl,dh		;Cypher into DL for output 
			add dl,30h		;Convert it to character 
			int 21h			;Output it using DOS service 
			loop OutSym		;Proceed to the next digit 
			
			jmp ToNext		;Proceed to the next drive processing 
Finish: 
			lea dx FinMsg		;Address of Message into DX
			mov ah,09		;Function 09h - ouytput text string 
			int 21h			;DOS service call 
; === Waiting for a key pressed 					
WaitKey:
			mov ax,0		;Function 00h - read character from keyboard 
			int 16h			;BIOS keyboard service call 
			cmp ah,EscScan		;Is the ESC key pressed?
			jne WaitKey		;If not - Wait for next key pressing 
; === Exit to DOS if necessary			
			mov ax,4C00h		;Function 4Ch - terminate process
			int 21h			;DOS service call 
			end
		
