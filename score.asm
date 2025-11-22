;Funciones para el puntaje del juego 

.MODEL SMALL

.Data
    PUBLIC score
    msg_score DB "Score:0000$"
    score DW 0

.CODE

PUBLIC DisplayScore
PUBLIC UpdateScore

; Procedimiento DisplayScore
; Despliega el puntaje del jugador
; Uso de LEA 
DisplayScore PROC
    MOV AH, 02h
    MOV BH, 00h
    MOV DH, 04h
    MOV DL, 01h
    INT 10h
    MOV AH, 09h
    LEA DX, msg_score
    INT 21h
    RET
DisplayScore ENDP

; Procedimiento UpdateScore
; Actualiza el score de acuerdo al valor que se tiene
; guardao
; Entrada: score
; Salida: Llamada a DisplayScore
; Descripcion: Se realiza conversion de entero a ASCII
UpdateScore PROC
    XOR AX, AX
    MOV SI, 9
    MOV AX, score
    MOV BX, 10
.label:
    CMP SI, 5
    JE .exit_label
    XOR DX, DX
    DIV BX
    ADD DX, 30h
    MOV [msg_score+si], DL
    DEC SI
    JMP .label
.exit_label:
    CALL DisplayScore
    RET
UpdateScore ENDP

END
