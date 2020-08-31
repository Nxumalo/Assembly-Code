;Array Sorting; demo program
;Author: Fraser Nxumalo, University of the Western Cape 2020
;*****************************************************************************************************************************
Extrn Bsort : Far
.model small
.stack 100h
.data
;-----------------------------------------------------------------------------------------------------------------------------
bell           equ 07     ;sound signal
lf             equ 10     ;Line Feed 
cr             equ 13     ;Carriage Return 
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
vmode          db 0       ;video mode saved

.code
OutMsg         macro Txt
               lea dx,Txt     ;address of message
               mov ah,09h     ;function 09h - output text string 
               int 21h        ;DOS service call
endm               
               
WaitKey        macro
               mov ah,0       ;function 0 - wait for key pressed 
               int 16h        ;BIOS keyboard service
endm
;---------------------------------------------------------------------------------------------------------------------
.startup
               OutMsg Text0   ;output initial message 
WaitKey  
               OutMsg Text1   ;output initial message
               OutMsg Text2   ;output initial message
WaitKey       
;Call subroutine demosort - sorting array (increasing) 
               mov ax,0       ;ax = 0 for increasing sequence
               mov cx,8       ;length of record
               mov dx,6       ;number of records 
               lea si,array2  ;DS:[SI] - address will be sorted 
               call bsort     ;perform sorting 
               cmp ax,0       ;normal return?
               jnz ErSort     ;if not,output errpr amd exit
               OutMsg Text3   ;output array sorted
;WaitKey 
;Call subroutine demosort - sorting arrau (decreasing)
               OutMsg Array2  ;AX = 1 for decreasing sequence 
               mov ax,1       ;length of record 
               mov cx,8       ;number of records 
               mov dx,6       ;DS:[SI] - address will be sorted
               lea si,array4  
               call bubblesort ;perform sorting 
               
               cmp ax,0       ;normal return?
               jnz erSort     ;if not,output error and exit 
               OutMsg Text5   ;output header 
               OutMsg Array4  ;output array sorted
WaitKey
;-----------------------------------------------------------------------------------------------------------------------------------------------------
;Terminate program amd exit to DOS 
ExtProgr:.exit    0
ErSort: OutMsg ErTxt
.exit     1
         end
               
