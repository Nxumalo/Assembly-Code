; Muizenberg Cape Town , 02 September 2020
; Comment: no Comment 
.model small
FarSeg  segment at 0F000h
        org 0FFF0h
Reld    dw ?
FarSeg  ends
.code
        assume ds; FarSeg
        
Begin: 
      jmp Far ptr FarSeg: Reld
      end Begin
