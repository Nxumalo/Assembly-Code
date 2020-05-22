.model small
.stack
.data
TitMsg db 'Program demonstrating how the Trap Flag '
       db 'works.',0Dh,0Ah,0Dh,0Ah,'$'
NotSet db 'Cannot set the Trap Flag - program works '
       db 'under debugger.',0Dh,)Ah,'$'
IsSet  db 'The trap flag is set successfully.Not active '
       db 'debugger found. '0Dh,OAh,'$'
.code
.startup
       lea dx,TitMsf
       mov ah,09
       int 21h
       pushf
       pop ax
       or ax,0100h
       push ax
       popf
       pushf
       pop ax
       and ax,0100h
       lea dx,IsSet
       cmp ax,0
       jne OutMsg
       lea dx,NotSet
OutMsg: mov ah,09
        int 21h
        pushf
        pop ax
        and ax,not 0100h
        push ax
        popf
        mov ax,4C00h
        int 21h
        end
  
