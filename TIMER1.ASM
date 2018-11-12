PROCESSOR 16F876A
#INCLUDE <P16F876A.INC>

VARIABLE        INT_CNT         = 20H
VARIABLE        DISP_CNT        = 21H
VARIABLE        D_1SEC          = 22H
VARIABLE        D_10SEC         = 23H
VARIABLE        D_1MIN          = 24H
VARIABLE        D_10MIN         = 25H
VARIABLE        W_TEMP          = 26H
VARIABLE        STATUS_TEMP     = 27H
VARIABLE        DOT             = 28H
VARIABLE        BUZZ            = 29H
VARIABLE	DBUF1		= 30H
VARIABLE	DBUF2		= 31H

ORG     00H
GOTO    START_UP
ORG     04H

MOVWF   W_TEMP
SWAPF   STATUS, W
MOVWF   STATUS_TEMP
CALL    DISP
SWAPF   STATUS_TEMP, W
MOVWF   STATUS
SWAPF   W_TEMP, F
SWAPF   W_TEMP, W
BCF     INTCON, 2
RETFIE

CONVC
        ANDLW   0FH
        ADDWF   PCL, F
        RETLW   B'11111111';0
        RETLW   B'01111000';1
        RETLW   B'11011011';2
        RETLW   B'11111010';3
        RETLW   B'01111100';4
        RETLW   B'10111110';5
        RETLW   B'00111111';6
        RETLW   B'11111100';7
        RETLW   B'11111111';8
        RETLW   B'11111100';9
        RETLW   B'10011000';-
        RETLW   B'00011000';
        RETLW   B'10011111';C
        RETLW   B'00011000';.
        RETLW   B'10011111';E
        RETLW   B'10011101';F
        
CONVA
        ANDLW   0FH
        ADDWF   PCL, F
        RETLW   B'11111100';0
        RETLW   B'11111100';1
        RETLW   B'11111110';2
        RETLW   B'11111110';3
        RETLW   B'11111110';4
        RETLW   B'11111110';5
        RETLW   B'11111110';6
        RETLW   B'11111100';7
        RETLW   B'11111110';8
        RETLW   B'11111110';9
        RETLW   B'11111100';-
        RETLW   B'11111100';
        RETLW   B'11111100';C
        RETLW   B'11111101';.
        RETLW   B'11111110';E
        RETLW   B'11111110';F
DISP
        INCF    DISP_CNT
        MOVF    DISP_CNT, W
        ANDLW   B'00000011'
        ADDWF   PCL, F
        GOTO    DISP1
        GOTO    DISP2
        GOTO    DISP3
        GOTO    DISP4

DISP1
        BSF     PORTA, 3
        MOVF    D_1SEC, W
        CALL    CONVC
        MOVWF   PORTC
        MOVF    D_1SEC, W
        CALL    CONVA
        ANDWF   BUZZ, W
        MOVWF   PORTA
        BCF     PORTB, 1
        RETURN

DISP2
        BSF     PORTB, 1
        MOVF    D_10SEC, W
        CALL    CONVC
        MOVWF   PORTC
        MOVF    D_10SEC, W
        CALL    CONVA
        ANDWF   BUZZ, W
        MOVWF   PORTA
        BCF     PORTB, 2
        INCF    INT_CNT
        RETURN

DISP3
        BSF     PORTB, 2
        MOVF    D_1MIN, W
        CALL    CONVC
        MOVWF   PORTC
        MOVF    D_1MIN, W
        CALL    CONVA
        IORWF   DOT, W
        ANDWF   BUZZ, W
        MOVWF   PORTA
        BCF     PORTA, 2
        RETURN

DISP4
        BSF     PORTA, 2
        MOVF    D_10MIN, W
        CALL    CONVC
        MOVWF   PORTC
        MOVF    D_10MIN, W
        CALL    CONVA
        ANDWF   BUZZ, W
        MOVWF   PORTA
        BCF     PORTA, 3
        INCF    INT_CNT, F
        RETURN

START_UP
        BSF     STATUS, RP0
        CLRF    TRISA
        CLRF    TRISC
        MOVLW   B'00111000'
        MOVWF   TRISB
        MOVLW   B'00000111'
        MOVWF   ADCON1
        
        MOVLW   B'00000010'
        MOVWF   OPTION_REG
        BCF     STATUS, RP0
        BSF     INTCON, 5
        BSF     INTCON, 7
        GOTO    MAIN_ST   
        
MAIN_ST
        CLRF    INT_CNT
        MOVLW   0FFH
        MOVWF   DISP_CNT
        MOVWF   BUZZ
        CLRF    D_10SEC
        CLRF    D_1SEC
        MOVLW   .5
        MOVWF   D_1MIN
        CLRF    D_10MIN
        MOVLW   B'00111000'
        MOVWF   PORTB
        

M_LOOP
        MOVLW   .244
        SUBWF   INT_CNT, W
        BTFSS   STATUS, Z
        GOTO    XLOOP
        
CK_LOOP
        CLRF    INT_CNT
        DECF    D_1SEC
        MOVLW   0FFH
        SUBWF   D_1SEC, W
        BTFSS   STATUS, Z
        GOTO    XLOOP
        
        MOVLW   09H
        MOVWF   D_1SEC
        DECF    D_10SEC
        MOVLW   0FFH
        SUBWF   D_10SEC, W
        BTFSS   STATUS, Z
        GOTO    XLOOP
        
        MOVLW   05H
        MOVWF   D_10SEC
        DECF    D_1MIN, F
        MOVLW   0FFH
        SUBWF   D_1MIN, W
        BTFSC   STATUS, Z
        GOTO    R2
        GOTO    R1
        
        R2      CLRF    D_1MIN
                CLRF    D_10SEC
                CLRF    D_1SEC
        R1      GOTO    XLOOP
XLOOP
        GOTO M_LOOP


END