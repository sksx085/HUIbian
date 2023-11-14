CODE SEGMENT
     START:MOV DX,283H
           MOV AL,00110100B     ;0号计数器，读写两个字节，2号方式，二进制计数
           OUT DX,AL            ;写入控制命令字寄存器
           MOV DX,280H          ;0号计数器数据口
           MOV AL,E8H           ;设置计数初值的低字节
           OUT DX,AL            ;先送低字节到0号计数器
           MOV AL,03H           ;设置计数初值的高字节
           OUT DX,AL            ;再送高字节到0号计数器
           MOV AH,4CH           ;程序结束
           INT 21H
CODE ENDS
     END START

;2号方式（也称为"rate generator"方式）：
;在2号方式下，计数器以固定的速率生成脉冲。
;当计数器的计数值从最大值减小到0时，触发一个中断。
;这种方式通常用于创建固定频率的时钟信号或用于控制设备的速率
;time : 1000(03E8)