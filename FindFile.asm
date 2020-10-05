.....................................................................................................
DATA SEGMENT 
PATH DB "D:\DIRECT1\*.asm", 0           ;file name mask
DTA DB 128 dup (0)                      ;DTA buffer
        ............................
DATA ENDS 
.....................................................................................................
CODE SEGMENT 
; Step 0 - prepare system registers
      mov ax,DATA                       ;base address
      mov ds,ax                         ;of data segment 
; Step 1 - "set DTA " operation 
      lea dx,DTA                        ;DS:DX - address of DTA
      mov ah,1Ah                        ;set DTA
      int 21h                           ;call MS-DOS service
; Step 2 - find first file 
      mov cx,07h                        ;attribute mask 
      lea dx,PATH                       ;DS:DX - addrtess of ASCIIZ mask 
      mov ah,4Eh                        ;function 4Eh - FindFirst
      int 21h                           ;call MS-DOS service 
      jc error                          ;error,if carry flag = 1
; Step 3 - find next files until CF is clear
Cycle:lea dx,PATH                       ;DS:DX - address of file name mask 
      mov ah,4Fh                        ;function 4Fh  - FindNext 
      int 21h                           ;call MS-DOS service 
      jc exit                           ;exit,if carry flag = 1
; === process the file found ===
....................
      jmp Cycle                         ; continue searching 
Exit: .......................
CODE ENDS 
.......................................................................................................
      
