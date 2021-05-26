;.............................................................................
DATA SEGMENT
TEXT DB "This is my string", CR,LF,"$"
DATA ENDS 
CR EQU 13          ; carriage return
LF EQU 10          ; line feed ASCII CODE
;.............................................................................
; Code Segment 

       push ds          ; save segment register
       mov ax,DATA      ; address of data segment
       mov ds,ax        ; set DS to start of data segment
       mov ah,9         ; function 09h - output text string
       lea dx,TEXT      ; DS:DX point to text string
       int 21h          ; DOS service call
       pop ds           ; restore segment register
       
; After this the cursor will be placed at the beginning 
; of the next line on the screen (CR and LF will be processed)
;....................................................................,.........
