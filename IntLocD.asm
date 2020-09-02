;      Program IntLocD
;      _____________________________________________________
;
;      Muizenberg, 20 September 20
;      _____________________________________________________
;
;      This is a sample of an assembler program that uses a simple 
;      DOS service. It outputs the table of interrupts onto the 
;      system output device and repots the corresponding handler is located. 
;      The letter B means BIOS, the letter D - DOS, the letter N - not set (dummy handler)

.model small
IntSeg segment at 0
IntVec dw 512 dup(?)
IntSeg ends
.stack
.data
tbint db 16 dup('xx-X '),'$'
HexSym db  '0','1','2','3','4','5','6','7'
       db  '8','9','A','B','C','D','E','F'
NumInt db 0
NumIntL db 0
.code
      assume es:IntSeg
      mov ax,@Data 
      mov ds,dx
      
      mov ax,IntSeg
      mov es,ax
      
      mov cx,16                    ;Line counter 
Rows:                              ;Lines cycles starts here 
      push cx                      ;Save outward counter       
      mov di,0                     ;Counter within line 
      mov cx,16                    ;Columns counter 
      mov al,NumInt
      mov NumIntL,al
Intrs:
      mov bh,0
      mov al,NumintL               ;Load interrupt numbers 
      mov bl,al
      shl bx,1
      sh1 bx,1
      mov dx,IntVec[bx+2]
      cmp dx,0A000h                ;Compare to BIOS start address
      ja  InBios                   ;If DX is greater - handler is in BIOS 
      mov tbint[di+3],'D'          ;Set indicator 'DOS'
      jmp doneind                  ;To the end of block 
InBios: mov tbint[di+3]            ;Set indcator 'BIOS'
DoneInd:                           ;This is the end of block 
       
       cmp byte es:[bx],0CFh       ;First instruction IRET?
       jne PresHan                 ;If not - handler presented 
       mov tbint[di+3]             ;Set indicator 'Not set'
PresHan: 
        mov ah,0                   ;AL keeps the interrupt number 
        mov dl,16                  ;Prepare to convert AL to symbols 
        div dl                     ;AX/16
        
        mov bx,offset HexSym
        xlat
        mov byte ptr tbint [di],al ;symbol into output line 
        mov al,ah
        xlat
        mov byte ptr tbint[di+1],al ; symbol into output line 
        
        add di,5                   ;Next position in the line 
        add NumIntL,16             ;Increase interrupt number 
        loop Intrs                 ;Next step - next interrupt 
        pop cx                     ;Restore cycle counter 
        mov ah,09                  ;Function 09 - output string 
        mov dx,offset tbint        ;Address of string DS:DX
        int 21h                    ;Output one string 
        inc NumInt                 ;
        loop Rows                  ;Next step - next string  
        mov ax,4C00h
        int 21h
        end
