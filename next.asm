.MODEL SMALL
.STACK 100h

DIBUJAR_BLOQUE_RELATIVO MACRO X, Y
    MOV AX, X
    MOV block_start_col, AX
    ADD AX, 12
    MOV block_finish_col, AX

    MOV AX, Y
    ADD AX, temp_y_offset
    MOV block_start_row, AX
    ADD AX, 12
    MOV block_finish_row, AX

    CALL DibujarBloqueUnico
ENDM

.DATA

    EXTRN block_start_row : WORD
    EXTRN block_finish_row : WORD
    EXTRN block_start_col : WORD
    EXTRN block_finish_col : WORD
    EXTRN random_incoming1_shape_number : BYTE
    EXTRN random_incoming2_shape_number : BYTE
    EXTRN block_colour : BYTE

    temp_y_offset DW 0
.CODE

EXTRN DibujarBloqueUnico : PROC

PUBLIC display_upcoming_1
PUBLIC display_upcoming_2
PUBLIC LimpiarSiguiente

LimpiarSiguiente proc
    MOV AH, 0Ch
    MOV AL, 0h
    MOV DX, 40  
clear_upcoming_panel_loop1:
    MOV CX, 256
clear_upcoming_panel_loop2:
    INT 10h
    INC CX
    CMP CX, 304
    JNZ clear_upcoming_panel_loop2
    INC DX
    CMP DX, 76
    JNZ clear_upcoming_panel_loop1
    MOV AH, 0ch
    MOV AL, 0h
    MOV DX, 136  
clear_upcoming_panel_loop3:
    MOV CX, 256
clear_upcoming_panel_loop4:
    INT 10h
    INC CX
    CMP CX, 304
    JNZ clear_upcoming_panel_loop4
    INC DX
    CMP DX, 172
    JNZ clear_upcoming_panel_loop3
    RET
LimpiarSiguiente ENDP

Draw_Upcoming_Generic PROC
    cmp al, 0
    je .draw_up_square_t
    cmp al, 1
    je .draw_up_line_t
    cmp al, 2
    je .draw_up_L_t
    cmp al, 3
    je .draw_up_T_t
    cmp al, 4
    je .draw_up_Z_t
    ret

.draw_up_square_t:
    JMP draw_up_square

.draw_up_line_t:
    JMP draw_up_line

.draw_up_L_t:
    JMP draw_up_L

.draw_up_T_t:
    JMP draw_up_T

.draw_up_Z_t:
    JMP draw_up_Z

draw_up_square: ; ID 0
    mov block_colour, 0EH
    DIBUJAR_BLOQUE_RELATIVO 268, 40
    DIBUJAR_BLOQUE_RELATIVO 268, 52
    DIBUJAR_BLOQUE_RELATIVO 280, 40
    DIBUJAR_BLOQUE_RELATIVO 280, 52
    ret

draw_up_line:   ; ID 1
    mov block_colour, 9H
    DIBUJAR_BLOQUE_RELATIVO 256, 40
    DIBUJAR_BLOQUE_RELATIVO 268, 40
    DIBUJAR_BLOQUE_RELATIVO 280, 40
    DIBUJAR_BLOQUE_RELATIVO 292, 40
    ret

draw_up_L:      ; ID 2
    mov block_colour, 2H
    DIBUJAR_BLOQUE_RELATIVO 268, 40
    DIBUJAR_BLOQUE_RELATIVO 268, 52
    DIBUJAR_BLOQUE_RELATIVO 268, 64
    DIBUJAR_BLOQUE_RELATIVO 280, 64
    ret

draw_up_T:      ; ID 3
    mov block_colour, 4H
    DIBUJAR_BLOQUE_RELATIVO 256, 64
    DIBUJAR_BLOQUE_RELATIVO 268, 64
    DIBUJAR_BLOQUE_RELATIVO 268, 52
    DIBUJAR_BLOQUE_RELATIVO 280, 64
    ret

draw_up_Z:      ; ID 4
    mov block_colour, 6H
    DIBUJAR_BLOQUE_RELATIVO 268, 40
    DIBUJAR_BLOQUE_RELATIVO 268, 52
    DIBUJAR_BLOQUE_RELATIVO 280, 52
    DIBUJAR_BLOQUE_RELATIVO 280, 64
    ret
Draw_Upcoming_Generic ENDP

display_upcoming_1 PROC
    mov temp_y_offset, 0      ; Offset 0 (posición original arriba)
    mov al, random_incoming1_shape_number
    call Draw_Upcoming_Generic
    ret
display_upcoming_1 ENDP

display_upcoming_2 PROC
    mov temp_y_offset, 96     ; Offset 96 (136 - 40 = 96 pixeles mas abajo)
    mov al, random_incoming2_shape_number
    call Draw_Upcoming_Generic
    ret
display_upcoming_2 ENDP

END
