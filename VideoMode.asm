;..............................................................................
DATA SEGMENT
VMODE DB 1Bh            ; code of ESC character 
      DB '[='           ; operation code
      DB 07h            ; video mode required
      DB '$'            ; end of string 
 DATA ENDS     
 ;.............................................................................
 ; set monochrome video mode
 begin: mov ax,DATA     ; address of DATA segment 
        mov ds,ax       ; set segment register
        mov ah,9        ; function 09h - output text string 
        lea dx,VMODE    ; DS:DX - address of string 
        int 21h         ; DOS service call
        
       
 ;.............................................................................    
