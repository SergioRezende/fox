
SELE notaent 

IF !REGLOCK()
   WAIT WINDOW notaent.tipo+" "+"Entrada "+STR(notaent.referencia,6)+" nao bloqueado p/ proc."
   wp_flgfecha = .t.
   RETURN
ENDIF

SELECT  notaite
SET ORDER TO TAG orcamento
SEEK STR(notaent.empresa,3)+STR(notaent.referencia,6)+;
			   STR(notaent.codforn,5)+STR(notaent.nota,6)+notaent.serie+LEFT(notaent.tipo,1)
***> ((((( PREVIA )))
LFflgtrans = .t.
m.valor     = 0
m.LNqtde	= 0			&& soma das quantidades 
m.LNbs_ipi  = 0         && base para calculo ipi
m.LNbs_icms = 0         && base para calculo icms
m.LNbs_subs = 0	     && base para calculo subs
m.LNbs_sbbrt= 0	     && base para abater icms do icms da subs
m.LNbs_iss  = 0        && base para calculo iss 
m.LNbs_isen = 0        && mercadorias isentas    
m.LNbs_outr = 0        && outras tributacoes    
m.LNalqicms = tipooper.aliq_icms		&& aliquota de icms
m.LNalqiss  = empresa.aliq_iss		&& aliquota de iss
m.LNicms 	 = 0		&& valor de icms
m.LNsubs 	 = 0		&& valor de icms por substituicao
m.LNiss  	 = 0		&& valor de iss
m.LNtotprod  = 0		&& soma dos valores dos produtos
m.LNtot  	 = 0		&& total da nota

*************************************************************
* VERIFICACAO PREVIA
*************************************************************

DO WHILE !eof() AND notaent.empresa 		= EMPRESA ;
				AND notaent.referencia 	= orcamento ;
				AND notaent.codforn 	 	= codforn ;
				AND notaent.nota 			= nota ;
				AND notaent.serie			= serie ;
				AND LEFT(notaent.tipo,1)  = LEFT(tipo,1)
		IF notaite.movestq = "S" 
		    IF !SOMA_SALDO() OR !(LEFT(notaite.situacao,1) $ "AB") 
				LFflgtrans = .F.
				EXIT
			ENDIF
			**  TESTAR PEDIDO NO PERIODO ACEMA DE 1998
			IF  notaent.data > {01.05.99} AND ;
				notaite.ch_opera = "1" AND ;
				LEFT(notaite.classifica,2) $ "00/01" AND notaent.pedido = 0 
			    WAIT WINDOW "Entrada "+STR(notaent.referencia,6)+" sem Nro.Pedido."
				LFflgtrans = .F.
				EXIT
			ENDIF
		    IF notaent.pedido > 0
				*----------------------------------------------------------*
				=W_DEFPROC("PEDIDO.SPR")
				IF !PDloc_item(notaent.empresa,;
							notaent.pedido,;
							notaite.codigo,.T.)
					EXIT
	   			ENDIF
				*----------------------------------------------------------*
			ENDIF
		ELSE
			IF !(LEFT(notaite.situacao,1) $ "AB")
				LFflgtrans = .F.
				EXIT
			ENDIF
		ENDIF
		SELE notaite
**		do UPimpent
    	    LNbs_ipi  = LNbs_ipi + vlripi
			LNbs_outr = m.LNbs_outr + vlripi     
			LNtotprod = LNtotprod + vlrvenda 
			LNqtde	  = LNqtde + qtde
    	    m.valor   = m.valor + vlrvenda 


		SKIP
ENDDO
IF !LFflgtrans
   WAIT WINDOW notaent.tipo+" "+"Entrada "+STR(notaent.referencia,6)+" itens irregulares."
   SELE notaent
   wp_flgfecha = .t.
   RETURN
ENDIF
m.LNtot  = m.valor + LNbs_ipi + m.LNsubs + ;
		   m.vlrfrete + m.vlrseguro + m.vlrdespes

*---->  POSICIONA ARQUIVOS RELACIONADOS
SELE empresa
SET ORDER TO TAG empresa
SEEK notaent.empresa

SELE tipooper
SET ORDER TO TAG tipo
IF notaent.tipo = "SCA"
	SEEK "s"+notaent.tipo
	IF !FOUND()
		SEEK "S"+notaent.tipo
	ENDIF
ELSE
	SEEK "e"+notaent.tipo
	IF !FOUND()
		SEEK "E"+notaent.tipo
	ENDIF
ENDIF
IF !FOUND()
   WAIT WINDOW notaent.tipo+" "+"Entrada "+STR(notaent.referencia,6)+" tipo nao Classificado."
   SELE notaent
   wp_flgfecha = .t.
   RETURN
ENDIF

SELECT  notaite
SET ORDER TO TAG orcamento
SEEK STR(notaent.empresa,3)+STR(notaent.referencia,6)+;
			   STR(notaent.codforn,5)+STR(notaent.nota,6)+notaent.serie+LEFT(notaent.tipo,1)

LFflgtrans = .t.
************************************
*=UPtransacao("INICIAR")
************************************
DO CASE
	CASE LEFT(notaent.situacao,1) = "A" && PROCESSAR TRANSITO
		DO WHILE !eof() ;
					AND LFflgtrans ;
					AND notaent.empresa 		= EMPRESA ;
					AND notaent.referencia 	= orcamento ;
					AND notaent.codforn 	 	= codforn ;
					AND notaent.nota 			= nota ;
					AND notaent.serie			= serie ;
					AND LEFT(notaent.tipo,1)  = LEFT(tipo,1)

	    	WAIT WINDOW "ITEM => "+STR(notaite.ordem,2) NOWAIT
			IF LEFT(notaite.situacao,1) $ "A"
			   	IF notaite.movestq = "S" 
	    			SELECT notaite
					IF REGLOCK()
						DO ULregtrans
					ELSE
						LFflgtrans = .F.
						EXIT
					ENDIF
					SELECT  notaite
				ELSE
		    		SELECT notaite
					IF REGLOCK()
						m.situacao = 'B'+RIGHT(notaent.situacao,1) 
						****** m.dtfat = wp_dtoper
						m.dtfat 	   =  notaent.data_emi
						=edithand('REGRAVA')
					ELSE
						LFflgtrans = .F.
						EXIT
					ENDIF
				ENDIF
			ENDIF
			SKIP
		ENDDO
		*----------------------------------------------------------*
		=W_DEFPROC("PEDIDO.SPR")
		=PDstat_pedd(notaent.empresa,notaent.pedido)
		*----------------------------------------------------------*

	CASE LEFT(notaent.situacao,1) = "B" && PROCESSAR ENTRADA
		DO WHILE !eof() ;
					AND LFflgtrans ;
					AND notaent.empresa 		= EMPRESA ;
					AND notaent.referencia 	= orcamento ;
					AND notaent.codforn 	 	= codforn ;
					AND notaent.nota 			= nota ;
					AND notaent.serie			= serie ;
					AND LEFT(notaent.tipo,1)  = LEFT(tipo,1)

	    	WAIT WINDOW "ITEM => "+STR(notaite.ordem,2) NOWAIT
			IF notaite.movestq = "S" 
			    IF SOMA_SALDO()
		    		SELECT notaite
					IF REGLOCK()
						DO fatura
					ELSE
						LFflgtrans = .F.
						EXIT
					ENDIF
				ELSE
					LFflgtrans = .F.
					EXIT
				ENDIF
				SELECT  notaite
			ELSE
    			SELECT notaite
				IF REGLOCK()
					m.situacao = 'C'+RIGHT(notaent.situacao,1) 
					******* m.dtfat = notaent.data
					m.dtfat 	   =  notaent.data_emi
				   =edithand('REGRAVA')
				ELSE
					LFflgtrans = .F.
					EXIT
				ENDIF
			ENDIF
			SKIP
		ENDDO
ENDCASE
*********************************************************************
SELE notaite
IF !LFflgtrans   && OPERACAO ABORTADA
    WAIT WINDOW notaent.tipo+" "+"Entrada "+STR(notaent.referencia,6)+" itens irregulares."
	************************************
	*=UPtransacao("ABORTAR")
	************************************
	UNLOCK ALL
	SELE notaent
    wp_flgfecha = .t.
	RETURN
ENDIF			
***************************
SELECT notaent
IF LEFT(notaent.situacao,1) = "A" && PROCESSAR TRANSITO
	m.situacao  =   "B"+RIGHT(notaent.situacao,1)
ELSE
	m.situacao  =   "C"+RIGHT(notaent.situacao,1)
ENDIF
*m.vlr_ipi	=	LNbs_ipi
m.base_iss	=	LNbs_iss
m.totservico=	LNbs_iss
***************************
SET FIELDS TO dtregis, hregis, usrregis,deletado
SET FIELDS TO situacao,  base_iss, totservico 
=edithand('REGRAVA')
CLEAR FIELDS
SET FIELDS OFF
************************************
*=UPtransacao("TERMINAR")
************************************
UNLOCK ALL
SELECT notaent
RETURN

****
* rotinas auxiliares
****

PROCEDURE SOMA_SALDO  && VERIFICA POSSIB. SOMA ESTOQUE  (proces)

   	IF LEFT(codigo,7) = "9999999"   && NAO REG. EM SALD OU ITEM COMENTA.
		RETURN(.T.)
   	ENDIF

   	SELECT saldo
   	SET ORDER TO TAG clas_saldo
   	SEEK STR(notaent.empresa,3)+notaite.classifica+;
        STR(YEAR(notaent.data),4)+;
        STR(MONTH(notaent.data),2)
	IF !FOUND()        
		SKIP -1			&& TESTE SE EXISTE REGISTRO ANTERIOR
      	IF !BOF() AND saldo.empresa    = notaent.empresa AND ;
      				  saldo.classifica = notaite.classifica
		    m.sld_ante   = m.sld_atu
		    m.vlr_ante   = m.vlr_atu
		ELSE
		    STORE 0 TO m.sld_ante,m.sld_atu,m.vlr_ante,m.vlr_atu
		ENDIF	 
   		m.empresa    = notaent.empresa
	    m.codigo     = notaite.codigo     
	    m.classifica = notaite.classifica
		STORE 0 TO 	m.qtd_compra,m.vlr_compra,m.qtd_venda,m.vlr_venda,;
					m.qtd_e_tran,m.vlr_e_tran,m.qtd_e_outr,m.vlr_e_outr,;
					m.qtd_s_tran,m.vlr_s_tran,m.qtd_s_outr,m.vlr_s_outr,;
					m.ven_tab,m.ven_contab,m.ven_enc

		m.dtabert   = notaent.data
	    m.status    = 'A'
		=edithand('SAVE')
	   	SEEK STR(notaent.empresa,3)+notaite.classifica+;
    	    STR(YEAR(notaent.data),4)+;
        	STR(MONTH(notaent.data),2)
	   	IF !FOUND()
		      WAIT WINDOW notaent.tipo+" "+RTRIM(transform(notaite.codigo,'@R &masc_codi'))+;
                   " nao foi aberto para movimentacao. Solicite abertura."
      		RETURN .F.                  
   		ENDIF
	ENDIF
   	IF notaite.qtde  = 0  	 && ITENS COM QTDE = 0 NAO SAO PROCESSADOS
    	WAIT WINDOW notaent.tipo+" "+RTRIM(transform(notaite.codigo,'@R &masc_codi'))+;
                   " tem QUANTIDADE =  0 "
      	RETURN .F.
   	ENDIF	
   	IF notaite.tp_mercad = 7  && SERVICO NAO NECESSITA SALDO
      	RETURN .T.                  
   	ENDIF
   	IF !REGLOCK()
      	WAIT WINDOW notaent.tipo+" "+RTRIM(transform(notaite.codigo,'@R &masc_codi'))+;
                 " nao pode ser bloqueado para efetivar soma."
	      RETURN .F.                  
   	ENDIF                            

   	IF notaent.natu_oper = 6	&& REQUISICAO DE SAIDA
		SELE itemmov
		SET ORDER TO TAG movimento
		SET NEAR ON
		SEEK STR(notaite.empresa,3)+notaite.codigo+;
	 		 DTOS(notaent.data)+notaent.hora+notaent.tipo+;
			 STR(notaent.nota,7)+STR(notaite.ordem,2)
		SET NEAR OFF
		SKIP -1
		IF BOF() OR notaite.codigo  <> itemmov.codigo ;
				 OR notaite.empresa <> empresa 
			SKIP
			IF EOF() OR notaite.codigo  <> itemmov.codigo ;
				 OR notaite.empresa <> empresa 
			   IF notaite.qtde > saldo.sld_atu
				  wp_msg = ;
				  RTRIM(transform(notaite.codigo,'@R &masc_codi'))+;
                  " Possui Saldo Insuficiente = "+STR(saldo.sld_atu,6)
			      WAIT WINDOW wp_msg+" <ENTER> "
			      RETURN .F.
			   ENDIF
			ELSE
			   IF notaite.qtde > itemmov.sld_estq
				  wp_msg = ;
				  	RTRIM(transform(notaite.codigo,'@R &masc_codi'))+;
                   	" Possui Saldo Insuficiente = "+STR(itemmov.sld_estq,6)
			      WAIT WINDOW wp_msg+" <ENTER> "
			      RETURN .F.
			   ENDIF
			ENDIF
		ELSE
		   IF notaite.qtde > itemmov.sld_estq
			  wp_msg = RTRIM(transform(notaite.codigo,'@R &masc_codi'))+;
                   " Possui Saldo Insuficiente = "+STR(itemmov.sld_estq,6)
		      WAIT WINDOW wp_msg+" <ENTER> "
		      RETURN .F.
		   ENDIF
		ENDIF
   	ENDIF

RETURN .T.  
*--------------------
*************************>
PROCEDURE FATURA

   SELECT notaite
   LNnota = notaent.nota     && EVITA APAGAR N. NOTA 
   SCATTER MEMVAR MEMO
   DO CASE
		CASE notaent.natu_oper = 1
		   m.operacao = 'ECP.'   && ENTRADA/COMPRA/PROCESSADA
		CASE notaent.natu_oper = 2
		   m.operacao = 'ETP.'   && ENTRADA/TRANSFERENCIA/PROCESSADA
		CASE notaent.natu_oper = 3
		   m.operacao = 'ERP.'   && ENTRADA/REMESSA/PROCESSADA
		CASE notaent.natu_oper = 4
		   m.operacao = 'EDP.'   && ENTRADA/DEVOLUCAO/PROCESSADA
		CASE notaent.natu_oper = 5
		   m.operacao = 'EOP.'   && ENTRADA/OUTRAS OPER/PROCESSADA
		CASE notaent.natu_oper = 6
		   m.operacao = 'SOP.'   && SAIDA/OUTRAS OPER / PROCESSADA
   ENDCASE
*******
**********************************
********  CALCULO DO CUSTO INDIRETO

   SET DECIMALS TO 6
	*---------------------------------------------------------------*
	*  CALCULO DO CUSTO INDIRETO
	*---------------------------------------------------------------*
   	SET DECIMALS TO 6
	IF notaent.data_emi < {01.09.1999} &&
   		TMP_totnf = m.totproduto 	&& NAO INCLUI O IPI => 
   									&& RATEIA COM O VALOR DA MERCADORIO
   									&& VLRVENDA
   		TMP_frete = ;
   			STR((m.vlrfrete+m.vlrdespes+m.vlrseguro) / TMP_totnf,20,11)
   		TMP_frt   = SUBS(TMP_frete,1,LEN(TMP_frete)-8)
   		TMP_frete = VAL(CHRTRAN(TMP_FRT,",","."))
		*----->>>>>>>>   RATEIO   <<<<<<------*
   		TMP_rateio 	= STR((TMP_frete * m.vlrvenda),20,8) && ipi item
   		TMP_rt   	= SUBS(TMP_rateio,1,LEN(TMP_rateio)-6)
   		TMP_rateio  = VAL(CHRTRAN(TMP_RT,",","."))
	ELSE
   		TMP_rateio  = ;
   		   ((m.vlrfrete+m.vlrdespes+m.vlrseguro) * (m.vlrvenda+m.vlripi)) /;
   		   (m.totproduto+m.vlr_ipi)
	ENDIF
	LNcstind  = TMP_rateio
   	SET DECIMALS TO 2
	**********************************
	   m.situacao = 'C'+RIGHT(notaent.situacao,1) 
   m.nota = notaent.nota
   *******   m.dtfat 	   =notaent.data
   m.dtfat 	   =  notaent.data_emi
   m.custo_ind =  LNcstind

   IF notaent.pedido > 0 and LEFT(m.codigo,7) <> "9999999"
		*----------------------------------------------------------*
		=W_DEFPROC("PEDIDO.SPR")
		IF !PDregistra_qte(notaent.empresa,notaent.pedido,notaite.codigo,;
							notaite.qtde,"REG.ENTRADA")
			LFflgtrans = .F.
			RETURN
		ENDIF
		*----------------------------------------------------------*
  ENDIF

   SELECT notaite
   =edithand('REGRAVA')
   IF LEFT(codigo,7) <> "9999999"   && NAO REG. EM SALD OU ITEM COMENTA.
	   SELECT itemmov
		m.data = notaent.data
		m.hora = notaent.hora
		m.sld_estq = 0
		m.vlr_estq = 0
		SELE itemmov
		SET ORDER TO TAG movimento
		SEEK STR(notaite.empresa,3)+notaite.codigo+;
	 		 DTOS(notaent.data)+notaent.hora+notaent.tipo+;
			 STR(notaent.nota,7)+STR(notaite.ordem,2)
		IF FOUND()
		   =edithand('REGRAVA')
		ELSE
		   =edithand('SAVE')
		ENDIF

		SELE itemmov
	   	=W_DEFPROC("moviment.spr")
		=MVatu_cmd(itemmov.empresa,;
					itemmov.codigo,;
					itemmov.classifica,;
					itemmov.data,;
					itemmov.hora,;
					itemmov.tipo,;
					itemmov.nota,;
					itemmov.ordem)
	    					&& ROTINA DE VERIFICACAO E ATUALIZACAO DO SALDO
							&& VAI DEVOLVER m.sld_atu e

*		DO UPatu_cmd		&& ROTINA DE VERIFICACAO E ATUALIZACAO DO SALDO
*						&& VAI DEVOLVER m.sld_atu e
	ENDIF
RETURN   
******
*************************>


PROCEDURE ULregtrans
   SELECT notaite
   SCATTER MEMVAR MEMO
   m.operacao = 'TRM.'   && TRANSITO / MERCADORIA
   LNcstind  = 0
   SET DECIMALS TO 2
**********************************
   m.situacao = 'B'+RIGHT(notaent.situacao,1) 
   m.nota = notaent.nota
   **** m.dtfat =notaent.data
   m.dtfat 	   =  notaent.data_emi
***
   IF notaent.pedido > 0
		*----------------------------------------------------------*
		=W_DEFPROC("PEDIDO.SPR")
		IF !PDregistra_qte(notaent.empresa,notaent.pedido,notaite.codigo,;
							notaite.qtde,"REG.TRANSITO")
			LFflgtrans = .F.
			RETURN
		ENDIF
		*----------------------------------------------------------*
   ENDIF
   SELECT notaite
    =edithand('REGRAVA')
   RETURN
RETURN


