TITLE Hello World       ; https://www.silentcode.za
.model small            ;declare memory model
.code                   ;declare code segment
Start:  mov Ax,@Data    ;copy address of data
        mov Ds,Ax       ;segment into DS
        lea Dx,Hello    
        mov Ah,09h      ;define DOS function number 
        int 21h         ;call DOS function to display 
        mov Ah,4Ch      ;define DOS function to exit
        mov Al,00h      ;with code sero
        int 21h         ;exit to DOS
        
.Data                   ;declare data segment 
Hello Db 'Hello!$'      ;define string to be
displayed
.Stack                  ;declare stack segment
End Start
