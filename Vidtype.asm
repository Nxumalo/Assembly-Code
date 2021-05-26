;Check whether EGA/VGA adapter is installed 
      Call VIDTYP     ; call subroutine for determing adapter 
      cmp al,3        ; EGA or higher?
      jnl Graph       ; OK - continue 
      lea dx,TEXT1    ; DX - address of message 
      mov ah,9        ; function 09h - output text string
      int 21h         ; DOS service call 
      xor ah,ah       ; function 0 - read a key
      int 16h         ; BIOS keyboard service
      jmp ExProg      ; to finish program
