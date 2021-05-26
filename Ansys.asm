;.................................................................................
; The DATA segment 
DATA SEGMENT
POS DB 1Bh, '['     ; beginning of ESC sequence
    DB '[11; 19']   ; 11 row, 19 - column
    DB 'H'          ; operation "position cursor"
    DB '$'          ; end of string 
DATA ENDS
;.................................................................................
; The Code Segemet
;.................................................................................
;Positioning the cursor int (11,19)
   mov  ax,DATA     ; address of DATA segment
   mov  ds,ax       ; access DATA through DS register
   lea  dx,POS      ; DS:DX point to ESC sequence
   mov  ah,9        ; function 09h - output text string
   int  21h         ; MS-DOS service call

;................................................................................
; Changing the size of the cursor 
   
    mov ah,1        ; function
    mov ch,3        ; CH - starting line for cursor
    mov cl,13       ; CL - ending line for cursor 
    int 10h         ; BIOS service
;................................................................................
; Switching the cursor off by position it outside the screen

    xor bh,bh       ; page number 0
    mov dh,25       ; row = 25
    mov d1,80       ; column = 80
    mov ah,2        ; function 02 - position cursor
    int 10h         ; BIOS video service
    end
    
