Segment Para Public 'Code'
Assume CS:OurCode, DS:OurData, SS:OurStack
         Mov ax, OurData
         Mov DS,ax
         Lea Dx,Hello
         Mov AH,09h
         Int 21h
         Mov AH,09h
         Mov AL,00h
         Int 21
Ends
Segment Para Public 'Data'
        Db 'Hello!$'
Ends
Segement Para Stack 'Stack'
        Db 64 Dup(?)
Ends
End     Start

