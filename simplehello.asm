.model tiny
.data
Hello Db 'Hello!$'
.code
.startup
          lea Dx,Hello
          mov AH,09h
          int 21h
          mov ax,4C00h
          int 21
          End
