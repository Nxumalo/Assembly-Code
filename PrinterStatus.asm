;............................................................................................
; DATA SEGMENT 
.data 
CR    EQU  13
LF    EQU  10
String   DB   "This is my string for Printer (INT 17h)", CR, LF
Lstr  EQU  $-String
;............................................................................................
; code segment 
;............................................................................................
.code 
.startup 
        mov cx,Lstr       ; length of string 
        xor dx,dx         ; DX = 0 stands for LPT1
        lea si,string     ; DS:SI - address of string

; Cycle to output one character

Cycle:  lodsb             ; next character into AL 
        mov ah,00h        ; function 00 - print character
        int 17h           ; BIOS printer service call
        loop Cycle        ; next repetition of cycle
        test ah,8         ; I/O Error? 
        jz   Exit         ; if not - exit 
        
; The code for error processing goes here
 
Error

.......

; Complete work and EXIT:

Exit: 

.......        
        
