.model small
.stack 512
.data
CR      equ 0Dh
LF      equ 0Ah
TAB     equ 09h
BELL    equ 07h 
EscScan equ 01h 
KbdPort equ 60h
EndMsg  equ 24h
newHand dd NextInt9
FuncN   db 0
BegMsg  db CR,LF,LF,BELL,TAB,'SCAN CODES BROWSER'
        db '(INT 09h) Version 2.0 11/08/2020
        db 'Copyright (C) 1992 V.B.Maljugin, Russia, Voronezh'
        db CR,LF,EndMsg
Kbd83   db CR,LF,TAB,TAB,'83-key keyboard in use',EndMsg
kbd101  db CR,LF,TAB,TAB,'Enhanced 101/102 keyboard', EndMsg
InsMsg  db CR,LF,CR,LF,TAB
        db 'Additional handler for int 09h will be called'
        db CR,LF,TAB,'through the function '
TFuncN  dw '00'
        db 'h of BIOS interrupt 16h
        db CR,LF,TAB,TAB,'Codes above 0F9h ignored.' CR,LF
        db CR,LF,TAB, 'Press Esc to exit or any other jet to '
        db 'determine its scan code ',CR,LF,LF,EndMsg
FinMSg  db CR,LF,LF,BELL,TAB,TAB
        db 'SCAN CODES BROWSER - End of job.'
        db CR,LF,EndMsg
.code
OldDS     dw ?
LinePros  db 0
Before9   db 0
Con16     db 16
OutByte   db 'xx '        
