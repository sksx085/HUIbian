SSEG SEGMENT
    DW 100 DUP(?)
SSEG ENDS

;设置保存中断向量地址的变量
DSEG SEGMENT
    OLD1_OFF DW ?
    OLD1_SEG DW ?
    OLD2_OFF DW ?
    OLD2_SEG DW ?
;题目要求中断10次，设置变量用于对比
    N DW 10
;通过8255设置LED灯打开位置
    LED1 DW 00000100B
    LED2 DW 00100000B
DSEG ENDS

CSEG SEGMENT
    ASSUME CS:CSEG,DS:DSEG,SS:SSEG
START:
    MOV AX,DSEG
    MOV DS,AX

;开放主片的中断屏蔽
    CLI
    IN AL,21H
    AND AL,0F3H	;11110011
    OUT 21H,AL

;开放从片的中断屏蔽
    IN AL,0A1H
    AND AL,0FBH	;11111011
    OUT 0A1H,AL

;中断主程序
    CALL SET_TABLE
;对要用到的8255进行初始化
    MOV DX,283H		;8255的命令口地址
    MOV AL,90H		;使用0方式
    OUT DX,AL		;送入命令口
;中断程序
    XOR CX,CX
;统计中断次数，超过10次则退出
S1:
    STI
    HLT		
    CMP CX,N
    JNZ S1
;中断结束，恢复中断向量
    CLI
    CALL RECOVER_TABLE
;中断结束恢复屏蔽
    IN AL,21H
    OR AL,0CH		;00001100
    OUT 21H,AL
    IN AL,0A1H
    OR AL,04H		;00000100
    OUT 0A1H,AL
    STI
    MOV AH,4CH		;程序结束
    INT 21H
    
;修改中断向量
SET_TABLE PROC
    PUSH DS
    PUSH DI
    PUSH BX
    
    MOV AX,0;
    MOV DS,AX
    MOV DI,4*0BH
    ;获取原中断向量
    MOV BX,[DI]
    MOV OLD1_OFF,BX
    MOV BX,[DI+2]
    MOV OLD1_SEG,BX
    ;设置新的中断向量
    MOV BX,OFFSET SW1_INT
    MOV [DI],BX
    MOV BX,SEG SW1_INT
    MOV [DI+2],BX
    
    MOV DI,4*72H
    ;获取原中断向量
    MOV BX,[DI]
    MOV OLD2_OFF,BX
    MOV BX,[DI+2]
    MOV OLD2_SEG,BX
    ;设置新的中断向量
    MOV BX,OFFSET SW2_INT
    MOV [DI],BX
    MOV BX,SEG SW2_INT
    MOV [DI+2],BX
    
    POP BX
    POP DI
    POP DS
    RET
SET_TABLE ENDP

;中断向量恢复
RECOVER_TABLE PROC
    PUSH DS
    PUSH DI
    PUSH BX
    
    MOV AX,0;
    MOV DS,AX
    MOV DI,4*0BH
    ;实现中断向量恢复语句
    MOV BX,OLD1_OFF
    MOV [DI],BX
    MOV BX,OLD1_SEG
    MOV [DI+2],BX
    
    MOV DI,4*72H
    ;实现中断向量恢复语句
    MOV BX,OLD2_OFF
    MOV [DI],BX
    MOV BX,OLD2_SEG
    MOV [DI+2],BX
    
    POP BX
    POP DI
    POP DS
    RET
RECOVER_TABLE ENDP

;中断服务程序
SW1_INT PROC
    PUSH AX
    PUSH DX
    CLI
    INC CX			;统计中断次数，如果超过10次则程序退出
    MOV AX,LED1
    MOV DX,281H		;8255的B口地址
    OUT DX,AX		;送到命令口
    XOR AX,00000100B	;异或语句实现指定LED对应输出电平转换
    MOV LED1,AX
    MOV AL,20H		
    OUT 20H,AL
    POP DX
    POP AX
    STI
    IRET
SW1_INT ENDP

;另一个中断服务程序
SW2_INT PROC
    PUSH AX
    PUSH DX
    CLI
    INC CX			;统计中断次数
    MOV AX,LED2
    MOV DX,281H		;8255的B口地址
    OUT DX,AX		;送到命令口
    XOR AX,00100000B	;异或语句实现指定LED对应输出电平转换
    MOV LED2,AX
    MOV AL,20H
    OUT 20H,AL
    MOV AL,20H;?
    OUT 0A0H,AL;?
    POP DX
    POP AX
    STI
    IRET
SW2_INT ENDP
CSEG ENDS
END START
