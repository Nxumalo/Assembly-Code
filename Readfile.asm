........................................................................................
DATA SEGMENT 
HANDLE DW ?                                   ;file name 
BUF    DB 4096 dup (0)                        ;I/O buffer
       ...................
DATA ENDS       
........................................................................................
CODE SEGMENT 
            mov ax,DATA                       ;base address
            mov ds,ax                         ;of data segment 
            lea dx,BUF                        ;DS:DX - address of buffer 
            mov bx,HANDLE                     ;file handle into BX
            mov cx,4096                       ;number of bytes to be read
            mov ah,3Fh                        ;function 3Fh - read file
            int 21h                           ;call MS-DOS service
            jc error                          ;error, if carry flag  = 1 
            ...............
CODE ENDS            
....................................................................................... 
