TITLE Hello Example Program     ;title is not necessary
OurProg SEGMENT PARA 'CODE'     ;declare code segment
        ORG 100H
        ASSUME CS:OurProg, DS:OurProg, ES:OurProg,SS:OurProg ; information on program instruction
Start:  JMP Begin         ;jump over data definition
Hello   DB ' Hello!$'     ;define string to display
Begin:  LEA dx,Hello      ;DS:DX - effective address of string
        MOV AH,09h        ;function 09h - output text string
        INT 21h           ;DOS service call
        MOV ax,4C00h      ;function 4Ch - terminate process
        INT 21h           ;DOS service call
OurProg ENDS              ;end of program segment 
        END    Start 
