.NoListMacro
.Sall

.model Small
IF1
include maclib.inc
Endif

.data
fir dw 0
sec dw 0
res dw 0
.stack
.code

Begin: mov ax, @Data
       mov ds,ax
       NewLine 
       OutStr ' Enter Number, sign, number, equals sign'
       OutStr ' To exit press Esc or Enter'
       NewLine 
       OutStr 'Example: 1951+41='
       NewLine 2
       
Next:  mov ax,0
       InpInt fir
       cmp d;,0Dh
       jne TstEsc

JmpFin: jmp Finish
TstEsc: cmp d1,1Bh
        je  JmpFin
        mov cl,dl
        
        InpInt sec
        mov ax,fir
        mov dx,0
        
TesMin: cmp cl,'-'
        jne TesMul
        jmp Minus
        
TesMulP: cmp cl,'*'
         jne TesDiv
         jmp Mult
         
TesDiv: cmp cl,'/'
        jne TesPl
        jmp Divide 
        
TesPl: cmp cl,'+'
       je Plus
       
Plus:  add ax,Sec
       jmp PrtRes
       
Minus: sub ax,Sec 
       jmp PrtRes
       
Multi: mul Sec
       jmp PrtRes
       
Divide: div Sec

PrtRes: mov res,ax
        OutInt res
        NewLine
        
        jmp Next
        
Finish: mov ax, 4C00h
        int 21h
        end Begin
