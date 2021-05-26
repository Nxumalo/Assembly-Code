;..............................................................................................,...
; data segment 
DATA SEGMENT 
CR EQU 13
LF EQU 10 
String DB 'This is my String for the Printer (INT 21h) ", CR,LF
Lstr EQU $-String 
DATA ENDS 
;..................................................................................................
; code segment 
;..................................................................................................
       mov ax,DATA       ; address of data segment 
       mov ds,ax         ; DS - points to data segment 
       mov cx,Lstr       ; length of string in counter 
       lea bx,String     ; DS : BX - address of string
       mov ah,05h        ; function 05h - character print
PrtStr: mov dl,[bx]       ; take character to print
        int 21h           ; MS-DOS service call
        inc bx            ; advance counter
        loop PrtStr       ; to print next character
code ENDS
     END BEGIN
