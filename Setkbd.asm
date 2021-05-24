.model tiny
.code
		mov ax,0305h         A - function 03, AL - subfunction 05
		mov bx,0             ;BH - delay (0 - 3), 0 for smallest
		                     ;BL - rate (0 - 1Fh, 0 for fastest)
		int 16h              ;BIOS interrupt - keyboard services
		mov ax4C00h          ;4C - terminate process, 00 - return code
		int 21h              ;DOS service call
		end
		
