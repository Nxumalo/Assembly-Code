;..............................................................................
; Data Segment 
DATA SEGMENT 
CLS    DB      1Bh         ; Esc 
       DB      '[2J'       ; clearing all screen 
       DB      '$'         ; end of string 
DATA   ENDS 
;..............................................................................
; code segment 
       mov     ax,DATA     ; address of data segment
       mov     ds,ax       ;
       lea     dx,CLS      ; DS:DX - ESC string
       mov     ah,9        ; function
       int     21h         ; MS-DOS service
;..............................................................................
; clearing all the screen by writing into video buffer
      
       mov     ax,0B800h   ; segment address of video buffer
       mov     es,ax       ; ES points to output segment 
       xor     di,di       ; output from the beginning of screen
       mov     ah,20h      ; attribute (black on green)
       mov     al," "      ; character to fill - blank
       mov     cx,2000     ; quantity of characters to output
       cld                 ; direction - forward !!!
       rep     stosw       ; ES:[DI] - output character
;..............................................................................
 EXTRN COLOUR : FAR
;..............................................................................
; clearing all the screen using subroutine COLOUR.ASM
 
       mov     ah,1Fh      ; attribute 
       mov     ch,1        ; start row 
       mov     dh,25       ; end row 
       call    COLOUR      ; clear screen
;..............................................................................
       
