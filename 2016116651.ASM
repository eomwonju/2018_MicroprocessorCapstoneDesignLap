		PROCESSOR 16F876A

		#INCLUDE <P16F876A.INC>

; ��������

		VARIABLE	DBUF1	=	20H
		VARIABLE	DBUF2	=	21H


		ORG	0000
		BSF	STATUS, RP0
		MOVLW	B'00000011'
		MOVWF	TRISA
		MOVLW	B'00000000'
		MOVWF	TRISC
		MOVLW	B'00000111'
		MOVWF	ADCON1
		BCF	STATUS, RP0

; MAIN PROGRAM	

D_LOOP		
		MOVF	PORTA, W
		CALL	CONV
		MOVWF	PORTC	
		CALL	DELAY	

		MOVLW	0FFH
		MOVWF	PORTC		
		CALL	DELAY
	
		GOTO	D_LOOP
		
CONV
	   	ANDLW	03H		
		ADDWF	PCL, F	
				
		RETLW	B'01111111'	;a
		RETLW	B'10011111'	;BC
		RETLW	B'11110011'	;ef
		RETLW	B'11101111'	;d

; SUBROUTINE

DELAY	
		MOVLW	.750	
		MOVWF	DBUF1
LP1		MOVLW	.200	
		MOVWF	DBUF2
LP2		NOP
		DECFSZ	DBUF2, F
		GOTO	LP2
		DECFSZ	DBUF1, F	
		GOTO	LP1	
		RETURN
		
		END
