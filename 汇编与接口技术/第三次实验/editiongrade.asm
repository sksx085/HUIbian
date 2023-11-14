;2,3方式级联
DATA SEGMENT
DATA ENDS
CODE SEGMENT
	      ASSUME CS:CODE,DS:DATA
	START:MOV    AX,DATA
	      MOV    DS,AX          	;开始程序，没啥实际意义
	      MOV    DX,283H        	;命令口
	      MOV    AL,00110100B   	;0计数器，读写两个字节，使用方式2，时间常数使用二进制计数
	      OUT    DX,AL          	;写入控制命令字寄存器
	      MOV    AX,0100H       	;设置计数初值，因为是两个字节，所以分两次输入，中间需要将AH赋值给到AL
	      MOV    DX,280H        	;0号计数器数据口
	      OUT    DX,AL          	;先送低字节到0号计数器
	      MOV    AL,AH          	;取高字节送AL
	      OUT    DX,AL          	;再送高字节到0号计数器
	      MOV    DX,283H        	;命令口
	      MOV    AL,76H         	;01110110，即使用1号计数器，同样读写两个字节，使用方式3，二进制计数
	      OUT    DX,AL          	;写入新的控制命令字寄存器
	      MOV    AX,0010H       	;设置计数初值
	      MOV    DX,281H        	;1号计数器数据口
	      OUT    DX,AL          	;先送低字节到1号计数器
	      MOV    AL,AH          	;取高字节送AL
	      OUT    DX,AL          	;再送高字节到1号计数器
CODE ENDS                   		;程序结束
END START

