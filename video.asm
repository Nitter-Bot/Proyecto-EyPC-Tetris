;Funciones para generar pantalla del juego

.MODEL SMALL
.CODE

; --- Funciones públicas (para TETRIS.ASM) ---
PUBLIC IniciarGraficos
PUBLIC RestaurarModoTexto
PUBLIC PantallaJuego

; --- Procedimiento IniciarModoGrafico ---
; Establece Modo 13h (320x200) y apunta ES a la VRAM.
IniciarGraficos PROC
    PUSH AX
    MOV AX, 0013h
    INT 10h
    MOV AX, 0A000h
    MOV ES, AX
    POP AX
    RET
IniciarGraficos ENDP

; --- Procedimiento RestaurarModoTexto ---
; Regresa a modo texto 80x25.
RestaurarModoTexto PROC
    PUSH AX
    MOV AX, 0003h
    INT 10h
    POP AX
    RET
RestaurarModoTexto ENDP

; --- Procedimiento DibujaPixel ---
; Dibuja un píxel en la pantalla.
; Dada la coordenada calcula el offset donde debe
; ser dibujado
DibujaPixel PROC
    PUSH AX
    PUSH BX
    PUSH CX ; X
    PUSH DX ; Y
    
    ; Calcular offset = (y*320)+x
    MOV AX, 320
    MUL DX      ; AX = Y*320
    ADD AX, CX  ; AX += X
    MOV DI, AX

    POP DX
    POP CX
    POP BX
    POP AX

    ; Escribir el píxel
    MOV ES:[DI], SI
    RET
DibujaPixel ENDP

; --- Procedimiento DibujaRectangulo (Helper Interno) ---
; Dibuja un rectángulo (solo bordes).
; Entrada: AX = x1, BX = y1, CX = x2, DX = y2, SI = Color
DibujaRectangulo PROC
    PUSH AX     ; x1
    PUSH BX     ; y1
    PUSH CX     ; x2
    PUSH DX     ; y2
    
    ; --- 2. Crear el "Stack Frame" ---
    PUSH BP         ; Guardar el BP anterior
    MOV BP, SP      ; Apuntar BP a la cima del stack

    ; --- 3. Reservar espacio para variables locales ---
    ;    (No necesitamos, usaremos los valores de la pila)
    
    ; --- Cómo acceder a los parámetros guardados (relativo a BP) ---
    ; [BP+12] = AX (x1)
    ; [BP+10] = BX (y1)
    ; [BP+8]  = CX (x2)
    ; [BP+6]  = DX (y2)
    ; [BP+4]  = SI (Color)
    ; [BP+2]  = IP de retorno
    ; [BP]    = BP anterior


    ; 1. Línea superior (y1)
    MOV DX, [BP+10] ; DX = y1
    MOV CX, [BP+12] ; CX = x1 (inicio del loop)
    .LOOP_TOP:
        CALL DibujaPixel
        INC CX
        CMP CX, [BP+8] ; Compara CX (actual) con x2
    JLE .LOOP_TOP

    ; 2. Línea inferior (y2)
    MOV DX, [BP+6]  ; DX = y2
    MOV CX, [BP+12] ; CX = x1
    .LOOP_BOTTOM:
        CALL DibujaPixel
        INC CX
        CMP CX, [BP+8] ; Compara CX con x2
    JLE .LOOP_BOTTOM

    ; 3. Línea izquierda (x1)
    MOV CX, [BP+12] ; CX = x1
    MOV DX, [BP+10] ; DX = y1 (inicio del loop)
    .LOOP_LEFT:
        CALL DibujaPixel
        INC DX
        CMP DX, [BP+6] ; Compara DX (actual) con y2
    JLE .LOOP_LEFT

    ; 4. Línea derecha (x2)
    MOV CX, [BP+8]  ; CX = x2
    MOV DX, [BP+10] ; DX = y1
    .LOOP_RIGHT:
        CALL DibujaPixel
        INC DX
        CMP DX, [BP+6] ; Compara DX con y2
   JLE .LOOP_RIGHT
   
    ; --- 4. Destruir el "Stack Frame" ---
    POP BP          ; Restaurar el BP anterior
    
    ; --- 5. Restaurar registros de entrada ---
    POP DX
    POP CX
    POP BX
    POP AX
    RET
DibujaRectangulo ENDP

; --- Procedimiento PantallaJuego (Público) ---
; Dibuja el layout principal del juego (cajas).
; Tablero, Puntuacion, Siguiente pieza
PantallaJuego PROC
    PUSH AX
    PUSH BX
    PUSH CX
    PUSH DX
    PUSH SI

    ; --- Definir color ---
    MOV SI, 15  ; Color blanco brillante

    ; --- Caja 1: Tablero (100x200 píxeles) ---
    ; (Esto es para un tablero de 10 bloques de 10px de ancho)
    MOV AX, 0  ; x1 = 10
    MOV BX, 10   ; y1 = 0
    MOV CX, 199 ; x2 = 110 (10 + 100)
    MOV DX, 110 ; y2 = 199 (0 + 199, casi 200 de alto)
    CALL DibujaRectangulo

    ; --- Caja 2: Puntuación ---
    MOV AX, 10 ; x1 = 120
    MOV BX, 120  ; y1 = 10
    MOV CX, 50 ; x2 = 310
    MOV DX, 310  ; y2 = 50
    CALL DibujaRectangulo

    ; --- Caja 3: Siguiente Pieza ---
    MOV AX, 120 ; x1 = 120
    MOV BX, 60  ; y1 = 60
    MOV CX, 200 ; x2 = 200
    MOV DX, 140 ; y2 = 140
    CALL DibujaRectangulo

    POP SI
    POP DX
    POP CX
    POP BX
    POP AX
    RET
PantallaJuego ENDP

END
