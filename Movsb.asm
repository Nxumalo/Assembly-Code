.model large
ExtDat segment 'DATA'   ;this defines extra data segment
StringD db ' This must have enough space to fit a source string'
ExtDat ends
.data 
;this is ordinary DATA segment 
StringS db 'This si the source string'
LSource equ $-StringS

.code 
.startup 
          mov ax,seg StringS    ;load segment address of StringS
          mov ds,ax             ;DS points to segment of StringS
          mov ax,seg StringD    ;load segment address of StringD
          mov es,ax             ;ES points to segment of StringS
          mov si,offset StringS ;DS:SI point to StringS
          mov di,offset StringD ;ES:DI point tp StringD
          mov cx,LSource        ;load length of StringS into CX
rep       movsb
.exit     
          end
