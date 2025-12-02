.MODEL SMALL
; --- MACRO: Verificar Limite del Tablero ---
; Compara una coordenada especifica (Offset) de los 4 bloques contra un limite
CHECK_LIMITS MACRO OFFSET_IDX, LIMIT_VAR, JUMP_EXIT
    LOCAL check_two
    LOCAL check_three
    LOCAL check_four
    LOCAL safe_continue

    ; --- Bloque 1 ---
    MOV BX, active_block_num_one[OFFSET_IDX]
    CMP BX, LIMIT_VAR
    JNE check_two      ; Si NO es igual, revisa el siguiente
    JMP JUMP_EXIT       ; Si ES igual, usa JMP largo a la salida

check_two:
    ; --- Bloque 2 ---
    MOV BX, active_block_num_two[OFFSET_IDX]
    CMP BX, LIMIT_VAR
    JNE check_three
    JMP JUMP_EXIT

check_three:
    ; --- Bloque 3 ---
    MOV BX, active_block_num_three[OFFSET_IDX]
    CMP BX, LIMIT_VAR
    JNE check_four
    JMP JUMP_EXIT

check_four:
    ; --- Bloque 4 ---
    MOV BX, active_block_num_four[OFFSET_IDX]
    CMP BX, LIMIT_VAR
    JNE safe_continue
    JMP JUMP_EXIT

safe_continue:
    ; Si llega aqui, ninguno choco con el limite
ENDM

; --- CORRECCION AQUI: Recargar CX y DX antes de cada bloque ---
CHECK_COLLISION MACRO OFF_X, OFF_Y, JUMP_EXIT
    ; Bloque 1
    MOV CX, OFF_X  ; <--- RECARGAR CX
    MOV DX, OFF_Y  ; <--- RECARGAR DX
    LEA SI, active_block_num_one
    CALL PREPARE_COLLISION_CHECK
    CALL BloqueLibre
    CMP block_is_free, 0H
    JE JUMP_EXIT
    
    ; Bloque 2
    MOV CX, OFF_X  ; <--- RECARGAR CX
    MOV DX, OFF_Y  ; <--- RECARGAR DX
    LEA SI, active_block_num_two
    CALL PREPARE_COLLISION_CHECK
    CALL BloqueLibre
    CMP block_is_free, 0H
    JE JUMP_EXIT
    
    ; Bloque 3
    MOV CX, OFF_X  ; <--- RECARGAR CX
    MOV DX, OFF_Y  ; <--- RECARGAR DX
    LEA SI, active_block_num_three
    CALL PREPARE_COLLISION_CHECK
    CALL BloqueLibre
    CMP block_is_free, 0H
    JE JUMP_EXIT
    
    ; Bloque 4
    MOV CX, OFF_X  ; <--- RECARGAR CX
    MOV DX, OFF_Y  ; <--- RECARGAR DX
    LEA SI, active_block_num_four
    CALL PREPARE_COLLISION_CHECK
    CALL BloqueLibre
    CMP block_is_free, 0H
    JE JUMP_EXIT
ENDM

BorrarTemporal MACRO ARRAY_PTR
    ; 1. Cargar coords actuales y BORRAR
    MOV BX, ARRAY_PTR[0]
    MOV block_start_col, BX
    MOV BX, ARRAY_PTR[2]
    MOV block_start_row, BX
    MOV BX, ARRAY_PTR[4]
    MOV block_finish_col, BX
    MOV BX, ARRAY_PTR[6]
    MOV block_finish_row, BX

    CALL BorrarBloque
ENDM

BORRAR_TODOS MACRO
    BorrarTemporal active_block_num_one
    BorrarTemporal active_block_num_two
    BorrarTemporal active_block_num_three
    BorrarTemporal active_block_num_four
ENDM

ACTUALIZAR_POS_GENERICO MACRO ARRAY_PTR, FILLER, OFF_X, OFF_Y, Dibujar
    
    ; --- Actualizar X ---
    MOV BX, ARRAY_PTR[0]
    IF OFF_X NE 0        ; Solo genera codigo si el offset no es 0
        ADD BX, OFF_X
    ENDIF
    MOV block_start_col, BX
    
    ; --- Actualizar Y ---
    MOV BX, ARRAY_PTR[2]
    IF OFF_Y NE 0
        ADD BX, OFF_Y
    ENDIF
    MOV block_start_row, BX
    
    ; --- Actualizar X Fin ---
    MOV BX, ARRAY_PTR[4]
    IF OFF_X NE 0
        ADD BX, OFF_X
    ENDIF
    MOV block_finish_col, BX
    
    ; --- Actualizar Y Fin ---
    MOV BX, ARRAY_PTR[6]
    IF OFF_Y NE 0
        ADD BX, OFF_Y
    ENDIF
    MOV block_finish_row, BX

    IF Dibujar NE 0
        CALL DibujarBloqueUnico
    ENDIF

    CALL FILLER
