*>>>>>>>>>>>>>>>>>>>>>>  2A ETAPA / 3     <<<<<<<<<<<<<<<<<<<<<<<< 
*          GERAR ARQUIVO DBF COM BASE NO TEXTO CONTINUO            *
*------------------------------------------------------------------*

	wl_arqtmp = ""
	wl_arqtb1 = ""		&& ORIENTA A 1A COLUNA
	wl_arqtb2 = ""		&& ORIENTA A 2A COLUNA
	wl_arqtb3 = ""		&& ARMAZENA O TEXTO GERADO

	LNtmp     = 65		&& TABELA ASCII A = 65
	IF !UPabretmp("tb1")
		WAIT WINDOW "Nao foi possivel gera arq. TMP.  <ENTER>"
		RETURN
	ENDIF
	wl_arqtb1 = wl_arqtmp
	LNtmp     = 65		&& TABELA ASCII A = 65
	IF !UPabretmp("tb2")
		WAIT WINDOW "Nao foi possivel gera arq. TMP.  <ENTER>"
		RETURN
	ENDIF
	wl_arqtb2 = wl_arqtmp

	LNtmp     = 65		&& TABELA ASCII A = 65
	IF !UPabretmp("tb3")
		WAIT WINDOW "Nao foi possivel gera arq. TMP.  <ENTER>"
		RETURN
	ENDIF
	wl_arqtb3 = wl_arqtmp

	SELE 0 
   	USE "\TMP\"+"&wl_arqtb1" exclu    
   	INDEX ON LINHA TAG registro ADDITIVE

	SELE 0 
   	USE "\TMP\"+"&wl_arqtb2" exclu    
   	INDEX ON LINHA TAG registro ADDITIVE

	SELE 0 
   	USE "\TMP\"+"&wl_arqtb3" exclu    
   	INDEX ON RECNO() TAG registro ADDITIVE
	APPEND FROM &wp_arqname  FIELDS DESCRICAO TYPE SDF
	REPLACE ALL LINHA WITH RECNO()
	GO BOTT
	LN_lhini = 1
	LN_lhfim = 60
	LN_lhend = RECNO()

	DO WHILE LN_lhini <= LN_lhend
		SELE &wl_arqtb1
		APPEND FROM \TMP\&wl_arqtb3 FOR LINHA >= LN_lhini ;
							   AND LINHA <= LN_lhfim
		LN_lhini = LN_lhini + 60
		LN_lhfim = LN_lhfim + 60
		SELE &wl_arqtb2
		APPEND FROM \TMP\&wl_arqtb3 FOR LINHA >= LN_lhini ;
							   AND LINHA <= LN_lhfim
		LN_lhini = LN_lhini + 60
		LN_lhfim = LN_lhfim + 60
	ENDDO
	SELE &wl_arqtb2
	REPLACE ALL LINHA WITH RECNO()
	GO BOTT
	SELE &wl_arqtb1
	REPLACE ALL LINHA WITH RECNO()
	GO BOTT
*>>>>>>>>>>>>>>>>>>>>>>>>  3A ETAPA / 3     <<<<<<<<<<<<<<<<<<<<<<<< 
*          IMPRESSAO DA TABELA DE PRECOS EM COLUNAS                *
*------------------------------------------------------------------*
*******************
*---->   (INICIALIZACAO DO CONTROLE DE STATUS IMPRESSAO)
*******************	
	DO RELINIC.PRG          && INICIA VAR P/ TERMOMETRO
	LFsegue = .t.
	LNregistro = RECNO()
    COUNT  TO LNimpressao
	LNimpressos = 0
	GO LNregistro
*******************
*---->   (COMPLETADO PREPARACAO DO CONTROLE DE STATUS IMPRESSAO)
*******************	
	SET RELATION TO  linha  INTO &wl_arqtb2 ADDITIVE
**************************>>> REGISTRO DE SAIDAS
    LSrel = "REL410B"      && relatorio padrao p/ impressoras ex: epson
	LSorienta  = " "          && fornece as condicoe de impressao
    LSorienta = " WHILE LFsegue "
	wp_arqname = SYS(5)+"\RELATO\TBP2"+STRTRAN(str(nUsr,4)," ","0")+".TXT"
***********
	DO UPimpressao    && COORDENA TRABALHO DE IMPRESSAO
***********
	DO RELFIM.PRG          && FIM VAR P/ TERMOMETRO
*-----------------------------
    SET PRINTER TO SET('PRINTER',1)
	SET RELATION TO 
	SET POINT TO 
	SET SEPARATOR  TO 

	SHOW GET m.imp_btn DISABLE
******************************************************************

	SELE &wl_arqtb1
	USE
	SELE &wl_arqtb2
	USE
	SELE &wl_arqtb3
	USE
