;...........................................................................
BlankStr db 80 dup ('',17h)     ; Blank string (white on blue -17h);
;...........................................................................

        mov ax,0B800h      ;0B800h - address of video buffer (color)
        mov es,ax          ;ES points to video buffer
        mov cx,25          ;repeat 25 times for whole screen
RepOut:    mov di,0        ;ES:DI , effective address of video buffer start
        lea si,BlnkStr     ;DS:SI effective address of text to output
        Con10 dw,10  
        push cx            ;save strings counter
        mov cx,80          ;total length of string 
rep     mov sb             ;send string to video memory
        pop cx             ;restore stringd counter
        add es,Con10       ;increase effective address by 160
        loop RepOut
        mov ah,09h         ;function 09h - output character and attribute
        mov bh,0           ;video page 0 will be used
        mov cx,2000        ;2000 Characters (80*25)
        mov al,''          ;character to be output
        mov bl,17h         ;attribute (white on blue)
        int 10h            ;BIOS video service 
        
        end
