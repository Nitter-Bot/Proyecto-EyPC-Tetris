;Funciones para generar pantalla del juego

.MODEL SMALL

;Variables para las coordenadas
.Data
    play_ground_start_col  DW   100;136;100 
    play_ground_start_row  DW   4;160;4
    play_ground_finish_col DW   220;172;220
    play_ground_finish_row DW 196;196    
    block_start_col DW 208
    block_start_row DW 184
    block_finish_col DW 220
    block_finish_row DW 196

    background_colour DB 68h
    EXTRN block_border_colour : BYTE
.CODE

; --- Funciones públicas
PUBLIC IniciarGraficos
PUBLIC RestaurarModoTexto
PUBLIC LimpiarPantalla
PUBLIC DibujarTablero
PUBLIC DibujarBorde

; Procedimiento IniciarModoGrafico -----------------
; Establece Modo 13h (320x200) y apunta ES a la VRAM.
IniciarGraficos PROC
    PUSH AX
    MOV AX, 0013h
    INT 10h
    MOV AX, 0A000h
    MOV ES, AX
    POP AX
    RET
IniciarGraficos ENDP

; Procedimiento RestaurarModoTexto 
; Regresa a modo texto 80x25.
RestaurarModoTexto PROC
    PUSH AX
    MOV AX, 0003h
    INT 10h
    POP AX
    RET
RestaurarModoTexto ENDP

; Procedimiento LimpiarPantalla
; Limpiar la pantalla
LimpiarPantalla PROC
    mov al, 06h
    mov bh, 00h
    mov cx, 0000h
    mov dx, 184Fh
    ret
LimpiarPantalla ENDP

; Procedimiento DibujarTablero
; Dibuja el entorno donde el juego sera
; llevado a cabo
DibujarTablero PROC
    MOV AH, 0Ch
    MOV AL, background_colour
    MOV DX, play_ground_start_row
.LOOP1:
    MOV CX, play_ground_start_col
.LOOP2:
    INT 10h
    INC CX
    CMP CX, play_ground_finish_col
    JNZ .LOOP2
    INC DX
    CMP DX, play_ground_finish_row
    JNZ .LOOP1
    RET
DibujarTablero ENDP

; Procedimiento DibujarBorde
; Dibuja el borde del tablero
DibujarBorde PROC
    MOV BX, play_ground_start_row
    MOV block_start_row, BX
    ADD BX, 12
    MOV block_finish_row, BX
.Dibujar:
    MOV BX, play_ground_start_col
    MOV block_start_col, BX
    ADD BX, 12
    MOV block_finish_col, BX
    .Dibujar2:
        CALL Dibujar_Borde_Bloque_Unico
        ADD block_start_col, 12
        ADD block_finish_col, 12
        MOV BX, play_ground_finish_col
        CMP BX, block_start_col
        JNZ .Dibujar2
    ADD block_start_row, 12
    ADD block_finish_row, 12
    MOV BX, play_ground_finish_row
    CMP BX, block_start_row
    JNZ .Dibujar
    RET
DibujarBorde ENDP

; Procedimiento Dibujar_Borde_Bloque_Unico
; Recibe el inicio de un bloque y dibuja su borde
Dibujar_Borde_Bloque_Unico PROC
    MOV AH, 0Ch
    MOV AL, block_border_colour
    DEC block_finish_row
    MOV DX, block_start_row
    MOV CX, block_start_col
.loop4_bb:
    INT 10h
    INC CX
    CMP CX, block_finish_col
    JNZ .loop4_bb
    INC DX
.loop3_b:
    MOV CX, block_start_col
.loop4_b:
    INT 10h
    ADD CX, 11
    CMP CX, block_finish_col
    JB .loop4_b
    INC DX
    CMP DX, block_finish_row
    JNZ .loop3_b
    MOV DX, block_finish_row
    MOV CX, block_start_col
.loop4_bbb:
    INT 10h
    INC CX
    CMP CX, block_finish_col
    JNZ .loop4_bbb
    INC block_finish_row
    RET
Dibujar_Borde_Bloque_Unico ENDP

END
