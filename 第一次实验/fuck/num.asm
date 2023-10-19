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
    MOV DS,AX
    AGAIN:
    MOV AH,1
    INT 21H
    CMP AL,0DH 
    JZ EXIT    
    CMP AL,'0'  
    JNL NEXT1  
    INC REST      
    JMP AGAIN 
    NEXT1:
    CMP AL,'9' 
    JBE N1     
    CMP AL,'a'
    JNL NEXT2 
    INC REST 
    JMP AGAIN
    N1:
    INC NUMBER  
    JMP AGAIN    

    NEXT2:
    CMP AL,'z'  
    JBE N2      
    CMP AL,'A'  
    JNL NEXT3   
    INC REST    
    JMP AGAIN  
    N2:
    INC CHAR     
    JMP AGAIN 

    NEXT3:
    CMP AL,'Z' 
    JBE N2      
    INC REST  
    JMP AGAIN 


    EXIT:
    LEA DX,STR1
    MOV AH,09H
    INT 21H                
    MOV DL,SHUZI        
    ADD DL,30H
    MOV AH,2
    INT 21H               
    LEA DX,STR2
    MOV AH,09H
    INT 21H                
    MOV DL,ZIMU          
    ADD DL,30H
    MOV AH,2
    INT 21H               
    LEA DX,STR3            
    MOV AH,09H
    INT 21H               
    MOV DL,ZIFU            
    ADD DL,30H
    MOV AH,2
    INT 21H               
    MOV AH,4CH
    INT 21H                
CSEG ENDS
    END START