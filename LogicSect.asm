;............................................................................................
DATA SEGMENT 
BUFSEC DB 6*512 DB (0)
;............................................................................................
DATA ENDS
;............................................................................................
CODE     SEGMENT 
         mov    ax,DATA        ; base address
         mov    ds,ax          ; of data semgent 
         lea    bx,BUFSEC      ; DS:BX - input buffer
         mov    cx,6           ; number of sectors
         mov    dx,18          ; initial sector
         mov    al,4           ; logical drive E will be used
         int    25h            ; call MS-DOS disk service
         pop    cx             ; stack alignment 
         jc     error          ; error if carry flag = 1         
;............................................................................................
