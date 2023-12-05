STACKS   SEGMENT 
STA       DW 512 DUP(?)
TOP       EQU  LENGTH STA
STACKS     ENDS

DATA        SEGMENT
IO0809A     EQU       298H
LED         DB        3FH,06H,5BH,4FH,66H,6DH,7DH,07H,7FH,6FH,77H,7CH,39H,5EH,79H,71H
TMP_1        DB    ?
TMP_2        DB    ?
TMP          DB    ?
DATA        ENDS

CODE         SEGMENT
ASSUME CS:CODE,DS:DATA,SS:STACKS
START:
    MOV AX,CS
    MOV DS,AX
    MOV DX,OFFSET INT3      ;系统功能调用、设置中断向量、由DS:DX指向四个字节地址
    

    MOV AX,250BH         ; AL=中断类型号（=0BH---0B*4=向量表地址）
    INT 21H                ; (实现向中断性量表中添置INT3的地址)
    
    MOV DX,283H     ;8255命令口地址,进行初始化
    MOV AL,10001001B ;设置工作方式,A工作在0方式输入，B口0方式输出
    OUT DX,AL
    
    MOV  AX,STACKS     ;设定堆栈段寄存器SS
    MOV  SS,AX
    MOV  SP,TOP        ;设定堆栈指针SP的初值
    
    IN AL,21H              ;设置中断屏蔽字（采用"读-与-写"方式使能）
    AND AL,0F7H            ;使能IRQ3
    OUT 21H,AL             ;写入OCW1(屏蔽字)
    MOV  SI,0             ;建立一个标志，原始=0
    
    MOV  AX,DATA
    MOV  DS,AX
    MOV  DX,IO0809A      ;启动A/D转换器
    OUT  DX,AL
LOOP1:
    STI                     ;开中断（IF置1）
    IN   AL,DX
    MOV    CX,0FFFFH        ;设定延时常数 
    CMP    SI,01           ;查询标志、判断是否转换完成
    JNE LOOP1               ;未完成时：返回等待
LOOP3:    
    LOOP  LOOP3            ;转换完成时首先延时   
    CLI
    MOV  DX,IO0809A        ;再次启动A/D转换器
    OUT  DX,AL 
    JMP  LOOP1             ;返回继续等待下一次中断

INT3:
    PUSH  AX                       ;中断服务程序
    PUSH  DX
    PUSH  CX     
    MOV SI,1                   ;建立一个转换完成的标志（SI=1）
    MOV  DX,IO0809A
    IN   AL,DX                 ;从A/D转换器输入数据
 ;处理采集的数据：将8位二进制数拆分为两位十六进制数以待显示
    MOV  TMP,0
    MOV     TMP,AL                 ;将AL保存到BL
    MOV  CL,4
    SHR  AL,CL                 ;将AL右移四位
    CALL DISP1                  ;调显示子程序显示其高四位
    MOV  AL,TMP
    AND  AL,0FH
    CALL DISP2                  ;调显示子程序显示其低四位
    MOV  DL,20H               ;（空格符）
    INT  21H
    
    MOV  DL,20H               ;（空格符）
    INT  21H
    PUSH DX
    MOV  AH,06H              ;判断是否有键按下
    MOV  DL,0FFH               ;DX=FF时 输入字符
    INT 21H                    ;AL=输入的字符
    POP DX
    JE   LOOP2                 ;若没有键盘操作（AL=0）则转START
    IN AL,21H                   ;中断屏蔽字OCW1操作        ;
    OR AL,08H                   ;将IMR中的IRQ3屏蔽
    OUT 21H,AL
    MOV  AH,4CH               ;退出
    INT  21H    
LOOP2:
    STI                         ;返回主程序之前开中断
    MOV AL,20H                 ;写OCW2，发EOI命令
    OUT 20H,AL                  ;使ISR相应位清零
    POP CX
    POP DX
    POP    AX
    IRET                        ;中断返回
    
DISP1  PROC NEAR                 ;显示子程序
    MOV  TMP_1,AL    

    MOV AL,00H
    MOV DX,281H            
    OUT DX,AL


    MOV  AL,TMP_1
    MOV  BX,OFFSET LED      ;BX为数码表的起始地址
    XLAT                          ;求出相应的段码
    MOV  DX,280H        ;从8255的A口输出
    OUT  DX,AL
    
    MOV AL,02H
    MOV DX,281H            ;
    OUT DX,AL
    RET
DISP1 ENDP    

DISP2  PROC NEAR                 ;显示子程序
    MOV  TMP_2,AL

    MOV AL,00H
    MOV DX,281H;
    OUT DX,AL
    
    MOV  AL,TMP_2
    MOV  BX,OFFSET LED      ;BX为数码表的起始地址
    XLAT                          ;求出相应的段码
    MOV  DX,280H        ;从8255的A口输出
    OUT  DX,AL
    
    MOV AL,01H
    MOV DX,281H            ;
    OUT DX,AL
    RET
DISP2 ENDP 
CODE ENDS
END START
