CODE       SEGEMENT WORD PUBLIC 
public GetScan
assume cs:code 
GetScan Proc far pascal, Prompt: byte, SpInd: far ptr byte
        
        mov ah,02
        mov dl,Prompt
        int 21h 
        les bx,SpInd     ; effective address of SpInd into ES:BX
        mov byte ptr es:[bx],0      ; SpInd := False
        mov ah,01h       ; function 01h - accept character 
        int 21h          ; DOS service call
        cmp al,0         ; special key pressed?
        jne ExSubr       ; if not, return to caller
        mov byte ptr es:[bx],1   ; SpInd := True
        int 21h          ; DOS service call
ExSubr:     ret          ; return to calling program
GetScan     endp
            end
