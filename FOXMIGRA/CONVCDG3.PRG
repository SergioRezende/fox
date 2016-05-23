**
**  COMFIRME OS LACOS QUE ESTAO SENDO EXECUTADOS
**



SET DELE ON
SET ESCAPE ON
SET TALK ON
CLOSE ALL
SET PROCEDURE TO ROTINAS


SELE 0
use Q:\SCGCM\CT1995\notaite
SET ORDER TO TAG codigoCONV

SELE 0
use Q:\SCGCM\CT1995\orcatmp
SET ORDER TO TAG codigoCONV

SELE 0
use Q:\SCGCM\CT1995\itmanexo
SET ORDER TO TAG MOVANEXO

SELE 0
use Q:\SCGCM\CT1995\saldo
SET ORDER TO TAG CLAS_SALDO


SELE 0
use Q:\SCGCM\CT1995\itemmov
SET ORDER TO TAG MOVSIMPLES


SELE 0
use Q:\FPD26\PROG\ITEMMOV ALIAS AUTORIZA
SET ORDER TO TAG MOVSIMPLES

SELE 0
use Q:\FPD26\PROG\TABNBM3 ALIAS TABNBM

GO TOP
LNEMP = 1
LNregvolta = 0

SET STEP ON

************************  ESTA SENDO EXECUTADO ******************
DO WHILE  !EOF()
	IF EMPTY(TABNBM.CODNOVO)
		SKIP
		LOOP
	ENDIF	

	*-----< AJUSTANDO CODIGO EM ITEMMOV  >--*

	SELE itemmov
	SET NEAR ON
	SEEK STR(LNEMP,3)+TABNBM.CODIGO+DTOS(TABNBM.APARTIR_DE)

	DO WHILE !EOF() AND itemmov.empresa  = LNEMP ;
					AND itemmov.codigo   = TABNBM.CODIGO 
		
		*------- CONVERSAO SO DO MOVIMENTO ENCONTRADO EM AUTORIZA ------*
		SCATTER MEMVAR
		SELE AUTORIZA
		SET ORDER TO TAG MOVIMENTO
		SEEK STR(M.EMPRESA,3)+M.CODIGO+;
			 DTOS(M.DATA)+M.HORA+M.TIPO+STR(M.NOTA,7)+STR(M.ORDEM,2)
		IF !FOUND()
			SELE ITEMMOV
			SKIP
			LOOP
		ENDIF
		SELE ITEMMOV
		*------------------------------------------------------------------*
		SKIP
		IF !EOF()
			LNregvolta = recno()
		ELSE
			LNregvolta = 9999999
		ENDIF			
		SKIP -1
		*------------------------------------------------------------------*
		=REGLOCK()
		REPLACE itemmov.codigo     WITH tabnbm.codnovo
		REPLACE itemmov.classifica WITH tabnbm.classnova
		*------------------------------------------------------------------*
		IF LNregvolta = 9999999
			EXIT
		ENDIF
		GO 	LNregvolta 
	ENDDO
	SELE TABNBM
	SKIP
ENDDO

*-------------------------------------------------------------------*

SELE TABNBM

GO TOP

************************  ESTA SENDO EXECUTADO ******************
DO WHILE !EOF()
	IF EMPTY(TABNBM.CODNOVO)
		SKIP
		LOOP
	ENDIF	

	*-----< AJUSTANDO CODIGO EM ITEMMOV  >--*

	SELE itmanexo
	SET NEAR ON
	SEEK STR(LNEMP,3)+TABNBM.CODIGO+DTOS(TABNBM.APARTIR_DE)

	DO WHILE !EOF() AND itmanexo.empresa  = LNEMP ;
					AND itmanexo.codigo   = TABNBM.CODIGO 
		
		*------- CONVERSAO SO DO MOVIMENTO ENCONTRADO EM AUTORIZA ------*
		SCATTER MEMVAR
		SELE AUTORIZA
		SET ORDER TO TAG MOVIMENTO
		SEEK STR(M.EMPRESA,3)+M.CODIGO+;
			 DTOS(M.DATA)+M.HORA+M.TIPO+STR(M.NOTA,7)+STR(M.ORDEM,2)
		IF !FOUND()
			SELE ITMANEXO
			SKIP
			LOOP
		ENDIF
		SELE ITMANEXO
		*------------------------------------------------------------------*
		SKIP
		IF !EOF()
			LNregvolta = recno()
		ELSE
			LNregvolta = 9999999
		ENDIF			
		SKIP -1
		*------------------------------------------------------------------*
		=REGLOCK()
		REPLACE itmanexo.codigo     WITH tabnbm.codnovo
		IF LNregvolta = 9999999
			EXIT
		ENDIF
		GO 	LNregvolta 
	ENDDO
	SELE TABNBM
	SKIP
ENDDO

*-------------------------------------------------------------------*

