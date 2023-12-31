CODE SEGMENT
ASSUME CS:CODE
START:
MOV DX,293H
MOV AL,10001001B
OUT DX,AL

XOR AX,AX
MOV BL,0
LOP:
MOV DX,292H
IN AL,DX
CMP AL,AH
JZ NEXT
MOV AH,AL
MOV BL,AH
ROL BL,1
NEXT:
ROR BL,1
MOV AL,BL
MOV DX,291H
OUT DX,AL
MOV CX,3FFFH

DOIT:
MOV DX,291H
MOV AL,00000000B
OUT DX,AL
MOV DX,290H
MOV AL,7FH
OUT DX,AL
MOV DX,291H
MOV AL,00100000B
OUT DX,AL
CALL DELAY

MOV DX,291H
MOV AL,00000000B
OUT DX,AL
MOV DX,290H
MOV AL,5BH
OUT DX,AL
MOV DX,291H
MOV AL,00010000B
OUT DX,AL
CALL DELAY

MOV DX,291H
MOV AL,00000000B
OUT DX,AL
MOV DX,290H
MOV AL,6DH
OUT DX,AL
MOV DX,291H
MOV AL,00001000B
OUT DX,AL
CALL DELAY

MOV DX,291H
MOV AL,00000000B
OUT DX,AL
MOV DX,290H
MOV AL,6DH
OUT DX,AL
MOV DX,291H
MOV AL,00000100B
OUT DX,AL
CALL DELAY

MOV DX,291H
MOV AL,00000000B
OUT DX,AL
MOV DX,290H
MOV AL,40H
OUT DX,AL
MOV DX,291H
MOV AL,00000010B
OUT DX,AL
CALL DELAY

MOV DX,291H
MOV AL,00000000B
OUT DX,AL
MOV DX,290H
MOV AL,77H
OUT DX,AL
MOV DX,291H
MOV AL,00000001B
OUT DX,AL
CALL DELAY
LOOP DOIT
JMP LOP

DELAY PROC
PUSH BX
PUSH CX
MOV BX,0FFFFH
DL1:MOV CX,06FH
DL2:DEC CX
JNZ DL2
DEC BX
JNZ DL1
POP CX
POP BX
RET
DELAY ENDP

CODE ENDS
END START