ENDM

ACTUALIZAR_TODOS MACRO VAL_X, VAL_Y
    ACTUALIZAR_POS_GENERICO active_block_num_one,   fill_array_num_one,   VAL_X, VAL_Y,1
    ACTUALIZAR_POS_GENERICO active_block_num_two,   fill_array_num_two,   VAL_X, VAL_Y,1
    ACTUALIZAR_POS_GENERICO active_block_num_three, fill_array_num_three, VAL_X, VAL_Y,1
    ACTUALIZAR_POS_GENERICO active_block_num_four,  fill_array_num_four,  VAL_X, VAL_Y,1
    ACTUALIZAR_POS_GENERICO active_block_center,    fill_center_block,    VAL_X, VAL_Y,0
ENDM

.DATA

    active_block_num_one DW ?, ?, ?, ?
    active_block_num_two DW ?, ?, ?, ?
    active_block_num_three DW ?, ?, ?, ?
    active_block_num_four DW ?, ?, ?, ?    
    active_block_center DW ?, ?, ?, ?     
    successful_magic_shift DB 0
    produce_next_shape DB 0
    PUBLIC active_block_num_one
    PUBLIC active_block_num_two
    PUBLIC active_block_num_three
    PUBLIC active_block_num_four
    EXTRN block_is_free : BYTE
.CODE

PUBLIC draw_square_block
PUBLIC draw_square_block_2
PUBLIC draw_rectangle_block
PUBLIC draw_rectangle_block_2
PUBLIC draw_L_block
PUBLIC draw_L_block_2
PUBLIC draw_L_block_3
PUBLIC draw_T_block
PUBLIC draw_T_block_2
PUBLIC draw_Z_block
PUBLIC draw_Z_block_2
PUBLIC draw_Z_block_3
PUBLIC shape_shift_right
PUBLIC shape_shift_left
PUBLIC shape_shift_down
PUBLIC shape_shift_up

EXTRN DibujarBloqueUnico : PROC
EXTRN block_colour : BYTE
EXTRN block_start_col : WORD
EXTRN block_start_row : WORD
EXTRN block_finish_col : WORD
EXTRN block_finish_row : WORD
EXTRN BorrarBLoque : PROC
EXTRN BLoqueLibre : PROC
EXTRN DibujarBorde : PROC
EXTRN play_ground_start_col : WORD
EXTRN play_ground_start_row : WORD
EXTRN play_ground_finish_col : WORD
EXTRN play_ground_finish_row : WORD
EXTRN block_border_colour : BYTE

draw_square_block PROC
    MOV block_start_col, 148
    MOV block_start_row, 4
    MOV block_finish_col, 160
    MOV block_finish_row, 16
    CALL DibujarBloqueUnico 
    CALL fill_array_num_one
    MOV block_start_col, 160
    MOV block_start_row, 4
    MOV block_finish_col, 172
    MOV block_finish_row, 16
    CALL DibujarBloqueUnico
    CALL fill_array_num_two
    MOV block_start_col, 148
    MOV block_start_row, 16
    MOV block_finish_col, 160
    MOV block_finish_row, 28
    CALL DibujarBloqueUnico
    CALL fill_array_num_three
    MOV block_start_col, 160
    MOV block_start_row, 16
    MOV block_finish_col, 172
    MOV block_finish_row, 28
    CALL DibujarBloqueUnico
    CALL fill_array_num_four
    ret
draw_square_block ENDP

draw_square_block_2 PROC
    MOV block_start_col, 148
    MOV block_start_row, 4
    MOV block_finish_col, 160
    MOV block_finish_row, 16
    CALL DibujarBloqueUnico 
    MOV block_start_col, 160
    MOV block_start_row, 4
    MOV block_finish_col, 172
    MOV block_finish_row, 16
    CALL DibujarBloqueUnico
    RET
draw_square_block_2 ENDP

