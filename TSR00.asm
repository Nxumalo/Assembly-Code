;_________________________________________________
; All the necessary data is in the code segment 
CODE SEGEMENT                      
OLD09H LABEL DWORD                 ; address of old handler
0FF09G DW 0                        ; old INT 09h handler offset
SEG09H DW 0                        ; old INT 09h handler segment address

PRES DW 1234                       ; signature iindicating presence of program 
 ;_______________________________________________
 ;
 ; The new handler of the interrupt 09h:
 ;
 ; Processing keystrokes of the type Shift (R) + 1 - 9
 ;
 ;_______________________________________________
INT09H PROC FAR                     ; new INT 09h handler code  
       cli                          ; disable interrupts 
       PUSHR                        ; macro for pushing all register used
       mov ax,40h                   ; segment address of BIOS data area 
       mov ES,ax                    ; ES points to BIOS data segment 
       mov ch ES:[17h]              ; get keyboard flag 1
       in al,60h                    ; get scan code
; Text if a "hot" key has been pressed (keys shift +1 - 9)       
       and ch,01h                   ; Clear all bits except Right Shift
       cmp ch,01h                   ; previous Right Shift ?
       jne RET09                    ; if not, exit
       sub al,1                     ; scan code into number 
       jng RET09                    ; exit if key value < 1
       cmp al,9                     ; digital key ?
       jg RET09                     ; >9, exit 
; A "hot" key has been pressed (keys shift +1 - 9)
; Necessary processing is done here 

; Restore Registers and Exit 
RET09: pushf                        ; flag register for IRET
       Call CS:OLD09H               ; call old interrupt handler INT 09H
       POPR                         ; macro call to restore registers
       IRET                         ; exit interrupt handler        
INT09H  ENDP
;___________________________________________________
;
; Intial loading of TSR00 Functional Section
;
;___________________________________________________
INSTALL:
; Test if TSR00 driver has been loaded already

;___________________________________________________
; Modify the keyboard interrupt (INT 09h) vector 
Modvec:
      cli                           ; disable interrupts for modification period 
      mov ax,3509h                  ; get current vector INT0 9h
      int 21h                       ; address ES:BX = old interrupt vector  
      mov CS:OFF09H,bx              ; store old vector offset
      mov CS:SEG09H,es              ; store old vector segment address
      lea dx,INT09H                 ; DS:DX - new vector address
      mov ax,2509h                  ; set new vector  INT 09h
      int 21h                       ; DOS service call
      sti                           ; enable interrupts
      
; Program Installation is continued       
