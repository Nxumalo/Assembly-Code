.model small 
.stack
.data
UnsWord dw 0
Hex dw 16
.code
.startup

NetCh: mov ah,01             ;function 01h - keyboard input
       int 21h               ;DOS service call
       cmp a1,0              ;special character?
       jne Notspec           ;if not - process character
       int 21h               ;read code of special character
       jmp FinProg           ;finish program 
       
NotSpec: cmp a1,'0'          ;compare character read to "0" (number?)
         jb FinProg          ;if not, don't process
         cmp a1,'9'          ;compare character read to "0" (number?)
         jbe Procnum         ;if numeric - process
         cmp a1,'A'          ;compare to "A" (hexa-decimal number?)
         jb FinProg          ;if not,dont process
         cmp al,'F'          ;compare to "F" (hex number?)
         ja FiniProg         ;if not,dont process
         sub al,7            ;prepare characters A - F for converting

ProcNum:sub al,30h           ;convert character to number
        mov bl,al            ;copy character read into BX
        mov ax,UnsWord       ;hex number into AX
        mul Hex              ;one hex position to the left
        mov UnsWord, ax      ;store result back into memory
        add UnsWord,bx       ;add current hex digit
        jmp NextCh           ;read next character

FinProg:mov ax,4C00h         ;function 4Ch - terminate process
        int 21h              ;DOS service call
        end
