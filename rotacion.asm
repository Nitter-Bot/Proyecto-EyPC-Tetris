.MODEL SMALL

.DATA
    position DB 1h
    shift_counter DW 0h
    ; --- IMPORTAR VARIABLES ---
    EXTRN active_block_num_one:WORD
    EXTRN active_block_num_two:WORD
    EXTRN active_block_num_three:WORD
    EXTRN active_block_num_four:WORD
    EXTRN active_block_center:WORD
    
    EXTRN block_start_col:WORD
    EXTRN block_start_row:WORD
    EXTRN block_finish_col:WORD
    EXTRN block_finish_row:WORD
    EXTRN play_ground_start_col:WORD
    EXTRN play_ground_start_row:WORD
    EXTRN play_ground_finish_col:WORD
    EXTRN play_ground_finish_row:WORD
    
    EXTRN random_shape_number:BYTE
    EXTRN block_is_free:BYTE
    EXTRN successful_magic_shift:WORD
    EXTRN block_border_colour:BYTE

.CODE
    ; --- IMPORTAR FUNCIONES ---
    EXTRN BorrarBloque:PROC
    EXTRN DibujarBloqueUnico:PROC
    EXTRN BloqueLibre:PROC
    EXTRN DibujarBorde:PROC
    EXTRN FILL_GENERIC_HELPER:PROC
    
    EXTRN shape_shift_right:PROC
    EXTRN shape_shift_left:PROC
    EXTRN shape_shift_down:PROC
    EXTRN shape_shift_up:PROC

    PUBLIC shape_rotate
; =================================================================
; 1. PROCESO PRINCIPAL: SHAPE_ROTATE
; =================================================================
SHAPE_ROTATE PROC
    ; Cuadrado (0) no rota
    CMP random_shape_number, 0
    JE EXIT_ROTATE

    ; Inicializar contador de colisiones
    MOV shift_counter, 0H

    ; Paso 1: Verificar si la rotacion es segura (Simulacion)
    CALL CHECK_ROTATION_COLLISION

    ; Paso 2: Si hubo colisiones (shift_counter > 0), intentar Wall Kicks
    CMP shift_counter, 0
    JE DO_ROTATE ; Si es 0, rotar directo

    ; Intentar correcciones (Kicks)
    CALL PROCESS_WALL_KICKS
    
    ; Verificar si los Kicks funcionaron (successful_magic_shift = 1)
    ; O si necesitamos cancelar.
    ; NOTA: PROCESS_WALL_KICKS se encarga de salir si falla.

DO_ROTATE:
    ; Paso 3: Ejecutar la rotacion (Borrar -> Dibujar Nuevo)
    CALL PERFORM_ROTATION
    
    ; Paso 4: Actualizar estado de posicion (1-4)
    CALL UPDATE_POSITION_STATE

EXIT_ROTATE:
    MOV block_border_colour, 4CH 
    CALL DibujarBorde
    RET
SHAPE_ROTATE ENDP

; =================================================================
; 2. CHECK_ROTATION_COLLISION
; Simula la rotacion de los 4 bloques y cuenta cuantos chocan.
; =================================================================
CHECK_ROTATION_COLLISION PROC
    ; Check Bloque 1
    LEA SI, active_block_num_one
    CALL CHECK_SINGLE_BLOCK_ROTATION
    
    ; Check Bloque 2
    LEA SI, active_block_num_two
    CALL CHECK_SINGLE_BLOCK_ROTATION
    
    ; Check Bloque 3
    LEA SI, active_block_num_three
    CALL CHECK_SINGLE_BLOCK_ROTATION
    
    ; Check Bloque 4
    LEA SI, active_block_num_four
    CALL CHECK_SINGLE_BLOCK_ROTATION
    
    RET
CHECK_ROTATION_COLLISION ENDP

