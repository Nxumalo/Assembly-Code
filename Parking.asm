.model tiny
.stack
.data
CR equ 00Dh
LF equ 00Ah
EscScan equ 001h
EndMsg	equ 024h
Ten 	db 10
StMsg	db CR,LF,LF,'The Hard Disk Parking utility 12/08/2020'
		db 'Version 1.4',CR,LF
		db 'Copyright (C) 1992 V.B. Maljugin, Voronezh,CR,LF,LF'
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
		
.code 
.startup

		org 100h
			
		mov cx,0
		mov es,cx
		mov cl,es:[475h]
		add Ndrives,cl
		
		lea dx,StMsg
		mov ah,09
		int 21h
		
ToNext: 
		add DrNum1,1
		add Drive,01h
		mov al,DrNum1
		cmp al,Ndrives
		jb ProcDrives
		jmp Finish 
		
ProcDrives: 
			mov ah,11h
			mov dl,Drive
			int 12h
			jnc DriveOK
			jmp ToNext
			
DriveOK:
			mov ah,08
			int 13h
			mov al,ch
			shl cx,1
			shl cx,1
			and ch,3
			mov ah,ch
			add ax,2
			cmp ax,1023
			jle le1023
			
			mov ax,1023
			
le1023L:
			mov LandZone,az
			mov ch,ah
			shr cx,1
			shr cx,1
			mov ch,al
			mov ah,0Ch
			mov dh,0
			mov dl,Drive
			int 13h
			
			lea dx,PrkMsg
			mov ah,09
			int 21h
			
			mov ax,LandZone
			mov cx,0
			
NexDiv:		div byte ptr Ten
			push ax
			mov ah,0
			inc cx
			cmp al,0
			jne NexDiv
			
			mov ah,02h
			
OutSym: 	pop dx
			mov dl,dh
			add dl,30h
			int 21h
			loop OutSym
			jmp ToNext
			
Finish: 
			lea dx FinMsg
			mov ah,09
			int 21h
			
WaitKey:
			mov ax,0
			int 16h
			cmp ah,EscScan
			jne WaitKey
			mov ax,4C00h
			int 21h
			end
		
		

		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
