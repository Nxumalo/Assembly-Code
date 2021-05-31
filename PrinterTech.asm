;.......................................................................................
DATA SEGMENT
CR   EQU   13
LF   EQU   10 
LPT1 DW    0 
String DB  "This is my string Printer (Low Level)", CR, LF
Lstr EQU   $-String 
;.......................................................................................
; - code segment 
; - printer port initialization
    
    mov ax,DATA       ; address of data segment
    mov DS,ax         ; DS points to data segemt 
    mov ax,40h        ; segment address of BIOS DATA area
    mov ES,ax         ; ES points to BIOS data area
    mov dx,ES:[8]     ; base address of LPT1 port

; - beginning of a printer port initializatio 

    inc dx            ; 
    inc dx            ; address of control register
    mov al,0Ch        ; 0Ch - command code of initialization
    out dx,al         ; intialize port 
    mov cx,3000       ; numbet of empty cycles
    loop $            ; empty cycle (delay)
    mov al,08h        ; 08h - command code of initialization 
                      ; complete
    out dx,al         ; complete initialization
    
;.......................................................................................

; code segment 
; - send ASCII - string onto printer 

    mov ax,DATA       ; address of data segment 
    mov DS,ax         ; DS points to data segment
    mov ax,40h        ; address of BIOS data area 
    mov ES,ax         ; ES points to BIOS data area
    mov dx,ES:[8]     ; base address of printer port
    mov LPT1,dx       ; save base address
    mov cx,Lstr       ; length of string to be printed
    lea si,String     ; DS:SI - address of string 
    cld               ; direction - forward 

; send a character onto printer 

Next:   lodsb         ; send character int AL accumulator 
        mov dx,LPT1   ; LPT1 will be used 
        out dx,al     ; send character to printer 
        inc dx,       ;
        inc dx        ; address of control register 
        mov al,0Dh    ; value of strobe register
        out dx,al     ; disable strobe 

;  check whether operation is complete

        dec dx        ; address of status register 
        in  al,dx     ; read status register
        test al,08h   ; is there error on printer
        jz ERROR      ; if so, output message 
        
;  wait until printer is free     

Wait0:  in al,dx      ; read status register 
        test al,80h   ; is printer busy?
        jz Wait0      ; if so, continue wait
        loop Next     ; repeat cycle
        jmp  Exit     ; end of job
        
 ; the code for error processing goes here 
 ERROR: 
 .....
 ; complete work and exit 
 Exit;
 
 ;.......................................................................................
    
