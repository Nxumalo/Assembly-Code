.model small
IntSeg segment at 0
IntVec dw 512 dup(?)
IntSeg ends
.stack
.data
tbint db 16 dup('xx-X '),'$'
HexSym db  '0','1','2','3','4','5','6','7'
       db  '8','9','A','B','C','D','E','F'
NumInt db 0
NumIntL db 0
.code
      assume es:IntSeg
      mov ax,@Data 
      mov ds,dx
      mov ax,IntSeg
      mov es,ax
      
      mov cx,16

Rows: 
      push cx
      mov di,0
      mov cx,16
      mov al,NumInt
      mov NumIntL,al

Intrs:
      mov bh,0
      mov al,NumintL
      mov bl,al
      shl bx,1
      sh1 bx,1
      mov dx,IntVec[bx+2]
      cmp dx,0A000h
      ja  InBios
      mov tbint[di+3],'D'
      jmp doneind
      
InBios: mov tbint[di+3]
DoneInd: 

       cmp byte es:[bx],0CFh
       jne PresHan
       mov tbint[di+3]
       
PresHan: 
        mov ah,0
        mov dl,16
        div dl
        
        mov bx,offset HexSym
        xlat
        mov byte ptr tbint [di],al
        mov al,ah
        xlat
        mov byte ptr tbint[di+1],al
        
        add di,5
        add NumIntL,16
        loop Intrs
        pop cx
        mov ah,09
        mov dx,offset tbint 
        int 21h
        inc NumInt
        loop Rows
        mov ax,4C00h
        int 21h
        end
