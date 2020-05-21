.model small
.code
Begin:

sub ax,ax
add ax,1
add ax,0FFFFh
add ax,1

sub ax,ax
sub ax,1
add ax,2

sub ax,ax
mov ax,OFFFFh
add ax,1
add ax,0
sub ax,1

sub ax,ax
mov ax,8
add ax,8
add ax,0
sub ax,1

sub ax,ax
mov a1,128
add al,128

sub ax,ax
add ax,8000h
sub ax,7FFFh

sub ax,ax
mov al,16
mov bx,16
mul bl

sub ax,ax
add ax,1
add ax,10h
add ax, 0100h
mov ax,4C00h
int 21h
.data
.stack
end begin


