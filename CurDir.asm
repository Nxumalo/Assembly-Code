.......................................................................................
DATA SEGMENT 
PATH DB "D:\DIRECT1\NEWDIR",0               ;ASCIIZ string for path 
     ........................................................
DATA ENDS
.............................................................
CODE SEGMENT 
            mov ax,DATA             ;base segment 
            mov ds,ax               ;of data segment 
            lea dx,PATH             ;DS:DX - pointer to path name 
            mov ah,3Bh              ;function 3Bh - set subdirectory
            int 21h                 ;call MS-DOS service 
            jc error                ;error, if carry flag = 1
            ....................
CODE ENDS 
............................................................................
            
            
