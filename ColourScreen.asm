;.....................................................................................
; Clearing screen by writing blanks writing blanks with attributes 

      mov ah,02      ; function 02h - positioned cursor 
      mov bh,0       ; video page 0 is used
      mov dx,0       ; cursor to position 0,0 - left top corner
      int 10h        ; BIOS video service call
      mov ah,9       ; function number
      mov cx,2000    ; number of character for output
      mov bl,1Eh     ; attribute - yellow on blue 
      mov al,' '     ; character to fill screen - blank
      int 10h        ; BIOS video service call
;.....................................................................................
; clearing part of screen by shifting rows

      mov ah,6       ; function number 
      xor al,al      ; clearing, as number of shifts = 0
      mov bh,74h     ; red on grey attribute
      mov ch,2       ; Y - coordinate of left upper corner 
      mov cl,10      ; X - coordinate of left upper corner
      mov dh,16      ; Y - coordinate of right lower corner
      mov dl,56      ; X - coordinate of right lower corner 
      int 10h        ; BIOS Service 
;.....................................................................................
      
