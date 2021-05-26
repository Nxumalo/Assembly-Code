;.............................................................................
CR EQU 0Dh       ; CR
LF EQU 0Ah       ; LF
; Data Segment 
DATA SEGMENT
STR DB 'This is my Text !!!  ; text string
    DB CR,LF                 ; CR & LF
    DB "$"                   ; end of string 
DATA ENDS
;.............................................................................
; code segment
; output string from cursor position
    
    mov ax,DATA              ; segment address of DATA
    mov ds,ax 
    lea dx,STR               ; DS:DX - address of string
    mov ah,9                 ; function
    int 21h                  ; call MS-DOS service 
    end 
     
