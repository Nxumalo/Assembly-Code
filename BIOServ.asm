.model small
.code
      mov ah,0Ah
      mov al,07h
      mov bh,0
      mov bl,0
      mov cx,1
      int 10h
      
      mov ah,02
      mov dl,al
      int 21h
      
.exit 
  end
