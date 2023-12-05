SSEG SEGMENT
    DW 100 DUP(?)
SSEG ENDS

;数据段，存储LED操作，中断向量以及中断次数标准
DSEG SEGMENT
    OLD_OFF DW ?
    OLD_SEG DW ?
    N DW 5
    LED DB 0FFH
DSEG ENDS

CSEG SEGMENT
    ASSUME CS:CSEG,DS:DSEG,SS:SSEG
START:
    MOV AX,DSEG
    MOV DS,AX

;开放中断屏蔽
    CLI
    IN AL,21H
    AND AL,0F3H	;11110011
    OUT 21H,AL

;中断主程序
    CALL SET_TABLE
;对8255进行初始化
    MOV DX,283H
    MOV AL,90H
    OUT DX,AL
;中断程序
    XOR CX,CX	;CX清零
S1:
    STI
    ;设置8255的PC6输出高电平，触发中断
    MOV DX,282H
    MOV AL,40H	;01000000
    OUT DX,AL
;LED
    MOV DX,281H
    MOV AL,0FFH
    OUT DX,AL
    CALL DELAY
    MOV AL,00H
    OUT DX,AL
    CALL DELAY
    MOV DX,282H
    MOV AL,00H
    OUT DX,AL
    ;统计中断次数
    CMP CX,N
    JNZ S1
;中断结束，恢复中断向量
    CLI
    CALL RECOVER_TABLE
;中断结束恢复中断屏蔽
    IN AL,21H
    OR AL,0CH
    OUT 21H,AL
    STI
    MOV AH,4CH
    INT 21H
    
;修改中断向量
SET_TABLE PROC
    ;寄存器压栈保护
    PUSH DS
    PUSH DI
    PUSH BX
    
    MOV AX,0;
    MOV DS,AX
    MOV DI,4*0BH
    ;获取原中断向量
    MOV BX,[DI]
    MOV OLD_OFF,BX
    MOV BX,[DI+2]
    MOV OLD_SEG,BX
    ;设置新的中断向量
    MOV BX,OFFSET SW_INT
    MOV [DI],BX
    MOV BX,SEG SW_INT
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
    ;实现中断向量恢复句
    MOV BX,OLD_OFF
    MOV [DI],BX
    MOV BX,OLD_SEG
    MOV [DI+2],BX
    
    POP BX
    POP DI
    POP DS
    RET
RECOVER_TABLE ENDP

;中断服务程序
SW_INT PROC
    PUSH AX
    PUSH DX
    CLI
    INC CX		;统计中断次数
    
    MOV AL,20H
    OUT 20H,AL
    POP DX
    POP AX
    STI
    IRET
SW_INT ENDP

;因为程序目的是LED自发闪烁，为确保观测效果设定时延
DELAY PROC
    PUSH BX
    PUSH CX
    MOV CX,0FFFH
DL1:    
    MOV BX,0FFFH
DL2:
    DEC BX
    JNZ DL2
    DEC CX
    JNZ DL1
    POP CX
    POP BX
    RET
DELAY ENDP

CSEG ENDS
END START
