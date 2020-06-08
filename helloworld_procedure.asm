.model small
.code
main proc
     mov ax,@data
     mov ds,ax
     lea dx,Hello
     call Display_Dx
     mov ah,4ch
     mov al,00h
     int 21h
     
Display_Dx Proc
         Ret
Display_Dx ENDP

Main ENDP

.Data

Hello DB 'Hello! Neo :--:. $'

.Stack
      DB 128 Dup (?)
       
      END Main 
      
