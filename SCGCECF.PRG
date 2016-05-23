=FWRITE(LNecf,chr(27)+".14}")
*CLOSE ALL
X=FOPEN('C:IFSWEDA',12)
*?X
*?FWRITE(X,CHR(27)+'.13}')


*---------------------  Emissao de Leitura X ----------------------*
LSdirant	=  sys(5)+CURDIR()

nArq = 0	&& CONTROLADOR REFERENTE A ECF
IF UPverifecf()
	WAIT WINDOW "Imprimindo Leitura X  " NOWAIT
	lErroCupom = .f.
	=FWRITE(nArq,CHR(27)+'.13}')
ENDIF
=FCLOSE(nArq)
SET DEFA TO &LSdirant

RETURN

*************************************************************

FUNCTION UPverifecf
	nArq = FOPEN('C:IFSWEDA',12)
	if nArq < 0
		=FCLOSE(nArq)
		WAIT WINDOW "ERRO ! Comunicacao com ECF (IFSWEDA.PRN) <ENTER> "
		WAIT WINDOW "Verifique a definicao de (IFSWEDA.PRN) no CONFIG.SYS <ENTER> "
		RETURN(.F.)
	ENDIF
RETURN(.T.)

