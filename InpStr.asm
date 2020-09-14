.model small
.stack
.data
CR equ 0Dh
LF equ 0Ah
Msg16   db CR,LF,'BIOS service: Type a string and press Enter:'
        db CR,LF,'$'
Msg21   db CR,LF,'Dos service: Typer a string and press Enter:'
        db CR,LF,'$'
MsgOut  db 'The Following text entered: ' ,'$'
ReqInp  db 255
FactInp db 0
Str1    db 256 dup('$')
.code 
.startup
;===        Output mesage about BIOS service 
            mov ah,09                ;function 09 - output text spring 
            lea dx,Msg16             ;address of message 'BOPS service'
            int 21h                  ;DOS service call 
;===        Creating string from characters (BIOS service)            
            mov bx,0                 ;BX - number of current character 
Next16:     mov ah,0                 ;function 00h - read character 
            int 16h                  ;BIOS keyboard service
            cmp al 0                 ;special key?
            je  Next16               ;ignore special key and read next
            mov Str1[bx],al          ;store current character into string 
            inc bx                   ;increase counter to store next char
            cmp al,CR                ;ENTER key [ressed (Carriage Return)?
            jne Next16               ;if not, read next character
;===        Append character CR and LF to the end of the String            
            mov Str1[bx],LF          ;add Line Feed to the end of string 
            mov Str1[bx+1],'$'       ;End Message character
;===        Output header and string entered            
            mov ah,09                ;function 09 - output text string 
            lea dx,Str1              ;address of message 'Text entered'   
            int 21h                  ;DOS service call
;===        Output message about DOS service             
            mov ah,09                ;function 09 - outout text string  
            lea dx,Msg21             ;address of message 'BIOS service'
            int 21h                  ;DOS service call
;===        Input text string (DOS service)            
            mov ah,0Ah               ;function 0Ah - input text string    
            lea dx,ReqInp            ;DS:DX - address of input buffer    
            int 21h                  ;DOS service call
;===        Append character CR and LF to the end of the string             
            mov bl,FactInp           ;length of string actually read    
            mov bh,0                 ;high byte of length =0 (length < 256)   
            mov Str1[bx],CR          ;Append Carriage Return    
            mov Str1[bx+1],LF        ;Append Line Feed    
            mov Str1[bx+2],'$'       ;Append End of Message
;===        Output header and string entered            
            mov ah,09                ;function 09 - output text string    
            lea dx,MsgOut            ;address of message 'Text entered'   
            int 21h                  ;DOS service call   
            lea dx,Str1              ;address of string obtained   
            int 21h                  ;DOS service call   
.exit
end
            
            
           
