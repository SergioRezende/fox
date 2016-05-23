    ********************************************************
	SELECT empresa
	SET ORDER TO TAG empresa
	SEEK m.empresa

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
    IF LFcrtRec OR LFrec_cli
       LStmp = "&wp_dirtmp"+"&wl_arqtmp"
       WAIT WINDOW "AGUARDE. Gerando Arq. Temporario." NOWAIT
       SELE duplicat
       COPY TO &LStmp  ;
         WHILE duplicat.empresa = m.empresa AND  !EMPTY(duplicat.dt_baixa) ;
			 AND duplicat.dt_baixa <= m.dt_fim WITH CDX
	   SELE 0 
	   USE &LStmp  exclu    
 	   SELE &wl_arqtmp
	   SET ORDER TO TAG r_portvenc
       
	*******************
	*---->   (INICIALIZACAO DO CONTROLE DE STATUS IMPRESSAO)
	*******************	
	   GO TOP
	   IF EOF() 
          WAIT WINDOW "Nao Existem Prod. Com Parametros Informados. <ENTER>"
          USE
          RETURN
       ENDIF
       *******************	
    ENDI
    DO RELINIC.PRG          && INICIA VAR P/ TERMOMETRO
	LFsegue = .t.
	
    IF LFcrtRec OR LFrec_cli
       LNregistro = RECNO()
       COUNT TO LNimpressao
       LNimpressos = 0
       GO LNregistro
    ENDI
	*******************
	*---->   (COMPLETADO PREPARACAO DO CONTROLE DE STATUS IMPRESSAO)
	*******************	
    IF LFcrtRec OR LFrec_cli
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
    ENDI

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
		CASE LFrec_port
  		     LSrel = "REL525B" 
             WAIT WINDOW "AGUARDE. Gerando Arq. Temporario." NOWAIT
			CREATE CURSOR C_DUPLICAT ;
		   (NOME C(40), CLIENTE N(14), DUPLICAT N(9), DT_VENC D(8), ;
		    VLR_FATURA N(12,2), VLR_DUP N(12,2), DT_PGTO D(8),;
		    NOMEP C(30), DESCTPCOB C(30), NOME_EM C(30),NUM_NO_BCO C(12)) 

            SELE DUPLICAT
			SET ORDER TO TAG r_dtbaixa

			SET NEAR ON
			SEEK STR(m.empresa,3)+DTOS(m.dt_inicio)
			SET NEAR OFF
			IF EOF() OR duplicat.empresa <> m.empresa ;
				     OR duplicat.dt_baixa > m.dt_fim	
				WAIT WINDOW ;
				"Nao Existem Dados Com Parametros Informados. 	<ENTER> "
				RETURN
			ENDIF
