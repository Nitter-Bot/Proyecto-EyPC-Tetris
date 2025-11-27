;Funciones para generar las siguientes piezas

.MODEL SMALL

; --- MACRO: Verificar si un bloque cabe en el Spawn ---
; Parametros: Columna, Fila, Etiqueta de salto en caso de error
VERIFICAR_SPAWN MACRO col_val, row_val, jump_fail
    LOCAL .is_not_full
    MOV block_start_col, col_val
    MOV block_start_row, row_val
    MOV block_finish_col, col_val + 12
    MOV block_finish_row, row_val + 12

    CALL BloqueLibreSencillo
    CMP block_is_free_simple, 0H
    JNE .is_not_full
    JMP jump_fail
.is_not_full:
ENDM

.Data
    PUBLIC random_incoming1_shape_number
    PUBLIC random_incoming2_shape_number
    PUBLIC not_enough_space
    random_shape_number DB ?
    not_enough_space DB 0H
    random_incoming1_shape_number DB ?
    random_incoming2_shape_number DB ?
    TablaColoresPiezas DB 0Eh, 24h, 02h, 04h, 06h
.CODE

PUBLIC NumeroAleatorio
PUBLIC FiguraAleatoria
EXTRN display_upcoming_1 : PROC
EXTRN display_upcoming_2 : PROC
EXTRN block_is_free_simple: BYTE
EXTRN Delay : PROC
EXTRN LimpiarSiguiente: PROC
EXTRN BloqueLibreSencillo : PROC
EXTRN block_colour : BYTE
EXTRN block_start_col : BYTE
EXTRN block_start_row : BYTE
EXTRN block_finish_col : BYTE
EXTRN block_finish_row : BYTE
EXTRN draw_square_block : PROC
EXTRN draw_square_block_2 : PROC
EXTRN draw_rectangle_block : PROC
EXTRN draw_rectangle_block_2 : PROC
EXTRN draw_L_block : PROC
EXTRN draw_L_block_2 : PROC
EXTRN draw_L_block_3 : PROC
EXTRN draw_T_block : PROC
EXTRN draw_T_block_2 : PROC
EXTRN draw_Z_block : PROC
EXTRN draw_Z_block_2 : PROC
EXTRN draw_Z_block_3 : PROC

;   Procedimiento NumeroAleatorio
;   Funcion que genera numeros aleatorios
;   entre 0 a 4
NumeroAleatorio PROC
    MOV AH, 00h
    INT 1AH
    MOV AX, DX
    XOR DX, DX
    MOV CX, 5
    DIV CX
    MOV random_incoming1_shape_number, DL
    CALL Delay
    MOV AH, 00h
    INT 1AH
    MOV AX, DX
    XOR DX, DX
    MOV CX, 5
    DIV CX
    MOV random_incoming2_shape_number, DL
    RET
NumeroAleatorio ENDP

ActualizarQueue PROC
    MOV BL, random_incoming1_shape_number
    MOV random_shape_number, BL
    MOV BL , random_incoming2_shape_number
    MOV random_incoming1_shape_number, BL

    ; 2. Generar nueva pieza futura (0-4)
    MOV AH, 00h
    INT 1AH
    MOV AX, DX
    XOR DX, DX
    MOV CX, 5
    DIV CX
    MOV random_incoming2_shape_number, DL

    ; 3. Actualizar UI
    CALL LimpiarSiguiente
    CALL display_upcoming_1
    CALL display_upcoming_2
    RET
ActualizarQueue ENDP

FiguraAleatoria PROC
    CALL ActualizarQueue
    MOV BL, 1H
    xor bh, bh
    mov bl, random_shape_number    ;
    mov al, TablaColoresPiezas[bx] ; Leemos el color correspondiente
    mov block_colour, al           ; Lo asignamos a la variable externa


    CMP random_shape_number, 0
    JNE .check_rect
    JMP .square_label

.check_rect:
    CMP random_shape_number, 1
    JNE .check_L
    JMP .rectangle_label

.check_L:
    CMP random_shape_number, 2
    JNE .check_T
    JMP .l_label

.check_T:
    CMP random_shape_number, 3
    JNE .check_Z
    JMP .t_label
.check_Z:
    JMP .z_label
    
.square_label:
    VERIFICAR_SPAWN 148, 4,  .fail
    VERIFICAR_SPAWN 160, 4,  .fail
    VERIFICAR_SPAWN 148, 16, .fail_squ
    VERIFICAR_SPAWN 160, 16, .fail_squ
    CALL draw_square_block
    JMP .salir_generador
.rectangle_label:
    VERIFICAR_SPAWN 136, 4,  .fail
    VERIFICAR_SPAWN 148, 4,  .fail
    VERIFICAR_SPAWN 160, 4,  .fail
    VERIFICAR_SPAWN 172, 4,  .fail
    VERIFICAR_SPAWN 136, 16, .fail_rec
    VERIFICAR_SPAWN 148, 16, .fail_rec
    VERIFICAR_SPAWN 160, 16, .fail_rec
    VERIFICAR_SPAWN 172, 16, .fail_rec
    CALL draw_rectangle_block
    JMP .salir_generador
.l_label:
    VERIFICAR_SPAWN 148, 4,  .fail
    VERIFICAR_SPAWN 148, 16, .fail_L1
    VERIFICAR_SPAWN 148, 28, .fail_L2
    VERIFICAR_SPAWN 160, 28, .fail_L2
    CALL draw_L_block
    JMP .salir_generador
.t_label:
    VERIFICAR_SPAWN 148, 4,  .fail
    VERIFICAR_SPAWN 136, 16, .fail_T
    VERIFICAR_SPAWN 148, 16, .fail_T
    VERIFICAR_SPAWN 160, 16, .fail_T
    CALL draw_T_block
    JMP .salir_generador
.z_label:
    VERIFICAR_SPAWN 148, 4,  .fail
    VERIFICAR_SPAWN 148, 16, .fail_Z1
    VERIFICAR_SPAWN 160, 16, .fail_Z1
    VERIFICAR_SPAWN 160, 28, .fail_Z2
    CALL draw_Z_block
    JMP .salir_generador

.fail_rec: 
    CALL draw_rectangle_block_2
    jmp .fail 
.fail_squ:
    CALL draw_square_block_2
    jmp .fail
.fail_L1:
    CALL draw_L_block_2
    jmp .fail 
.fail_L2:
    CALL draw_L_block_3
    jmp .fail 
.fail_T:
    CALL draw_T_block_2
    jmp .fail        
.fail_Z1:
    CALL draw_Z_block_2
    jmp .fail 
.fail_Z2:
    CALL draw_Z_block_3
    jmp .fail
.fail:
    MOV not_enough_space , 1H
.salir_generador:
    RET
FiguraAleatoria ENDP

END
