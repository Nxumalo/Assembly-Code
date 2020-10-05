.................................................................................................
DATA SEGMENT 
PATH DB 68 dup (0)            ;buffer for path name
     .........................
DATA ENDS
................................................................................................
CODE SEGMENT 
      mov ax,DATA             ;base address
      mov ds,ax               ;of data segment 
;first 3 positions reserved for disk name and separator
      mov word ptr PATH+1,'\:';   place separator into buffer
      lea si,PATH+3           ;DS:SI - address of buffer
      mov ah,47h              ;fucntion 47h - get current directory 
      int 21h                 ;call MS-DOS service 
      jc error                ;error,if carry flag = 1
;get the current disk name 
      mov ah,19h              ;function 19h - get drive number 
      int 21h                 ;call MS-DOS disk service 
      add al,41h              ;41h is ASCII code for "A"
      mov PATH,al             ;full path is formed!
      ............................................................
CODE ENDS
.......................................................................................................      
      