*1
			DO WHILE !EOF() AND ;
					 duplicat.empresa = m.empresa AND ;
					 duplicat.dt_baixa <= m.dt_fim

				IF EMPT(DUPLICAT.dt_pgto)
				   SKIP
				   LOOP
				ENDI

				
			*	IF DUPLICAT.PAGA_EM <> 0   
			*	   SKIP
			*	   LOOP
			*	ENDI
			*	IF DUPLICAT.TP_COBRANC <> 88             && 
			*		IF DUPLICAT.PORTADOR   =  0   OR  ;	&& CARETIRA
			*		   DUPLICAT.PORTADOR   =  898 OR  ;	&& COB 898
			*		   DUPLICAT.PORTADOR   =  751 OR  ;	&& COBRADOR CGB
			*		   DUPLICAT.PORTADOR   =  801 OR  ;	&& GERENCIA FILIAL
 			*		   DUPLICAT.PORTADOR   =  805 OR  ;	&& CORDEIRO ADV
			*		   DUPLICAT.PORTADOR   =  806 OR  ;	&& COBRANCA DORA
			*		   DUPLICAT.PORTADOR   =  888 OR  ;	&& ADVOGADO
			*		   DUPLICAT.PORTADOR   =  898 OR  ;	&& COB 898
			*		   DUPLICAT.PORTADOR   =  901 OR  ;	&& MATRIZ
			*		   DUPLICAT.PORTADOR   =  902 OR  ;	&& SIA
			*		   DUPLICAT.PORTADOR   =  903 OR  ;	&& W-3
			*		   DUPLICAT.PORTADOR   =  904 OR  ;	&& BGS
			*		   DUPLICAT.PORTADOR   =  905 OR  ;	&& IPG
			*		   DUPLICAT.PORTADOR   =  906 OR  ;	&& CGB
			*		   DUPLICAT.PORTADOR   =  907 OR  ;	&& IDL
			*		   DUPLICAT.PORTADOR   =  908 OR  ;	&& ARG
			*		   DUPLICAT.PORTADOR   =  951 OR  ;	&& COBRADOR
			*		   DUPLICAT.PORTADOR   =  909 OR  ;	&& IDP
			*		   DUPLICAT.PORTADOR   =  990 OR  ;	&& FATURAMENTO
			*		   DUPLICAT.PORTADOR   =  991 OR  ;	&& BAIXA FILIAL
			*		   DUPLICAT.PORTADOR   =  992 OR  ;	&& BORDERO FILIAL
			*		   DUPLICAT.PORTADOR   =  993 OR  ;	&& CAIXA LOJA
			*		   DUPLICAT.PORTADOR   =  998 		&& COB 998
			*		   IF EMPT(ALLT(DUPLICAT.NUM_NO_BCO))
			*	   		   SKIP
		    *			   LOOP
			*		   ENDI
	    	*		ENDI
			*	ENDI

				*---------------------------------------------------*
				*     Listar se a duplicata foi:
				*  PROTESTADA (TP_COBRANC = 88)
				*	OU 
				*  (Se Paga fora do Portador (PAGA_EM <> PORTADOR)
				*   E
				*   Tenha ido a banco !EMPT(ALLT(DUPLICAT.NUM_NO_BCO))
				*---------------------------------------------------*

				DO CASE
					CASE DUPLICAT.TP_COBRANC = 88
						SELE RETORNMV
						SET ORDER TO TAG DOC_OCOR
						SEEK STR(duplicat.duplicata,9)+STR(15,2)				
						IF FOUND()
				   		   SKIP
	    				   LOOP
						ENDIF
					CASE duplicat.paga_em <> duplicat.portador AND ;
				      !EMPT(ALLT(DUPLICAT.NUM_NO_BCO))))
			   		   SKIP
    				   LOOP
				ENDCASE


				SELE CLIENTES
		        SET ORDER TO TAG cliente
				SEEK DUPLICAT.CLIENTE
				IF FOUND()
				   LSNCLIEN = NOME
				  ELSE
				   LSNCLIEN = "??"
				ENDI

				SELE BANCO
		        SET ORDER TO TAG banco
				SEEK DUPLICAT.PORTADOR
				IF FOUND()
					LSNOMEP = NOME
				   ELSE
					LSNOMEP = "??"
				ENDI

				SELE BANCO
		        SET ORDER TO TAG banco
				SEEK DUPLICAT.PAGA_EM
				IF FOUND()
					LSNPAGAEM = NOME
				   ELSE
					LSNPAGAEM = "??"
				ENDI
				
				SELE TAB002
				SET ORDE TO TAG codigo
				SEEK "CBR"+TRANS(DUPLICAT.TP_COBRANC,"@L 99")
				IF FOUND()
					LSDESCTPCOB = DESCRICAO
				   ELSE
					LSDESCTPCOB = "??"
				ENDI

				SELE C_DUPLICAT
				APPE BLANK
				REPL NOME     	WITH LSNCLIEN
				REPL CLIENTE  	WITH DUPLICAT.CLIENTE
				REPL DUPLICAT   WITH DUPLICAT.DUPLICATA
				REPL DT_VENC 	WITH DUPLICAT.DT_VENC
				REPL DT_PGTO	WITH DUPLICAT.DT_PGTO
			*	REPL VLR_FATURA WITH DUPLICAT.VLR_FATURA
				REPL VLR_DUP    WITH DUPLICAT.VLR_DOC
				REPL NOMEP	 	WITH LSNOMEP
			    REPL DESCTPCOB	WITH LSDESCTPCOB
			    REPL NOME_EM 	WITH LSNPAGAEM
			    REPL NUM_NO_BCO WITH DUPLICAT.NUM_NO_BCO 

   				SELE DUPLICAT
   				SKIP
			 ENDD			     
*1
 			 SELE C_DUPLICAT
			 INDE ON CLIENTE TAG CHAVE OF C_DUPLICAT
             GO TOP
             LNregistro = RECNO()
             COUNT TO LNimpressao
             LNimpressos = 0
             GO TOP 				&& LNregistro
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
    IF LFcrtRec OR LFrec_cli
       SELE &wl_arqtmp
       USE
    ENDI
    LFrec_port = .F.
	SHOW WINDOW SCGC525 TOP
	SHOW GET m.imp_btn DISABLE
RETURN
