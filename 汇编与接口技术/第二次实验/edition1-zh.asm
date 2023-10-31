    .model small 
    .386 ;老师说要加...
DSEG SEGMENT
    PORTA EQU 280H; A端口
    PORTB EQU 281H; B端口
    PORTD EQU 283H; 命令与状态口
DSEG ENDS



CSEG SEGMENT
ASSUME CS:CSEG,DS: DSEG
START: 
    
    MOV AX,DSEG;
    MOV DS,AX;

    MOV DX,PORTD
    MOV AL,90H;1001 0000 初始化命令：A端口0方式输入，B端口0方式输出
    OUT DX,AL;将初始化命令输入到命令状态口
    
    MOV DX,PORTA;
    IN AL,DX; 输入初始开关状态到AL
    MOV CL,AL; CL保存流水状态
    MOV BL,AL; BL保存旧的开关状态, 在此初始化BL
LP1:
    MOV DX,PORTA
    IN AL,DX
    MOV BH,AL;  BH存放新的开关状态
    
    CMP BH,BL; 判断开关状态是否发生改变
    JZ LIGHT; 如果开关状态未变，则调转到LIGHT
    MOV BL,BH; 否则旧的开关状态变为新状态
    MOV CL,BL; 把当前开关状态存入CL, 更新流水线状态
    
LIGHT:
    MOV AL,CL; AL中存入流水线状态
    MOV DX,PORTB;
    OUT DX,AL; 灯亮

    CALL DELAY1 
    ROR AL,1;右移一个灯
    MOV CL,AL; CL 保存下一个要亮的灯
    
    JMP LP1;
    
DELAY1 PROC ;子程序
 mov cx,25
    AGAIN:
    mov dx,0ffffh
    delay:dec dx
    jnz delay
    LOOP AGAIN
RET
DELAY1 ENDP



CSEG ENDS
END START 

