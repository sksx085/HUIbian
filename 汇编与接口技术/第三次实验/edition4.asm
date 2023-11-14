CODE SEGMENT
  START:MOV DX,283H
        MOV AL,00111000B  ;0号计数器，读写两个字节，4号方式，二进制计数
        OUT DX,AL         ;写入控制命令字寄存器
        MOV DX,280H       ;0号计数器数据口
        MOV AL,E8H        ;设置计数初值的低字节
        OUT DX,AL         ;先送低字节到0号计数器
        MOV AL,03H        ;设置计数初值的高字节
        OUT DX,AL         ;再送高字节到0号计数器
        MOV AH,4CH        ;程序结束
        INT 21H
CODE ENDS
     END START