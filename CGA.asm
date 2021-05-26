;...............................................................................
; switching CGA-screen off before writing into video buffer
; current mode value locates at address 0: [465h]
      
      xor ax,ax      ;segment address of BIOS data area
      mov es,ax      ;ES become 0
      mov al,es:[465h]      ;current mode value
      mov bl,al      ; saving current mode value
      mov dx,3D8h    ; mode register
      and al,0F7h    ; switch video signal off
      out dx,al      ; switch display off

; outputting "E" symbols from start of screen
      
      mov ax,0B800h  ; video buffer segment address
      mov es,ax      ; ES points to video buffer
      xor di,di      ; output from start of screen
      mov ah,1Eh     ; attribute (yellow on blue)
      mov al,"E"     ; symbol to output
      mov cx,80      ; quantity of symbols to output
      cld            ; direction - forward !!!
      rep stosw      ; ES:[DI] -output character
 
 ;switching on screen after writing into video buffer
 
      mov dx,3D8h    ; mode register
      mov al,bl      ; switch video signal on 
      out dx,al      ; switch display on
