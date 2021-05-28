;******************************************************************************

; The procedure for screen scrolling 

; DS:[SI] - address of string to be output

; ES:[DI] - address of the string in the video buffer

; CX - number of words to be controlled 

; The Direction Flag is used to define the scrolling direction

; CLD - scroll upwards

; STD - scroll downwards 

;******************************************************************************

; Screen scrolling downwards by one line 

       mov  si,3678     ; source offset (end of line 21)
       mov  di,3838     ; target offset (end of line 22)
       mov  ES,VIDSEG     ; target segment (video buffer)
       mov  DS,VIDSEG     ; source segment (video buffer)
       mov  cx,22*80      ; number of words to be scrolled (22 lines)
       std              ; scroll down 
       Call SCROLL      ; function 
       cls              ; Clear Direction Flag 
       
 SCROLL  PROC NEAR 
         mov bl,CGA     ; take CGA indicator
         cmp bl,1       ; CGA card ?
         jne Cycle7     ; no don't check for retrace
                        ; Wait for retrace 
Cycle4:   mov dx,3DAh    ; video state register (CGA)
Cycle5:   in   al,dx      ; read state register 
          test al,1       ; retrace?
          jnz  Cycle5     ; yes, wait for finishing 

; Check whether it is possible to write into video buffer

Cycle6:   in    al,dx     ; read state register 
          test  al,1      ; retrace (writing allowed)?
          jz    Cycle6    ; no, check again 
          lodsw           ; take character and attribute 
          stosw           ; output character attributes
          loop  Cycle4    ; next step of outward cycle
          RETN            ; return to caller

; NON-CGA video card - direct writing always allowed

Cycle7:   rep   movsw     ; output character and attribute
          RETN            ; return to caller 
SCROLL    ENDP          


 
       
