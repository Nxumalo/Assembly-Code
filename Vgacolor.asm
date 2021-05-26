;........................................................................
; Output of "E" characters in first row.
        mov ax,0B800h     ; video buffer segment address
        mov es,ax         ; ES points to video buffer
        xor di,di         ; output from the beginning of screen
        mov ah,1Eh        ; attribute (yellow on blue)
        mov al,"E"        ; character to be written
        mov cx,80         ; quantity of repetitions
        cld               ; direction - forward !!!
        rep stosw         ; ES:[DI] - output character
;........................................................................        
