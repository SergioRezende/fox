


	LNctrproc	= 0		&& CONTADOR DE INSTR. PROCESSADA
	LNctrreje	= 0		&& CONTADOR DE INSTR. REJEITADAS
	LNctrdesc	= 0		&& CONTADOR DE INSTR. DESCARTADAS
	LFprocessa	= .f.	&& INDICA SE O REGISTRO FOI ACEITO NO PROCESSO

	SELE retornbc
	SCATTER MEMVAR MEMO
	SET ORDER TO TAG aviso
	=REGLOCK(.T.)

	SELECT  retornmv
	SET ORDER TO TAG aviso
	SEEK STR(m.empresa,3)+STR(m.banco,3)+STR(m.aviso,8)
	DO WHILE !EOF() AND m.aviso = retornmv.aviso AND ;
						m.banco = retornmv.banco AND ; 
						m.empresa = retornmv.empresa
		IF retornmv.status $ "PR/RJ"     && EVITA PROCESSO REDUNDANTE
			IF retornmv.status $ "PR"  
				LNctrproc = LNctrproc + 1
			ELSE
				LNctrreje = LNctrreje + 1
			ENDIF
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
			m.dsp_cobr	= 	m.dsp_cobr + retornmv.dsp_cobr
			m.out_desp	= 	m.out_desp + retornmv.out_desp
			m.iof  		= 	m.iof      + retornmv.iof

*** AS FILIAIS NAO TEM OCORRENCIA ESPECIFICA PARA INFORMAR QUE A BAIXA
*** E DO TIPO 83 => LIQ.FINAL.DUP C/PGTS.PARCIAIS 
*** POR SER INFORMADO OCORRENCIA 2, NESTE PONTO E FEITO TRATAMENTO....

