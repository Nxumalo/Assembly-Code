;
;this program outputs ASCII character table onto screen 
;character set currently loaded while be shown
;
.model small
.stack
.data
CR equ 00Dh			;carriage return code 
LF equ 00Ah			;line feed code
Con16 db 16			;integer constant 16 
EndMsg equ 024h			;"dollar" sign - end of message
StMsg db CR,LF,LF
		db 'screen font shoow utility 14 Jun 82 version 1.2',CR,LF
		db 'copyright (C) 2020 3538264,Cape Town,CIS',CR,LF
CrLf	db CR,LF,EndMsg
Pattern db 'xx-',EndMsg
HexSym 	db '0','1','2','3','4','5','6','7'
		db '8','9','A','B','C','D','E','F'
CodSym 	db 0

.code 			;CODE segment starts here
.startup		;standard prologue (MASM 6)
			mov ax,40h			;segment address of BIOS data area 
			mov es,ax			;ES will point to BIOS data 
			lea dx,StMsg			;address of message into DX
			mov ag,09			;function 09h - output text string 
			int 21h				;DOS service call 
			mov cx,16			;number of lines in table 
; === enclosing cycle starts here 			
PrtTable:
			push cx				;save enclosing cycle counter 
; === nested cycle - output 16 columns in current row 			
			mov cx,16			;set counter for nested cycle
rows:
			push cx				;save outward counter 
			mov al,CodSym
; === convert code of current character code into two hex digits 			
ToHex:			;
			mov ah,0			;character code (0 - 0FFh) in AX
			div Con16			;low digit into AL,high - into AH
			mov bx,offset HexSym		;offset of hext symbols table 
			xlat				;convert AL to character 
			mov byte ptr Pattern,al		;and place it into output line 
			mov al,ah			;place high digit into AL 
			xlat				;convert AL to character 
			mov byte ptr Pattern[1],al	;and place it into output line 
; === Output hexadecimal representation of character (DOS Service)
			mov ah,09			;function 09 - output string 
			lea dx,Pattern			;address of text to be output 
			int 21h				;DOS service call
			
			mov bh,es:[62h]			;number of active video page 
			mov bl,0			;color in some graphics modes 
			mov ah,0Ah			;function 0Ah - output symbol [
			mov al,CodSym			;AL - symbol to be output 
			mov cx,1			;CX - repeat counter 
			int 10h				;BIOS video service 
; === prepare for output next column 			
			mov ah,03			;function 03h - get cursor location 
			int 10h				;BIOS video service 
			mov ah,02			;function 02h - set cursor location 
			add dl,2			;new location - 2 places to right 
			int 10h				;BIOS video service 
			pop cx				;restore counter of nested cycle 
			add CodSym,16			;code for character in next column 
			loop Rows			; === end of nexted cycle body 
; === enclosed cucle contines from here 
			lea dx,CrLf			;address of message into DX
			mov ah,09h			;function 09h - output text string 
			int 21h				;DOS service call
			pop cx				;restore counter of enclosed cycle 
			inc CodSym			;code for first character in next line 
			
	EndMain: lo
