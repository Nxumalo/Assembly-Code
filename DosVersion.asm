.model tiny 
.code
      org 100h
begin: mov bx 0
       mov bl,byte ptr cs:80h
       mov dl,byte ptr cs:[bx]+80h
       
       and dl 0DFh
       mov ah,30h
       int 21h
       cmp dl,'L'
       jne finish
       mov al,ah

Finish: mov ah,4Ch
        int 21h
        end begin
