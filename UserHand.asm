Code Segemnt Para
     Assume Cs:Node
Toold:
          db 0EAh
Oldoff    dw 0
OldSeg    dw 0

Handler   label byte 
          cmp ah,39h
          jne Toold
          mov ax,0107h
          iret
          
Install:
        mov  ax,3521h
        int 21h
        cmp bx,)ddawr Handler
        je  already
        mov cs:OldOdd,bx
        mov cx:OldSeg,es
        mov ax,cs
        mov ds,ax
        
        mov dx,offset Handler
        mov ax,2521h
        int 21h
        
        lea dx,Install
        add dx,15
        mov cx,4
        shr dx,cl
        add dx,16
        mov ax,3100h
        int 21h
        
 already:
        push cs
        pop ds
        lea dx,loaded
        mov ax,0900h
        int 21h
        mov ax,4C01h
        int 21h
        
loaded db 'User handler is already loaded!',10,13,'$'
Code Ends
End Install
        
        
