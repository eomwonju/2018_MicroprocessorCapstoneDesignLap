
		PROCESSOR 16F876A

		#INCLUDE <P16F876A.INC>

	; User Variable (20H ~ 7FH)

		VARIABLE DBUF1 = 20H
		VARIABLE DBUF2 = 21H
	
		ORG     00H		  		; PROCESSOR RESET VECTOR
	; I/O DIRECTION SETTING
		BSF	STATUS,RP0			;BANK1
		MOVLW	B'00000111'
		MOVWF	ADCON1				;PORTA를 디지털로 변환
		MOVLW	B'00001111'
		MOVWF	TRISA				;PORTA0,1,2,3 입력으로 설정
		MOVLW	B'00000000'
		MOVWF	TRISB				;PORTB 모든 PORT 출력으로 설정 
		MOVLW	B'00000000'
		MOVWF	TRISC				;PORTC 모든 PORT 출력으로 설정
		BCF	STATUS,RP0			;BANK0



MAIN 	; MAIN 시작 부분
		BSF		PORTC,0
		CALL		DELAY
		BCF		PORTC,0
		CALL		DELAY
		GOTO		MAIN	

DELAY	; DELAY 서브루틴						
		MOVLW	.125
		MOVWF	DBUF1
LP1		MOVLW	.200
		MOVWF	DBUF2
LP2		NOP
		DECFSZ	DBUF2,F
		GOTO	LP2
		DECFSZ	DBUF1,F
		GOTO	LP1
		RETURN	
		END
