;Funciones para generar pantalla del juego

.MODEL SMALL

;Variables para las coordenadas
.Data
    x1 DW ?
    y1 DW ?
    x2 DW ?
    y2 DW ?
.CODE

; --- Funciones públicas
PUBLIC IniciarGraficos
PUBLIC RestaurarModoTexto
PUBLIC PantallaJuego
PUBLIC DibujaPixel

; Procedimiento IniciarModoGrafico -----------------
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

; Procedimiento RestaurarModoTexto 
; Regresa a modo texto 80x25.
RestaurarModoTexto PROC
    PUSH AX
    MOV AX, 0003h
    INT 10h
    POP AX
    RET
RestaurarModoTexto ENDP

; Procedimiento DibujaPixel ---------------------
; Dibuja un píxel en la pantalla.
; Dada la coordenada calcula el offset donde debe
; ser dibujado
DibujaPixel PROC
    PUSH AX
    PUSH BX
    PUSH CX ; X
    PUSH DX ; Y
    PUSH DI
    
    ; Calcular offset = (y*320)+x
    MOV AX, 320
    MUL DX      ; AX = Y*320
    ADD AX, CX  ; AX += X
    MOV DI, AX

    MOV ES:[DI], SI
    
    POP DI
    POP DX
    POP CX
    POP BX
    POP AX

    ; Escribir el píxel
    RET
DibujaPixel ENDP

; Procedimiento DibujaRectangulo ------------
; Dibuja un rectangulo.
; Entrada: AX = x1, BX = y1, CX = x2, DX = y2
; 
DibujaRectangulo PROC
    MOV x1, AX
    MOV y1, BX
    MOV x2, CX
    MOV y2, DX

    MOV CX, x1
    MOV DX, y1

    .LOOP_TOP:
        CALL DibujaPixel
        INC CX
        CMP CX, x2
    JLE .LOOP_TOP

    MOV CX, x1
    MOV DX, y2

    .LOOP_BOT:
        CALL DibujaPixel
        INC CX
        CMP CX, x2
    JLE .LOOP_BOT

    MOV CX, x1
    MOV DX, y1

    .LOOP_LEFT:
        CALL DibujaPixel
        INC DX
        CMP DX, y2
    JLE .LOOP_LEFT

    MOV CX, x2
    MOV DX, y1

    .LOOP_RIGHT:
        CALL DibujaPixel
        INC DX
        CMP DX, y2
    JLE .LOOP_RIGHT

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

    ; --- Caja 1: Tablero (190x190 píxeles) ---
    MOV AX, 10
    MOV BX, 5
    MOV CX, 200
    MOV DX, 195
    CALL DibujaRectangulo

    ; --- Caja 2: Puntuación ---
    MOV AX, 210 ; x1 = 120
    MOV BX, 20  ; y1 = 10
    MOV CX, 300 ; x2 = 310
    MOV DX, 50  ; y2 = 50
    CALL DibujaRectangulo

    ; --- Caja 3: Siguiente Pieza ---
    MOV AX, 225 ; x1 = 120
    MOV BX, 70  ; y1 = 60
    MOV CX, 285 ; x2 = 200
    MOV DX, 130 ; y2 = 140
    CALL DibujaRectangulo

    POP SI
    POP DX
    POP CX
    POP BX
    POP AX
    RET
PantallaJuego ENDP

END
