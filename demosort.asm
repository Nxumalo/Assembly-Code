Extrn Bsort : Far
.model small
.stack 100h
.data

bell           equ 07
lf             equ 10
cr             equ 13
text0          db cr,lf,cr,lf "String sorting: demo program."
               db "Press any key to continue ...", bell cr,lf,"$"
text1          db cr,lf,"Outputting an original sequence:"
               db "Press any key ... ",bell cr,lf,"$"
text2          db cr,lf
array2         db "yyyyyy eeeee 123456 zzzzzz 000000 qqqqqq
               db "$"
text3          db cr,lf,cr,lf," Increasing sequence. "
               db " Press any key ... ",bell,cr,lf,"$"
text4          db cr,lf
array4         db "yyyyyyy eeeeee 1234567 zzzzzz 000000 qqqqqqq","$"
text5          db cr,lf,cr,lf,"Decreaseing sequence."
               db " Press any key .... ",bell,cr,lf,"$"
ertxt          db cr,lf,cr,lf, "Sorting error."
               db "Press any key .... ",bell,cr,lf,"S"
vmode          db 0
.code
OutMsg         macro Txt
               lea dx,Txt
               mov ah,09h
               int 21h
WaitKey        macro
               mov ah,0
               int 16h
.startup
               OutMsg Text0
               OutMsg Text1
               OutMsg Text2
               mov ax,0
               mov cx,8
               mov dx,6
               lea si,array2
               call bsort
               cmp ax,0
               jnz ErSort
               OutMsg Text3
               OutMsg Array2
               mov ax,1
               mov cx,8
               mov dx,6
               lea si,array4
               call bsort
               cmp ax,0
               jnz erSort
               OutMsg Text5
               OutMsg Array4
ExtProgr:.exit
ErSort: OutMsg ErTxt
.exit     1
         end
               
