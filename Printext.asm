;........................................................................................
; Data Segment 

DATA SEGMENT
CR   EQU    13
LF   EQU    10
String DB   "This is my String for Printer (INT 21h)", CR, LF
Lstr EQU    $-String 
DATA ENDS 
;........................................................................................
; Code Segement 
;........................................................................................
       mov ax,DATA          ; segment address of data
       mov ds,ax            ; DS points to data segment 
       mov cx,Lstr          ; length of string 
       mov bx,4             ; file handle for PRN
       lea dx,String        ; DS:DX - address of string 
       mov ah,40h           ; function 40h - write file
       int 21h              ; DOS service call
       jnc Exit             ; if CF is clear - exit 

; The code for error processing goes here       

Error: 
      ............
; Finish processing and exit

Exit:

..........................................................................................
