...............................................................................................................
DATA SEGMENT
PATH DB "D:\DIRECT1\OLDFILE",0                              ; file name 
HANDLE DW ?                                                 ; file handle 
       .......................
DATA ENDS
...............................................................................................................
CODE  SEGMENT
      mov ax,DATA                     ;base address
      mov ds,ax                       ;of data segment 
      lea dx,PATH                     ;DS:DX - address of file name 
      mov al,2                        ;access mode - read & write
      mov ah,3Dh                      ;function 3Dh - open file 
      int 21h                         ;call MS-DOS service
      jc error                        ;error, if carry flag = 1
      mov HANDLE,ax                   ;store file handle for future usage 
      .........................
CODE ENDS 
....................................................................................................................
