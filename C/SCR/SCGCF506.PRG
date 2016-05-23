

******
***  CANCELA PROCESSOS DE BAIXAS E .....
****        CHAMADO PELO PROG. DE CANCELA IMPORTACAO 004
******

	LNctrproc	= 0		&& CONTADOR DE INSTR. PROCESSADAS
	LNctrreje	= 0		&& CONTADOR DE INSTR. REJEITADAS
	LNctrdesc	= 0		&& CONTADOR DE INSTR. DESCARTADAS
	LFprocessa	= .f.	&& INDICA SE O REGISTRO FOI ACEITO NO PROCESSO

	SELE retornbc
	SCATTER MEMVAR MEMO
	=REGLOCK(.T.)

	SELECT  retornmv
	SET ORDER TO TAG aviso
	SEEK STR(m.empresa,3)+STR(m.banco,3)+STR(m.aviso,8)
	DO WHILE !EOF() AND m.aviso = retornmv.aviso AND ;
						m.banco = retornmv.banco AND ; 
						m.empresa = retornmv.empresa
		IF retornmv.status $ "AP"     && EVITA PROCESSO REDUNDANTE
			SELE retornmv
			SKIP
			LOOP
		ENDIF
		SELE duplicat
		SET ORDER TO TAG doc
		SEEK STR(m.empresa,3)+STR(retornmv.duplicata,9)
		IF FOUND()
			=REGLOCK(.T.)
			SCATTER MEMVAR MEMO
			SELE retornmv
			=REGLOCK(.T.)
			LFprocessa	=	.t.
 		    m.efeito	 = 0		&&  NULO (indica efeto no Contas a Rec)

			m.num_no_bco=  	retornmv.num_no_bco
			m.dsp_cobr	= 	m.dsp_cobr - retornmv.dsp_cobr
			m.out_desp	= 	m.out_desp - retornmv.out_desp
			m.iof  		= 	m.iof      - retornmv.iof
			***** processa ocor 02/06/09/10/12/14/17/19/23
			DO CASE   
				CASE retornmv.status $ "RJ"  && ANULA PROCERSSO 
						LFprocessa	=	.F.  
				CASE retornmv.ocorrencia = 02
					 m.portador  = 0
					 m.agencia   = retornmv.agenc_cobr
				** 83 LIQUIDACAO RESIDUO // 86 - INCOBRAVEL SALDO
				CASE retornmv.ocorrencia = 06  OR ;
  					 retornmv.ocorrencia = 15  OR ;
  					 retornmv.ocorrencia = 83  OR ;
  					 retornmv.ocorrencia = 86  OR ;
  					 retornmv.ocorrencia = 17  && LIQUIDACAO DO TITULO
		  		     m.efeito	 = 2		  &&  PGTO TOTAL
					*******************   CRITICA *******************
					 IF EMPTY(m.dt_pgto)  && PROCESSO NAO INDICADO
						LFprocessa	=	.F.  
					 ELSE
						 STORE 0 TO  juros, iof,abatimento, desconto, ;
								mora, out_credt, form_pgto
						 m.vlr_pgto = m.vlr_pgto - retornmv.vlr_pgto
						 m.dtocorrenc= CTOD(" .  .  ")  
						 m.dt_pgto   = CTOD(" .  .  ")  
						 m.dt_baixa  = CTOD(" .  .  ")  
					 ENDIF
				CASE retornmv.ocorrencia = 07  && ESPECIFICO DO BFB
					*					LIQUIDACAO PARCIAL
					***************************************************
					* VIAILIZAR CRITICA 
					*************************************************

		  		     m.efeito	 = 3		&&  PGTO PARCIAL
					 STORE 0 TO  juros, iof,abatimento, desconto, ;
								mora, out_credt, form_pgto
					 m.vlr_pgto = m.vlr_pgto - retornmv.vlr_pgto
					 m.parc_pgto = m.parc_pgto - retornmv.vlr_pgto
					 m.dtocorrenc= CTOD(" .  .  ")  
				CASE retornmv.ocorrencia = 09 OR ;
					 retornmv.ocorrencia = 10 && BAIXADOS
					 m.portador	= retornbc.banco
					 m.agencia  = retornmv.agenc_cobr
				CASE retornmv.ocorrencia = 12 && ABATIMENTO CONCEDIDO
					m.abatimento= 	0
				CASE retornmv.ocorrencia = 13 && ABATIMENTO CANCELADO
					m.abatimento= 	retornmv.abatimento
				CASE retornmv.ocorrencia = 14 && VENCIMENTO ALTERADO
					m.dt_venc	=	retornmv.vencimento
				CASE retornmv.ocorrencia = 19 && INSTR. PROTESTO CONFIRMADO
					m.trf_cart 	=  	""
				CASE retornmv.ocorrencia = 20 && INSTR. PROTESTO CANCELADA
					m.trf_cart 	=  	""
				CASE retornmv.ocorrencia = 23 && ENTRADA CARTORIO   
					m.tp_cobranc=   01    && COBRANCA EM CARTORIO
					m.trf_cart 	=  	retornmv.trf_cart
				CASE retornmv.ocorrencia = 34 && ENTRADA CARTORIO   
					m.tp_cobranc=   88    && COBRANCA SIMPLES
					m.trf_cart 	=  	retornmv.trf_cart
				******** INSTRUCOES DE CARTEIRA
				CASE retornmv.ocorrencia = 80 OR retornmv.ocorrencia = 84
			 		 m.efeito	 = 4		&&  DEVOLUCAO
					*******************   CRITICA *******************
					 IF retornmv.ocorrencia = 80    && LIQUID. POR DEVOL.
						*******************   CRITICA *******************
						 IF EMPTY(m.dt_pgto)  && DUP JA ESTA BAIXADA
							LFprocessa	=	.F.  
						 ELSE
							 STORE 0 TO juros, iof,abatimento, desconto, ;
									mora, out_credt, form_pgto
							 m.dtocorrenc= CTOD(" .  .  ")
							 m.devolucao = m.devolucao - retornmv.vlr_pgto
							 m.dt_pgto  = CTOD(" .  .  ")
							 m.dt_baixa = CTOD(" .  .  ")
						 ENDIF
					 ELSE
							 m.devolucao = m.devolucao - retornmv.vlr_pgto
					 ENDIF
				CASE retornmv.ocorrencia = 81  && INCOBRAVEL
			 		 m.efeito	 = 5		&&  INCOBRAVEL
					*******************   CRITICA *******************
					 IF EMPTY(m.dt_pgto)  && PROCESSO NAO INDICADO
						LFprocessa	=	.F.  
					 ELSE
	 				 	 m.tp_cobranc=   1    && INCOBRAVEL
						 m.dt_pgto  = CTOD(" .  .  ")
						 m.dt_baixa = CTOD(" .  .  ")
						 m.status = "I"
					ENDIF
				CASE retornmv.ocorrencia = 82  && ALTERA DIRECIONA. COBRANCA
			 		 m.banco      =  0
					 m.agencia    = retornmv.agenc_cobr
				OTHERWISE   && 03/24/27/30/32/   && REJEICOES
					LFprocessa	=	.F.  
			ENDCASE			
			SELE duplicat
			=edithand('REGRAVA')
	 		m.banco      =  retornmv.banco  && 

			SELE retornmv 
			REPLACE dtprocesso WITH CTOD(" .  .  ")
			REPLACE efeito 	   WITH m.efeito 
			REPLACE status 	   WITH "AP"  && AGUARDA PROCESSO
			***************************
			SET FIELDS TO dtregis, hregis, usrregis,deletado
			=edithand('REGRAVA')
			CLEAR FIELDS
			SET FIELDS OFF
			************************************
		ENDIF
		SELE retornmv
		SKIP
	ENDDO
	SELE retornbc
	REPLACE status 	   WITH "AP"  && AGUARDA PROCESSADO
	REPLACE reg_proces WITH 0
	REPLACE reg_descar WITH 0
	REPLACE reg_rejeit WITH 0
	REPLACE dtprocesso WITH CTOD(" .  .  ")
	***************************
	SET FIELDS TO dtregis, hregis, usrregis,deletado
	=edithand('REGRAVA')
	CLEAR FIELDS
	SET FIELDS OFF
	************************************
	UNLOCK 

RETURN
