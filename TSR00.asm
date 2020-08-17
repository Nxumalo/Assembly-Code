CODE SEGEMENT 
OLD09H LABEL DWORD
0FF09G DW 0
SEG09H DW 0

PRES DW 1234

INT09H PROC FAR
       cli
       PUSHR
       mov ax,40h
       mov ES,ax
       mov ch ES:[17h]
       in al,60h
       
       and ch,01h
       
       cmp ch,01h
       jne RET09
            
RET09: pushf
       Call CS:OLD09H
       POPR
       IRET
       
INT09H  ENDP

INSTALL:

Modvec:
      cli
      mov ax,3509h
      int 21h
      mov CS:OFF09H,bx
      mov CS:SEG09H,es
      lea dx,INT09H
      mov ax,2509h
      int 21h
      sti
      
