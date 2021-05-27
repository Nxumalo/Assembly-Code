;..........................................................................................
; outputting "E" characters into first row 
   
     call VIDTYP      ; DX - segment address of video buffer
     mov bl,al        ; AL = 1 - CGA video adapter 
     mov es,dx        ; ES points to target segment
     xor di,di        ; output from start of screen 
     mov cx,80        ; quantity of symbols 
     cld              ; direction - forward !!!

; outer loop for sending 80 symbols to first row
; testing type of video adapter, is it CGA 

cycle0:
     cmp bl,1         ; is it CGA?
     jne WrChar       ; no, it's safe to write
     mov dx,3DAh      ; status register 

; waiting for completion of current retrace

cycle1:
     in    al,dx        ; reading status register
     test  al,1         ; is retrace being executed now ?
     jnz   cycle1       ; yes, wait for end 
       
; testing, is writing without snow possible?

cycle2:
     in    al,dx        ; read status register
     test  al,1         ; is retrace being executed now?
     jz    cycle2       ; no, continue testing 

; writing character and it's attribute into video buffer

WrChar:
      mov ah,1Eh        ; attribute (yellow on blue)
      mov a1,"E"        ; character to output
      stosw             ; ES:[DI] - output charactee
      loop cycle0       ; come to start loop
      

