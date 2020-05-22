.model small
.code
Start:  mov ax,@Data
        mov Ds,ax
        lea Dx,Hello
        mov AH,09h
        int 21h
        mov Ah,4Ch
        mov Al,00h
        Int 21h
.Data
Hello Db 'Hello!$'
displayed
.Stack
End Start
