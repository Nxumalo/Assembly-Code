.XLIST
InpInt macro Dest
      local Read, ExitMac, Number
      push cx
      push bx
      mov bx,0
      mov cx,0
      mov Dest, 0
Read:
      mov ah,1
      int 21h
      mov dl,al
      
      cmp al,'0'
      jl ExitMac
      cmp al,'9'
      jg Exitmac
      
Number: 
      mov ah,'0'
      sub al,'0'
      mov cx,ax
      mov ax,10
      mul bx
      add ax,cx
      mov bx,ax
      
      jmp Read
      
ExitMac:

      mov ax,bx
      pop bx
      pop cx
      mov Dest,ax
      endm
      
OutInt macro src
      local NextDiv, outSym
      push ax,
      push bx
      push cx
      push dx
      mov ax,Src
      mov bx, 10
      mov cx,0
      
NextDiv:
      mov dx,0
      div bx
      
      oush dx
      inc cx
      cmp ax,0
      jne NextDiv
      mov ax,200h
      
OutSym: pop  dx
        add  dl,'0'
        int  21h
        loop OutSym
        pop  dx
        pop cx
        pop bx
        pop ax
        endm

OutStr macro tpar
local  locpar,aftcon
       
       push ds
       push dx
       push ax
       ifndef tpar
       jmp aftcon

locpar db tpar
       db 0Dh,0Ah
       db '$'
       
aftcon:
       endif
       mov dx,cs
       mov ds,dx
       mov dx,offset cs:locpar
       
       mov ah,9
       int 21h
       pop ax
       pop dx
       pop ds
       endm
       
NewLine macro Num
       push ax
       push cx
       push dx
       mov ax, 200h
       mov dx,0Dh
       int 21H
       mov dx,0Ah
       int 21h
       pop dx
       pop cx
       pop ax
       endm

UpCase macro Letter
       local UpCase, Notlet
       cmp letter,'a'
       jkl NotLet
       cmp Letter,'z'
       jg NotLet
       
UpCase: and al, 0DFh
NotLet:
       endm
ToFlags macro prm
       pushf 
       pop prm
       endm
       
.List
.sall

        
      
    