*			IF retornmv.ocorrencia = 02 AND duplicat.parc_pgto > 0
*				REPLACE retornmv.ocorrencia WITH 83
*			ENDIF


			DO CASE   && processa ocor 02/06/07/09/10/12/13/14/17/19/
					  && 			   20/23/34/80/81/82/83/84/85/86
				      &&   E  03/24/27/30/32/   && REJEICOES


				CASE retornmv.ocorrencia = 02
					 m.portador  = retornbc.banco
					 m.agencia   = retornmv.agenc_cobr
				** 83 LIQUIDACAO RESIDUO // 86 - INCOBRAVEL SALDO
				CASE retornmv.ocorrencia = 06  OR ;
  					 retornmv.ocorrencia = 15  OR ;
  					 retornmv.ocorrencia = 83  OR ;
  					 retornmv.ocorrencia = 86  OR ;
  					 retornmv.ocorrencia = 17  && LIQUIDACAO DO TITULO
		  		     m.efeito	 = 2		  &&  PGTO TOTAL
					*******************   CRITICA *******************
					 IF !EMPTY(m.dt_pgto)  && DUP JA ESTA BAIXADA
						LFprocessa	=	.F.  
					 ELSE
						 SCATTER FIELDS juros, iof,abatimento, desconto, ;
								mora, out_credt, form_pgto, ;
								dtocorrenc  MEMVAR 
						 m.vlr_pgto = m.vlr_pgto + retornmv.vlr_pgto
						 m.dt_pgto  = m.dtocorrenc
						 m.dt_baixa = m.dtprocesso
					ENDIF
				CASE retornmv.ocorrencia = 07  && ESPECIFICO DO BFB
					*			LIQUIDACAO PARCIAL
					***************************************************
					* VIAILIZAR CRITICA 
					*************************************************
		  		     m.efeito	 = 3		&&  PGTO PARCIAL
					 SCATTER FIELDS juros, iof,abatimento, desconto, ;
								mora, out_credt, form_pgto, ;
								dtocorrenc  MEMVAR 
					 m.vlr_pgto = m.vlr_pgto + retornmv.vlr_pgto
					 m.parc_pgto = m.parc_pgto + retornmv.vlr_pgto
				CASE retornmv.ocorrencia = 09 OR ;
					 retornmv.ocorrencia = 10 && BAIXADOS
					 m.portador	=	0      && inf. carteira CR e Cobranca
					 m.agencia  =   0
				CASE retornmv.ocorrencia = 12 && ABATIMENTO CONCEDIDO
					m.abatimento= 	retornmv.abatimento
				CASE retornmv.ocorrencia = 13 && ABATIMENTO CANCELADO
					m.abatimento= 	0
				CASE retornmv.ocorrencia = 14 && VENCIMENTO ALTERADO
					m.dt_venc	=	retornmv.vencimento
				CASE retornmv.ocorrencia = 19 && INSTR. PROTESTO CONFIRMADO
					m.trf_cart 	=  	retornmv.trf_cart
				CASE retornmv.ocorrencia = 20 && INSTR. PROTESTO CANCELADA
					m.trf_cart 	=  	retornmv.trf_cart
				CASE retornmv.ocorrencia = 23 && ENTRADA CARTORIO   
					m.tp_cobranc=   88    && COBRANCA EM CARTORIO
					m.trf_cart 	=  	retornmv.trf_cart
				CASE retornmv.ocorrencia = 34 && ENTRADA CARTORIO   
					m.tp_cobranc=   1    && COBRANCA SIMPLES
					m.trf_cart 	=  	retornmv.trf_cart

				******** INSTRUCOES DE CARTEIRA

				CASE retornmv.ocorrencia = 85 && ALTERCACAO DE VLR DE DUPL.

					 m.vlr_doc =  retornmv.vlr_pgto 


				CASE retornmv.ocorrencia = 80 OR retornmv.ocorrencia = 84
					&& LIQ. POR DEVOLUCAO // DEVOL. PARCIAL
			 		 m.efeito	 = 4		&&  DEVOLUCAO
					 SCATTER FIELDS juros, iof,abatimento, desconto, ;
								mora, out_credt, form_pgto, ;
								dtocorrenc  MEMVAR 

					 IF retornmv.ocorrencia = 80    && LIQUID. POR DEVOL.
						*******************   CRITICA *******************
						 IF !EMPTY(m.dt_pgto)  && DUP JA ESTA BAIXADA
							LFprocessa	=	.F.  
						 ELSE
							 m.devolucao = m.devolucao + retornmv.vlr_pgto
							 m.dt_pgto  = m.dtocorrenc
							 m.dt_baixa = m.dtprocesso
						 ENDIF
					 ELSE
							 m.devolucao = m.devolucao + retornmv.vlr_pgto
					 ENDIF
				CASE retornmv.ocorrencia = 81  && INCOBRAVEL
					*******************   CRITICA *******************
					 IF !EMPTY(m.dt_pgto)  && DUP JA ESTA BAIXADA
						LFprocessa	=	.F.  
					 ELSE
				 		 m.efeito	 = 5		&&  INCOBRAVEL
 					 	 m.tp_cobranc=   99    && INCOBRAVEL
						 m.dt_pgto  = m.dtocorrenc
						 m.dt_baixa = m.dtprocesso
						 m.status = "I"
					 ENDIF
				CASE retornmv.ocorrencia = 82  && ALTERA DIRECIONA. COBRANCA
					 m.portador   =  retornmv.banco_cobr   
					 m.agencia    =  retornmv.agenc_cobr
				OTHERWISE   && 03/24/27/30/32/   && REJEICOES
					LFprocessa	=	.F.  
			ENDCASE			
			SELE duplicat
		   =edithand('REGRAVA')
	 		m.banco      =  retornmv.banco  && 

			SELE retornmv 
			REPLACE dtprocesso WITH m.dtprocesso
			REPLACE efeito 	   WITH m.efeito 
			IF LFprocessa
  				REPLACE status 	   WITH "PR"  && PROCESSADO
				LNctrproc = LNctrproc + 1
			ELSE
  				REPLACE status 	   WITH "RJ"  && PROCESSADO
				LNctrreje = LNctrreje + 1
			ENDIF
			***************************
			SET FIELDS TO dtregis, hregis, usrregis,deletado
			=edithand('REGRAVA')
			CLEAR FIELDS
			SET FIELDS OFF
			************************************
		ELSE
			LNctrdesc = LNctrdesc + 1
		ENDIF
		SELE retornmv
		SKIP
	ENDDO
	SELE retornbc
	REPLACE status 	   WITH "PR"  && PROCESSADO
	REPLACE reg_proces WITH LNctrproc
	REPLACE reg_descar WITH LNctrdesc
	REPLACE reg_rejeit WITH LNctrreje
	REPLACE dtprocesso WITH m.dtprocesso	
	***************************
	SET FIELDS TO dtregis, hregis, usrregis,deletado
	=edithand('REGRAVA')
	CLEAR FIELDS
	SET FIELDS OFF
	************************************
	UNLOCK 

RETURN
