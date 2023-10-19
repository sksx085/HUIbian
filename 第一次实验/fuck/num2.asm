DSEG SEGMENT
    NUMBER DB 0            ;存储数字个数
    CHAR DB 0            ;字母个数
    REST DB 0            ;字符个数
    STR1 DB 'NUMBER:','$'  ;输出提示”NUMBER:”
    STR2 DB ' CHAR:','$'    ;输出提示”CHAR:”
    STR3 DB ' REST:','$'        ;输出提示”REST:”
DSEG ENDS
CSEG SEGMENT
    ASSUME CS:CSEG,DS:DSEG
START:
    MOV AX,DSEG
    MOV DS,AX
    AGAIN:
    MOV AH,1
    INT 21H
    CMP AL,0DH ;判断字符是否为回车
    JZ EXIT     ;是回车，跳转到结束语句
    CMP AL,'0'  ;不是回车，判断是否大于’0’
    JNL NEXT1  ;大于‘0’，跳转到NEXT1
    INC REST      ; 小于’0’，是字符，REST自增1
    JMP AGAIN ;AGAIN循环
    NEXT1:
    CMP AL,'9' ;判断是否小于’9’
    JBE N1     ;小于9，是数字，跳转到N1
    CMP AL,65;大于9，不是数字，跟’a’比较
    JNL NEXT2 ;大于’a’，跳转到NEXT2
    INC REST ;小于’a’，是字符，REST自增1
    JMP AGAIN;返回循环
    NEXT2:
    CMP AL,90   ;跟’z’作比较
    JBE N2      ;小于’z’，是字母，跳转到N2
    CMP AL,97   ;大于’z’，跟‘A’比较
    JNL NEXT3   ;大于’A’跳转到NEST3
    INC REST    ;大于’z’，小于‘A’，是字符，REST自增1
    JMP AGAIN  ;返回循环
    NEXT3:
    CMP AL,122 ;跟’Z’比较
    JBE N2      ;小于’Z’，是大写字母，跳转到N2
    INC REST  ;不是字母，是字符，REST自增1
    JMP AGAIN  ;返回循环
    
    N1:
    INC NUMBER  ;判断为数字，NUMBER自增1
    JMP AGAIN     ;返回循环
    N2:
    INC CHAR     ;判断为字母，CHAR自增1
    JMP AGAIN  ;返回循环
    EXIT:
    LEA DX,STR1
    MOV AH,09H
    INT 21H                ;显示提示“NUMBER:”
    MOV DL,NUMBER        ;NUMBER送到DL
    ADD DL,30H
    MOV AH,2
    INT 21H                ;显示NUMBER的值
    LEA DX,STR2
    MOV AH,09H
    INT 21H                ;显示提示“CHAR:”
    MOV DL,CHAR            ;CHAR送到DL
    ADD DL,30H
    MOV AH,2
    INT 21H                ;显示CHAR的值
    LEA DX,STR3            
    MOV AH,09H
    INT 21H                ;显示提示”REST:”
    MOV DL,REST            ;REST送到DL
    ADD DL,30H
    MOV AH,2
    INT 21H                ;显示REST的值
    MOV AH,4CH
    INT 21H                ;程序结束
CSEG ENDS
    END START