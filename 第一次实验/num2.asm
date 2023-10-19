DSEG SEGMENT
    SHUZI DB 0            
    ZIMU DB 0            
    ZIFU DB 0            
    STR1 DB 'SHUZI:','$'  
    STR2 DB ' ZIMU:','$'    
    STR3 DB ' ZIFU:','$'        
DSEG ENDS
CSEG SEGMENT
    ASSUME CS:CSEG,DS:DSEG
START:
    MOV AX,DSEG
    MOV DS,AX ;把操行系统安排给 DSEG 的地址，送到 DS

    AGAIN:
    MOV AH,01H ;从键盘上输入一个字符，将其对应字符的ASCII码送入AL中，并在屏幕上显示该字符。如果按下的是Ctrl＋Break组合键，则终止程序执行。1号功能调用无须入口参数，出口参数在AL中
    INT 21H

    CMP AL,0DH  ;回车比较
    JZ EXIT    
    CMP AL,'0'  
    JNL NEXT1  
    INC REST      
    JMP AGAIN 

    NEXT1: ;比较型函数NEXT型均同理
    CMP AL,'9' 
    JBE N1     
    CMP AL,'A'
    JNL NEXT2 
    INC ZIFU
    JMP AGAIN

    N1: ;N型函数 表示数字自增加 后均同理
    INC SHUZI  
    JMP AGAIN    

    NEXT2:
    CMP AL,'Z'  
    JBE N2      
    CMP AL,'a'  
    JNL NEXT3   
    INC ZIFU    
    JMP AGAIN  

    N2:
    INC ZIMU    
    JMP AGAIN 

    NEXT3:
    CMP AL,'z' 
    JBE N2      
    INC ZIFU 
    JMP AGAIN 

    EXIT:
    LEA DX,STR1
    MOV AH,09H
    INT 21H          
      
    MOV DL,SHUZI       
    ADD DL,30H

    MOV AH,02H
    INT 21H             
  
    LEA DX,STR2
    MOV AH,09H
    INT 21H             
   
    MOV DL,ZIMU          
    ADD DL,30H

    MOV AH,02H
    INT 21H          
     
    LEA DX,STR3            
    MOV AH,09H
    INT 21H            
   
    MOV DL,ZIFU            
    ADD DL,30H

    MOV AH,02H
    INT 21H     
          
    MOV AH,4CH     	;INT 21H 称为 DOS 中断调用。	实际上，是调用 DOS 中的子程序。	当 MOV AH,4CH，就是结束本程序，返回 DOS 操作系统。
    INT 21H    
            
CSEG ENDS
    END START