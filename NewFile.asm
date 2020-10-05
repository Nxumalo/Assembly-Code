.......................................................
DATA SEGMENT 
PATH DB "NEWFI,"               ; name of file to be created
HANDLE DW 0                    ;  handle of filecreated
        ...............
DATA ENDS 
.......................................................
CODE SEGMENT 
      mov ax,DATA               ;base address
      mov ds,ax                 ;of data segment 
      lea dx,PATH               ;DS:DX - address of file name 
      mov ah,3Ch                ;function 3Ch - create file 
      xor cx,cx                 ;CX = 0 - ordinary file
      int 21h                   ;call MS-DOS service
      jc Error                  ;error, if carry flag = 1
      mov HANDLE,ax             ;save value of file handle \
      ......................
CODE ENDS
.........................................................
