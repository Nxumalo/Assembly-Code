.model small
.stack
.data
TextStr db 'Hello World!'
.code 
.startup
        mov ah,40h      ; function 40h - write file with handle
        mov bx,1        ; 1 - value of handle for screen
        mov cx,11       ; length of string for output into CX
        lea dx,TextStr  ; DS-DX - address of strig to be output
        int 21h         ; DOS service call
        
        mov ax,4COOh    ; function 4Ch - terminate process
        int 21h         ; DOS service call
        end 
