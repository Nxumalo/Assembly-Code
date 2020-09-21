.model small
.code 
		org 100h			;this is needed for COM - files 
; === block 1 : get equipment information 
begin: 			;program starts here
			int 11h			;BIOS service - get equipment information 
			and al,30h		;emphasize bits 4,5 - display mode
			cmp al,30h		;bits 4 and 5 are set - monochrome
			je  mono		;process monochrome display 
; === block 2 : enable CGA cursor emulation 			
			mov ah,11h		;function 11h - character set service 
			mov al,0		;allow cursor emulation 
			mov bl,34h		;subfunction 34h - cursor emulation 
			int 10h			;BIOS video service 
			mov cx,0607h		;CGA cursor locates within lines 6 - 7 
			jmp SetCur
; === block 3 : set cursor parameters - monochrome mode 			
mono:		mov cx,0B0Dh			;MDA/HGC cursor: lines 13-14
; === block 4 : set cursor parameters - color mode 			
SetCur: 		mov ax,40h		;segment address of BIOS data area 	
			mov es,ax		;ES will point to the BIOS data area
			mov al,es:49h		;AL - current video mode for some BIOS 
			mov bh,es:62h		;BH contains number of active video page 
			mov ah,01h		;function 01 - set cursor type 
			int 10h			;BIOS video service call
; === block 5 : exit program 			
ExProg: 		mov ax,4C00h		;function 4Ch - terminate process exit code 0			
			int 21h			;DOS service call 
			end begin
