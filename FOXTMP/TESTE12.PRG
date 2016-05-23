*------------------------ < ROT. APOIO >------------------------*
*---------------------------------------------------------------*
*------------------------------------------------------------
SET TALK ON
SET ESCAPE ON
SET STEP ON
CLOSE ALL

USE D:\SCGC\CENTRAL\NOTAITE
SET ORDER TO TAG CHV_BKP


USE D:\SCGC\CENTRAL\ITEMMOV
SET ORDER TO TAG DT_GERAL 
GO TO
DO WHILE !EOF()
	SCATTER MEMVAR
	SELE NOTAITE
	SEEK STR(M.EMPRESA,3)+STR(M.FAVORECIDO,14)+STR(M.ORCAMENTO,6)+STR(M.ORDEM,3)
	IF !FOUND()
		APPEND BLANK
		GATHER MEMVAR
	ENDIF
	SELE ITEMMOV
	SKIP
ENDDO
