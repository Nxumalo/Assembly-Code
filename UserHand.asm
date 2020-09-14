Code Segemnt Para
     Assume Cs:Node
Toold:
          db 0EAh
Oldoff    dw 0                          ;offset
OldSeg    dw 0                          ;segment 

Handler   label byte                    ;Start of new handler for INT 21
          cmp ah,39h                    ;Check function number 
          jne Toold                     ;If not a function 30h - to old handler 
          mov ax,0107h                  ;Function 30h - return the version number
          iret                          ;Return from handler 
          
Install:                                ;Installation starts here 
        mov  ax,3521h                   ;Get handler's address 
        int 21h                         ;ES - segment, BX - offset 
        cmp bx,)ddawr Handler           ;Vector points to this handler?
        je  already                     ;If so - put message end exit 
        mov cs:OldOdd,bx                ;Save offset of old handler      
        mov cx:OldSeg,es                ;Save segment of old handler 
        mov ax,cs                       ;Command segment of this program 
        mov ds,ax                       ;into DX (for setting handler)
        
        mov dx,offset Handler           ;Address of handler 
        mov ax,2521h                    ;Function 25h - Set new handler 
        int 21h                         ;DOS service call 
        
        lea dx,Install                  
        add dx,15
        mov cx,4                        ;Set counter for shift 
        shr dx,cl                       ;4 bits to the right - divide by 16
        add dx,16                       ;Add size of PSP in paragraphs 
        mov ax,3100h                    ;Terminate and 
        int 21h                         ;stay resident 
        
 already:
        push cs                         ;Copy the value of CS
        pop ds                          ;into the register DS
        lea dx,loaded                   ;DX := address of message text
        mov ax,0900h                    ;Function 09 - output string 
        int 21h                         ;DOS service call
        mov ax,4C01h                    ;Function 4Ch-stop (return code 01)
        int 21h                         ;DOS service call
        
loaded db 'User handler is already loaded!',10,13,'$'
Code Ends
End Install
        
        
