.model small 
.stack
.data
UnsWord dw 0
Hex dw 16
.code
.startup

NetCh: mov ah,01
       int 21h
       cmp a1,0
       jne Notspec
       int 21h
       jmp FinProg
       
NotSpec: cmp a1,'0'
         jb FinProg
         cmp a1,'9'
         jbe Procnum
         cmp a1,'A'
         jb FinProg
         cmp al,'F'
         ja FiniProg
         sub al,7
ProcNum:sub al,30h
        mov bl,al
        mov ax,UnsWord
        mul Hex
        mov UnsWord, ax
        add UnsWord,bx
        jmp NextCh
FinProg:mov ax,4C00h
        int 21h
        end
