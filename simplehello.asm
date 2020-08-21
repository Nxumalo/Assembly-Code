TITLE Hello A Simple Hello    ;title is not necessary
.model tiny
.data
Hello Db 'Hello! Neo Nxumalo the Matrix has found You :--:---:--. $' ;define string to display
.code
.startup
          lea Dx,Hello World            ;DS:DX -  effectove address of string
          mov AH,09h                    ;function 09h -  output text string
          int 21h                       ;DOS service call
          mov ax,4C00h                  ;function 4Ch - terminate process 
          int 21h                       ;DOS service call
          End
