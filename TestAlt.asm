CODE       segment word public 
           assume CS:CODE
           public TestAlt        ; entry TestAlt is accessible 
                                 ; from other modules
TestAlt    Proc far
           mov  ah, 02h          ; function 02h - get keyboard flag 
           int  16h              ; BIOS keyboard service
           and  al,8             ; only bit 3 (ALT Pressed) is needed 
           mov  cl,3             ; shift to the right by 3 - bit 3 becomes bit 0
           shr  al,cl            ; bit 3 becomes bit 0
           ret                   ; return to calling program
TestAlt    endp
CODE       ends
           end
