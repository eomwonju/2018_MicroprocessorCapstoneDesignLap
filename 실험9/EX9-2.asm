	INCLUDE <P16F876A.INC>

	ORG 0

	BSF STATUS, RP1
	MOVLW 00H
	MOVWF EEADR
	BSF	STATUS, RP0
	BSF	EECON1, RD
	BCF	STATUS, RP0
	MOVF EEDATA, W

	GOTO $

	END



