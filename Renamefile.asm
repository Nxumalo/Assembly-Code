................................................................................................
DATA SEGMENT
PATH1 DB "D:\DIRECT1\OLDFILE",0                     ;old file name 
PATH2 DB "D:\DIRECT1\NEWFILE",0                     ;new file name 
      .....................
DATA ENDS 
................................................................................................
CODE SEGMENT 
      mov ax,DATA                                   ;base address
      mov ds,ax                                     ;of data segment 
      mov es,ax                                     ;
      lea dx,PATH1                                  ;DS:DX - old name 
      lea di,PATH2                                  ;ES:DI - new name
      mov aj,56h                                    ;function 56h - RENAME
      int 21h                                       ;call MS-DOS service
      jc error                                      ;error,if carry flag = 1
      ......................
CODE ENDS 
...............................................................................................
