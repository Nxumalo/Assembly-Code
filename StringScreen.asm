;.............................................................................
; determining offset if character in video buffer

      call VIDTYP       ; DX - segment address of video buffer
      mov  bl,al        ; store adapter type in BL
      mov  ds,dx        ; DS points to video buffer
      mov  si,1000h     ; offset of videopage 2
      mov  ax,12        ; row number(0  - 25)
      mov  bh,80*2      ; multiplier - length of one row
      mul  bh           ; AX - offset of row 12
      add  ax,50*2      ; offset caused by position
      add  si,ax        ; offset in video buffer

; testing video adapter (CGA ?)

cycle0:  cmp bl,1       ; is it CGA?
         jne RdChar     ; no, it's safe to read
         mov dx,3DAh    ; status register

; waiting for completion of current retrace

cycle1:  in    al,1       ; read status register
         test  al,1       ; is retrace being executed now?
         jnz   cycle1     ; yes, wait for completion

; testing if reading without snow is possible 

cycle2:  in    al,dx      ; reading status register
         test  al,1       ; is retrace executed now, may we read?
         jz    cycle2     ; no, go on testing
         
; reading character and attribute from video buffer (DS:[SI])

RdChar:  mov   ax,[si]    ; AH - attribute; AL - character
