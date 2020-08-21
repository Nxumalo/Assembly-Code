.model small
.code
Begin:

;PART 1 The effects of Zero Flags demmonstration

sub ax,ax ; Clear AX-Zero equals ZR
add ax,1  ; Zero Flag becomes NZ
add ax,0FFFFh ; Zero Flag becomes ZR
add ax,1  ; Zero Flag becomes NZ again

;Part 2 The effects to Sign Flag Demostrations 

sub ax,ax ; Sign flag must be PL
sub ax,1 ; Sign flag becomes NG 
add ax,2 ; Sign flag becomes PL

;Part 3 The effects to Carry Flag (CF) demonstration

sub ax,ax ; Clear AX- CF must be NC
mov ax,OFFFFh ; Carry flag is not affected
add ax,1 ; Carry flag becomes CY
add ax,0 ; Carry flag becomes NC
sub ax,1 ; Carry flag becomes CY

;Part 4 The effects to Auxilliary Carry Flag

sub ax,ax ; Auxiliary Carry gets NA
mov ax,8 ; FLAG IS NOT AFFECTED
add ax,8 ; Auxiliary carry gets AC
add ax,0 ; Auxiliary Carry gets NA
sub ax,1 ; Auxiliary Carry gets AC

;Part 5 The effects to Overflow Flag demostration

sub ax,ax ; Overfkiw flag must be NV
; Addition
mov a1,128 ; Overflow flag is not affected 
add al,128 ; Overflow flag becomes OV

; Subtraction

sub ax,ax ; Overflow flag becomes NV
add ax,8000h
sub ax,7FFFh ; Overflow flag becomes OV

; Multiplication

sub ax,ax ; Overflow flag must be NO
mov al,16 ; The first factor into AL
mov bx,16 ; The second factor into BL (BH = 0)
mul bl ; Product = 256 in AX, Overfkiw fkag us OV,
;     Carry flag  = CY

; Part 6 The effects of Parity Flag demonstration
sub ax,ax ; Parity flag must be PE
add ax,1 ; Parity flag becomes PO
add ax,10h ; parity flag becomes PE
add ax, 0100h ; Parity flag unchanged

; Part 7 Finish the Program

mov ax,4C00h  ; AH - Dose servic number,
              ; Al - Return Code
int 21h       ; Dos service Call
.data
.stack
end begin


