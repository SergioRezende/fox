SET TALK ON

SELE 0
USE GRUPO EXCLU
INDEX ON CLASSIFICA  TO TP
GO TOP
CTR = 1

DO WHILE !EOF()
 	REPLACE ORDEM WITH CTR
	SKIP
	CTR = CTR + 1
ENDDO
