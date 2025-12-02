.MODEL SMALL

.DATA
    ; --- Variables Locales de Logica de Filas ---
    PUBLIC row_is_full, row_is_smart
    row_is_full  DB 0
    row_is_smart DB 0
    smart_colour DB 0

    ; --- Importar Variables Externas ---
    EXTRN block_start_col:WORD, block_start_row:WORD
    EXTRN block_finish_col:WORD, block_finish_row:WORD
    EXTRN play_ground_start_col:WORD, play_ground_start_row:WORD
    EXTRN play_ground_finish_col:WORD, play_ground_finish_row:WORD
    
    EXTRN block_colour:BYTE
    EXTRN background_colour:BYTE
    EXTRN temp_colour:BYTE
    EXTRN block_is_free_simple:BYTE
    EXTRN score:WORD

.CODE
    ; --- Importar Funciones Externas ---
    EXTRN BloqueLibreSencillo:PROC  ; (is_this_block_free_simple)
    EXTRN DibujarBloqueUnico:PROC   ; (draw_single_block)
    EXTRN BorrarBloque:PROC         ; (erase_single_block)
    PUBLIC check_and_modify_full_rows

; =================================================================
; COLLAPSE: Baja todas las filas superiores cuando una se elimina
; =================================================================
COLLAPSE PROC
    MOV BX, block_finish_row
    SUB BX, 12  
COLLAPSE_LOOP:
    CMP BX, play_ground_start_row
    JE  COLLAPSE_EXIT
    
    MOV block_finish_row, BX
    SUB BX, 12
    MOV block_start_row, BX
    PUSH BX
    
    MOV BX, play_ground_start_col
COLLAPSE_INNER_LOOP:
    CMP BX, play_ground_finish_col    
    JE COLLAPSE_INNER_EXIT
    
    MOV block_start_col, BX
    ADD BX, 12
    MOV block_finish_col, BX
    
    CALL BloqueLibreSencillo
    CMP block_is_free_simple, 0H  
    JNE COLLAPSE_INNER_LOOP
    
    ; Si el bloque de arriba esta ocupado, hay que bajarlo
    CALL BorrarBloque
    
    ADD block_start_row, 12
    ADD block_finish_row, 12
    PUSH BX
    
    MOV BL, temp_colour
    MOV block_colour, BL 
    CALL DibujarBloqueUnico
    
    POP BX
    SUB block_start_row, 12
    SUB block_finish_row, 12
    JMP COLLAPSE_INNER_LOOP

COLLAPSE_INNER_EXIT:      
    POP BX
    JMP COLLAPSE_LOOP  

COLLAPSE_EXIT:   
   RET 
COLLAPSE ENDP

; =================================================================
; CHECK AND MODIFY FULL ROWS: Revisa todo el tablero buscando lineas
; =================================================================
CHECK_AND_MODIFY_FULL_ROWS PROC
    MOV BX, play_ground_finish_row

CHECK_LOOP:
    CMP BX, play_ground_start_row
    JE CHECK_EXIT
    
    MOV block_finish_row, BX
    SUB BX, 12
    MOV block_start_row, BX                                  
    PUSH BX                       
    
    CALL IS_THIS_ROW_FULL
    POP BX
    
    CMP row_is_full, 1H
    JNE CHECK_LOOP          ; Si no esta llena, seguir subiendo
    
    ; Si esta llena, checar "Smart" (mismo color?)
    PUSH BX
    CALL IS_THIS_ROW_SMART
    POP BX
    
    CMP row_is_smart, 1H
    JNE CONTINUE_FULL_ROWS
    ADD score, 10           ; Bonus por fila smart

CONTINUE_FULL_ROWS:    
    PUSH BX
    
    ; Borrar la fila llena (pintando del color de fondo)
    MOV BX, play_ground_start_col
    MOV block_start_col, BX 
    MOV BX, play_ground_finish_col
    MOV block_finish_col, BX
    MOV BL, background_colour 
    MOV block_colour, BL
    CALL DibujarBloqueUnico
    
    ; Colapsar todo lo de arriba
    CALL COLLAPSE
    
    ADD score, 10           ; Puntos por linea
    POP BX
    
    ; Como colapsamos, debemos volver a revisar la misma fila (BX+12)
    ; porque ahora tiene bloques nuevos que bajaron.
    ADD BX, 12
    JMP CHECK_LOOP 

CHECK_EXIT:
     RET
CHECK_AND_MODIFY_FULL_ROWS ENDP

; =================================================================
; IS THIS ROW FULL: Revisa si una fila no tiene huecos
; =================================================================
IS_THIS_ROW_FULL PROC   
    MOV BX, play_ground_start_col
    MOV row_is_full, 1H 

FULL_LOOP:
    CMP BX, play_ground_finish_col
    JE FULL_EXIT
    
    MOV block_start_col, BX
    ADD BX, 12
    MOV block_finish_col, BX
    
    CALL BloqueLibreSencillo
    CMP block_is_free_simple, 1H    
    JE  FULL_SET_FALSE      ; Si encontramos un hueco, no esta llena
    JMP FULL_LOOP

FULL_SET_FALSE:
     MOV row_is_full, 0H     

FULL_EXIT:           
    RET
IS_THIS_ROW_FULL ENDP

; =================================================================
; IS THIS ROW SMART: Revisa si toda la fila es del mismo color
; =================================================================
IS_THIS_ROW_SMART PROC 
    MOV row_is_smart, 1H
    
    ; 1. Leer el color del primer bloque
    MOV BX, play_ground_start_col    
    MOV block_start_col, BX
    ADD BX, 12
    MOV block_finish_col, BX  
    
    ; Ajuste para leer pixel central
    INC block_start_col
    INC block_start_row
    DEC block_finish_col
    DEC block_finish_row 
    
    MOV AH, 0DH                    
    MOV CX, block_start_col
    MOV DX, block_start_row
    INT 10H
    MOV smart_colour, AL
    
    ; Restaurar coords
    DEC block_start_col
    DEC block_start_row
    INC block_finish_col
    INC block_finish_row
    
    MOV BX, play_ground_start_col  

SMART_LOOP:
    CMP BX, play_ground_finish_col
    JE SMART_EXIT
    
    MOV block_start_col, BX
    ADD BX, 12
    MOV block_finish_col, BX
    
    INC block_start_col
    INC block_start_row
    DEC block_finish_col
    DEC block_finish_row 
    
    MOV AH, 0DH                    
    MOV CX, block_start_col
    MOV DX, block_start_row
    INT 10H
    
    DEC block_start_col
    DEC block_start_row
    INC block_finish_col
    INC block_finish_row  
    
    CMP AL, smart_colour
    JNE SMART_SET_FALSE     ; Si un color es distinto, no es smart
    JMP SMART_LOOP

SMART_SET_FALSE:
    MOV row_is_smart, 0H

SMART_EXIT:    
    RET
IS_THIS_ROW_SMART ENDP

END