draw_rectangle_block PROC
    MOV block_start_col, 136
    MOV block_start_row, 16
    MOV block_finish_col, 148
    MOV block_finish_row, 28
    CALL DibujarBloqueUnico
    CALL fill_array_num_one
    MOV block_start_col, 148
    MOV block_start_row, 16
    MOV block_finish_col, 160
    MOV block_finish_row, 28
    CALL DibujarBloqueUnico
    CALL fill_array_num_two
    MOV block_start_col, 160
    MOV block_start_row, 16
    MOV block_finish_col, 172
    MOV block_finish_row, 28
    CALL DibujarBloqueUnico
    CALL fill_array_num_three
    MOV block_start_col, 172
    MOV block_start_row, 16
    MOV block_finish_col, 184
    MOV block_finish_row, 28
    CALL DibujarBloqueUnico
    CALL fill_array_num_four 
    MOV block_start_col, 160
    MOV block_start_row, 28
    MOV block_finish_col, 172
    MOV block_finish_row, 28
    CALL fill_center_block
    ret
draw_rectangle_block ENDP 

draw_rectangle_block_2 PROC
    MOV block_start_col, 136
    MOV block_start_row, 4
    MOV block_finish_col, 148
    MOV block_finish_row, 16
    CALL DibujarBloqueUnico
    CALL fill_array_num_one
    MOV block_start_col, 148
    MOV block_start_row, 4
    MOV block_finish_col, 160
    MOV block_finish_row, 16
    CALL DibujarBloqueUnico
    CALL fill_array_num_two
    MOV block_start_col, 160
    MOV block_start_row, 4
    MOV block_finish_col, 172
    MOV block_finish_row, 16
    CALL DibujarBloqueUnico
    CALL fill_array_num_three
    MOV block_start_col, 172
    MOV block_start_row, 4
    MOV block_finish_col, 184
    MOV block_finish_row, 16
    CALL DibujarBloqueUnico
    CALL fill_array_num_four 
    MOV block_start_col, 160
    MOV block_start_row, 16
    MOV block_finish_col, 160
    MOV block_finish_row, 16
    CALL fill_center_block
    ret
draw_rectangle_block_2 ENDP 

draw_L_block PROC
    MOV block_start_col, 148
    MOV block_start_row, 4
    MOV block_finish_col, 160
    MOV block_finish_row, 16
    CALL DibujarBloqueUnico
    CALL fill_array_num_one
    MOV block_start_col, 148
    MOV block_start_row, 16
    MOV block_finish_col, 160
    MOV block_finish_row, 28
    CALL DibujarBloqueUnico
    CALL fill_array_num_two
    MOV block_start_col, 148
    MOV block_start_row, 28
    MOV block_finish_col, 160
    MOV block_finish_row, 40
    CALL DibujarBloqueUnico
    CALL fill_array_num_three
    MOV block_start_col, 160
    MOV block_start_row, 28
    MOV block_finish_col, 172
    MOV block_finish_row, 40
    CALL DibujarBloqueUnico 
    CALL fill_array_num_four
    MOV block_start_col, 160
    MOV block_start_row, 16
    MOV block_finish_col, 172
    MOV block_finish_row, 28
    CALL fill_center_block
    ret
draw_L_block ENDP 

draw_L_block_2 PROC
    MOV block_start_col, 148
    MOV block_start_row, 4
    MOV block_finish_col, 160
    MOV block_finish_row, 16
    CALL DibujarBloqueUnico 
    MOV block_start_col, 160
    MOV block_start_row, 4
    MOV block_finish_col, 172
    MOV block_finish_row, 16
    CALL DibujarBloqueUnico
    RET
draw_L_block_2 ENDP

draw_L_block_3 PROC
    MOV block_start_col, 148
    MOV block_start_row, 16
    MOV block_finish_col, 160
    MOV block_finish_row, 28
    CALL DibujarBloqueUnico 
    MOV block_start_col, 160
    MOV block_start_row, 16
    MOV block_finish_col, 172
    MOV block_finish_row, 28
    CALL DibujarBloqueUnico
    MOV block_start_col, 148
    MOV block_start_row, 4
    MOV block_finish_col, 160
    MOV block_finish_row, 16
    CALL DibujarBloqueUnico
    ret 
draw_L_block_3 ENDP

draw_T_block PROC
    MOV block_start_col, 148
    MOV block_start_row, 4
    MOV block_finish_col, 160
    MOV block_finish_row, 16
    CALL DibujarBloqueUnico
    CALL fill_array_num_one
    MOV block_start_col, 136
    MOV block_start_row, 16
    MOV block_finish_col, 148
    MOV block_finish_row, 28
    CALL DibujarBloqueUnico 
    CALL fill_array_num_two
    MOV block_start_col, 148
    MOV block_start_row, 16
    MOV block_finish_col, 160
    MOV block_finish_row, 28
    CALL DibujarBloqueUnico 
    CALL fill_array_num_three
    MOV block_start_col, 160
    MOV block_start_row, 16
    MOV block_finish_col, 172
    MOV block_finish_row, 28
    CALL DibujarBloqueUnico   
    CALL fill_array_num_four 
    MOV block_start_col, 148
    MOV block_start_row, 16
    MOV block_finish_col, 160
    MOV block_finish_row, 28
    CALL fill_center_block
    ret