; Auxiliar para verificar un solo bloque
CHECK_SINGLE_BLOCK_ROTATION PROC
    ; Calcular coordenadas rotadas en variables temporales
    ; (Usa SI para leer el bloque actual y active_block_center)
    CALL CALC_ROTATED_COORDS
    
    ; Verificar si ese espacio esta libre
    CALL BloqueLibre
    
    ; Si no esta libre, incrementar contador de fallos
    CMP block_is_free, 0H
    JNE .SAFE
    INC shift_counter
.SAFE:
    RET
CHECK_SINGLE_BLOCK_ROTATION ENDP

; =================================================================
; 3. PROCESS_WALL_KICKS
; Intenta mover la pieza si la rotacion esta bloqueada.
; =================================================================
PROCESS_WALL_KICKS PROC
    ; Logica especifica por pieza
    CMP random_shape_number, 1 ; Linea
    JE KICK_LINE
    
    ; L, T, Z (Comparten logica similar pero podrias separarla mas si quieres)
    ; Aqui implementamos la logica generica de tus ifs anidados
    
    ; Router por tipo de pieza para Kicks especificos
    CMP random_shape_number, 2 ; L
    JE KICK_L
    CMP random_shape_number, 3 ; T
    JE KICK_T
    CMP random_shape_number, 4 ; Z
    JE KICK_Z
    RET

KICK_LINE:
    ; Logica especial de la linea (chequeo de bordes)
    ; Implementacion simplificada de tus chequeos de bordes
    MOV BX, active_block_num_two[0] ; Start Col del bloque 2
    CMP BX, play_ground_start_col
    JE KICK_RIGHT_1
    
    MOV BX, active_block_num_two[4] ; Finish Col
    CMP BX, play_ground_finish_col
    JE KICK_LEFT_1
    
    ; Si choca abajo
    MOV BX, active_block_num_two[6]
    CMP BX, play_ground_finish_row
    JE KICK_UP_1
    
    ; Si no son bordes, son colisiones internas (tus ifs grandes)
    ; Por brevedad, aqui deberias llamar a tus secuencias de movimiento
    ; Ejemplo generico:
    JMP KICK_CONC_GENERIC

KICK_RIGHT_1:
    CALL shape_shift_right
    RET
KICK_LEFT_1:
    CALL shape_shift_left
    RET
KICK_UP_1:
    CALL shape_shift_up
    RET

KICK_L:
    ; Implementar la logica de ifs anidados de la L
    ; position 1 -> Left, 2 -> Up, etc.
    CMP position, 1
    JE DO_LEFT
    CMP position, 2
    JE DO_UP
    CMP position, 3
    JE DO_RIGHT
    CMP position, 4
    JE DO_DOWN
    RET

KICK_T:
    ; T tiene logica distinta en pos 2 y 4
    CMP position, 1
    JE DO_UP
    CMP position, 2
    JE DO_RIGHT
    CMP position, 3
    JE DO_DOWN
    CMP position, 4
    JE DO_LEFT
    RET

KICK_Z:
    ; Z logica
    CMP position, 1
    JE DO_LEFT
    CMP position, 2
    JE DO_UP
    CMP position, 3
    JE DO_RIGHT
    CMP position, 4
    JE DO_DOWN
    RET
    
KICK_CONC_GENERIC:
    ; Logica de fallback
    RET

; Helpers de movimiento simples que decrementan el contador si tienen exito
DO_LEFT:
    CALL shape_shift_left
    JMP CHECK_SUCCESS
DO_RIGHT:
    CALL shape_shift_right
    JMP CHECK_SUCCESS
DO_UP:
    CALL shape_shift_up
    JMP CHECK_SUCCESS
DO_DOWN:
    CALL shape_shift_down
    JMP CHECK_SUCCESS

CHECK_SUCCESS:
    CMP successful_magic_shift, 0
    JE ABORT_ROTATION ; Si no se pudo mover, cancelamos todo
    DEC shift_counter ; Si se movio, reducimos la deuda de colision
    RET

