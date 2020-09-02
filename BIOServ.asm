;This is an example of using two different levels
;of output procedures - BIOS service and DOS service.

;Note that BIOS procedure outputs the symbol
;"BELL" as visible symbol while the DOS procedure 
;takes the corresponding action - lets look and hear!

.model small
.code
      mov ah,0Ah             ;function 0Ah - output symbol
      mov al,07h             ;AL - symbol to be output (BELL)
      mov bh,0               ;Video page is supposed to be 0
      mov bl,0               ;Used in graphic mode - hear not needed
      mov cx,1               ;CX - number of symbols  
      int 10h                ;BIOS video service call
      
      mov ah,02              ;Function 02h - output symbol
      mov dl,al              ;DL - symbol to be output 
      int 21h                ;DOS service call 
      
.exit 
  end
