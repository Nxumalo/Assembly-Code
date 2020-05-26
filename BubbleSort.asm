.model large
public bsort
MaxLen equ 48
.code
BSORT PROC FAR pascal uses bx cx dx es si di bp
                  cmp  cx,MaxLen
                  jng  ChkN
                  mov  ax,1
                  jmp  Exit 
ChKN:             cmp  dx,0
                  jg   Work
                  mov  ax,2
                  jmp  Exit
                  
Work:             mov  CS:SrtOrd,ax
                  cld
                  mov  CS:RecLen,cx
                  mov  CS:RecNum,dx
                  mov  CS:AddrArr,so
                  push ds
                  pop  es
                  
ExtLoop:          mov  CS:SWP,0
                  mov  ax,0
                  dec  CS:RecNum
                  jz   Exit
                  mov  dx,CS:RecNum
                  mov  bp,CS:AddrArr
                  mov  CS:BP0,bp
Ml:               mov  si,CS:BP0
                  mov  di,si
                  mov  cx,CS:RecLen
                  add  di,si
                  mov  cx,SrtOrd,0
                  jnz  Decrs
Incrs:            repe cmpsb
                  jbe  Swapped
                  jmp  short SWAP
Decrs:            repe cmpsb
                  jae  Swapped
SWAP:             mov  cx,CS:RecLen
                  mov  bp,CS:BPO
                  mov  bx,bp
                  add  bx,cx
SwBytes:          mov  al,DS:[BP]
                  xchg al,[bx]
                  mov  DS:[BP],al
                  inc  bp
                  inc  bx
                  loop SwBytes
                  mov  CS:SWP,1
Swapped:          mov  ax,CS:RecLen
                  add  CS:BP0,ax
                  dec  dx
                  jnz  Ml
                  cmp  CS:SWP,0
                  jnz  ExtLoop
                  mov  ax,0
Exit:             ret
Bsort    EndP

SrtOrd            DW  0
RecLen            DW  0
RecNum            DW  0
AddrArr           DW  0
BP0               DW  0
SWP               DB
                  END

                  
                  

                  
