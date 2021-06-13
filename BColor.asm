;*******************************************************************************************
; The PC screen input/output library Version 1.0
; Subroutine for clearing rhe display screen
; (fillung it with a specified color)
; Copyright (c) : 3538264, Cape Town, South Africa 2019 - 2021

; This subroutine can be called from programs written
; in MS QuickBASIC

; Type of parameters: Integer

; Parameters:

; M - first line to be cleared
; N - last line to be cleared
; Co - background and character attribute

; ALL parameters are passed by reference, through the stack

; The FAR calls are used

;*******************************************************************************************

.model medium
   extrn color:far
   public bcolor
.code
bcolor proc far basic uses ax bx cx dx,
            M: word, N: word, Co: word
       mov  bx,Co           ; address of Co into BX
       mov  AX,[bx]         ; value of Co into AX
       mov  ah,al           ; convert word into byte (<255)
       mov  bx,M            ; address of M into BX
       mov  CX,[bx]         ; value of M into CX
       mov  ch,cl           ; convert word into byte (<255)
       mov  bx,N            ; address of N into BX
       mov  DX,[bx]         ; value of N into DX
       mov  dh,dl           ; convert word into byte (<255)
       Call COLOR           ; call functional subroutine
       RET                  ; return to caller
BCOLOR ENDP
       END
