; 数据段
DATA SEGMENT
    MONTH DB 'JAN','FEB','MAR','APR','MAY','JUN','JUL','AUG','SEP','OCT','NOV','DEC' ; 月份名称数组
    NUM DB 2 DUP(?)    ; 存储用户输入的数字的数组
    STRONE DB 'month:?',10,'$' ; 提示用户输入月份的字符串
    STRTWO DB 'month ERROR!',10,'$' ; 月份输入错误时的字符串
DATA ENDS

; 代码段
CODE SEGMENT
    ASSUME CS:CODE,DS:DATA

START:
    MOV AX,DATA     ; 将数据段地址加载到寄存器AX
    MOV DS,AX       ; 将数据段地址设置到DS寄存器
BEGIN:
    MOV DX,OFFSET STRONE    ; 将STRONE的偏移地址加载到寄存器DX
    MOV AH,9        ; 设置AH寄存器为9，表示显示字符串功能
    INT 21H         ; 执行DOS中断21H，显示字符串
    MOV BX,0        ; 将BX寄存器置零，用于数组索引
    MOV [NUM],BL    ; 将BL的值存储到NUM数组的第一个元素
    MOV [NUM+1],BL  ; 将BL的值存储到NUM数组的第二个元素
RE:
    MOV AH,1        ; 设置AH寄存器为1，表示等待用户输入字符
    INT 21H         ; 执行DOS中断21H，等待用户输入字符
    CMP AL,1BH      ; 检查用户是否按下ESC键 (ASCII码1B)
    JE EXIT         ; 如果是，跳转到EXIT退出程序
    CMP AL,0DH      ; 检查用户是否按下回车键 (ASCII码0D)
    JE NEXT         ; 如果是，跳转到NEXT继续处理输入
    CMP AL,30H      ; 检查字符是否小于'0'
    JB ERROR        ; 如果是，跳转到ERROR，表示输入错误
    CMP AL,39H      ; 检查字符是否大于'9'
    JA ERROR        ; 如果是，跳转到ERROR，表示输入错误
    CMP BX,2        ; 检查数组索引是否已经达到2
    JZ ERROR        ; 如果是，跳转到ERROR，表示输入错误
    MOV NUM[BX],AL  ; 将输入的字符存储到NUM数组
    INC BX          ; 增加数组索引
    JMP RE          ; 继续等待用户输入字符
NEXT:
    MOV AL,[NUM]    ; 将NUM数组的第一个元素加载到AL寄存器
    SUB AL,30H      ; 将字符转换为数字
    JE ERROR        ; 如果输入为0，跳转到ERROR，表示输入错误
    MOV BL,[NUM+1]  ; 将NUM数组的第二个元素加载到BL寄存器
    CMP BL,0        ; 检查第二个字符是否为0
    JE GO           ; 如果是0，跳转到GO，表示输入正确
    SUB BL,30H      ; 将字符转换为数字
    MOV AH,10       ; 设置AH寄存器为10
    MUL AH          ; 乘以10
    ADD AL,BL       ; 将两个数字相加
    CMP AL,12       ; 检查月份是否大于12
    JA ERROR        ; 如果是，跳转到ERROR，表示输入错误
GO:
    MOV CX,3        ; 设置CX寄存器为3，用于循环输出月份字符串
    DEC AL          ; 月份减1
    MOV AH,3        ; 设置AH寄存器为3，表示显示一个字符
    MUL AH          ; 将AH乘以2
    MOV BX,OFFSET MONTH ; 将MONTH数组的地址加载到BX寄存器
    ADD BX,AX       ; 将偏移地址加上月份索引
    MOV DL,10       ; 设置DL寄存器为10，表示新行
    MOV AH,2        ; 设置AH寄存器为2，表示显示字符
    INT 21H         ; 执行DOS中断21H，显示字符
OUTPUT:
    MOV DL,[BX]     ; 将MONTH数组中的字符加载到DL寄存器
    MOV AH,2        ; 设置AH寄存器为2，表示显示字符
    INT 21H         ; 执行DOS中断21H，显示字符
    INC BX          ; 增加数组索引
    LOOP OUTPUT     ; 循环继续输出字符
    MOV DL,0AH      ; 设置DL寄存器为0AH，表示新行
    MOV AH,2        ; 设置AH寄存器为2，表示显示字符
    INT 21H         ; 执行DOS中断21H，显示字符
    JMP BEGIN       ; 跳转回BEGIN，继续处理下一个月份输入
ERROR:
    MOV DL,0AH      ; 设置DL寄存器为0AH，表示新行
    MOV AH,2        ; 设置AH寄存器为2，表示显示字符
    INT 21H         ; 执行DOS中断21H，显示字符
    MOV DX,OFFSET STRTWO ; 将STRTWO的偏移地址加载到DX寄存器
    MOV AH,9        ; 设置AH寄存器为9，表示显示字符串功能
    INT 21H         ; 执行DOS中断21H，显示字符串
    JMP BEGIN       ; 跳转回BEGIN，继续处理下一个月份输入
EXIT:
    MOV AH,4CH      ; 设置AH寄存器为4CH，表示程序结束
    INT 21H         ; 执行DOS中断21H，退出程序
CODE ENDS

END START
