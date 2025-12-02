.MODEL SMALL
.DATA
    msg_titulo      DB 13, 10, "      === TETRIS 8086 ===$"
    msg_opcion1     DB 13, 10, 13, 10, "   1. INICIAR JUEGO$"
    msg_opcion2     DB 13, 10, "   2. INSTRUCCIONES$"
    msg_opcion3     DB 13, 10, "   3. SALIR$"
    msg_prompt      DB 13, 10, 13, 10, "   Elige una opcion: $"

    msg_inst_tit    DB 13, 10, "      === INSTRUCCIONES ===$"
    msg_inst_1      DB 13, 10, 13, 10, "   A - Mover Izquierda$"
    msg_inst_2      DB 13, 10, "   D - Mover Derecha$"
    msg_inst_3      DB 13, 10, "   S - Bajar Lento$"
    msg_inst_4      DB 13, 10, "   W - Rotar Pieza$"
    msg_inst_5      DB 13, 10, "   F - Caida Rapida (Hard Drop)$"
    msg_inst_ret    DB 13, 10, 13, 10, "   [Presiona cualquier tecla para volver]$"

.CODE
    PUBLIC Mostrar_Menu_Principal
    PUBLIC Mostrar_Instrucciones
    PUBLIC Esperar_Tecla_Menu

Mostrar_Menu_Principal PROC
    MOV AX, 0003h
    INT 10h
    MOV AH, 09h
    LEA DX, msg_titulo
    INT 21h
    LEA DX, msg_opcion1
    INT 21h
    LEA DX, msg_opcion2
    INT 21h
    LEA DX, msg_opcion3
    INT 21h
    LEA DX, msg_prompt
    INT 21h
    RET
Mostrar_Menu_Principal ENDP

Mostrar_Instrucciones PROC
    MOV AX, 0003h
    INT 10h
    MOV AH, 09h
    LEA DX, msg_inst_tit
    INT 21h
    LEA DX, msg_inst_1
    INT 21h
    LEA DX, msg_inst_2
    INT 21h
    LEA DX, msg_inst_3
    INT 21h
    LEA DX, msg_inst_4
    INT 21h
    LEA DX, msg_inst_5
    INT 21h
    LEA DX, msg_inst_ret
    INT 21h
    MOV AH, 00h
    INT 16h
    RET
Mostrar_Instrucciones ENDP

Esperar_Tecla_Menu PROC
    MOV AH, 00h
    INT 16h
    RET
Esperar_Tecla_Menu ENDP

END
