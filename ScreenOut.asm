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
