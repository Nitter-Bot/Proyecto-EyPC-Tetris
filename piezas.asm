.MODEL SMALL

.DATA
    TAM_BLOQUE DW 10
    TABLERO_OFFSET_X DW 10
    TABLERO_OFFSET_Y DW 5
    
    pos_x DW ?
    pos_y DW ?
    pb_x1 DW ?
    pb_x2 DW ?
    pb_y1 DW ?
    pb_y2 DW ?
    pb_color DW ?

    BasePiezas   DW OFFSET datos_pieza_I
                 DW OFFSET datos_pieza_J
                 DW OFFSET datos_pieza_L
                 DW OFFSET datos_pieza_O
                 DW OFFSET datos_pieza_S
                 DW OFFSET datos_pieza_T
                 DW OFFSET datos_pieza_Z

datos_pieza_I DB 11, 0,0, 0,1, 1,0, 1,1
datos_pieza_J DB  1, 0,0, 0,1, 1,0, 2,0
datos_pieza_L DB 12, 0,0, 1,0, 2,0, 2,1
datos_pieza_O DB 14, 0,0, 1,0, 2,0, 3,0
datos_pieza_S DB 10, 0,0, 0,1, 1,1, 1,2
datos_pieza_T DB 13, 0,0, 1,0, 1,1, 2,1
datos_pieza_Z DB  4, 0,0, 1,0, 2,0, 1,1

.CODE

EXTRN DibujaPixel : PROC

PUBLIC DibujarPieza

;Procedimiento DibujaBloque
;Dibuja un bloque de 19x19 pixeles
;Entrada AX = PosX (0-9), BX = PosY(0-19), SI = Color
DibujaBloque PROC
; --- 1. Calcular Coordenadas de Píxeles ---
    ; a) PixelX1
    PUSH CX             ; Guardar CX
    PUSH SI
    MOV CX, AX          ; CX = GridX
    MOV AX, TAM_BLOQUE
    MUL CX
    ADD AX, TABLERO_OFFSET_X
    MOV pb_x1, AX

    ; b) PixelY1
    MOV AX, TAM_BLOQUE
    MUL BX
    ADD AX, TABLERO_OFFSET_Y
    MOV pb_y1, AX

    ; c) PixelX2
    MOV CX, pb_x1
    ADD CX, TAM_BLOQUE
    MOV pb_x2, CX

    ; d) PixelY2
    MOV CX, pb_y1
    ADD CX, TAM_BLOQUE
    MOV pb_y2, CX

    ; e) Guardar Color
    MOV SI, pb_color
    POP CX

    PUSH AX
    PUSH BX
    PUSH CX
    PUSH DX

    MOV CX, pb_x1
    MOV DX, pb_y1

    .I:
        .J:
            CALL DibujaPixel
            INC CX
            CMP CX , pb_x2
        JLE .J
        MOV CX, pb_x1
        INC DX
        CMP DX, pb_y2
    JL .I

    POP DX
    POP CX
    POP BX
    POP AX
    POP SI
    RET
DibujaBloque ENDP

; --- Procedimiento DibujarPieza (NUEVO) ---
; Dibuja una pieza completa en una posición del tablero.
; Entrada: AX = Índice de la Pieza (0-6)
;          CX = GridX (Posición base en el tablero, 0-18)
;          DX = GridY (Posición base en el tablero, 0-18)
DibujarPieza PROC
    MOV pos_x, CX
    MOV pos_y, DX
    PUSH BX
    
    PUSH SI
    MOV BX, AX
    SHL BX, 1

    MOV SI, OFFSET BasePiezas
    ADD SI, BX
    MOV SI, [SI]

    MOV AL, [SI]
    MOV AH, 0
    MOV pb_color, AX
    INC SI

    MOV BP, 0       ; BP = Contador (4 bloques)
    .LOOP_DIBUJA_BLOQUE:
        ; 1. Leer Coords Relativas
        MOV AL, [SI]    ; AL = X_relativa
        MOV AH, 0
        INC SI
        MOV BL, [SI]    ; BL = Y_relativa
        MOV BH, 0
        INC SI          ; <-- ¡IMPORTANTE! Mover el puntero 2 veces
    
        ; 2. Calcular Coords Absolutas
        ;    (BaseX está en CL, BaseY está en DL)
        ADD AX, pos_x      ; AL = X_abs (X_rel + BaseX)
        ADD BX, pos_y      ; BL = Y_abs (Y_rel + BaseY)

        PUSH SI
        CALL DibujaBloque
        POP SI
        MOV AX, 0
        MOV BX, 0
        INC BP
        CMP BP,4
    JL .LOOP_DIBUJA_BLOQUE

    POP SI
    POP BX

    RET
DibujarPieza ENDP

END
