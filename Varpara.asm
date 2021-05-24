Title Hello Procedure Example Program 
.MODEL SMALL
.CODE
MAIN PROC
Start:                        ;procedure displays string at
                              ;the data segment named Hi
            CALL DISPLAY_Hi
            MOV AX,4C00h
            INT 21h
            
;Procedure section 

DISPLAY_Hi  ENDP

;End of procedure section

Main  ENDP
.DATA
Hi  DB "Hello!$"
.STACK  
    DB 128 DUP ('STACK128')   ;reserve 1024 bytes for stack
    END MAIN
            
            
            
