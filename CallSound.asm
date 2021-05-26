;..........................................................................................
; Permission of channel 2, port B (8255) is programming for this 
purpose 
       in al,61h        ; read current setting of Port B
       jmp $+2          ; short delay
       or al,03h        ; set necessary bits
       out 61h,al       ; permission of speaker 

; Setting registers of channel 2 (8253)
     
       mov al,0B6h      ; necessary mode 
       out 43h,al       ; write into command register
       
;Evaluation of necessary delat,frequency for this is 1.193 Mhz
; is divided by the necessary frequency 1000 hz. Result = 1193

       mov ax,1193      ; evaluated delay
       out 42h, al      ; write lower byte 
       mov al, ah       ; value of higher byte 
       out 42h, al      ; write higher byte 
       
; Speaker generates sounds of 1000 hertz until key pressed 

       xor ah,ah        ; wait for pressing of any key 
       int 16h          ; Call BIOS Service 
       
; Switching sound off, bite 0, 1 of Port B are cleared for this

purpose 
       in al,61h        ; read current setting of Port B
       jmp $+2          ; short delay
       and al, 0FDh     ; clear necessary bits 
       out 61h,al       ; switch speaker off
;............................................................................................................
       
