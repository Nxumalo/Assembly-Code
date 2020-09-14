.model small
.stack 512
.data
CR      equ 0Dh                 ;The Carriage return code
LF      equ 0Ah                 ;The Line feed code
TAB     equ 09h                 ;The TAB code
BELL    equ 07h                 ;The BELL code
EscScan equ 01h                 ;The Scan code for ESC key 
KbdPort equ 60h                 ;PPI 8255A port A
EndMsg  equ 24h                 ;Dollar sigh-end of message for DOS service 
newHand dd NextInt9             ;Reference to the new handler for int 09
FuncN   db 0                    ;Function number for interrupt 16h
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
OutByte   db 'xx ',EndMsg
OutByte   db CR,LF,EndMsg
HexTab    db '0','1','2','3','4','5','6','7',
          db '8','9','A','B','C','D','E','F'
          
NextInt9        proc far                        ;Additional handler for INT 9
                push ax
                push bx
                push dx
                push ds
                in al,KbdPort                   ;Read scan code from keyboard port
                push ax                         ;Push this SCAN CODE for processing 
                pushf                           ;This is needed for interrupt call
                db 9Ah                          ;OpCode for FAR CALL
Off9            dw ?                            ;Offset address for standard handler 
Seg9            dw ?                            ;to avoid keyboard buffer overflow 
                pop ax                          ;Read scan code from keyboard port 
                cli                             ;AX now in range 0 - 255
                in  al,KbdPort
                mov ah,0
                cmp al,0FAh
                jb  ProcScan
                jmp NotShow
ProcScan:
                div Con16                       ;AL - first hex digit, Ah - second 
                mov bh,0                        ;Clear high part of BX
                push cs                         ;After this CS and DS aare equal to
                pop  ds                         ;address internal area of handler 
                mov bl,al                       ;Take the first hext digit 
                mov al,HexTab[bx]               ;Take the corresponding character 
                mov OutByte[0],al               ;Place it into output string 
                mov bl,ah                       ;Take the second hex digit 
                mov al,HexTab[bx]               ;Place it into output string
                mov OutByte[1],al               ;Take the second hex digit 
                lea dx,cs:OutByte               ;Address of scan code text into DX
                mov ah,09                       ;Function 09h - output text string         
                int 21h                         ;DOS service call 
                inc LinePos                     ;Increase counter of bytes output
                cmp LinePos,24                  ;24 code per line are valid 
                jb  NotSkip                     ;If less than 24, don't skip line 
                mov LinePos,0                   ;Clear counter of codes in line 
                lea dx,CrLf                     ;Address of LineFeed code into DX
                int 21h                         ;DOS service call 
NotSkip:                                
NotShow:
        pop ds
        pop dx
        pop bx
        pop ax
        iret
NewInt9 endp 
.startup
        mov OldDS,ds
        lea dx,BegMsg                           ;Address of start message into DX
        mov ah,09                               ;Function 09h - output text string 
        int 21h                                 ;DOS service call
        
        mov ax,40h                              ;40h - segment address for BIOS area
        mov es,ax                               ;Place this address into ES
        test byte ptr es:[96h]                  ;Bit 4 for  101/102 keys
        jnz Pres101                             ;If enhanced keyboard is present 
        lea dx,Kbd83                            ;Address of message into DX
        mov ah,09                               ;Function 09h - output text string 
        int 21h                                 ;DOS service call
        jmp PrtInstr                            ;To print the initial message
        
Pres101:        
        lea dx,Kbd101                           ;Address of start message into DX
        mov ah,09                               ;Function 09h -output text string 
        int 21h                                 ;DOS service call
        mov FuncN,10h                           ;10h - Read From Enhanced Keyboard
        mob TFuncN,'01'                         ;Text '01' because TFuncN is a word!
        
PrtInstr:
        lea dx,InsMsg                           ;Address of message into DX
        mov ah,09                               ;Function 09h - output text string 
        int 21h                                 ;Dos service call
        
        mov ah,35h                              ;Function 35h - Get interrupt vector
        mov al,09h                              ;Interrupt number is 09h
        int 21h                                 ;DOS service call
        mov Off9,bx                             ;Save offset address of old handler 
        mov Seg9,es                             ;Save segment address of old handler 
        lds dx,NewHand                          ;DS:DX - full address of new handler 
        mov ah,25h                              ;Function 25h - set interrupt vector 
        int 21h                                 ;DOS service call 
        mov ds,OldDS
        
NextKey:
        mov ah,0                                ;Function 00h - read character
        int 16h                                 ;BIOS keyboard service 
        cmp ah,EscScan                          ;Is the ESC key pressed?
        jne NextKey                             ;If not - process the next key
        
Finis:
        mov dx,Off9                             ;Offset address for old handler
        mov ds,Seg9                             ;Segment address for old handler
        mov ax,2509h                            ;Set interrupt vector for INT 9
        int 21h                                 ;DOS service call 
        
        mov ah,0Ch                              ;Function 0Ch - clear keyboard buffer
        int 21h                                 ;DOS service call
        
        mov ds,OldDS                                    
        lea dx,FinMsg                           ;Address of message into DX
        mov ah,09                               ;Function 09h - output text string 
        int 21h                                 ;DOS service call
      
        mov ax,4C00h                            ;Function 4Ch - terminate process
        int 21h                                 ;DOS service call 
        end 
        
                
