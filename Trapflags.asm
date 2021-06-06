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
       lea dx,TitMsf        ;address of initial message
       mov ah,09            ;function 09 - output text string
       int 21h              ;Dos service call
       pushf                ;push original flags
       pop ax               ;copy original glags into AX
       or ax,0100h          ;set bit 8 - Trap flag
       push ax              ;push flags value to be set
       popf                 ;pop flags value to be set
       pushf                ;push new flags value 
       pop ax               ;copy new flags into AX
       and ax,0100h         ;separate bit 8 - highlight TF
       lea dx,IsSet         ; Address of message "TF os set"
       cmp ax,0             ; is bit 8 clear?
       jne OutMsg           ; is not ,putput message
       lea dx,NotSet        ;address of message "cannot set TF"

OutMsg: mov ah,09           ;function 09 - output text string           
        int 21h             ;Dos service call
        pushf               ;push original flags
        pop ax              ;copy original flag into AX
        and ax,not 0100h    ;clear bit 8 - Trap flag
        push ax             ;push flags value to be set
        popf                ;pop flags with TF clear
        mov ax,4C00h        ;function 4Ch - terminate process 
        int 21h             ;Dos service call
        end
  
