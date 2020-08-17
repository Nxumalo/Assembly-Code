PUBLIC SOUND
CODE SEGEMENT
    ASSUME CS:CODE
SOUND PROC FAR
      push ax
      push cx
      push dx
      push ds
      push es
      push si
      
      in al,61h
      mov cl,al
      or al,3
      out 61h
      mov al,0B6h
      out 43h,al
      mov dx,14h
      mov ax,4F38h
      div di
      out 42h,al
      mov al,ah
      out 42h,al
      
      mov ax,91
      mul bx
      mov bx,500
      div bx
      mov bx,ax
      mov ah,0
      int 1Ah
      add dx,bx
      mov bx,dx
      
Cycle: int 1Ah
       cmp dx,bx
       jne Cycle
       in al,61h
       mov al,cl
       and al,0FCh
       out 61h,al
       
Exit:  pop si
       pop es
       pop ds
       pop dx
       pop cx
       pop ax
       RETF
        
SOUND  ENDP
CODE ENDS
     END
      
      