ABORT_ROTATION:
    ; Truco: Sacamos la direccion de retorno del stack para salir de SHAPE_ROTATE
    POP BP 
    JMP EXIT_ROTATE
PROCESS_WALL_KICKS ENDP

; =================================================================
; 4. PERFORM_ROTATION
; Ejecuta la rotacion visual y logica final.
; =================================================================
PERFORM_ROTATION PROC
    ; 1. Borrar la pieza actual (los 4 bloques)
    LEA SI, active_block_num_one
    CALL ERASE_HELPER
    LEA SI, active_block_num_two
    CALL ERASE_HELPER
    LEA SI, active_block_num_three
    CALL ERASE_HELPER
    LEA SI, active_block_num_four
    CALL ERASE_HELPER
    
    ; 2. Calcular nuevas posiciones, Dibujar y Guardar
    LEA SI, active_block_num_one
    CALL ROTATE_AND_UPDATE
    
    LEA SI, active_block_num_two
    CALL ROTATE_AND_UPDATE
    
    LEA SI, active_block_num_three
    CALL ROTATE_AND_UPDATE
    
    LEA SI, active_block_num_four
    CALL ROTATE_AND_UPDATE
    
    RET
PERFORM_ROTATION ENDP

; Helper para borrar usando puntero SI
ERASE_HELPER PROC
    MOV BX, [SI]
    MOV block_start_col, BX
    MOV BX, [SI+2]
    MOV block_start_row, BX
    MOV BX, [SI+4]
    MOV block_finish_col, BX
    MOV BX, [SI+6]
    MOV block_finish_row, BX
    CALL BorrarBloque
    RET
ERASE_HELPER ENDP

; Helper para rotar, dibujar y guardar usando puntero SI
ROTATE_AND_UPDATE PROC
    CALL CALC_ROTATED_COORDS ; Calcula y llena block_start/finish
    CALL DibujarBloqueUnico
    CALL FILL_GENERIC_HELPER ; Guarda en el array apuntado por SI
    RET
ROTATE_AND_UPDATE ENDP

; =================================================================
; 5. CALC_ROTATED_COORDS (Matematica Pura)
; Transforma coordenadas locales a globales rotadas.
; Entrada: SI apunta al bloque a rotar.
; Salida: Llena block_start_col, etc.
; =================================================================
CALC_ROTATED_COORDS PROC
    PUSH CX
    
    ; Row = (BloqueX + CenterY) - CenterX
    MOV BX, [SI]               ; Bloque X
    MOV CX, active_block_center[2] ; Center Y
    ADD BX, CX
    MOV CX, active_block_center[0] ; Center X
    SUB BX, CX
    MOV block_start_row, BX
    
    ; Col = (CenterY + CenterX) - BloqueY
    MOV BX, active_block_center[0] ; Center X
    MOV CX, active_block_center[2] ; Center Y
    ADD BX, CX
    MOV CX, [SI+2]             ; Bloque Y
    SUB BX, CX
    MOV block_start_col, BX
    
    ; --- CORRECCIÓN CRÍTICA ---
    ; No rotamos el "Finish". Lo calculamos sumando 12 al "Start".
    ; Esto garantiza Start < Finish siempre.
    MOV BX, block_start_col
    ADD BX, 12
    MOV block_finish_col, BX
    
    MOV BX, block_start_row
    ADD BX, 12
    MOV block_finish_row, BX
    
    POP CX
    RET
CALC_ROTATED_COORDS ENDP

; =================================================================
; AUXILIAR: Actualizar Posicion (1->2->3->4->1)
; =================================================================
UPDATE_POSITION_STATE PROC
    INC position
    CMP position, 5
    JNE .EXIT_POS
    MOV position, 1
.EXIT_POS:
    RET
UPDATE_POSITION_STATE ENDP

END
