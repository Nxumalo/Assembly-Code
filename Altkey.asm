CODE    SEGMENT  word public 
        assume   CS:CODE
        public   TestAlt         ; entry TestALT is accessible from modules
 
TestAlt     Proc   far
            mov    ah,02h        ; function 02h - get keyboard flag 
            int    16h           ; BIOS keyboard service
            and    al,8          ; allot bit 3
            mov    cl,3          ; shift to the right by 3 -
            shr    al,cl         ; bit 3 becomes bit 0
            ret                  ; return to calling program
            
TestAlt     endp
CODE        ends 
            