draw_T_block ENDP 

draw_T_block_2 PROC
    MOV block_start_col, 136
    MOV block_start_row, 4
    MOV block_finish_col, 148
    MOV block_finish_row, 16
    CALL DibujarBloqueUnico 
    MOV block_start_col, 148
    MOV block_start_row, 4
    MOV block_finish_col, 160
    MOV block_finish_row, 16
    CALL DibujarBloqueUnico 
    MOV block_start_col, 160
    MOV block_start_row, 4
    MOV block_finish_col, 172
    MOV block_finish_row, 16
    CALL DibujarBloqueUnico   
    ret
draw_T_block_2 ENDP

draw_Z_block PROC
    MOV block_start_col, 148
    MOV block_start_row, 4
    MOV block_finish_col, 160
    MOV block_finish_row, 16
    CALL DibujarBloqueUnico  
    CALL fill_array_num_one
    MOV block_start_col, 148
    MOV block_start_row, 16
    MOV block_finish_col, 160
    MOV block_finish_row, 28
    CALL DibujarBloqueUnico 
    CALL fill_array_num_two
    MOV block_start_col, 160
    MOV block_start_row, 16
    MOV block_finish_col, 172
    MOV block_finish_row, 28
    CALL DibujarBloqueUnico 
    CALL fill_array_num_three
    MOV block_start_col, 160
    MOV block_start_row, 28
    MOV block_finish_col, 172
    MOV block_finish_row, 40
    CALL DibujarBloqueUnico   
    CALL fill_array_num_four
    MOV block_start_col, 160
    MOV block_start_row, 16
    MOV block_finish_col, 172
    MOV block_finish_row, 28
    CALL fill_center_block 
    MOV block_start_col, 148
    MOV block_start_row, 16
    MOV block_finish_col, 160
    MOV block_finish_row, 28
    CALL fill_center_block
    ret
draw_Z_block ENDP

draw_Z_block_2 PROC
    MOV block_start_col, 160
    MOV block_start_row, 4
    MOV block_finish_col, 172
    MOV block_finish_row, 16
    CALL DibujarBloqueUnico  
    ret
draw_Z_block_2 ENDP  

draw_Z_block_3 PROC
    MOV block_start_col, 148
    MOV block_start_row, 4
    MOV block_finish_col, 160
    MOV block_finish_row, 16
    CALL DibujarBloqueUnico  
    MOV block_start_col, 160
    MOV block_start_row, 4
    MOV block_finish_col, 172
    MOV block_finish_row, 16
    CALL DibujarBloqueUnico
    MOV block_start_col, 160
    MOV block_start_row, 16
    MOV block_finish_col, 172
    MOV block_finish_row, 28
    CALL DibujarBloqueUnico  
    ret
draw_Z_block_3 ENDP

; --- PROCEDIMIENTO AUXILIAR (Privado) ---
; Copia las coordenadas actuales al array apuntado por SI
FILL_GENERIC_HELPER PROC
    MOV BX, block_start_col   
    MOV [SI], BX         
    ADD SI, 2
    MOV BX, block_start_row 
    MOV [SI], BX        
    ADD SI, 2
    MOV BX, block_finish_col 
    MOV [SI], BX         
    ADD SI, 2
    MOV BX, block_finish_row
    MOV [SI], BX         
    ADD SI, 2   
    RET
FILL_GENERIC_HELPER ENDP

; --- FUNCIONES ORIGINALES (Refactorizadas) ---

fill_array_num_one PROC
    LEA SI, active_block_num_one
    CALL FILL_GENERIC_HELPER
    RET              
fill_array_num_one ENDP

fill_array_num_two PROC
    LEA SI, active_block_num_two
    CALL FILL_GENERIC_HELPER
    RET              
fill_array_num_two ENDP

fill_array_num_three PROC
    LEA SI, active_block_num_three
    CALL FILL_GENERIC_HELPER
    RET              
fill_array_num_three ENDP

fill_array_num_four PROC
    LEA SI, active_block_num_four
    CALL FILL_GENERIC_HELPER
    RET              
