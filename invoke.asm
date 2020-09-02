.model small
.stack
.data
Msg1 db 'Message1',0Dh,0Ah,'$'
Msg2 db 'Message2',0Dh,0Ah,'$'
.code
ProcOut proc near PASCAL, MsgAddr:ptr byte
        mov  dx,MsgAddr     ;take address of parameter
        mov  ah,09h
        int 21h
        ret
ProcOut endp
.startup
        invoke ProcOut,addr Msg1
        invoke ProcOut,addr Msg2
.exit   0
end 
