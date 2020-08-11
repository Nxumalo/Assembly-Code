.model small
.stack
.data
OutStr db 0Dh,0Dh,'<<<=== The text read: ===>>>.'0Dh,0Ah
StrBuf db 32767 dup (?)
StrBufE label byte 
.code
.startup
IsOpen:     mov bx,0
            mov cx,StrBufE-StrBuf-StrBuf
GetNext:    mov ah,3Fh
            lea dx,StrBuf
            int 21h
            jnc TstStr
            mov al,ah
            jmp ExProg
TstStr:     cmp ax,3
            jb  Compl
            mov di,ax
            mov StrBuf[di],'$'
            lea dx,OutStr
            mov ah,09
            int 21h
            jmp GetNext
Compl:      mov al,0
ExProg:     mov ah,4Ch
            int 21h
            end
            
