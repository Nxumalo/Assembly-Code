.model large
HiBios segment at 0F000h
       org 0FFFEh
PcType db ?
HiBios ends

.code
      assume es: HiBios
      
Begin: mov ax,@data
       mov ds,ax
       mov ax,HiBios
       mov es,ax
       mov cx,Ltable
       mov dl,PcType
       
Search: mov bx,cx
        cmp dl,TypeTbl[bx-1]
        je EndSear
        loop Search
        
EndSear: mov al,cl
         mov ah,4Ch
         int 21h

.data
         db 0
 TypeTbl db 0F8h
         db 0F9h
         db 0FAh
         db 0FBh
         db 0FCh
         db 0FDh
         db 0FEh
         db 0FFh
         db 09Ah
         db 030h
         db 02Dh
         
Ltable equ $-TypeTbl
       end begin
      
