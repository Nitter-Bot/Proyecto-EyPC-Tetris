;Funciones para el puntaje del juego 

.MODEL SMALL

.Data
    msg_score DB "Score:0000$"

.CODE

PUBLIC DisplayScore


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

END
