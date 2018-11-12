	PROCESSOR 16F876A

	#INCLUDE <P16F876A.INC>



; ---���� ����---

VARIABLE	W_TEMP		= 20H
VARIABLE	STATUS_TEMP	= 21H
VARIABLE	INT_CNT		= 22H
VARIABLE	D_10SEC		= 23H
VARIABLE	D_1SEC		= 24H
VARIABLE	DISP_CNT	= 25H
VARIABLE	COM_A		= 26H
VARIABLE	COM_B		= 27H


; MAIN PROGRAM

	ORG		00H
	GOTO		START_UP
	ORG		04H

; ISR ���� ����
	MOVWF		W_TEMP		; ���� ���ǰ� �ִ� W REG�� ����
	SWAPF		STATUS, W
	MOVWF		STATUS_TEMP
	CALL		DISP		; DISPLAY �� ���α׷�
	SWAPF		STATUS_TEMP, W	; ����� �������� ����
	MOVWF		STATUS
	SWAPF		W_TEMP, F
	SWAPF		W_TEMP, W
	BCF			INTCON, 2
	RETFIE
	
; DISPLAY ROUTINE
DISP

;7-segment�� ǥ�� ���ڰ� 2�ڸ��̹Ƿ� �� �ڸ��� ���������� ǥ���ؾ��Ѵ�.
; ���� �� ���α׷��� ������ Ƚ���� Ȯ���Ͽ� ó�� ������ ����
; ���� ������ ��츦 �����Ͽ� �����ؾ��Ѵ�.
; < ó�� ���� �� > �� < ���� ���� �� > �� �����ϱ�

	INCF		DISP_CNT
	BTFSC		DISP_CNT, 0
	GOTO		DISP1
	GOTO		DISP2

; < ó�� ���� �� >
DISP1
	MOVLW		B'00000000'
	MOVWF		PORTA
	
	MOVF		D_10SEC, W
	CALL		CONV
	MOVWF		PORTC
	
	MOVLW		B'00000010'
	MOVWF		PORTA
		
	RETURN

; < ���� ���� �� >
DISP2
	MOVLW		B'00000000'
	MOVWF		PORTA
	
	MOVF		D_1SEC, W
	CALL		CONV
	MOVWF		PORTC
	
	MOVLW		B'00000001'
	MOVWF		PORTA
	

	INCF		INT_CNT
	RETURN

; main program ����
START_UP	
	BSF			STATUS,RP0	; RAM BANK 1 ����
	MOVLW		B'00000000'	; PORT I/O ���� 
	MOVWF		TRISA
	MOVWF		TRISC
	MOVLW		B'00000111'
	MOVWF		ADCON1

; INTERRUPT �ð� ���� --- 2.048msec �ֱ�
	MOVLW		B'00000010'	; 2.048msec
	MOVWF		OPTIONR
	BCF			STATUS,RP0	; RAM BANK 0 ����
	
	CLRF		DISP_CNT
	
	BSF			INTCON, 5	; TIMER INTERRUPT ENABLE
	BSF			INTCON, 7	; GLOBAL INT. ENABLE
	GOTO		MAIN_ST
	
MAIN_ST
; ���⼭���� USER PROGRAM �ۼ�
; ���� �ʱ�ȭ
; INT_CNT=0, D_10SEC=0, D_1SEC=0, key_IN=0
	CLRF		INT_CNT
	CLRF		D_10SEC
	CLRF		D_1SEC
	
M_LOOP
; interrupt�� ���� Ƚ�� Ȯ�� (�ð����)
	MOVLW		.250
	SUBWF		INT_CNT, W
	BTFSS		STATUS, ZF
	GOTO		XLOOP
	
; 1sec ���� ������ �κ�
CK_LOOP
	CLRF		INT_CNT		; ���� 1�ʸ� ��ٸ��� ���� �ʱ�ȭ
	INCF		D_1SEC		; 1�� ���� ���� ����
	MOVLW		.10
	SUBWF		D_1SEC, W
	BTFSS		STATUS, ZF
	GOTO		XLOOP

; 10sec ���� ������ �κ�
	CLRF		D_1SEC		; ���� 10�ʸ� ��ٸ��� ���� �ʱ�ȭ
	INCF		D_10SEC		; 10�� ���� ���� ����
	MOVLW		.10
	SUBWF		D_10SEC, W
	BTFSC		STATUS, ZF
	CLRF		D_10SEC		; 10�� ������ �ʱ�ȭ
	GOTO		XLOOP
	
; ������ �ð� ���� ����� ����� �����ϱ� ���� ���α׷� ����

XLOOP
; key Ȯ���Ͽ� key�� ���� ��� ����
; ��ɿ� ���� ���� �︮�� ��
	GOTO		M_LOOP
	
CONV
	ANDLW		0FH
	ADDWF		PCL
	
	RETLW		B'00000011'	; '0'
	RETLW		B'10011111'	; '1'
	RETLW		B'00100101'	; '2'
	RETLW		B'00001101'	; '3'
	RETLW		B'10011001'	; '4'
	RETLW		B'01001001'	; '5'
	RETLW		B'01000001'	; '6'
	RETLW		B'00011011'	; '7'
	RETLW		B'00000001'	; '8'
	RETLW		B'00001001'	; '9'
	RETLW		B'11111101'	; '-'
	RETLW		B'11111111'	; ' '
	RETLW		B'11100101'	; 'C'
	RETLW		B'11111110'	; '.'
	RETLW		B'01100001'	; 'E'
	RETLW		B'01110001'	; 'F'
	
	
	END