fill_array_num_four ENDP 

fill_center_block PROC
    LEA SI, active_block_center
    CALL FILL_GENERIC_HELPER
    RET              
fill_center_block ENDP

magic_shift_right PROC
    BORRAR_TODOS            ; Fase 1: Borrar todo
    ACTUALIZAR_TODOS 12, 0  ; Fase 2: Mover X+12, Y+0
    RET
magic_shift_right ENDP

magic_shift_left PROC
    BORRAR_TODOS            ; Fase 1: Borrar todo
    ACTUALIZAR_TODOS -12, 0 ; Fase 2: Mover X-12, Y+0
    RET
magic_shift_left ENDP

magic_shift_down PROC
    BORRAR_TODOS            ; Fase 1: Borrar todo
    ACTUALIZAR_TODOS 0, 12  ; Fase 2: Mover X+0, Y+12
    RET
magic_shift_down ENDP

magic_shift_up PROC
    BORRAR_TODOS            ; Fase 1: Borrar todo
    ACTUALIZAR_TODOS 0, -12 ; Fase 2: Mover X+0, Y-12
    RET
magic_shift_up ENDP

PREPARE_COLLISION_CHECK PROC
    MOV BX, [SI]      
    ADD BX, CX        
    MOV block_start_col, BX
    
    MOV BX, [SI+2]    
    ADD BX, DX        
    MOV block_start_row, BX
    
    MOV BX, [SI+4]    
    ADD BX, CX        
    MOV block_finish_col, BX
    
    MOV BX, [SI+6]    
    ADD BX, DX        
    MOV block_finish_row, BX
    RET
PREPARE_COLLISION_CHECK ENDP

SHAPE_SHIFT_RIGHT PROC
    MOV successful_magic_shift, 0H
    
    ; 1. Verificar Limites
    CHECK_LIMITS 4, play_ground_finish_col, EXIT_SHAPE_SHIFT_RIGHT
    
    ; 2. Verificar Colision (+12 X, 0 Y)
    ; La macro ahora se encarga de cargar 12 y 0 en cada paso
    CHECK_COLLISION 12, 0, EXIT_SHAPE_SHIFT_RIGHT
    
    ; 3. Mover
    CALL magic_shift_right
    MOV successful_magic_shift, 1H

EXIT_SHAPE_SHIFT_RIGHT:
    MOV block_border_colour, 4CH 
    CALL DibujarBorde
    RET   
SHAPE_SHIFT_RIGHT ENDP 

SHAPE_SHIFT_LEFT PROC
    MOV successful_magic_shift, 0H 
    
    CHECK_LIMITS 0, play_ground_start_col, EXIT_SHAPE_SHIFT_LEFT
    
    ; Verificar Colision (-12 X, 0 Y)
    CHECK_COLLISION -12, 0, EXIT_SHAPE_SHIFT_LEFT
    
    CALL magic_shift_left
    MOV successful_magic_shift, 1H

EXIT_SHAPE_SHIFT_LEFT:
    MOV block_border_colour, 4CH 
    CALL DibujarBorde
    RET   
SHAPE_SHIFT_LEFT ENDP

SHAPE_SHIFT_DOWN PROC 
    MOV produce_next_shape, 0H
    MOV successful_magic_shift, 0H 
    
    CHECK_LIMITS 6, play_ground_finish_row, EXIT_SHAPE_SHIFT_DOWN
    
    ; Verificar Colision (0 X, +12 Y)
    CHECK_COLLISION 0, 12, EXIT_SHAPE_SHIFT_DOWN
    
    CALL magic_shift_down
    MOV successful_magic_shift, 1H
    JMP EXIT_SHAPE_SHIFT_DOWN_WITHOUT_ANY_PRODUCE

EXIT_SHAPE_SHIFT_DOWN:
    MOV produce_next_shape, 1H 

EXIT_SHAPE_SHIFT_DOWN_WITHOUT_ANY_PRODUCE:
    RET
SHAPE_SHIFT_DOWN ENDP   

SHAPE_SHIFT_UP PROC 
    MOV successful_magic_shift, 0H 
    
    CHECK_LIMITS 2, play_ground_start_row, EXIT_SHAPE_SHIFT_UP
    
    ; Verificar Colision (0 X, -12 Y)
    CHECK_COLLISION 0, -12, EXIT_SHAPE_SHIFT_UP    
    
    CALL magic_shift_up
    MOV successful_magic_shift, 1H

EXIT_SHAPE_SHIFT_UP:
    RET
SHAPE_SHIFT_UP ENDP
END
