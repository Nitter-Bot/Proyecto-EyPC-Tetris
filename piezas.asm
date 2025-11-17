.MODEL SMALL

.DATA
    TAM_BLOQUE DW 10
    TABLERO_OFFSET_X DW 10
    TABLERO_OFFSET_Y DW 5
    
    pb_x1 DW ?
    pb_x2 DW ?
    pb_y1 DW ?
    pb_y2 DW ?
    pb_color DW ?
.CODE

EXTRN DibujaPixel : PROC

PUBLIC DibujaBloque

;Procedimiento DibujaBloque
;Dibuja un bloque de 19x19 pixeles
;Entrada AX = PosX (0-9), BX = PosY(0-19), SI = Color
DibujaBloque PROC
; --- 1. Calcular Coordenadas de Píxeles ---
    ; a) PixelX1
    PUSH CX             ; Guardar CX
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
    MOV pb_color, SI
    POP CX              ; Restaurar CX

    ; --- 2. Bucle de Dibujo (usando DibujaPixel) ---
    PUSH AX
    PUSH BX
    PUSH CX
    PUSH DX

    MOV CX, pb_x1
    MOV DX, pb_y1       ; Contador Y = y1

    .I:
        .J:
            CALL DibujaPixel
            INC CX
            CMP CX , pb_x2
        JLE .J
        MOV CX, pb_x1
        INC DX
        CMP DX, pb_y2
    JLE .I

    POP DX
    POP CX
    POP BX
    POP AX
    RET
DibujaBloque ENDP

END
