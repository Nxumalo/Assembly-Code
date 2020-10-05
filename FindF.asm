.model small
.stack 
.data
DTA db 21 dup (?)					;first 21 byte reserved 
Attrib (db) ?						;========== File Attributes;
Time 	dw	?					; 01 - Read Only
Date 	dw 	?					; 02 - Hidden 
							; 04 - System
							; 08 - Volume Id
							; 10 - Directory 
							; 20 - Archive 
Time 	dw ?						; time of last modification
Date	dw ?						; date of last modification 
Fsize	dd	?					; size of file in bytes 
NameF	db	13 dup('')				; name of file 
		db 85 dup (?)				; not used but defined (up to 128 bytes)
FName	db 	80 dup(0)				; file name mask (ASCIZ string)

.code 
.startup
; === Accepting parameters (file mask)
			mov ah,51h			; function 51h - get PSP segment 
			int 21h				; DOS service call
			mov es,bx			; ES pintes to PSP
			mov bx,0			; BX will be used as index
			mov cl,es:[80h]			; length of parameter string into CX
			mov ch,0			; high part of parameter length = 0
			cmp cl,3			; parameter must be longer than 3chars 
			jb ExProg			; if paramter shorter, exit 
GetParm:	mov al,es:[bx+82h]			; get current character of parameter 
			cmp al,0Dh			; Carriage Return?
			jne TestCR			; if not - check for CR 
			mov al,0			; replace Carriage Return with NUL 
			jmp CopChar			; addd current character to string 
TestLF:		cmp al,0Ah				; Line Feed?
			jne CopChar			; if not, add current character 
			mov al,0			; replace Line Feed with NUL 			
CopChar:	mov FName[bx],al			; and copy it into data segment 
			inc bx				; increase character counter 
			loop GetParm			; get next character 
; === Set DTA for subsequent usage as a disk buffer 
			lea dx,DTA			; DS:DX contain address of DTA buffer 
			mov ah,1Ah			; function 1Ah - set DTA 
			int 21h				; DOS service call
; === Find first matching file 
			lea dx,FName			; file name mask 
			mov cx,3Fh			; file attribute mask 3Fh - any file
			mov ah,4Eh			; function 4Eh - Find First 
			int 21h				; DOS service call 
; === If search failed, exit from the program 
Next: 		jc ExProg				; file not found - exit 
; === Output file name onto the screen 
			mov byte ptr NameF[12],0Dh	;add LF symbol to file name 
			mov byte ptr NameF[13],0Ah	;add CR symbol to file name 
			mov byte ptr NameF[14],'$'	;add EndOfString symbol to file name 
			mov dx,offset NameF		; address of file name for outputting
			mov ah,09			; unction 09 - output string 
			int 21h				; DOS service call 
;- clear the string containing the file name (preparing next step)
			push cx				; save CX content (file mask)
			mov  cx,12			; set cycle counter to file name length 
			mov  bx,0			; prepare index
			
Clear: 		mov NameF[bx]				; clear next character 
			inc bx				; increase index (go to next character) 
			loop Clear			; perform cycle 
; === Find next matching file 
			pop cx				; restore file mask for DOS Service (CX)
			mov ah,4Fh			; function 4Fh - Find First
			int 21h				; DOS Service call 
; === Jump to Checking whether the searching was successful
			jmp Next			; process next file 
; === Final block: leave the program with the return code 0
 ExProg: 	mov ax,4C00h				; function 4Ch - terminate process 
			int 21h				; Dos service call 
			end
			
			  
