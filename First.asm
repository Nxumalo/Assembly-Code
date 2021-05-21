.code                 ;This starts the code segment

Begin:                ;This is the beginning of a program instruction

      mov   bx,0      ;Clear BX register
      
      input bx        ;Input the first operand
      
      mov   cx,bx     ;Input the second operand
      
      add   bl,cl     ;Add operand, Note it is a main command for this program
