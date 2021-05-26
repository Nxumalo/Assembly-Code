;Selection of the active video page 
      
       mov ah,5      ; Function 05h - Selectio Video Page 
       mov al,2      ; Number of page selected 
       int 10h       ; BIOS video service
       
;Selection of the active video page        

       mov ax,40h    ;Segment of BIOS data area
       mov es,ax     ;ES points to start of BIOS data
       mov al,2      ;Number of active video page
       cdw           ;AX - Page Number
       mov cl,12     ;Number of bits for shift into CL
       shl ax,cl     ;Shift to left: Page * 4096
       mov es:[4Eh],ax   ;Set new active video page 
       