SELE TABNBM

GO TOP

************************ NAO ESTA SENDO EXECUTADO ******************

DO  WHILE .F. && !EOF()
	IF EMPTY(TABNBM.CODNOVO)
		SKIP
		LOOP
	ENDIF	

	*-----< AJUSTANDO CODIGO EM SALDO >--*
	LDdtpesq = TABNBM.APARTIR_DE - DAY(TABNBM.APARTIR_DE) + 1

	SELE saldo
	SET NEAR ON
	SEEK STR(LNEMP,3)+TABNBM.CLASSIFICA+;
					STR(YEAR(LDdtpesq),4)+STR(MONTH(LDdtpesq),2)
	
	DO WHILE !EOF() AND saldo.empresa  = LNEMP ;
					AND saldo.codigo   = TABNBM.CODIGO 
		
		=REGLOCK()
		REPLACE saldo.codigo     WITH tabnbm.codnovo
		REPLACE saldo.classifica WITH tabnbm.classnova
		SEEK STR(LNEMP,3)+TABNBM.CLASSIFICA+;
					STR(YEAR(LDdtpesq),4)+STR(MONTH(LDdtpesq),2)
	ENDDO
	SELE TABNBM
	SKIP
ENDDO

*-------------------------------------------------------------------*

SELE TABNBM

GO TOP

************************ NAO ESTA SENDO EXECUTADO ******************

DO  WHILE  !EOF()
	IF EMPTY(TABNBM.CODNOVO)
		SKIP
		LOOP
	ENDIF	

	*-----< AJUSTANDO CODIGO EM ORCATMP >--*

	SELE orcatmp
	SET NEAR ON
	SEEK STR(LNEMP,3)+TABNBM.CODIGO+DTOS(TABNBM.APARTIR_DE)

	DO WHILE !EOF() AND orcatmp.empresa  = LNEMP ;
					AND orcatmp.codigo   = TABNBM.CODIGO 
		*------- CONVERSAO SO DO MOVIMENTO ENCONTRADO EM AUTORIZA ------*
		SCATTER MEMVAR
		SELE AUTORIZA
		SET ORDER TO TAG ORCAMENTO
		SEEK STR(M.EMPRESA,3)+STR(M.ORCAMENTO,6)
		IF !FOUND()
			SELE ORCATMP
			SKIP
			LOOP
		ENDIF
		SELE ORCATMP
		*------------------------------------------------------------------*
		SKIP
		IF !EOF()
			LNregvolta = recno()
		ELSE
			LNregvolta = 9999999
		ENDIF			
		SKIP -1
		*------------------------------------------------------------------*
		=REGLOCK()
		REPLACE orcatmp.codigo     WITH tabnbm.codnovo
		REPLACE orcatmp.classifica WITH tabnbm.classnova
		*------------------------------------------------------------------*
		IF LNregvolta = 9999999
			EXIT
		ENDIF
		GO 	LNregvolta 
	ENDDO
	SELE TABNBM
	SKIP
ENDDO

*-------------------------------------------------------------------*

SELE TABNBM

GO TOP
************************ ESTA SENDO EXECUTADO ******************

DO  WHILE  !EOF()
	IF EMPTY(TABNBM.CODNOVO)
		SKIP
		LOOP
	ENDIF	
	*
	*-----< AJUSTANDO CODIGO EM ORCATMP >--*
	*
	SELE notaite
	SET NEAR ON
	SEEK STR(LNEMP,3)+TABNBM.CODIGO+DTOS(TABNBM.APARTIR_DE)

	DO WHILE !EOF() AND notaite.empresa  = LNEMP ;
					AND notaite.codigo   = TABNBM.CODIGO 

		*------- CONVERSAO SO DO MOVIMENTO ENCONTRADO EM AUTORIZA ------*
		SCATTER MEMVAR
		SELE AUTORIZA
		SET ORDER TO TAG MOVIMENTO
		SEEK STR(M.EMPRESA,3)+M.CODIGO+;
			 DTOS(M.DATA)+M.HORA+M.TIPO+STR(M.NOTA,7)+STR(M.ORDEM,2)
		IF !FOUND()
			SELE NOTAITE
			SKIP
			LOOP
		ENDIF
		SELE NOTAITE
		*------------------------------------------------------------------*
		SKIP
		IF !EOF()
			LNregvolta = recno()
		ELSE
			LNregvolta = 9999999
		ENDIF			
		SKIP -1
		*------------------------------------------------------------------*
		=REGLOCK()
		REPLACE notaite.codigo     WITH tabnbm.codnovo
		REPLACE notaite.classifica WITH tabnbm.classnova
		*------------------------------------------------------------------*
		IF LNregvolta = 9999999
			EXIT
		ENDIF
		GO 	LNregvolta 
	ENDDO
	SELE TABNBM
	SKIP
ENDDO
