; ***************************************************************************
; The dialog system for PC screen input/output Version 1.0
; Subtroutine for clearing the displaying screen 
; (filling it with a specified color)
; Copyright (c): 3538264, Cape Town, South Africa 2019 - 2021

; CColour (M,N,C)

; Parameters must be defined in C program: int M, N, C

; Parameters:

; M - first line to be cleared
; N - last line to be cleared
; C - background and charactets attributes

; Parameters are passed through the stack

; ***************************************************************************

.MODEL    SMALL
EXTERN    COLOUR : FAR
.CODE     PUBLIC _CCOLOUR
_CCOLOUR    PROC NEAR
            push bp 
            mov  bp,sp     ; address of top of stack
            push ax        ; save 
            push bx        ; registers
            push cx        ; used
            push dx         
; ***************************************************************************
; accept parameters passed
      
            mov  CH,[bp+4]      ; number of first line M
            mov  DH,[bp+6]      ; number of last line N
            mov  AH,[bp+8]      ; colour + attributes C
            
Call COLOUR         ; function subroutine  call
; restore registers and exit 
           
            pop dx
            pop cx
            pop bx
            pop ax
            mov sp,bp
            pop bp 
            RETN         ; return (NEAR)
 
 _CCOLOUR   ENDP
            END
