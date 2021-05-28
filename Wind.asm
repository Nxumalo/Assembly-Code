;..............................................................................
; toggle blink / intensity bit (for EGA, VGA ...)

      mov ah,10h       ; function
      mov al,3h        ; subfunction 
      xor bl,bl        ; intensity toggle 
      int 10h          ; call BIOS service 
 ;.............................................................................
 ; toggle blink/intensity bit (for CGA only)
 
 CGA: xor ax,ax        ;
      mov ax,ax        ;
      mov al,es:[465h] ; preceding mode
      or  al,10h       ; blink (bit 5 = 1)
      cmp ch,1         ; blinking?
      je  Out3D8       ;
      and al,0EFh      ; intensity (bit 5 = 0)
Out3D8: 
      mov dx,3D8h      ; working mode port address
      out dx,al        ; blinking mode change 
;.............................................................................
