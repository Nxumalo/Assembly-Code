;..............................................................................
DATA SEGMENT 
CLS DB  1Bh      ; ESC
    DB  '[K'     ; clearing to end of row 
    DB  '$'      ; end of string 
DATA ENDS
;..............................................................................
; Code Segment 
    mov ax,DATA   ; base address of data segment 
    mov ds,ax     ;
    lea dx,CLS    ; DS:DX - ESC string 
    mov ah,9      ; function 
    int 21h       ; MS-DOS service 
;..............................................................................

HORLINE PROC NEAR 
        xor  cx,cx         ; X - starting column for output (0)
 HOR1:  mov  ah,0Ch        ; function 0Ch - output pixel 
        mov  al,Col        ; put pixel color into AL
        mov  dx,Nstr       ; Y - line for output
        mov  bh,0          ; video page 0 is used 
        int  10h           ; BIOS video service 
        inc  cx            ; increase column counter
        cmp  cx,H_Leng     ; end of string?
        jl   HOR1          ; if,not output next pixel
        RETN               ; return to caller 
 HORLINE ENDP       
     
 

