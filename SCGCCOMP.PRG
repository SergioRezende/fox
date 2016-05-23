********************************************************************
**********  FORMA RAPIDA DE REINDEXAR E COMPACTAR ARQUIVOS *********
********************************************************************

PRIVATE LSareant,LSult_dir
LSareant	= ALLTRIM(ALIAS()) && PERMITE RETORNAR A AREA ANTER. A CHAMADA
LStmp  = sys(5)+sys(2003)  		&&  UNIDADE E DIRETORIO CORRENTES
*------
LSult_dir = wp_dirdat

CLEAR
SET TALK ON
DO WHILE .T.
	SET DEFA TO &LSult_dir		&&POSICIONA NO ULT. DIRETORIO SELEC

	A= GETFILE("DBF","----- DESFRAGMENTAR o Arq. Selecionado ----")
	LSult_dir = LEFT(A,rat("\",a))

	SET DEFA TO &LStmp			&& VOLTA AO DIR ORIGINAL

	IF LASTKEY() = 27 OR EMPTY(A)
	   EXIT
	ENDIF

    DO OBJ_ALER.SPR WITH ;
		   "Antes de Processar a 1a Compactacao Faca <BACKUP>  "+CHR(13)+;
		   "Caso o Processo seja Interrompido Retorne o <BACKUP>  "

    DO OBJ_ALER.SPR WITH ;
		   "*---------------- ATENCAO ----------------*" +;
		   CHR(13)+CHR(13)+"NAO REPITA BACKUP QUANDO OCORRER INTERRUPCAO"+;
		   " DO PROCESSO. ISSO DANIFICARIA TABEM O BACKUP "

	LSmsg  = "Arquivo Escolhido e "+A+chr(13)+chr(13)+"CONFIRMA COMPACTACAO ?"

	IF fox_alert(LSmsg)
			wp_msg = 'Manutencao de Sistema...'
			BTMP   =  'usuario.master '
			LNusr_ret = 0
			DO obj_prmt.SPR WITH   wp_msg , Btmp
			IF LNusr_ret <>  0 
				SELE 0

				USE &A EXCL
				PACK

    			COPY TO \TMP\TMPCOMP WITH CDX
			    USE \TMP\TMPCOMP

    			COPY TO &A WITH CDX
				USE &A EXCL
				REINDEX

				USE
				wp_msg = "Compactacao de " +A + " Concluida. Tecle <ENTER> "
				=UPbeeps(.F.,wp_msg)
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


