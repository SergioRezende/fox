*------------------------ < ROT. APOIO >------------------------*
*---------------------------------------------------------------*
*------------------------------------------------------------
SET TALK ON
SET ESCAPE ON
SET STEP ON
CLOSE ALL
SET DELE ON
SET TALK ON

USE Q:\SCGC\CENTRAL\ITEMMOV
SET ORDER TO TAG ITENSNOTA 
GO TOP

DO WHILE !EOF()
	SCATTER MEMVAR
	SKIP

	IF LEFT(itemmov.operacao,1) = "E" AND LEFT(M.operacao,1) = "E"
		IF !EOF() AND  M.EMPRESA = ITEMMOV.EMPRESA ;
		   AND M.FAVORECIDO = ITEMMOV.FAVORECIDO ;
		   AND M.ORCAMENTO = ITEMMOV.ORCAMENTO ;
		   AND M.ORDEM = ITEMMOV.ORDEM
		   CTR = CTR + 1
		   =RLOCK()
		   DELETE
		   SKIP
		ENDIF
	ENDIF
ENDDO

