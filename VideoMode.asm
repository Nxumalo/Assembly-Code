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

        push es         ; save segment register
        mov ax,40h      ; segment of BIOS data
        mov es,ax       ; ES points to BIOS data 
; looking for EGA/VGA adapters 

EVGAVGA: 

        test byte ptr es:[87h],0      ; EGA or VGA not installed ? 
        jz MDA          ; test MDA
        test byte ptr es:[87h],08h    ; is EGA or VGA active ?
        jnz MDA         ; test MDA
        mov al,2        ; EGA or VGA is present
        jmp short Exit  ; return 
 ; looking for an MDA adapter 
 
 MDA:   mov ax,es:[10h] ; get equipment
        and al,30h      ; make bits 
        cmp al,30h      ; is MDA present?
        jne CGA         ; test CGA
        xor al,al       ; AL = 0 -MDA
        jmp short Exit  ; return 
CGA:    mov al,l  ; AL=1 -CGA    
CHCKEGA:  mov ah,12h     ; function 12h - 
          mov b1,10h     ; subfunction 10h - get EGA/VGA config
          int 10h        ; call BIOS video service    
exit:   pop es           ; restore segment register
;.............................................................................        
;.............................................................................
 
