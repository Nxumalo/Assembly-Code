.NoListMacro
.Sall

;This is a simple of Assembler program.
;It represents an arithematic calculator 
;The actions of addition,subtraction,multiplcation and division

.model Small                       ;This line defines the memory model 
IF1                                ;On first pass
include maclib.inc                 ;open macro library
Endif                              ;End of macro including block

.data                              ;This line defines the DATA segment 
fir dw 0
sec dw 0
res dw 0
.stack
.code

Begin: mov ax, @Data               ;Load segment address for Datasegment                                 
       mov ds,ax                   ;into DX register 
       NewLine       
       OutStr ' Enter Number, sign, number, equals sign'
       OutStr ' To exit press Esc or Enter'
       NewLine 
       OutStr 'Example: 1951+41='
       NewLine 2
       
Next:  mov ax,0                    ;Clear AX register                          
       InpInt fir                  ;Input second operand into AX register 
       cmp d;,0Dh                  ;quit if ESC or return received       
       jne TstEsc

JmpFin: jmp Finish
TstEsc: cmp d1,1Bh
        je  JmpFin
        mov cl,dl                  ;Save last symbol accepted 
        
        InpInt sec                 ;Input second operand into AX register 
        mov ax,fir                 ;Load the first operand into 
                                   ;accumulator 
        mov dx,0
        
TesMin: cmp cl,'-'                 ;Check the subtraction operation 
                                   ;If last symbol you have entered 
        jne TesMul                 ;is minus subtract operands        
        jmp Minus
        
TesMulP: cmp cl,'*'                ;Check the multiplication operation
                                   ;If last symbol you have entered
         jne TesDiv                ;is asterisk multiply operands 
         jmp Mult
         
TesDiv: cmp cl,'/'                 ;Check the divide operation 
                                   ;If last symbol you have entered
        jne TesPl                  ;is slash divide operands
        jmp Divide 
        
TesPl: cmp cl,'+'                  ;Check the addition operation 
                                   ;If last symbol you have entered 
       je Plus                     ;is plus,add operands 
       
Plus:  add ax,Sec                  ;add operands 
       jmp PrtRes                  ;to output result 
       
Minus: sub ax,Sec                  ;subtract operands 
       jmp PrtRes                  ;to output result 
       
Multi: mul Sec                     ;multiply operands
       jmp PrtRes                  ;to output result 
       
Divide: div Sec                    ;divide operands 
                                   ;to output result 
                                   
PrtRes: mov res,ax                 
        OutInt res                 ;display result on screen 
        NewLine
        
        jmp Next                   ;process next input string 
        
Finish: mov ax, 4C00h              ;function 4Ch-terminate process,0-exit code
        int 21h                    ;DOS service call 
        end Begin
