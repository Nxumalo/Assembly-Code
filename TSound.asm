.model small
EXTRN sound : far
.stack
.data
freq dw 0,988,880,784,699,659,587,523
.code
.startup
        mov cx,7
        
prop:   mov bx,cx
        shl bx,1
        mov di,word ptr freq[bx]
        mov bx,50
        call sound 
        loop prod
        
        mov ax,4C00h
        int 21h
        
  end      
        
