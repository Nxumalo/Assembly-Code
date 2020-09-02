.XLIST
;           Macro Definition
;__________________________________________________________
;
InpInt macro Dest
      local Read, ExitMac, Number
      push cx
      push bx
      mov bx,0
      mov cx,0
      mov Dest, 0
Read:
      mov ah,1              ;Prepare Dos Service Call - function 1
      int 21h               ;Dos Service 01 - gget symbol with echo
      mov dl,al             ;Save symbol to proceeding 
;
;     Check if symbol is a number 0 ... 9
;
      cmp al,'0'            ;Compare symbol in AL and ASCII code "0"
      jl ExitMac            ;If symbol is less than "0" it is no number 
      cmp al,'9'            ;Compare symbole is AL and ASCII code "9"
      jg Exitmac            ;If symbole is greater than "9" it is no number 
                            ;=== Leave macro
Number:                     ;
      mov ah,'0'
      sub al,'0'            ;Convert symbol in AL into number 
      mov cx,ax             ;Save this number into CL
      mov ax,10             ;Prepare to calculate the result 
      mul bx                ;AX = BX * 10
      add ax,cx             ;AX = (BX*10)+AX
      mov bx,ax             ;Save the current result 
      
      jmp Read              ;Read next symbol 
      
ExitMac:
      mov ax,bx             ;Save result into AX register   
      pop bx                ;Restore BX (work register)
      pop cx                ;Restore CX (work register)
      mov Dest,ax           ;Put result into 
      endm
                             ;
OutInt macro src              
      local NextDiv, outSym
      push ax,
      push bx
      push cx
      push dx
      mov ax,Src
      mov bx, 10              ;Place number to be printed into AX.
      mov cx,0                ;Place number '10'(divider) into DI 
      
NextDiv:
      mov dx,0
      div bx                  ;Divide command. After this reusklt is in 
                              ;Al register and remainder in AH.
      oush dx                 ;Push Remainder into stack.
      inc cx                  ;Increase counter 
      cmp ax,0                ;Check if result is zero and 
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
local  locpar,aftcon          ;These labels are internal 

;     Attehntion! That's really wonderful
;     If you replace the name "locpar" with 
;     name "par", MASM 5.0 will put the message 
;     "Error between phases".
       
       push ds                ;save
       push dx                ;the
       push ax                ;registers
;    
;      This locates parameter texit in memory     
;       
       ifndef tpar            ;Check whether parameter
                              ;is present 
       jmp aftcon             ;Avoid to execute constants

locpar db tpar                ;Text string into memory
       db 0Dh,0Ah             ;Line feed, carriage return
       db '$'                 ;This is needed for DOS
       
aftcon:
       endif
       mov dx,cs
       mov ds,dx
       mov dx,offset cs:locpar
       
       mov ah,9               ;Service 09 - put string 
       int 21h                ;DOS service call
       pop ax                 ;Restore 
       pop dx                 ;the 
       pop ds                 ;registers
       endm
       
NewLine macro Num
       push ax
       push cx
       push dx
       mov ax, 200h
       mov dx,0Dh             ;output CR
       int 21H
       mov dx,0Ah             ;output LF
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
       
UpCase: and al, 0DFh           ;Force upper case
NotLet:
       endm
ToFlags macro prm
       pushf 
       pop prm
       endm
       
.List
.sall

        
      
    
