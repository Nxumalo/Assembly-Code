TITLE hello example program ; title is not necessary 

OurCode Segment Para Public 'Code'           ; declare code segment 
         Assume CS:OurCode, DS:OurData, SS:OurStack
Start:         Mov ax, OurData      ;copy address of data
               Mov DS,ax            ;segment into ds 
               Lea Dx,Hello         ;address of message
               Mov AH,09h           ;DOS service "output text string"
               Int 21h              ;DOS  service call
               Mov AH,09h           ;DOS serice "terminate process"
               Mov AL,00h           ;return code zero
               Int 21h              ;DOS service call
OurCode                  ENDS       ;end of code segment 

OurData         Segment Para Public 'Data'   ;declare data segment 
Hello        DB 'Hello!$'                    ;define string to display
OurData                  ENDS                ;end of segment 

OurStack Segement Para Stack 'Stack'         ;declare stack segment
        DB 64 Dup(?)                         ;reserve 64 bytes
OurStack         ENDS                        ;end of stack segment
                  
                  END     Start              ;end of program

