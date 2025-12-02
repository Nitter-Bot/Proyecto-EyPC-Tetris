.MODEL SMALL

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
PUBLIC magic_shift_right

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

END
