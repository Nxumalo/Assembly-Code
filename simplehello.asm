.model tiny
.data
Hello Db 'Hello! Neo Nxumalo the Matrix has found You :--:---:--. $'
.code
.startup
          lea Dx,Hello World
          mov AH,09h
          int 21h
          mov ax,4C00h
          int 21
          End
