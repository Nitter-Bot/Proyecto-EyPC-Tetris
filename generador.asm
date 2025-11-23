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
    random_incoming1_shape_number DB ?
    random_incoming2_shape_number DB ?

.CODE

PUBLIC NumeroAleatorio
EXTRN Delay : PROC

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

END
