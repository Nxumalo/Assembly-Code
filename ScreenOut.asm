;.....................................................................................................................
; The external sub-program used are defined here:
; EXTERN VIDTYP : FAR, PUTSTR : FAR, WRCHAR : FAR
;---------------------------------------------------------------------------------------------------------------------
DATA SEGMENT
TEXTO DB 'Output screen (LOW LEVEL). Press and key ...',0
      .........
DATA  ENDS
;---------------------------------------------------------------------------------------------------------------------
CODE  SEGMENT 
      ASSUME   CS:CODE, DS:DATA
Start:      mov ax,DATA        ; data segement 
            mov ds,ax          ; basing
            ...........
;---------------------------------------------------------------------------------------------------------------------
; The external sub-program PUTSTR is called here
; The necessary parameters are passed through the common
registers.
           lea  si,TEXTO     ; DS:SI - address of beginning of text
           mov  ah,07h       ; attribute
           mov  cx,80        ; maximum length of string
           xor  dx,dx        ; beginning of screen output
           xor  bh,bh        ; video page number 0
           call PUTSTR       ; text string ouput
           xor  ah,ah        ; wait for a key to be pressed
           int  16h          ; read ASCII character into AL
            ..........
;---------------------------------------------------------------------------------------------------------------------
; Finish the work and exit to MS DOS.

Exit:      mov  ax,4COOh     ; return Code = 0
           int  21h          ; read ASCII character int AL
            ..........
CODE       ENDS
           END  Start
;---------------------------------------------------------------------------------------------------------------------
        
