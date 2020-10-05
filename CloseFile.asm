..............................................................
DATA SEGMENT 
HANDLE DW ?                       ; file handle
      .............
DATA ENDS
.............................................................
CODE SEGMENT 
      mov ax,DATA                 ;base address
      mov ds,ax                   ;of data segment 
      mov bx,HANDLE               ;put file handle into BX
      mov ah,3Eh                  ;function 3Dh  - close file 
      int 21h                     ;call MS-DOS service
      jc error                    ;error, if carry flag = 1
      ...................
CODE ENDS 
.............................................................
      
      
