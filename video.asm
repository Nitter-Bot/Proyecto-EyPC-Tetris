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
    block_colour DB ?
    background_colour DB 68h
    block_is_free_simple DB 0
    block_is_free DB 0
    temp_colour DB 4H
    PUBLIC block_start_col
    PUBLIC block_start_row
    PUBLIC block_finish_col
    PUBLIC block_finish_row
    PUBLIC block_colour
    PUBLIC block_is_free_simple
    PUBLIC block_is_free
    EXTRN random_incoming1_shape_number : BYTE
    EXTRN random_incoming2_shape_number : BYTE
    EXTRN block_border_colour : BYTE
    EXTRN active_block_num_one : WORD
    EXTRN active_block_num_two : WORD
    EXTRN active_block_num_three : WORD
    EXTRN active_block_num_four : WORD 
.CODE

; --- Funciones públicas
PUBLIC IniciarGraficos
PUBLIC RestaurarModoTexto
PUBLIC LimpiarPantalla
PUBLIC DibujarTablero
PUBLIC DibujarBorde
PUBLIC DibujarBloqueUnico
PUBLIC BloqueLibreSencillo 
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

; Procedimiento Dibujar_Bloque_Unico
DibujarBloqueUnico PROC
    MOV AH, 0Ch
    MOV AL, block_colour
    INC block_start_col
    INC block_start_row
    DEC block_finish_col
    DEC block_finish_row 
    MOV DX, block_start_row  
.loop3:
    MOV CX, block_start_col
.loop4:
    INT 10h
    INC CX 
    CMP CX, block_finish_col
    JNZ .loop4
    INC DX
    CMP DX, block_finish_row
    JNZ .loop3
    DEC block_start_col
    DEC block_start_row
    INC block_finish_col
    INC block_finish_row
    RET
DibujarBloqueUnico ENDP

;Procecimiento BloqueLibreSencillo

BloqueLibreSencillo PROC
    INC block_start_col
    INC block_start_row
    DEC block_finish_col
    DEC block_finish_row
    MOV block_is_free_simple, 0h
    MOV AH, 0Dh
    MOV CX, block_start_col
    MOV DX, block_start_row
    INT 10H
    CMP AL, background_colour
    JNE is_this_block_free_exit_simple
    MOV block_is_free_simple, 1H
is_this_block_free_exit_simple:
    MOV temp_colour, AL
    DEC block_start_col
    DEC block_start_row
    INC block_finish_col
    INC block_finish_row
    RET
BloqueLibreSencillo ENDP

BloqueLibre PROC
    INC block_start_col
    INC block_start_row
    DEC block_finish_col
    DEC block_finish_row
    
    MOV block_is_free, 0H   ; Asumir ocupado por defecto
    MOV AH, 0DH
    MOV CX, block_start_col
    MOV DX, block_start_row
    INT 10H
    
    DEC block_start_col
    DEC block_start_row
    INC block_finish_col
    INC block_finish_row

    CMP AL, background_colour
    JE .IS_FREE_LABEL
    
    CMP AL, block_colour
    JE .CHECK_SELF_COLLISION ; Si es mi color, verificar si soy yo mismo.
    
    JMP .EXIT_CHECK

.CHECK_SELF_COLLISION:
    ; Verificar contra el Bloque 1
    LEA SI, active_block_num_one
    CALL CHECK_COORDS_MATCH
    JE .IS_FREE_LABEL

    LEA SI, active_block_num_two
    CALL CHECK_COORDS_MATCH
    JE .IS_FREE_LABEL

    LEA SI, active_block_num_three
    CALL CHECK_COORDS_MATCH
    JE .IS_FREE_LABEL

    LEA SI, active_block_num_four
    CALL CHECK_COORDS_MATCH
    JE .IS_FREE_LABEL

    JMP .EXIT_CHECK

.IS_FREE_LABEL:
    MOV block_is_free, 1H

.EXIT_CHECK:
    RET
BloqueLibre ENDP


; --- HELPER PRIVADO: Comparar Coordenadas ---
; Entrada: SI apunta al array del bloque activo (active_block_num_X)
; Salida:  Zero Flag (ZF) = 1 si coinciden todas, 0 si no.
CHECK_COORDS_MATCH PROC
    MOV BX, [SI]
    CMP BX, block_start_col
    JNE .NO_MATCH

    MOV BX, [SI+2]
    CMP BX, block_start_row
    JNE .NO_MATCH

    MOV BX, [SI+4]
    CMP BX, block_finish_col
    JNE .NO_MATCH

    MOV BX, [SI+6]
    CMP BX, block_finish_row
    RET

.NO_MATCH:
    OR BX, 1
    RET
CHECK_COORDS_MATCH ENDP

END
