.model large

ExtDat segment 'DATA'         ;this defines extra data segment
;..............................................................................................
StringD db 'This must have enough space to fit a source string'

;..............................................................................................

ExtDat ends

;..............................................................................................

.data 
;This is orderniary Data segment


;..............................................................................................

StringS db 'This is the source string'
LSource equ $ - StringS


;..............................................................................................

.code 
.startup 
        mov ax,seg StringS     ;load segnent address of StringS
        mov ds,ax              ;DS point to segment of StringS
        mov ax,seg StringD     ;load segment address of StringD
        mov es,ax              ;ES points to segment of stringS
        mov si,offset StringS  ;DS:SI point to StringS
        mov di,offset StringD  ;ES:DI point to StringD
        mov cx,LSource         ;load length of StringS into CX

rep        movsb                  ;copy strings (size in CX);
    

;..............................................................................................
.exit();
           end
     
;..............................................................................................      
