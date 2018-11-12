	PROCESSOR 16F876A

	#INCLUDE <P16F876A.INC>

		
	
; ---���� ����---

VARIABLE DBUF1 = 20H
VARIABLE DBUF2 = 21H


		
	ORG	0000
	; --------- �۽� ���� �� ---------
	BSF	STATUS, RP0		; BANK 1
	BCF	TRISC, 6		; TX ���ڸ� �������
	MOVLW	B'00100100' 		; BIT2(BRGH=1), BIT5(TXEN=1)
	MOVWF	TXSTA			; �����㰡, ���	
	MOVLW	.51			; BAUD RATE ? 4M ����(4800 bps)
	MOVWF	SPBRG
	BCF	STATUS, RP0		; BANK 0
	MOVLW	B'10000000'		; BIT7(SPEN=1: ������Ʈ �㰡)
	MOVWF	RCSTA			; �񵿱� ���� ��Ʈ �ο��̺�

		
; MAIN


	MOVLW	'A'
	CALL	TX_OUT
	CALL	DELAY		; ������ ������ ���Ͽ�


BBLP	
	GOTO	BBLP

;-----------------------------------------------------------

TX_OUT					; W-reg ������ ��µ�
	MOVWF	TXREG		; �۽� ������ �ε�
	; --------- �۽��� �Ϸ�Ǿ��°��� Ȯ�� ----------
LP	BSF		STATUS, RP0	; BANK 1
;	CLRWDT				; watch-dog ���� �־�� ��
	BTFSS	TXSTA, TRMT	; �۽ſϷ� Ȯ��
	GOTO	LP
	BCF		STATUS, RP0	; BANK 0
	NOP					; �ణ�� ������ �ʿ��� ��
	RETURN


;--- LONG DELAY FOR LCD COMMAND   ---
		
DELAY
	MOVLW		0FFH
	MOVWF		DBUF1
LP2
	MOVLW		05H
	MOVWF		DBUF2
LP3
	NOP
	DECFSZ		DBUF2, F
	GOTO		LP3
	DECFSZ		DBUF1, F
	GOTO		LP2
	
	RETURN
	
	END