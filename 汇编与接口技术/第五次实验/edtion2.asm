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
    MOV DX,OFFSET INT3     

    MOV AX,250BH         
    INT 21H                
    
    MOV DX,283H     
    MOV AL,10001001B 
    OUT DX,AL
    
    MOV  AX,STACKS     
    MOV  SS,AX
    MOV  SP,TOP        
    
    IN AL,21H              
    AND AL,0F7H            
    OUT 21H,AL             
    MOV  SI,0             
    
    MOV  AX,DATA
    MOV  DS,AX
    MOV  DX,IO0809A      
    OUT  DX,AL
LOOP1:
    STI                     
    IN   AL,DX
    MOV    CX,0FFFFH        
    CMP    SI,01           
    JNE LOOP1               
LOOP3:    
    LOOP  LOOP3            
    CLI
    MOV  DX,IO0809A        
    OUT  DX,AL 
    JMP  LOOP1             

INT3:
    PUSH  AX                       
    PUSH  DX
    PUSH  CX     
    MOV SI,1                   
    MOV  DX,IO0809A
    IN   AL,DX                 
    MOV  TMP,0
    MOV     TMP,AL                 
    MOV  CL,4
    SHR  AL,CL                 
    CALL DISP1                  
    MOV  AL,TMP
    AND  AL,0FH
    CALL DISP2                  
    MOV  DL,20H               
    INT  21H
    
    MOV  DL,20H               
    INT  21H
    PUSH DX
    MOV  AH,06H              
    MOV  DL,0FFH               
    INT 21H                    
    POP DX
    JE   LOOP2                 
    IN AL,21H                   
    OR AL,08H                   
    OUT 21H,AL
    MOV  AH,4CH               
    INT  21H    
LOOP2:
    STI                         
    MOV AL,20H                 
    OUT 20H,AL                  
    POP CX
    POP DX
    POP    AX
    IRET                        
    
DISP1  PROC NEAR                 
    MOV  TMP_1,AL    
    MOV AL,00H
    MOV DX,281H            
    OUT DX,AL
    MOV  AL,TMP_1
    MOV  BX,OFFSET LED      
    XLAT                          
    MOV  DX,280H        
    OUT  DX,AL
    MOV AL,02H
    MOV DX,281H            
    OUT DX,AL
    RET
DISP1 ENDP    

DISP2  PROC NEAR                 
    MOV  TMP_2,AL
    MOV AL,00H
    MOV DX,281H;
    OUT DX,AL
    MOV  AL,TMP_2
    MOV  BX,OFFSET LED      
    XLAT                          
    MOV  DX,280H        
    OUT  DX,AL
    MOV AL,01H
    MOV DX,281H            
    OUT DX,AL
    RET
DISP2 ENDP 
CODE ENDS
END START
