.model small 
.stack
.data
StrBuf            db        80
ActLen            db        0
Str1              db        80    dup   ('')
Str2              byte      'ABCDEFGHIJKLMNOPQRSTUVWXYZ'
.code 
                  include   maclib.inc
.startup
                  push      dx
                  pop       es
                  NewLine
                          OutMsg  'Enter alphabet character: ABC... in capital letters:'
                  NewLine
                  mov       ah,0Ah        ;function 0Ah - input stromg 
                  lea       dx,StrBuf     ;DS:DX - buffer address
                  int       21h           ;DOS service call 
                  .IF       ActLen<1
                  .exit     1
                  .ENDIF
                  lea       di,Str2       ;ES:DI point to string 2 (comparand)
                  lea       si,Str1       ;DS:SI point to string 1 (entered)
                  mov       ch,0          ;clear high byte of CX
                  mov       cl,ActLen     ;CX contaos length of string
                  .IF       cx > LengthOf Str2
                  mov       cx,LengthOf Str2
                  .ENDIF
                  NewLine
                  OutMsg    'Entered text: '
                  OutBytes  Str1,cx
                  NewLine
                  OutMsg    'Compared with: '
                  OutBytes  Str2,LengthOf Str2
                  NewLine
                  cld                     ;process string from left to right 
repe              cmpab                   ;compare strings
                  .IF ZERO?
                            OutMsg 'Right'
                  .Else
                  mov       al,Action
                  cbw
                  sub       ax,cx
                  OutMsg    'Character at position '
                  OutInt    ax
                  OutMsg    ' is: "'
                  OutChar[si-l]
                  OutMsg    '"; must be"'
                  OutChar[di-l]
                  .ENDIF
                  NewLine
.exit 0
                  end
                  
