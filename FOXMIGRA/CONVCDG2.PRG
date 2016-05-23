
SET ESCAPE ON
SET TALK ON
CLOSE ALL
SET PROCEDURE TO ROTINAS

SELE 0
use Q:\SCGCM\SALDOS\saldo
SET ORDER TO TAG CLAS_SALDO

SELE 0
use Q:\FPD26\PROG\TABNBM

GO TOP

SET STEP ON

DO  WHILE  !EOF()
	IF EMPTY(TABNBM.CODNOVO)
		SKIP
		LOOP
	ENDIF	

	*-----< AJUSTANDO CODIGO EM SALDO >--*
	LDdtpesq = TABNBM.APARTIR_DE - DAY(TABNBM.APARTIR_DE) + 1

	SELE saldo
	SET NEAR ON
	SEEK STR(1,3)+TABNBM.CLASSIFICA+;
					STR(YEAR(LDdtpesq),4)+STR(MONTH(LDdtpesq),2)
	
	DO WHILE !EOF() AND saldo.empresa  = 1 ;
					AND saldo.codigo   = TABNBM.CODIGO 
		
		=REGLOCK()
		REPLACE saldo.codigo     WITH tabnbm.codnovo
		REPLACE saldo.classifica WITH tabnbm.classnova
		SEEK STR(1,3)+TABNBM.CLASSIFICA+;
					STR(YEAR(LDdtpesq),4)+STR(MONTH(LDdtpesq),2)
	ENDDO
	SELE TABNBM
	SKIP
ENDDO

*-------------------------------------------------------------------*

