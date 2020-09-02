;       Program IntLoc
;       _______________________________________
;      
;       Muizenberg, 02 September 20
;
;       _______________________________________
;
;       This is a sample of an assembler program that uses a simple 
;       DOS service. It ouputs the table of interrupts onto the system
;       output device and reports where the corresponding handler is located. 
;       The letter B means BIOS, the letter  D - DOS, the letter N - not set (dummy handler)

.model small
.stack
.data 
tbint   db 16 dup ('xx-X'), '$'
HexSym  db '0','1','2','3','4','5','6','7'
        db '8','9','A','B','C','D','E','F'
NumInt  db 0
NumIntL db 0 
.code 
        mov ax,@data
        mov ds, ax,
        mov cx,'16'                     ;Line counter 
Rows:   
        push cx                         ;Lines cycle starts here 
        mov di,0                        ;Save outward counter 
        mov cx,16                       ;Counter within line 
        mov al,NumInt                   ;Columns counter 
        mov NumIntL,al      
Intrs:        
        mov al,NumintL                  ;Load interrupt number 
        mov ah,35h                      ;Get interrupt vector (DS:BX) 
        int 21h                         ;DOS service call 
        mov dx,es                       ;address of interrupt handler 
        cmp dx,0A000h                   ;Compare to BIOS start address
        ja InBios                       ;If DX is greater - handler is in BIOS 
        mov tbint[di+3],'D'             ;Set indicator 'DOS'
        jmp DoneInd                     ;To the end of block 
InBios: mov tbint[di+3],'B'             ;Set indicator 'DOS'
DoneInd:                                ;This is the end of block 
        cmp byte ptr es:[bx],0CFh       ;First instruct IRET?
        jne PresHan                     ;If not - handler presented 
        mov tbint[di+3],'N'             ;Set indicator 'Not set'
PresHan:                                ;
        mov ah,0                        ;AL keeps the interrupt number 
        mov dl,16                       ;Prepare to convert AL to symbols 
        div dl                          ;AX/16
        mov bx,offset HexSym
        xlat
        mov byte ptr tbint[di],al       ;symbol into output line 
        mov al,ah
        xlat
        mov byte ptr tbint[di+l],al     ;symbol into output line 
        
        add di,5                        ;Next position in the line                         
        add NumIntL,16                  ;Increase interrupt number 
        loop Intrs                      ;Next step - next interrupt 
        pop cx                          ;Restore cycle counter
        mov ah,09                       ;Function 09 - output strings 
        mov dx,offset tbint             ;Address of string DS:DX
        int 21h                         ;Output one string 
        inc NumInt                      ;
        loop Rows                       ;Next step - next string 
        mov ax,4C00h
        int 21h
        end
