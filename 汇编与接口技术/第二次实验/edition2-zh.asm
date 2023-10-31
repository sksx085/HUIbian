DATA SEGMENT
DATA ENDS

CODE SEGMENT
    ASSUME CS:CODE,DS:DATA
START:MOV AX,DATA
MOV DS,AX

MOV DX,283H	;命令口地址
MOV AL,98H     ;10011000（0方式，输入，输入，0方式，输出，输出）
OUT DX,AL	;送到命令口

MOV DX,281H   	;CLEAR PORT B
MOV AL,00H	;清空B口
OUT DX,AL	;送到命令口

WAIT1:MOV DX,280H	;A口
IN AL,DX			;获取当前命令行情况
AND AL, 11111111B		;判断是否有开关已经打开
JZ WAIT1			;如果没有，继续循环等待

;将获取的A口信息进行调整，因为可能有多个开关被打开之后再运行的程序
MOV CX,08H	;设置最大循环量	
MOV BL,01H	;判断开关位置的条件	
LP1:MOV DL,AL	;将获取的A口进行调整
AND DL,BL	;判断BL中为1的位置的开关是否打开
JNZ OT		;JNZ说明打开的开关就是当前BL对应的那个，可以跳出循环，开始点亮
SHL BL,1H		;如果不是，将BL逻辑左移一位
LOOP LP1		;再次循环
OT:MOV AL,DL	;找到对应的

;跑马灯的具体实现部分
LP2:MOV DX,281H	;B口地址
    OUT DX,AL	;将命令送到B口
    CALL DELAY	;调用延时，放置跑马灯太快观察不到
    ROR AL,01H	;循环右移一位，完成跑马灯的要求
    JMP LP2	;继续循环，一直进行上述步骤

;时延部分
DELAY PROC 
    PUSH BX
    PUSH CX
    MOV BX,0FFFFH
DL1:MOV CX,0FH	;外层循环
DL2:DEC CX	;内层循环，两层循环的目的是延长时延时间
    JNZ DL2
    DEC BX 
    JNZ DL1
    POP CX
    POP BX
    RET
DELAY ENDP

CODE ENDS
END START
