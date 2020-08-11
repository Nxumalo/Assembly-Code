.model small
.stack
.data
CR equ 0Dh
LF equ 0Ah
Msg16   db CR,LF,'BIOS service: Type a string and press Enter:'
        db CR,LF,'$'
Msg21   db CR,LF,'Dos service: Typer a string and press Enter:'
        db CR,LF,'$'
MsgOut  db 'The Following text entered: ' ,'$'
ReqInp  db 255
FactInp db 0
Str1    db 256 dup('$')
.code 
.startup
            mov ah,09
            lea dx,Msg16
            int 21h
            mov bx,0

Next16:     mov ah,0
            int 16h
            cmp al 0
            je  Next16
            mov Str1[bx],al
            inc bx
            cmp al,CR
            jne Next16
            
            mov Str1[bx],LF
            mov Str1[bx+1],'$'
            
            mov ah,09
            lea dx,Str1
            int 21h
            
            mov ah,09
            lea dx,Msg21
            int 21h
            
            mov ah,0Ah
            lea dx,ReqInp
            int 21h
            
            mov bl,FactInp
            mov bh,0
            mov Str1[bx],CR
            mov Str1[bx+1],LF
            mov Str1[bx+2],'$'
            
            mov ah,09
            lea dx,MsgOut
            int 21h
            lea dx,Str1
            int 21h
.exit
end
            
            
           
