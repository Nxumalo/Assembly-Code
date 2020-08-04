.model small
.stack
.data 
tbint   db 16 dup ('xx-X'), '$'
HexSym  db '0','1','2','3','4','5','6','7'
        db '8','9','A','B','C','D','E','F'
NumInt  db 0
NumIntL db 0 
.code 
        mov ax,@data
        mov ds, ax,
        mov cx,'16'
Rows:   
        push cx
        mov di,0 
        mov cx,16
        mov al,NumInt
        mov NumIntL,al
        
Intrs:
        
        mov al,NumintL
        mov ah,35h
        int 21h
        mov dx,es
        cmp dx,0A000h
        ja InBios
        mov tbint[di+3],'D'
        jmp DoneInd

InBios: mov tbint[di+3],'B'
DoneInd:
        cmp byte ptr es:[bx],0CFh
        jne PresHan
        mov tbint[di+3],'N'
        
PresHan: 
        mov ah,0
        mov dl,16
        div dl
        
        mov bx,offset HexSym
        xlat
        mov byte ptr tbint[di],al
        mov al,ah
        xlat
        mov byte ptr tbint[di+l],al
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
