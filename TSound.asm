.model small                                    
EXTRN sound : far                               ;external sub-program SOUND will be used
.stack
.data
freq dw 0,988,880,784,699,659,587,523
.code
.startup
        mov cx,7                                ;number of signals produced 
        
prop:   mov bx,cx                               ;number of current signal 
        shl bx,1                                ;multiply number by 2 to obtain offset 
        mov di,word ptr freq[bx]                ;get frequency of current signal 
        mov bx,50                               ;duration - 25 hundredths of second
        call sound                              ;this produces sound 
        loop prod                               ;next signal 
        
        mov ax,4C00h                            ;function 4C - terminate process 
        int 21h                                 ;DOS service call 
        
  end      
        
