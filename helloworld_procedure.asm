Title Hello Example Program        ;title is not necessary
.model small                       ;declare memory model
.code                              ;declare code segment 
main proc                          ;declare main procedure 
     mov ax,@data                  ;copy address of data
     mov ds,ax                     ;segment into DS
     lea dx,Hello                       
     call Display_Dx               ;call procedure
     mov ah,4ch                    ;define DOS function to exit 
     mov al,00h                    ;with code zero
     int 21h                       ;exit to DOS
     
     ;Procedure section
     
Display_Dx Proc                    ;deckare procedure Display_DX
         Ret                       ;return to MAIN
Display_Dx ENDP                    ;end of procedure

     ;End of procedure section
     
Main ENDP                          ;end of code section

.Data                              ;declare data segment 
Hello DB 'Hello! Neo :--:. $'      ;define string to display

.Stack                             ;Declare stack segment 
      DB 128 Dup (?)               ;reserve 128 byte for stack
       
      END Main                     ;end of program
      
