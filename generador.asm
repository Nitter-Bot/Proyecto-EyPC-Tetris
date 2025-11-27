;Funciones para generar las siguientes piezas

.MODEL SMALL

; --- MACRO: Verificar si un bloque cabe en el Spawn ---
; Parametros: Columna, Fila, Etiqueta de salto en caso de error
VERIFICAR_SPAWN MACRO col_val, row_val, jump_fail
    MOV block_start_col, col_val
    MOV block_start_row, row_val
    MOV block_finish_col, col_val + 12
    MOV block_finish_row, row_val + 12

    CALL is_this_block_free_simple
    CMP block_is_free_simple, 0H
    JE jump_fail
ENDM

.Data
    PUBLIC random_incoming1_shape_number 
    PUBLIC random_incoming2_shape_number 
    random_shape_number DB ?
    random_incoming1_shape_number DB ?
    random_incoming2_shape_number DB ?

.CODE

EXTRN display_upcoming_1 : PROC
EXTRN display_upcoming_2 : PROC

PUBLIC NumeroAleatorio
EXTRN Delay : PROC
EXTRN LimpiarSiguiente: PROC

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

    RET
FiguraAleatoria ENDP

END
