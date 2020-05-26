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
                  mov       ah,0Ah
                  lea       dx,StrBuf
                  int       21h
                  .IF       ActLen<1
                  .exit     1
                  .ENDIF
                  lea       di,Str2
                  lea       si,Str1
                  mov       ch,0
                  mov       cl,ActLen
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
                  cld
repe              cmpab
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
                  
