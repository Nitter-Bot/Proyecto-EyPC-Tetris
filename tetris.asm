.MODEL SMALL
.STACK 100h

.DATA
    PiezaActiva_Tipo DB ?
    PiezaActiva_X DW ?
    PiezaActiva_Y DW ?
    block_border_colour DB ?
    delay_counter DW 0
    PUBLIC PiezaActiva_Tipo
    PUBLIC block_border_colour
.CODE

PUBLIC Delay
;Funciones externas
EXTRN IniciarGraficos : PROC
EXTRN RestaurarModoTexto : PROC
EXTRN DibujarTablero : PROC
EXTRN LimpiarPantalla : PROC
EXTRN DisplayScore : PROC
EXTRN UpdateScore : PROC
EXTRN score : WORD
EXTRN DibujarBorde : PROC
EXTRN NumeroAleatorio : PROC
EXTRN FiguraAleatoria : PROC
EXTRN LlamarTeclado : PROC

Delay PROC
    MOV delay_counter, 1
.delay_loop1:
    MOV CX, 0FFFFH
    INC delay_counter
.delay_loop2:
    LOOP .delay_loop2
    CMP delay_counter, 5
    JNZ .delay_loop1
    RET
Delay ENDP

MAIN PROC
    MOV AX, @DATA
    MOV DS, AX

    ;Inicio de Graficos y pantalla
    CALL LimpiarPantalla
    CALL IniciarGraficos
    CALL DibujarTablero
    MOV block_border_colour, 4CH
    CALL DibujarBorde
    CALL DisplayScore
    ;Dibujar siguientes piezas
    CALL NumeroAleatorio
    CALL Delay
    CALL FiguraAleatoria

    MOV AH, 00h
    INT 16h

    CALL RestaurarModoTexto
    CALL LimpiarPantalla
    MOV AX, 4C00h
    INT 21h
MAIN ENDP
END MAIN 
