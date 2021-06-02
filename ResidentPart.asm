;..............................................................................................................................
PRES DW 1234        ; program presence signature
; The functional section code
;..............................................................................................................................
;
; Program of Initial Loading of the TSR00 Functional Section
;
; Test if TRS00 has been loaded already:
;
INSTALL:
       mov ax,3509h        ; get current handler address
       int 21h             ; ES: BX - address of current handler
       mov ax,cs           ;
       mov ds,ax           ; data segment is in code segment 
       mov ax,ES:[bx-2]    ; ax = program signature 
       cmp ax,CS:PRES      ; is program in memory?
       jne Modvec          ; no, modify vector, and install TRS
 
; Output the message that the program has been loaded and terminate:
  
       lea dx,LOAD1        ; address of text message
       mov ah,9            ; text output function code
       int 21h             ; output message 
       mov ax,4C01h        ; return code
       int 21h             ; return to MS-DOS
       
;..............................................................................................................................

; Keyboard interupt INT 09H vector modification:
; The necessary program code
     
       Modvec:
   
;..............................................................................................................................
     
; Functional Section Loading:

       lea dx,LOAD0        ; address of text message
       mov ah,9            ; function 09h - output text
       int 21h             ; output message that program is loaded
       lea dx,INSTALL      ; length of functional section (in bytes)
       mov cl,4            ; 4 shifts to right (dividing by 16)
       shr dx,cl           ; length of functional section paragraphs
       
       add dx,20           ; 16 paragraphs for PSP +4
       mov ax,3100h        ; terminate and stay resident
       int 21h             ; KEEP

;..............................................................................................................................
     
; The Text of the Necessary Messages are in the code segment
LOAD0 DB 10,13,'Program ***TRS00*** is loaded',13,10,'$'
LOAD1 DB 10,13,'Program ***TRS00*** already loaded',13,10,'$'
CODE ENDS
     END INSTALL
