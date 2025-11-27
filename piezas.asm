.MODEL SMALL
.DATA

    active_block_num_one DW ?, ?, ?, ?
    active_block_num_two DW ?, ?, ?, ?
    active_block_num_three DW ?, ?, ?, ?
    active_block_num_four DW ?, ?, ?, ?    
    active_block_center DW ?, ?, ?, ?     
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

EXTRN DibujarBloqueUnico : PROC
EXTRN block_colour : BYTE
EXTRN block_start_col : WORD
EXTRN block_start_row : WORD
EXTRN block_finish_col : WORD
EXTRN block_finish_row : WORD

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
    MOV block_finish_col, 160
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

END
