********************************************************************
**********  FORMA RAPIDA DE LIMPAR DADOS DO ARQUIVO        *********
********************************************************************

PRIVATE LSareant
LSareant	= ALLTRIM(ALIAS()) && PERMITE RETORNAR A AREA ANTER. A CHAMADA
LStmp  = sys(5)+sys(2003)  		&&  UNIDADE E DIRETORIO CORRENTES
*------
SET DEFA TO &wp_dirdat
CLEAR
SET TALK ON
DO WHILE .T.
	A= GETFILE("DBF","----- APAGAR Dados  o Arq. Selecionado ----")
	IF LASTKEY() = 27
	   EXIT
	ENDIF
	IF fox_alert("1 - Confirma Limpeza de Registros em "+A)
		IF fox_alert("2 - Confirma Limpeza de Registros em "+A)
			SELE 0
			USE &A
		    COPY STRU TO TMP WITH CDX
		    USE TMP
    		COPY STRU TO &A WITH CDX
			USE
		ENDIF
	ENDIF
ENDDO	    
SET TALK OFF
IF !EMPTY(LSareant)
	SELECT &LSareant
ENDIF
SET DEFA TO &LStmp
CLEAR
RETURN
