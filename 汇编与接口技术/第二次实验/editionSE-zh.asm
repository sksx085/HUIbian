code segment 		;初始化代码段
assume cs:code
start:		;初始化，设置A口B口工作方式
mov dx,293h 	;送入命令口地址
mov al,10001001b 		;传入命令字
out dx,al

;显示A口输入的数并循环移位
xor ax,ax
mov bl,0
lop:      
mov dx,292h  
in al,dx   
cmp al,ah  
jz next   
mov ah,al
mov bl,ah
rol bl,1    
next: 
ror bl,1   
mov al,bl
mov dx,291h
out dx,al
mov cx,3fffh

;显示8255-A 
doit:
 ;显示8
 mov dx,291h
 mov al,00000000b
 out dx,al
 mov dx,290h
 mov al,7fh;数字8所对应的段码
 out dx,al
 mov dx,291h
 mov al,00100000b
 out dx,al
 call DELAY		;延时程序，防止数字跳转过快，便于观察
 
 ;显示2
 mov dx,291h
 mov al,00000000b
 out dx,al
 mov dx,290h
 mov al,5bh;数字2所对应的段码
 out dx,al
 mov dx,291h
 mov al,00010000b
 out dx,al
 call DELAY

 ;显示5
 mov dx,291h
 mov al,00000000b
 out dx,al
 mov dx,290h
 mov al,6dh;数字5所对应的段码
 out dx,al
 mov dx,291h
 mov al,00001000b
 out dx,al
 call DELAY

 ;显示5
 mov dx,291h
 mov al,00000000b
 out dx,al
 mov dx,290h
 mov al,6dh;数字5所对应的段码
 out dx,al
 mov dx,291h
 mov al,00000100b
 out dx,al
 call DELAY

 ;显示-
 mov dx,291h
 mov al,00000000b
 out dx,al
 mov dx,290h
 mov al,40h;数字-所对应的段码
 out dx,al
 mov dx,291h
 mov al,00000010b
 out dx,al
 call DELAY
 
 ;显示A
 mov dx,291h
 mov al,00000000b
 out dx,al
 mov dx,290h
 mov al,77h;数字A所对应的段码
 out dx,al
 mov dx,291h
 mov al,00000001b
 out dx,al
 call DELAY
 loop doit     
 jmp lop 
 
;延时程序 
 DELAY PROC 
    PUSH BX
    PUSH CX
    MOV BX,0FFFFH
DL1:MOV CX,06FH
DL2:DEC CX
    JNZ DL2
    DEC BX 
    JNZ DL1
    POP CX
    POP BX
    RET
DELAY ENDP

code ends
end start
