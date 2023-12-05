SSEG SEGMENT
    DW 100 DUP(?)
SSEG ENDS

DSEG SEGMENT
    OLD1_OFF DW ?
    OLD1_SEG DW ?
    OLD2_OFF DW ?
    OLD2_SEG DW ?
    N DW 10
    LED1 DW 00000100B
    LED2 DW 00100000B
DSEG ENDS

CSEG SEGMENT
    ASSUME CS:CSEG,DS:DSEG,SS:SSEG
START:
    MOV AX,DSEG
    MOV DS,AX

    CLI
    IN AL,21H
    AND AL,0F3H  
    OUT 21H,AL

    IN AL,0A1H
    AND AL,0FBH   
    OUT 0A1H,AL

    CALL SET_TABLE
    MOV DX,283H        
    MOV AL,90H        
    OUT DX,AL     
    XOR CX,CX
S1:
    STI
    HLT        
    CMP CX,N
    JNZ S1
    CLI
    CALL RECOVER_TABLE
    IN AL,21H
    OR AL,0CH   
    OUT 21H,AL
    IN AL,0A1H
    OR AL,04H        
    OUT 0A1H,AL
    STI
    MOV AH,4CH        
    INT 21H
    
SET_TABLE PROC
    PUSH DS
    PUSH DI
    PUSH BX
    
    MOV AX,0;
    MOV DS,AX
    MOV DI,4*0BH
    MOV BX,[DI]
    MOV OLD1_OFF,BX
    MOV BX,[DI+2]
    MOV OLD1_SEG,BX
    MOV BX,OFFSET SW1_INT
    MOV [DI],BX
    MOV BX,SEG SW1_INT
    MOV [DI+2],BX
    
    MOV DI,4*72H
    MOV BX,[DI]
    MOV OLD2_OFF,BX
    MOV BX,[DI+2]
    MOV OLD2_SEG,BX
    MOV BX,OFFSET SW2_INT
    MOV [DI],BX
    MOV BX,SEG SW2_INT
    MOV [DI+2],BX
    
    POP BX
    POP DI
    POP DS
    RET
SET_TABLE ENDP

RECOVER_TABLE PROC
    PUSH DS
    PUSH DI
    PUSH BX
    
    MOV AX,0;
    MOV DS,AX
    MOV DI,4*0BH
    MOV BX,OLD1_OFF
    MOV [DI],BX
    MOV BX,OLD1_SEG
    MOV [DI+2],BX
    
    MOV DI,4*72H
    MOV BX,OLD2_OFF
    MOV [DI],BX
    MOV BX,OLD2_SEG
    MOV [DI+2],BX
    
    POP BX
    POP DI
    POP DS
    RET
RECOVER_TABLE ENDP

SW1_INT PROC
    PUSH AX
    PUSH DX
    CLI
    INC CX        
    MOV AX,LED1
    MOV DX,281H      
    OUT DX,AX        
    XOR AX,00000100B   
    MOV LED1,AX
    MOV AL,20H        
    OUT 20H,AL
    POP DX
    POP AX
    STI
    IRET
SW1_INT ENDP

SW2_INT PROC
    PUSH AX
    PUSH DX
    CLI
    INC CX           
    MOV AX,LED2
    MOV DX,281H       
    OUT DX,AX   
    XOR AX,00100000B
    MOV LED2,AX
    MOV AL,20H
    OUT 20H,AL
    MOV AL,20H
    OUT 0A0H,AL
    POP DX
    POP AX
    STI
    IRET
SW2_INT ENDP
CSEG ENDS
END START
