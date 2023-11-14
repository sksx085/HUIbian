CODE SEGMENT
     START:MOV DX,283H
           MOV AL,00110110B     ;0号计数器，读写两个字节，3号方式，二进制计数
           OUT DX,AL            ;写入控制命令字寄存器
           MOV DX,280H          ;0号计数器数据口
           MOV AL,F4H           ;设置计数初值的低字节
           OUT DX,AL            ;先送低字节到0号计数器
           MOV AL,01H           ;设置计数初值的高字节
           OUT DX,AL            ;再送高字节到0号计数器
           MOV AH,4CH           ;程序结束
           INT 21H
CODE ENDS
     END START

;3号方式（也称为"square wave generator"方式）：
;在3号方式下，计数器产生一个方波输出。
;当计数器的计数值减小到0时，输出状态翻转（从高电平变为低电平或反之）。
;这种方式通常用于产生可调节占空比的方波信号。
;time : 500 (01F4)