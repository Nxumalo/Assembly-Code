;Character arrays sorting. Version 1.4
;Author: 3538264, University of the Western Cape 2020/08/31
;Using from assembler programs
;Call Bubble Sort algorithm is used
;Parameters passed
;Enter parameters
;DS:SI - address of the array to be sorted
;CX    - the array element length
;DX    - number of elements
;Sorting oder
;AX = 0 - increasing
;      1 - decreasing 
;Output (error code in the AX register)
;AX = 0 - normal finish
;     1 - elements longer than 46 bytes 
;     2 - invalid parameters specified
;The source array remains unchanged
.model large
public bsort
MaxLen equ 48
.code
BSORT PROC FAR pascal uses bx cx dx es si di bp
;Check parameters passed
                  cmp  cx,MaxLen    ;array length valid?
                  jng  ChkN         ;less than maxium - continue 
                  mov  ax,1         ;indicate "elements too long" 
                  jmp  Exit         ;return
ChKN:             cmp  dx,0         ;number of elements = 0?
                  jg   Work         ;if not continue
                  mov  ax,2         ;indicate "no elements in array"
                  jmp  Exit         ;return
;------------------------------------------------------------------------------------                  
                  
Work:             mov  CS:SrtOrd,ax ;store Sort Order
                  cld               ;Clear Direct Flag
                  mov  CS:RecLen,cx ;store Record Length 
                  mov  CS:RecNum,dx ;store Number of Records 
                  mov  CS:AddrArr,so ;store Array Address   
                  push ds           ;push DATA segments address 
                  pop  es           ;ES now points to DATA segment
;External loop (WHILE SWP = 1, i.e whhile elements moved)                  
ExtLoop:          mov  CS:SWP,0     ;indicate "no elements moved"
                  mov  ax,0         ;Normal Return Code
                  dec  CS:RecNum    ;decrease  number of records to process
                  jz   Exit         ;if no more records - exit
                  mov  dx,CS:RecNum ;of DX - numbers of records left 
                  mov  bp,CS:AddrArr  ; starting address of array 
                  mov  CS:BP0,bp      ; save address pf forst record 
;Nested loop (comparing adjacent records)                  
Ml:               mov  si,CS:BP0      ;address of current record 
                  mov  di,si          ;address of following record
                  mov  cx,CS:RecLen   ;record length
                  add  di,si          ;address of next record 
                  mov  cx,SrtOrd,0    ;increasing?
                  jnz  Decrs          ;AX<> 0 - decreasing 
Incrs:            repe cmpsb          ;compare adjacent records
                  jbe  Swapped        ;if following < current 
                  jmp  short SWAP     ;swap records
Decrs:            repe cmpsb          ;compare adjacent records
                  jae  Swapped        ;if following > current
;Swapping Records 
SWAP:             mov  cx,CS:RecLen   ;CX - record length
                  mov  bp,CS:BPO      ;BP - address of current record
                  mov  bx,bp          ;BX points to current record 
                  add  bx,cx          ;now BX points to next record
SwBytes:          mov  al,DS:[BP]     ;byte from current record to AL
                  xchg al,[bx]        ;swap bytes in AL and next record
                  mov  DS:[BP],al     ;put byte in AL and next record 
                  inc  bp             ;next byte in current record 
                  inc  bx             ;next byte in next record
                  loop SwBytes        ;repeat swapping 
                  mov  CS:SWP,1       ;indicate swapping
;advance parameters of external cycle                  
Swapped:          mov  ax,CS:RecLen   ;AX - record length 
                  add  CS:BP0,ax      ;BP pints to next record 
                  dec  dx             ;decrease number of records to process
                  jnz  Ml             ;next step of nested cycle
                  cmp  CS:SWP,0       ;have elemts been swapped?
                  jnz  ExtLoop        ;yes- repeat process
                  mov  ax,0           ;Normal Return Code
;Restore register and return (exit code in AX)                  
Exit:             ret
Bsort    EndP

SrtOrd            DW  0
RecLen            DW  0
RecNum            DW  0
AddrArr           DW  0               ;address of current record
BP0               DW  0               ;swappings indicator 
SWP               DB
                  END

                  
                  

                  
