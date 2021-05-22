TITLE Hello ; https://www.silentcode.za
.model small      ;This model permits  the use of one physical segment only
.stack 1024       ;stack area occupies 1024 bytes
.data
;.......... Physical Address 
.code 
     org 100h
.startup
Start:  jmp Begin
        mov ax,4C00h    ;function 4Ch - terminate process
        int 21h         ;DOS service call
        end start
Begin:  mov ax,4C00h    ;function 4Ch - terminate process
        int 21h         ;DOS service call
        end start
.exit                   ;this finishes the program with the return code 0
.end
        
        
     
        
    
