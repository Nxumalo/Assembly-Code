.............................................................
DATA SEGMENT 
PATH DB "OLDFILE", 0                      ; file name 
     ....................
DATA ENDS
.............................................................
CODE SEGMENT 
     mov ax,DATA                          ;base address
     mov ds,ax                            ;of data segment
     lea dx,PATH                          ;DS:DX - address of file name 
     mov ah,41h                           ;function 41h - UNLINK
     int 21h                              ;call MS-DOS service 
     jc error                             ;error,if carry flag = 1
     ...................
CODE ENDS 
..............................................................
     
