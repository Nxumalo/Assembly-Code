.nolistmacro

;                                                     Program Factr

;                Muizenberg Cape Town South Africa, 21 August 2020

; This is a sample of an assembler program which calculates the function called n-factorial 

.model SMALL      ; This defines memory model
            IF1   ; Of first pass
            include maclib.inc  ; open macro library 
            ENDIF               ; End of macro including block
.code
Begin:
Next:
      InpInt cx               ;Enter the number to compute
      cmp dl,0Dh              ;Check the ENTER key
      je ExCycle              ;Exit if pressed
      cmp d1,1Bh              ;Check if ESC key
      je ExCycle              ;Exit if pressed
      
      mov ax,1                ; The initiall value of factorial 
      cmp cx,1                ; Check the input value
      jl Prtres               ;Skip the calculating if the number is less than 1
      mov bx,0                ;Clear the work register
      
Multi:
      mov dx,0                ; Clear the high part of result
      inc bx                  ; Increase the work regist
      mul bx                  ;The next result
      loop Multi              ; Continue the cycle      
  
PrtRes:
      OutIntax                ;Put result on screen
      NewLine                 ;Move curse to the next line
      jmp Next                ;Proceed next number

ExCycle:                      ; This label marks end of program                        
      mov ax,4C00h            ; AH register contains 4Ch code that is a Dos Function number,AL register contains return code 00
      int 21h                 ; Dos service "Terminate program"
.stack                        ; This line defines the STACK segment 
end Begin
