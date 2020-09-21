.model small
.code
		org 100h
begin:
; === read number of active video page from BIOS data area

		mov ax,0		;clear AX
		mov es,ax		;prepare ES for accessing BIOS data area
		mov bh,es:[462h]	;active video page into BH for next calls 
; === get parameters of cursor on active video page
		mov ah,03h		;function 03h - get cursor parameters
		int 10h			;BIOS video service
; === turn off cursor on active video page 
		mov ah,01h		;function 01h - set cursor parameters 
		or  ch,30h		;set bits 4 and 5 of CH regiseter to 1
		int 10h			;BIOS video service call 
; === exit program 
		mov ax,4C00h		;function 4Ch - terminate process ; exit code
		int 21h			;DOS service call 
		end begin
