.MODEL SMALL
.STACK 100h

.DATA
    delay_counter DW 0


.CODE
EXTRN shape_shift_right : PROC
EXTRN shape_shift_left : PROC
EXTRN shape_shift_down : PROC
EXTRN shape_rotate : PROC
EXTRN successful_magic_shift : BYTE 

PUBLIC LlamarTeclado

LlamarTeclado PROC
    MOV delay_counter, 1
delay_loop3:
    MOV CX, 0FFFFH
    INC delay_counter
delay_loop4:
    CALL Acciones
    LOOP delay_loop4
    CMP delay_counter, 5
    JNZ delay_loop3
    RET
LlamarTeclado ENDP

Acciones PROC
; --- 1. Verificar si hay tecla presionada (No bloqueante) ---
    MOV AH, 01h
    INT 16h
    JZ arrow_exit           ; Si Z=1, no hay tecla, salir

    ; --- 2. Leer la tecla (Bloqueante, pero sabemos que hay una) ---
    MOV AH, 00h
    INT 16h                 ; AL = ASCII, AH = Scan Code

    ; --- 3. Router de Teclas ---
    CMP AL, 'd'
    JE shape_shift_right_label
    CMP AL, 'a'
    JE shape_shift_left_label
    CMP AL, 's' 
    JE shape_shift_down_label 
    CMP AL, 'w'
    JE shape_rotate_label
    CMP AL, 'f'
    JE fast_shape_shift_down_label
    
    ; Si no es ninguna de las anteriores, salir (Seguridad)
    JMP arrow_exit

shape_shift_right_label: 
    CALL shape_shift_right
    JMP arrow_exit

shape_shift_left_label:
    CALL shape_shift_left
    JMP arrow_exit 

shape_shift_down_label:
    CALL shape_shift_down
    JMP arrow_exit                        

shape_rotate_label:
    CALL shape_rotate
    JMP arrow_exit 

fast_shape_shift_down_label:
fast_loop:
    CALL shape_shift_down
    CMP successful_magic_shift, 0H ; Verifica si chocó
    JE arrow_exit                  ; Si chocó (0), termina el loop
    JMP fast_loop                  ; Si bajó bien (1), repite

arrow_exit:
    RET
Acciones ENDP

END
