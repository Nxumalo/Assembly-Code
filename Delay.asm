DELAY PROC NEAR 
      push es
      push dx
      push ax
      mov ax,40h        ; segment address of BIOS area
      mov ES,ax         ; ES points to BIOS DATA segment
      sti               ; enable interrrupts

TO:   mov dx,ES:[6Ch]   ; initial time (in ticks)
T1:   cmp dx,ES:[6Ch]   ; has time passed ?
      je  T1            ; no !!!
      loop T0           ;
      pop ax
      pop dx
      pop es
      RETN
DELAY ENDP      
       
