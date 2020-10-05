....................................................................................
DATA SEGMENT 
HANDLE DW 0                         ;file handle for opened file 
BUF    DB 4096 dup (0)              ;buffer for data to be written 
       .................
DATA ENDS
...................................................................
CODE  SEGMENT 
      mov ax,DATA                   ;base address
      mov ds,ax                     ;of data segment
      lea dx,BUF                    ;DS:DX - address of buffer
      mov bx,HANDLE                 ;file handle for file processed 
      mov cx,4096                   ;number of bytes written 
      mov ah,40h                    ;function 40h - write file 
      int 21h                       ;call MS-DOS service
      jc error                      ;error, if carry flag  = 1 
      cmp ax,cx                     ;is all the data written?
      jne error                     ;if not - process an error 
      ................
CODE ENDS 
.................................................................................
      
