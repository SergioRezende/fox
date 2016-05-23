    ********************************************************
	SELE duplicat
	SET ORDER TO TAG r_dtbaixa

	SET NEAR ON
	SEEK STR(m.empresa,3)+DTOS(m.dt_inicio)
	SET NEAR OFF
	IF EOF() OR duplicat.empresa <> m.empresa ;
			 OR duplicat.dt_baixa > m.dt_fim	
		WAIT WINDOW "Nao Existem Dados Com Parametros Informados. <ENTER> "
		RETURN
	ENDIF

	********************>  GERANDO ARQTMP **********************
	wl_arqtmp = ""
	LNtmp     = 65		&& TABELA ASCII A = 65
	IF !UPabretmp("tmp")
		wp_flgfecha = .t.
	ENDIF
	IF wp_flgfecha
		UNLOCK
 		RETURN
 	ENDIF		
	************************************************************
	LStmp = "&wp_dirtmp"+"&wl_arqtmp"

	WAIT WINDOW "AGUARDE. Gerando Arq. Temporario." NOWAIT

	SELE duplicat
    COPY TO &LStmp  ;
		WHILE duplicat.empresa = m.empresa AND  ;
			  duplicat.dt_baixa <= m.dt_fim WITH CDX
	SELE 0 
	USE &LStmp  exclu    
	SELE &wl_arqtmp
	SET ORDER TO TAG r_portvenc

	*******************
	*---->   (INICIALIZACAO DO CONTROLE DE STATUS IMPRESSAO)
	*******************	
	GO TOP
	IF EOF() 
		WAIT WINDOW "Nao Existem Prod. Com Parametros Informados. <ENTER> "
		USE
		RETURN
	ENDIF
	*******************	
	DO RELINIC.PRG          && INICIA VAR P/ TERMOMETRO
	LFsegue = .t.
	
	LNregistro = RECNO()
    COUNT TO LNimpressao
	LNimpressos = 0
	GO LNregistro
	*******************
	*---->   (COMPLETADO PREPARACAO DO CONTROLE DE STATUS IMPRESSAO)
	*******************	
	SELECT tab002
	SET ORDER TO TAG codigo

	SELE banco
	SET ORDER TO TAG banco

	SELE clientes
	SET ORDER TO TAG cliente
	
	**************************>>> REGISTRO DE SAIDAS
	SELE &wl_arqtmp
	SET RELATION TO cliente INTO clientes
	SET RELATION TO portador INTO banco ADDITIVE
    SET RELATION TO ;
    	'CBR'+CHRTRAN(STR(tp_cobranc,2)," ","0") INTO TAB002 ADDITIVE

	LFsegue  = .T.
	wp_arqname = ""
	DO CASE 
		CASE LFcrtRec
		    LSrel = "REL525" 
			SET ORDER TO TAG r_portvenc
		CASE LFrec_cli
		    LSrel = "REL525A" 
			SELECT &wl_arqtmp
		    INDEX ON STR(EMPRESA,3)+clientes.NOME+STR(clientes.cliente,14)+;
				 STR(DUPLICATA,9)  TAG cliente ADDITIVE
			SET ORDER TO TAG cliente
	ENDCASE
	LSorienta = " FOR LFsegue "
	***********
	DO UPimpressao    && COORDENA TRABALHO DE IMPRESSAO
	***********
	DO RELFIM.PRG          && FIM VAR P/ TERMOMETRO
	*-----------------------------
	*-----------------------------
    SET PRINTER TO SET('PRINTER',1)
	SET RELATION TO 
	SET POINT TO 
	SET SEPARATOR  TO 
	SELE &wl_arqtmp
	USE

	SHOW WINDOW SCGC525 TOP
	SHOW GET m.imp_btn DISABLE
RETURN
