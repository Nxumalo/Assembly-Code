.model tiny
.stack
.data
Msg db 'This is a very simple assembly code created by Fraizer Nxumalo'
    db 'program' ,0Ah,0Dh,'$'
.code
.startup

Begin: mov ah,09
       lea dx,Msg
       int 21h
Finish: mov ax, 4C00h
        int 21h
        end
