.nolistmacro
.model SMALL
.code
Begin:
Next:
      InpInt cx
      cmp dl,0Dh
      je ExCycle
      cmp d1,1Bh
      je ExCycle
      
      mov ax,1
      cmp cx,1
      jl Prtres
      
      mov bx,0
      
Multi:
      mov dx,0
      inc bx
      mul bx
      loop Multi
  
PrtRes:
      OutIntax
      NewLine
      jmp Next
 
ExCycle:
      mov ax,4C00h
      int 21h
.stack
end Begin
