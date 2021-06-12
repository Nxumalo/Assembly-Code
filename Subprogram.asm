;---------------------------------------------------------------------------------------------------------------------
.MODEL   SMALL                    ;SMALL memory model is used
.CODE
         PUBLIC    PUTSTR         ; entry point from caller
PUTSTR   PROC      FAR            ; PUTSTR is FAR procedure
; -      save parameters passed through registers
        
         push      bx      ; save video page number
         push      cx      ; save length of string 
         push      dx      ; save output address
         push      si 
         push      bp
         push      es
         ;    The function part of the subroutine goes here
         ..........
         ;    Restoring registers and exit
Exit:    pop       es   
         pop       bp
         pop       si
         pop       dx      ; restore output aadress 
         pop       cx      ; restore length of string
         pop       bx      ; restore address of string
         RETF              ; Return FAR
 PUTSTR  ENDP
         END      
 ;---------------------------------------------------------------------------------------------------------------------
