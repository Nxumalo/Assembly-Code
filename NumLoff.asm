.model tiny


BiosData  segment at 40h
          org 17h
KbdSt1    db ?
KbdSt2    db ?
BiosData  ends 

.code 
begin:
          assme es: BiosData
          mov ax,BiosData
          mov es,ax
          and KbdSt1,0DFh
          
          mov ax,4C00h
          int 21h
          
          end begin
