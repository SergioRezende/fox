
***********************************************************************

PROCEDURE ULconvsaida
	wp_flgfecha = .F.
	IF ! NetUse("notaimpo",.t.)
		wp_flgfecha = .t.  && implica no fechamento da secao
	ENDIF
	IF ! NetUse("itemimpo",.t.)
		wp_flgfecha = .t.  && implica no fechamento da secao
	ENDIF
	IF ! NetUse("cobrimpo",.t.)
		wp_flgfecha = .t.  && implica no fechamento da secao
	ENDIF


	IF m.empresa = 10 
		IF !FILE("l:\tmp\saidas.txt")
			=UP_fecha("notaimpo")
			=UP_fecha("itemimpo")
			=UP_fecha("cobrimpo")
			RETURN
		ENDIF
	ELSE
		IF !FILE(LSnfstmp) OR !FILE(LSitemtmp) ;
					   OR !FILE(LScobrtmp)	OR wp_flgfecha
			=UP_fecha("notaimpo")
			=UP_fecha("itemimpo")
			=UP_fecha("cobrimpo")
			RETURN
		ENDIF
	ENDIF


	SELE notaimpo
*>>>>>>>>>>>>>>>>>>>>>>>>>>  LIMPEZA DO ARQUIVO
	LStmp  = sys(5)+sys(2003)  		&&  UNIDADE E DIRETORIO CORRENTES
	SET DEFA TO &wp_dirdat

	SELE notaimpo
    USE notaimpo EXCL
    COPY STRU TO tmp WITH CDX
    USE tmp EXCL
    COPY STRU TO notaimpo WITH CDX
	USE

	SELE itemimpo
    USE itemimpo EXCL
    COPY STRU TO tmp WITH CDX
    USE tmp EXCL
    COPY STRU TO itemimpo WITH CDX
	USE

	SELE cobrimpo
    USE cobrimpo EXCL
    COPY STRU TO tmp WITH CDX
    USE tmp EXCL
    COPY STRU TO cobrimpo WITH CDX
	USE

	SET DEFA TO &LStmp
*---------------------------
	IF ! NetUse("notaimpo",.t.)
		wp_flgfecha = .t.  && implica no fechamento da secao
	ENDIF
	IF ! NetUse("itemimpo",.t.)
		wp_flgfecha = .t.  && implica no fechamento da secao
	ENDIF
	IF ! NetUse("cobrimpo",.t.)
		wp_flgfecha = .t.  && implica no fechamento da secao
	ENDIF
	IF ! NetUse("IDLNFS",.t.)
		wp_flgfecha = .t.  && implica no fechamento da secao
	ENDIF
	IF ! NetUse("IDLITNFS",.t.)
		wp_flgfecha = .t.  && implica no fechamento da secao
	ENDIF


	set step on

	IF m.empresa = 10
		SELE idlnfs
		ZAP
		PACK
		APPEND FROM L:\tmp\saidas.txt TYPE SDF ;
				for filial = 10 and tipo_nf = 1
		SELE notaimpo
		ZAP
		PACK
		a=DBF("idlnfs")
		APPEND FROM &a
	
	ELSE
		SELE notaimpo
		ZAP
		PACK
		APPEND FROM &LSnfstmp TYPE SDF
		GO TOP
	ENDIF
	IF EOF() AND BOF()
		=UP_fecha("notaimpo")
		=UP_fecha("itemimpo")
		=UP_fecha("cobrimpo")
		RETURN
	ENDIF


	IF m.empresa = 10
		SELE idlitnfs
		ZAP
		PACK
		APPEND FROM L:\tmp\saidas.txt TYPE SDF ;
				for filial = 10 and tipo_nf = 2
		SELE itemimpo
		ZAP
		PACK
		a=DBF("idlitnfs")
		APPEND FROM &a

	ELSE
		SELE itemimpo
		ZAP
		PACK
		APPEND FROM &LSitemtmp TYPE SDF
	ENDIF
	GO TOP
	
	SELE cobrimpo
	ZAP
	PACK
	IF m.empresa <> 10 
		APPEND FROM &LScobrtmp FOR FILIAL = notaimpo.filial TYPE SDF
	ENDIF

	SELE notaimpo
*******************
*---->   (INICIALIZACAO DO CONTROLE DE STATUS IMPRESSAO)
*******************	
	DO RELINIC.PRG          && INICIA VAR P/ TERMOMETRO

	LFsegue = .t.
	LNregistro = RECNO()
	LNimpressao = RECCOUNT()
	LNimpressos = 0
	GO LNregistro
*******************
	GO TOP
	m.msg_acomp = "Importa Saidas       "
	SHOW GET m.msg_acomp
	m.contador = 0
	SHOW GET m.contador
	
	DO WHILE !EOF() AND !wp_flgfecha  AND LFsegue
		SELE notaimpo
		wp_msg = "IMP. SAIDAS [Emp.: "+STR(m.empresa,3)+ " ]"+;
									DTOC(m.dt_inicio)
		=UPtermo()
************
		=UPtransacao("INICIAR")
************
	*>>>>>>>>>>>>>>>>>     INICIO CONVERSAO P/ ORCAMENT ou OUTROPER
		m.orcamento		=   notaimpo.nota
		m.empresa 		= 	notaimpo.filial
		m.tipo			=   notaimpo.tipo_sai
*********
*		IF m.tipo = "NSP"    && INFORMATIVO SEM EFEITO GERADO NA INDUSTRIA
*			SELE notaimpo
*			SKIP
*			LOOP
*		ENDIF			
**********
		DO CASE
			**********   TIPOS ANTIGO USADOS NA RECONSTITUICAO DE 95/96/97
			CASE m.tipo = "VVC"
					m.tipo = "VLA"
			CASE m.tipo = "VPC" OR m.tipo = "D  "
					m.tipo = "VLB"
			CASE m.tipo = "VVF"
					m.tipo = "VFA"
			CASE m.tipo = "VPF" OR m.tipo = "F  "
					m.tipo = "VFB"
			CASE m.tipo = "RTP"
					m.tipo = "VFD"
			CASE m.tipo $ "TIT/TST"
					m.tipo = "TDA"
			CASE m.tipo $ "TIF"
					m.tipo = "TDB"
			CASE m.tipo = "TET"
					m.tipo = "TCA"
			CASE m.tipo = "TIC"
					m.tipo = "TDC"
			CASE m.tipo = "RTV"
					m.tipo = "VFC"
			CASE m.tipo = "RMC"
					m.tipo = "RCE"
			CASE m.tipo = "CVV"
					m.tipo = "VLG"
			CASE m.tipo = "RMI"
					m.tipo = "RDC"
			CASE m.tipo = "VRV"
					m.tipo = "VLE"
			CASE m.tipo = "RRT"
					m.tipo = "RDC"
			CASE m.tipo = "TCM"
					m.tipo = "TCC"
			CASE m.tipo = "VAI"
					m.tipo = "VLK"
			**************************************************************
			CASE m.tipo = "NSP" OR m.tipo = "NS "
					m.tipo = "NSP"
			CASE m.tipo = "RCG"    && O TIPO RCG FOI CRIADO, MAS E = RCC
					m.tipo = "RCC"
			CASE m.tipo = "VPC"   && TIPO ESPECIFICO DA IDL
					m.tipo = "VLB"
			CASE m.tipo = "RCI" OR m.tipo = "RD " OR m.tipo = "RF "   && TIPO ESPECIFICO DA IDL
					m.tipo = "RCE"
			CASE m.tipo = "VPF"   && TIPO ESPECIFICO DA IDL
					m.tipo = "VFB"
			CASE m.tipo $ "DIC/DCC/DPI"   && TIPO ESPECIFICO DA IDL
					m.tipo = "DCC"
			CASE m.tipo $ "DAI/DPP"   && TIPO ESPECIFICO DA IDL
					m.tipo = "DCD"
			CASE m.tipo $ "DCF/DCM/DSI"   && TIPO ESPECIFICO DA IDL
					m.tipo = "DDC"
		ENDCASE
		LDTtmp			= (SUBS(notaimpo.dt_emi,1,2)+"."+;
								 SUBS(notaimpo.dt_emi,3,2)+"."+;
								 SUBS(notaimpo.dt_emi,5,2))
		IF LDTtmp		= "29.02.00"
			LDTtmp	= {29.02.2000}
		ELSE
			LDTtmp	= CTOD(LDTtmp)
		ENDIF								
	 	m.dt_fat    	=	UPValData(LDTtmp)  && bug 20000

		m.hora_fat		=	space(8)
		m.nota     		= 	m.orcamento
		*-------------------------------------------------------------
		*  VERIFICACAO DA EXISTENCIA DO DOC. NO ARQ. DESTINO
		*-------------------------------------------------------------
		SELE nota
		SET ORDER TO TAG nota
		SEEK STR(m.empresa,3)+STR(m.orcamento,7)		
		IF FOUND()			&& Nota ja existe
			SELE notaimpo
			SKIP
			LOOP
		ENDIF
		*-------------------------------------------------------------
		*  NOTAS CANCELADAS E NOTAS DE ENTRADA
		*-------------------------------------------------------------
 		IF m.tipo = "CAN" OR m.tipo = "ENT"     &&*- AND m.ch_opera <> "5"
			m.nota     		= m.orcamento

			LDTtmp			=	(SUBS(notaimpo.dt_emi,1,2)+"."+;
								 SUBS(notaimpo.dt_emi,3,2)+"."+;
								 SUBS(notaimpo.dt_emi,5,2))
			IF LDTtmp		= "29.02.00"
				LDTtmp		= {29.02.2000}
			ELSE
				LDTtmp		= CTOD(LDTtmp)
			ENDIF								
		 	m.data    	    =	UPValData(LDTtmp)  && bug 20000

			m.status = 1
			m.operacao = "S"		&& NOTA FISCAL DE ENTRADA
			*---------------------------------------------------------*
			*	ATRIBUINDO DADOS PARA O CADASTRO
			*---------------------------------------------------------*
			m.nome		=	notaimpo.nome_cli
			m.endereco	=	notaimpo.end_cli
			m.cidade	=	notaimpo.mun_cli
			m.bairro	=	notaimpo.bairro_cli
			m.cep		= 	STR(notaimpo.cep_cli,5)+STR(notaimpo.cep2,3)
			m.cep		=   STRTRAN(m.cep," ","0")
			m.estado 	= 	notaimpo.uf_cli
			m.fone		= "(   )-"+SUBS(STR(notaimpo.tel_cli,7),1,3)+"-"+;
									 SUBS(STR(notaimpo.tel_cli,7),4,4)
			m.regiao 		=  notaimpo.regiao_cli
	 		m.tp_transp		= 	notaimpo.tipo_trans
			m.tp_pessoa		= 	notaimpo.tipo_cli + 1
			m.inscricao		= 	STR(notaimpo.insc_cli,13)

			LDTtmp			= (SUBS(notaimpo.dt_emi,1,2)+"."+;
								 SUBS(notaimpo.dt_emi,3,2)+"."+;
								 SUBS(notaimpo.dt_emi,5,2))
			IF LDTtmp		= "29.02.00"
				LDTtmp	= {29.02.2000}
			ELSE
				LDTtmp	= CTOD(LDTtmp)
			ENDIF								

		 	m.DATA    	=	UPValData(LDTtmp)  && bug 20000



			m.cliente		=	notaimpo.cgc_cpf
			m.favorecido	=	notaimpo.cgc_cpf
			m.valor			=	notaimpo.total_nota / 100
			m.vlr_ent       =   notaimpo.vlr_dup / 100
			m.taxa			=	notaimpo.taxa / 100
			m.banco			=	notaimpo.cobranca
			m.agencia		=	notaimpo.agencia
			m.vlrfrete		=	notaimpo.frete / 100
			m.vlrseguro		=	notaimpo.seguro / 100
			m.vlrdespes		=	0
			*---------------------------------------------------------*
			IF m.tipo = "CAN"		
					m.status = 2
					DO CASE
						CASE notaimpo.tipo_nota = 1
							m.ch_opera = "1"
						CASE notaimpo.tipo_nota <= 3
							m.ch_opera = "2"
						OTHERWISE
							m.ch_opera = "3"
					ENDCASE	
			ELSE
				m.operacao = "E"		&& NOTA FISCAL DE ENTRADA
			ENDIF
			SELE nota
		    =edithand('SAVE')
			SELE notaimpo
			SKIP
************
			=UPtransacao("TERMINAR")
************
			LOOP
		ENDIF
********************************************************************
********************************************************************
		SELE tipooper
		SET ORDER TO TAG tipo
		SEEK 's'+m.tipo
		IF !FOUND()
			SEEK 'S'+m.tipo
		ENDIF


	    SCATTER FIELDS ch_opera, ch_produ, ch_motiv, ch_desti,;
		    		 ch_contr, ch_condi, cfo  MEMVAR  MEMO
***>>PARA PROCESSO POR NAO ENCONTRAR CLASSIFICACAO
		IF !FOUND()
			wp_msg = "Emp["+STR(m.empresa,3)+"]"+;
					 " SAIDA No "+STR(m.orcamento,6)+;
					 " de "+DTOC(m.dt_inicio)+" TIPO=>"+m.tipo+;
					  " Nao identifcado"
			=UPbeeps(LFalerta,wp_msg)
			wp_flgfecha = .T.
			m.dt_inicio = m.dt_fim + 1	
			SELE notaimpo
************
			=UPtransacao("ABORTAR")
************
			LOOP
		ENDIF			
		SELE orcament
		SET ORDER TO TAG geral
		SEEK STR(m.empresa,3)+STR(m.orcamento,6)		

		IF FOUND()
			DO CASE
			    CASE !(LEFT(orcament.situacao,1) $ "OZ")
				   DO OBJ_ALER.SPR WITH ;
				   "Documento ja importado e NAO FATURADO. " + ;
				   "Apague o registro para processeguir IMPORTACAO."+ ;
				   "  Doc : "+m.tipo+"  "+str(m.orcamento,6)
					wp_flgfecha = .t.   				
	
			    CASE (LEFT(orcament.situacao,1) $ "O")
				   DO OBJ_ALER.SPR WITH ;
				   "Documento Consta Como Faturado sem que "+ ;
				   "NF.esteja emitida"+ ;
			       chr(13)+"Verifique com Suporte o Motivo de Erro."+ ;
			       chr(13)+" Doc : "+m.tipo+"  "+str(m.orcamento,6)
				   wp_flgfecha = .t.   				
			    CASE (LEFT(orcament.situacao,1) $ "Z")
				   DO OBJ_ALER.SPR WITH ;
				   "Orcamento Consta Como Cancelado e Impede Processo "+ ;
			       chr(13)+" Elimine o Orcamento Para Prosseguir."+ ;
			       chr(13)+" Doc : "+m.tipo+"  "+str(m.orcamento,6)
				   wp_flgfecha = .t.   				
			ENDCASE
			SELE notaimpo
			SKIP
			=UPtransacao("ABORTAR")
			LOOP
		ELSE
			SELE itemmov
			SET ORDER TO TAG orcamento
			SEEK STR(m.empresa,3)+STR(m.orcamento,6)
			IF FOUND()
			   DO OBJ_ALER.SPR WITH ;
			   "N. Documento nao Consta entre Notas e Orcamentos mas " + ;
			   " consta no movimento  => "+ CHR(13)+;
	    		      " Orc. = "+STR(m.orcamento,6)+" de "+;
	          			DTOC(itemmov.data) + ;
			          " NFS. = "+STR(itemmov.nota,7)+" de "+;
					  " ITEM=> "+itemmov.codigo
				wp_flgfecha = .t.   				
				SELE notaimpo
				SKIP
				=UPtransacao("ABORTAR")
				LOOP
			ENDIF
		ENDIF
		*---------------------------------------------------------*
		*	ATRIBUINDO DADOS PARA O CADASTRO
		*---------------------------------------------------------*
		*   		 CAMPOS COM CORRESPONDENCIA DIRETA

		m.cliente		=	notaimpo.cgc_cpf
		m.nome			=	notaimpo.nome_cli
		m.endereco		=	notaimpo.end_cli
		m.cidade		=	notaimpo.mun_cli
		m.bairro		=	notaimpo.bairro_cli
		m.cep			= 	STR(notaimpo.cep_cli,5)+STR(notaimpo.cep2,3)
		m.cep			=   STRTRAN(m.cep," ","0")
		m.estado 		= 	notaimpo.uf_cli
		m.fone			= 	"(   )-"+SUBS(STR(notaimpo.tel_cli,7),1,3)+"-"+;
									 SUBS(STR(notaimpo.tel_cli,7),4,4)
		m.regiao 		=  notaimpo.regiao_cli
		IF m.ch_contr 	= "4"
			m.revendedor = "S"
		ELSE
			m.revendedor = "N"
		ENDIF
		*---------------------------------------------------------*
		*	CAPTURANDO ENDERECO DE COBRANCA DO CADASTRO
		*---------------------------------------------------------*
		STORE "" TO m.cbnome, m.cbendereco, m.cbbairro, m.cbcidade, ;
						m.cbestado, m.cbcep	
		SELE cobrimpo
		SET ORDER TO TAG cgc
		SEEK m.cliente
		IF FOUND()
			IF !EMPTY(RTRIM(cobrimpo.endereco))
				m.cbnome		= 	m.nome
				m.cbendereco	= 	RTRIM(cobrimpo.endereco)+"; "+;
									  cobrimpo.numero
				m.cbbairro		= 	cobrimpo.bairro
				m.cbcidade		=	cobrimpo.municipio
				m.cbestado		=	cobrimpo.uf
				m.cbcep		    = 	cobrimpo.cep+cobrimpo.cep2
				m.cbcep			=   STRTRAN(m.cbcep," ","0")
			ELSE
				m.cbnome		= 	m.nome
				m.cbendereco	=	notaimpo.end_cli
				m.cbbairro		=	notaimpo.bairro_cli
				m.cbcidade		=	notaimpo.mun_cli
				m.cbestado 		= 	notaimpo.uf_cli
				m.cbcep			=   STR(notaimpo.cep_cli,5)+;
											STR(notaimpo.cep2,3)
				m.cbcep			=   STRTRAN(m.cep," ","0")
			ENDIF
		ENDIF
		*---------------------------------------------------------*
 		m.tp_transp		= 	notaimpo.tipo_trans
		m.tp_pessoa		= 	notaimpo.tipo_cli + 1
		m.inscricao		= 	STR(notaimpo.insc_cli,13)

		LDTtmp			= (SUBS(notaimpo.dt_emi,1,2)+"."+;
								 SUBS(notaimpo.dt_emi,3,2)+"."+;
								 SUBS(notaimpo.dt_emi,5,2))
		IF LDTtmp		= "29.02.00"
			LDTtmp	= {29.02.2000}
		ELSE
			LDTtmp	= CTOD(LDTtmp)
		ENDIF								
	 	m.DATA    	=	UPValData(LDTtmp)  && bug 20000

		m.favorecido	=	notaimpo.cgc_cpf
		m.valor			=	notaimpo.total_nota / 100
		m.vlr_ent       =   notaimpo.vlr_dup / 100
		m.taxa			=	notaimpo.taxa / 100
		m.banco			=	notaimpo.cobranca
		m.agencia		=	notaimpo.agencia

		**** COBRANCA CHEQUE => FORMA_PGTO = 2
		IF m.banco = 898	
			m.forma_pgto	=	2
		ELSE
			m.forma_pgto	=	4	
		ENDIF

		m.vlrfrete		=	notaimpo.frete / 100
		m.vlrseguro		=	notaimpo.seguro / 100
		m.vlrdespes		=	0
*********************** ATE CONVERTER OPERADOR P/ 5 DIGITOS ******
		IF m.empresa > 9
			m.operador		=	notaimpo.vendedor
		ELSE
			m.operador		=	notaimpo.vendedor + (m.empresa * 1000)
		ENDIF
************************************************************
		m.serv_1        =   m.operador
		m.situacao		= "A "   && ESTADO INICIAL P/ FAT. SEM RESERVA
		m.obs			=   notaimpo.obs
*------->>>>>>>>>>>>    CAMPOS COM CONVERCAO P/ NOVAS CONDICOES >>>>>>>>		
		IF notaimpo.insc_cli > 0
			m.tp_inscr = 1    && ESTADUAL
		ELSE
			m.tp_inscr = 4    && OUTROS
		ENDIF
		m.juro_mes		= 	m.taxa * 30
		m.tp_pgto		= 	notaimpo.condicao  && 1=vista 2=prazo 		

		LDTtmp			= (SUBS(notaimpo.dt_emi,1,2)+"."+;
								 SUBS(notaimpo.dt_emi,3,2)+"."+;
								 SUBS(notaimpo.dt_emi,5,2))
		IF LDTtmp		= "29.02.00"
			LDTtmp	= {29.02.2000}
		ELSE
			LDTtmp	= CTOD(LDTtmp)
		ENDIF								

	 	m.dt_emi    	=	UPValData(LDTtmp)  && bug 20000

		LDTtmp			= (SUBS(notaimpo.venc_dup,1,2)+"."+;
								 SUBS(notaimpo.venc_dup,3,2)+"."+;
								 SUBS(notaimpo.venc_dup,5,2))
		IF LDTtmp		= "29.02.00"
			LDTtmp	= {29.02.2000}
		ELSE
			LDTtmp	= CTOD(LDTtmp)
		ENDIF								
	 	m.venc_dup 	=	UPValData(LDTtmp)  && bug 20000


		m.vias_osi = 1

*>>>>>>>>>> OPERACOES EPCIFICAS POR OPERACAO ex: VENDAS/TRANS/DEV/REMS..	
		m.motivo = 0
		m.prazo  = ""
		m.prazomedio= 0
***************
		m.natu_oper   = INT(VAL(m.ch_opera))
**************
		DO CASE
			CASE m.ch_opera	= "1"		&& VENDA
				DO ULopevenda
			CASE m.ch_opera	= "2"		&& TRANSF
				DO ULopetransf
			CASE m.ch_opera	= "3"		&& REMSSS
				DO ULoperemessa
			CASE m.ch_opera	= "4"		&& DEVOLUCAO
				DO ULopedevol
		ENDCASE		
*********
		IF m.tipo = "NSP"    && INFORMATIVO SEM EFEITO GERADO NA INDUSTRIA
			m.tp_pgto = 1		&& A VISTA
			m.prazo  = ""
			m.prazomedio= 0
		ENDIF			
**********
		SELE orcament
		m.prazo         =   CHRTRAN(m.prazo," ","0")
		m.lim_libera	=	m.valor
		m.lim_prazo		=	m.prazomedio
		m.lim_forma		=   0
		m.usr_libera	= 	0


		LDTtmp			= (SUBS(notaimpo.dt_emi,1,2)+"."+;
								 SUBS(notaimpo.dt_emi,3,2)+"."+;
								 SUBS(notaimpo.dt_emi,5,2))
		IF LDTtmp		= "29.02.00"
			LDTtmp	= {29.02.2000}
		ELSE
			LDTtmp	= CTOD(LDTtmp)
		ENDIF								
	 	m.dt_libera 	=	UPValData(LDTtmp)  && bug 20000


		IF m.tp_pgto = 2 AND m.prazomedio > 0
			m.tp_pgto = 3		&& a prazo (AJUSTA P/ CODIGO DO NV.SIST)
		ENDIF


		DO CASE
			CASE m.tp_pgto = 1
				m.tp_parcela = m.tp_pgto
			CASE m.banco = 898
				m.tp_parcela = 2
			CASE m.banco <> 898  AND (m.banco < 850 or m.banco > 856)
				m.tp_parcela = 3
			CASE m.banco >= 850 AND m.banco <= 856
				m.tp_parcela = 4
		ENDCASE

		m.lmt_parcel = "N"

		m.flgtransac = .t.
		=edithand('SAVE')

		*-----------------------------------------------------------*
		*   Os dados do  cliete etarao no ORCAMENT se a importacao
		* ja estiver sendo feita para o sistema sem reestruturacao
		* mas ja transcrevera os dados para CLIENC prevendo o fatura-
		* mento com sistema ja reestruturado
		*-----------------------------------------------------------*
		SELE clienc
		SET ORDER TO TAG emporca
		SEEK STR(m.empresa,3)+STR(m.orcamento,6)		
		IF !FOUND()		
			=edithand('SAVE')
		ELSE
			=edithand('REGRAVA')
		ENDIF		
*>>>>>>>>>>>>>>>>>     FIM CONVERSAO P/ ORCAMENT ou OUTROPER
      							*********
*>>>>>>>>>>>>>>>>>     INICIO CONVERSAO DE ITENS P/ ORCATMP
		m.ordem 	 = 0   &&  p/ diferenciar codigo com + de um movimento

		SELE itemimpo
		SET ORDER TO TAG nota
		SEEK STR(m.empresa,2)+STR(m.orcamento,6)

		LNrgant = 0		&& lancada para pesqusar o avanco do registro
		*------------------------------------------------------*
		*   Para apurar o valor de Fechamento da osi
		*------------------------------------------------------*
	    FCHvlr     = 0
		FCHqtde    = 0        && base para calculo ipi
		*------------------------------------------------------*

		DO WHILE !EOF() AND m.orcamento = nota AND  !wp_flgfecha
		*------------------------------------------------------*
		*  ESTA LINHA FOI COLOCADA POR QUE ESTAVA ACONTECENDO GRAV.
		*            DUPLAS DO MESMO REGISTRO                  *
		*------------------------------------------------------*
			IF LNrgant <> 0 AND RECNO() = LNrgant  && NAO AVANCOU
			   SKIP
			   LNrgant = RECNO()  && marca o registro atual P/ VER NA PROX.
			ENDIF			    		
		*------------------------------------------------------*
			m.ordem 	= 	m.ordem + 1
			m.codigo 	=	LEFT(itemimpo.codigo,7)
			m.codigo	=   ALLTRIM(m.codigo)+UPCALCDIG(m.codigo)

			m.qtde  	=	itemimpo.qtde
			m.desconto 	=	itemimpo.desconto / 10
	
		*	m.preco 	= 0
		*	m.clas_cms 	= ""
		*	=W_DEFPROC("PRECO.SPR")
		*	IF !PRpreco((m.empresa),tipooper.ch_opera,;
		*		tipooper.tipo,(m.codigo),(m.data),m.preco,m.clas_cms)
		*		m.preco		=	itemimpo.vlr_tab / 100
		*	ENDIF

			m.preco 	= 0
			m.clas_cms 	= ""
			=W_DEFPROC("PRECO.SPR")
			m.preco = PRVlrSaida((orcament.empresa),;
		                     (orcament.orcamento),;
		                      (m.codigo))
			=W_DEFPROC("PRECO.SPR")
			m.clas_cms = PRClas_Cms((orcament.empresa),;
		                     (orcament.orcamento),;
		                      (m.codigo))

			if m.preco = 0 
			   m.preco		=	itemimpo.vlr_tab / 100
			endif


		
**** NAS TRANSFERENCIAS O CUSTO E JOGADO EM VLR_UNI E O SISTEMA TEM
*** QUE CONSIDERAR O CUSTO DO SISTEMA ORIGEM PARA EFEITO DOS LANCAMENTOS
*** CONTABEIS DE MERCADORIA P/ REVENDA ONDE O CUSTO INFLUENCIA NO CALCULO
*** E PORTANTO DEVE SER USADO O MESMO CUSTO DA MONTAGEM DA NOTA.	

			IF m.preco  =   0 OR m.tipo $ "TCA/TDA"
				m.preco = itemimpo.vlr_uni / 100
			ENDIF
			
          *--==============================>>> CALC. VALOR VENDA
			m.vlr_uni	=	itemimpo.vlr_uni / 100
			
*********   Para truncar desconto e valor liquido

			IF m.desconto = 0			
	 		    LVVLRVENDA   = m.vlr_uni * m.qtde
			ELSE
********    	LVVLRVENDA =
*********   	ABS((m.vlr_uni - (m.vlr_uni*m.desconto/100))  * m.qtde)
*********   Para truncar desconto e valor liquido
					SET DECIMALS TO 6
************** modulo substituido
		   	        LVVLRVENDA   = ABS(m.vlr_uni-(m.vlr_uni*m.desconto/100))
					LVVLRVENDA   = STRTRAN(STR(LVVLRVENDA,16,5),",",".")
					LVVLRVENDA   = VAL(LEFT(LVVLRVENDA,13))*m.qtde
					SET DECIMALS TO 2
			ENDIF

 			m.vlrvenda   = LVvlrvenda
          *
          *--==============================>>> CALC. DESCONTO REAL
		     LNtotal  = m.preco * m.qtde
		     LNvlreal = LNtotal + LNtotal * TAXA / 100
		     LNperct  = LNvlreal - m.vlrvenda
		     LNdesconto = (LNperct * 100) / LNvlreal
		     m.desconto = LNdesconto
			 IF m.desconto < -99 or m.desconto > 100
			     m.desconto = 0
			 ENDIF
			*****************************
			IF m.qtde > 0
				 m.precofinal	= m.vlrvenda / m.qtde
			ELSE
				 m.precofinal	= m.vlrvenda
			ENDIF


			*-------------------------------------------------*
			FCHvlr  = FCHvlr + precofinal
			FCHqtde = FCHqtde + qtde
			*-------------------------------------------------*
			m.comissiona=	""
		   	SELECT grupo
		    SET ORDER TO  TAG codigo
		    SEEK m.codigo

***>>PARA PROCESSO POR NAO ENCONTRAR PRODUTO
			IF !FOUND() AND LEFT(m.codigo,7) <> "0000009"
				wp_msg = "Emp["+STR(m.empresa,3)+"]"+;
				         "SAIDA No "+STR(m.orcamento,6)+" de "+;
						  DTOC(m.dt_inicio)+" ITEM=>"+m.codigo+;
						  " Nao identifcado"
				=UPbeeps(LFalerta,wp_msg)
				wp_flgfecha = .T.
				m.dt_inicio = m.dt_fim + 1	
				SELE itemimpo
				LOOP
			ENDIF			

			m.cfo        =  tipooper.cfo
			m.info_icms  =  tipooper.info_icms
			IF m.info_icms = "S"
				m.aliq_icms  = notaimpo.aliq_icm / 10
			ELSE
				m.aliq_icms  =  tipooper.aliq_icms
			ENDIF
			m.aliq_iss   =  empresa.aliq_iss
			m.info_vlr   =  tipooper.info_vlr
			m.info_base  =  tipooper.info_base
		*		CALCULO ENVOLVENDO IPI ==> ALIQ_IPI
			m.TMPipi   = notaimpo.vlr_ipi / 100
			m.vlr_ipi  = 0
			m.aliq_ipi = 0
			m.TMPmerc  = notaimpo.mercadoria / 100
			IF notaimpo.vlr_ipi > 0
				m.aliq_ipi = (m.TMPipi * 100) / m.TMPmerc
				m.vlr_ipi  = (m.vlrvenda * m.aliq_ipi) / 100
			ENDIF
		*
			IF LEFT(m.codigo,7) = "0000009"
				m.codigo     =  "99999999"
				m.classifica =  "99999999"
				m.descricao  =  " "
				m.tp_mercad  =  1
				m.movestq    =  "N"
				m.movvalor   =  "N"
				m.movcusto   =  "N"
				m.cst        = ""
				m.iva  		 =  0
			ELSE
				m.codigo     =  grupo.codigo
				m.descricao  =  LTRIM(grupo.descricao)
				m.classifica =  grupo.classifica
				m.origem     =  grupo.origem
				m.tp_mercad  =  grupo.tp_mercad
				m.movestq    =  tipooper.movestq
				m.movvalor   =  tipooper.movvalor
				m.movcusto   =  tipooper.movcusto
				m.iva  		 =  grupo.iva
			ENDIF
*>>>>>
			SELECT tab_cst
			SET ORDER TO TAG cst
			SEEK STR(m.tab_cst,2)+tipooper.tipo;
					+STR(m.tp_mercad,1)

			m.cst        =  RIGHT(tab_cst.cst,1)

		    IF cst = "2"	&& REDUZIR BASE DO ICMS
			    m.base_calc = ROUND(m.vlrvenda * empresa.reduz_base/100,2)
		    ELSE
	    	 	m.base_calc = m.vlrvenda
		    ENDIF

			m.desc_adici = 0
			LSid_chamada = "DADO PRECO FINAL (PRECOFINAL)"
			*----------------------------------------------------------*
			=W_DEFPROC("ORCAMENT.SPR")
			=ORcalc_vlres(m.preco,(m.qtde),m.DESCONTO,m.desc_adici,;
				(m.taxa),m.precofinal,m.vlrvenda,LSid_chamada)
			*----------------------------------------------------------*
			SELE orcatmp
			=edithand('SAVE')
			SELE itemimpo
			SKIP
			UNLOCK ALL
		ENDDO
		*---------------------------------------------------------
		* Gravar valor de Fechamento da OSI
		*---------------------------------------------------------
		SELE orcament
		=REGLOCK(.T.)
		REPLACE orcament.fecha WITH FCHvlr + (FCHqtde / 100)
		*---------------------------------------------------------
		SELE itemimpo

		*>>>>>>>>>>>>>>>>>     INICIO ATUALIZA CADASTRO CLIENTES
		IF  m.cliente > 0
			m.natureza		=	notaimpo.natu_cli + 1
			m.ult_atend		=	m.data
			m.status		=   1
			SELE clientes
			SET ORDER TO TAG cliente
			SEEK m.cliente
			IF FOUND() AND m.cliente > 0
				m.dtcad			= 	clientes.dtcad
				m.dt_alter 		=   m.data
				m.credito		=	clientes.credito
				=REGLOCK(.T.)
				=edithand('REGRAVA')
				REPLACE USRREGIS WITH 9999   &&  SISTEMA
			ELSE
				m.dtcad			= 	m.data
				m.dt_alter 		=   m.data
				m.credito		=	0
				=edithand('SAVE')
			ENDIF			
		ENDIF
*>>>>>>>>>>>>>>>>>     INICIO ATUALIZA CADASTRO FORNECEDORES
		IF  m.cliente > 0	AND m.ch_opera	= "4"
			SELE fornece
			SET ORDER TO TAG cgc
			SEEK m.cliente
			IF !FOUND()
				SET ORDER TO TAG codigo
				go bott
				m.codigo = fornece.codigo + 1
				m.pais   = "BRASIL"
				m.cgc 	 = m.cliente
				m.dt_alter 		=   m.data
				=edithand('SAVE')
			ENDIF			
		ENDIF
*>>>>>>>>>>>>>>>>>     FIM ATUALIZA CADASTRO FORNECEDORES
		IF 	wp_flgfecha = .T.
			=UPtransacao("ABORTAR")
			SKIP
			UNLOCK ALL
			LOOP
		ELSE
			=UPtransacao("TERMINAR")
		ENDIF
*-----------------   FINAL DO REGISTRO DA PRE NOTA
*-----------------   INICIO DO FATURAMENTO
************
		=UPtransacao("INICIAR")
************
		SELE orcament
		*---------------------------------------------------------*
		=W_DEFPROC("NOTA.SPR")
		wp_flgfecha = !NFrot_fat("IMPORTACAO","EFETIVAR FATURAMENTO")
		*---------------------------------------------------------*
		SELE notaimpo
*>>>>>>>>>>>>>>>>>     FINAL DO FATURAMENTO
		IF 	wp_flgfecha = .T.
			=UPtransacao("ABORTAR")
		ELSE
			=UPtransacao("TERMINAR")
		ENDIF
		SKIP
		UNLOCK ALL
	ENDDO
	=UP_fecha("notaimpo")
	=UP_fecha("itemimpo")
	=UP_fecha("cobrimpo")
	=UP_fecha("IDLNFS")
	=UP_fecha("IDLITNFS")

*****
	DO RELFIM.PRG          && FIM VAR P/ TERMOMETRO

RETURN

***********************************************************************
***********************************************************************
***********************************************************************

PROCEDURE ULconventrada
	wp_flgfecha = .F.
	IF ! NetUse("nfenimpo",.t.)
		wp_flgfecha = .t.  && implica no fechamento da secao
	ENDIF
	IF ! NetUse("itenimpo",.t.)
		wp_flgfecha = .t.  && implica no fechamento da secao
	ENDIF
	IF !FILE(LSnfetmp) OR !FILE(LSitemetmp) OR wp_flgfecha
		=UP_fecha("nfenimpo")
		=UP_fecha("itenimpo")
		RETURN
	ENDIF
*>>>>>>>>>>>>>>>>>>>>>>>>>>  LIMPEZA DO ARQUIVO
	LStmp  = sys(5)+sys(2003)  		&&  UNIDADE E DIRETORIO CORRENTES
	SET DEFA TO &wp_dirdat
	SELE nfenimpo
    USE nfenimpo EXCL
    COPY STRU TO tmp WITH CDX
    USE tmp EXCL
    COPY STRU TO nfenimpo WITH CDX
	USE
	SELE itenimpo
    USE itenimpo EXCL
    COPY STRU TO tmp WITH CDX
    USE tmp EXCL
    COPY STRU TO itenimpo WITH CDX
	USE
	SET DEFA TO &LStmp
*>>>>>>>>>>>>>>>>>>>>>>>>>>>
	IF ! NetUse("nfenimpo",.t.)
		wp_flgfecha = .t.  && implica no fechamento da secao
	ENDIF
	IF ! NetUse("itenimpo",.t.)
		wp_flgfecha = .t.  && implica no fechamento da secao
	ENDIF

	SELE nfenimpo
	ZAP
	PACK
	APPEND FROM &LSnfetmp TYPE SDF
	IF EOF()
		=UP_fecha("nfenimpo")
		=UP_fecha("itenimpo")
		RETURN
	ENDIF
	SELE itenimpo
	ZAP
	PACK
	APPEND FROM &LSitemetmp TYPE SDF
	SELE nfenimpo
*******************
*---->   (INICIALIZACAO DO CONTROLE DE STATUS IMPRESSAO)
*******************	
	DO RELINIC.PRG          && INICIA VAR P/ TERMOMETRO
	LFsegue = .t.
	LNregistro = RECNO()
	LNimpressao = RECCOUNT()
	LNimpressos = 0
	GO LNregistro
*******************
	GO TOP
	m.msg_acomp = "Importa Entradas     "
	SHOW GET m.msg_acomp
	m.contador = 0
	SHOW GET m.contador
	
	DO WHILE !EOF() AND !wp_flgfecha  AND LFsegue
		wp_msg = "IMP. ENTRADAS [Emp.: "+STR(m.empresa,3)+ " ]"+;
										DTOC(m.dt_inicio)
		=UPtermo()
		************
		=UPtransacao("INICIAR")
		************

		*>>>> INICIO CONVERSAO P/ ORCAMENT ou OUTROPER <<<<*

		m.empresa 		= 	nfenimpo.filial
		m.nota			=   nfenimpo.nota
		m.referencia	=   nfenimpo.nota
		********************************************************
		IF LEFT(nfenimpo.serie,1) = "U"
			m.serie	= LEFT(nfenimpo.serie,1)
		ELSE
			m.serie			=   STR(INT(VAL(nfenimpo.serie)),1)
			IF m.serie  = " "
				m.serie = "0"
			ENDIF
		ENDIF
		********************************************************

		LDTtmp			= (SUBS(nfenimpo.dt_entrada,1,2)+"."+;
								 SUBS(nfenimpo.dt_entrada,3,2)+"."+;
								 SUBS(nfenimpo.dt_entrada,5,2))
		IF LDTtmp		= "29.02.00"
			LDTtmp	= {29.02.2000}
		ELSE
			LDTtmp	= CTOD(LDTtmp)
		ENDIF								

	 	m.data_emi  	=	UPValData(LDTtmp)  && bug 20000

		LDTtmp			= (SUBS(nfenimpo.dt_emi,1,2)+"."+;
								 SUBS(nfenimpo.dt_emi,3,2)+"."+;
								 SUBS(nfenimpo.dt_emi,5,2))
		IF LDTtmp		= "29.02.00"
			LDTtmp	= ctod("29.02.2000")
		ELSE
			LDTtmp	= CTOD(LDTtmp)
		ENDIF								


		IF  LDTtmp < date() - 20
		   DO OBJ_MENS.SPR WITH ;
			   "Nao e autorizado Importacao de Documentos Com "+;
			   " Mais de 20 dias da data de hoje." + ;
			   "  Doc : "+str(m.nota,6)
			SELE nfenimpo
			SKIP
			LOOP
		ENDIF

	 	m.data  	=	UPValData(LDTtmp)  && bug 20000




		m.hora			=   SPACE(8)		
		m.tipo			=   nfenimpo.tipo
*-----> CONVERSAO DO TIPO
		DO CASE
			CASE m.tipo = "CTF"
				m.tipo	= "CLJ"
			CASE m.tipo = "CTR"
				m.tipo	= "CFJ"
			CASE m.tipo = "CME"
				m.tipo	= "CLB"
			CASE m.tipo = "CMI"
				m.tipo	= "CFB"
			CASE m.tipo = "CEV"
				m.tipo	= "CLA"
			CASE m.tipo = "CIV"
				m.tipo	= "CFA"
			CASE m.tipo = "NFC"
				m.tipo	= "CFI"
			CASE m.tipo = "CCE"
				m.tipo	= "CLD"
			CASE m.tipo = "CCI"
				m.tipo	= "CFD"
			CASE m.tipo = "CCV"
				m.tipo	= "CLC"
			CASE m.tipo = "CCP"
				m.tipo	= "CFC"
			CASE m.tipo = "CTE"
				m.tipo	= "CLH"
			CASE m.tipo = "CTI"
				m.tipo	= "CFH"
			CASE m.tipo = "CTV"
				m.tipo	= "CLG"
			CASE m.tipo = "CMV"
				m.tipo	= "CFG"
			CASE m.tipo = "CAE"
				m.tipo	= "CLF"
			CASE m.tipo = "CAI"
				m.tipo	= "CFF"
			CASE m.tipo = "CAV"
				m.tipo	= "CLE"
			CASE m.tipo = "CAP"
				m.tipo	= "CFE"
			CASE m.tipo = "TME"
				m.tipo	= "TAA"
			CASE m.tipo = "TMI"
				m.tipo	= "TBA"
			CASE m.tipo = "TIE"
				m.tipo	= "TAA"
			CASE m.tipo = "TII"
				m.tipo	= "TBA"
			CASE m.tipo = "TMR"
				m.tipo	= "TAA"
			CASE m.tipo = "TAE"
				m.tipo	= "TAB"
			CASE m.tipo = "TAI"
				m.tipo	= "TBB"
			CASE m.tipo = "TCI"
				m.tipo	= "TAC"
			CASE m.tipo = "TCT"
				m.tipo	= "TBD"
			CASE m.tipo = "TIC"
				m.tipo	= "TBC"
			CASE m.tipo = "CTF"
				m.tipo	= "TAE"
			CASE m.tipo = "DME"
				m.tipo	= "DAA"
			CASE m.tipo = "DMI"
				m.tipo	= "DBA"
			CASE m.tipo = "DIE"
				m.tipo	= "DAA"
			CASE m.tipo = "DII"
				m.tipo	= "DBA"
			CASE m.tipo = "CIM"
				m.tipo	= "CIA"
			CASE m.tipo = "OIR" OR m.tipo = "OEI"
				m.tipo	= "RBE"
			CASE m.tipo = "ORI"
				m.tipo	= "RBC"
*---REQUISICOES
			CASE m.tipo = "ORP"	&& ENTRADA PRODUCAO IDL
				m.tipo	= "QLB"	

				* Adequacao de numero para evitar duplicacao
				* pois o sistema antigo gera n. iguais em meses diferentes
				* ddmmas  => dd=dia, mm=mes, a=final do ano, s=sequencia
				
				lNftmp	=	STRTRAN(STR(m.nota,6)," ","0")
				lNftmp2 =   SUBS(nfenimpo.dt_emi,1,2)+;
							SUBS(nfenimpo.dt_emi,3,2)+;
							SUBS(nfenimpo.dt_emi,6,1)+;
							SUBS(lNftmp,6,1)

				m.nota		=   VAL(lNftmp2)
				m.referencia=   m.nota

*---REQUISICOES
			CASE m.tipo = "CRC"	&& ENTRADA PRODUCAO IDL
				m.tipo	= "OCE"	
*---REQUISICOES
			CASE m.tipo = "AIE"
				m.tipo	= "QLA"
*---REQUISICOES DE SAIDA
			CASE m.tipo = "OSI" OR m.tipo = "OFI" OR m.tipo = "AIS"
				m.tipo	= "SCA"
		ENDCASE
**************** NOTAS CANCELADAS E NOTAS DE ENTRADA ***************
		IF m.tipo = "CAN" OR  m.tipo = "ENT"   && AND m.ch_opera <> "5")
			SELE nota
			SET ORDER TO TAG nota
			SEEK STR(m.empresa,3)+STR(m.nota,7)
			IF FOUND()
				=REGLOCK(.T.)
				REPLACE tipo with m.tipo
			ELSE
			   =edithand('SAVE')
			ENDIF
			SELE nfenimpo
			SKIP
************
			=UPtransacao("TERMINAR")
************
			LOOP
		ENDIF
********************************************************************
*-----> FIM CONVERSAO DO TIPO
		SELE tipooper
		SET ORDER TO TAG tipo
		IF m.tipo = "SCA"
			SEEK "s"+m.tipo
			IF !FOUND()
				SEEK "S"+m.tipo
			ENDIF
		ELSE
			SEEK "e"+m.tipo
			IF !FOUND()
				SEEK "E"+m.tipo
			ENDIF
		ENDIF
	    SCATTER FIELDS ch_opera, ch_produ, ch_motiv, ch_desti,;
		    		 ch_contr, ch_condi, cfo  MEMVAR  MEMO

***>>PARA PROCESSO POR NAO ENCONTRAR CLASSIFICACAO
		IF !FOUND()
			wp_msg = "Emp["+STR(m.empresa,3)+"]"+;
			         "ENTRADA No "+STR(m.referencia,6)+" de "+;
					  DTOC(m.dt_inicio)+" TIPO=>"+m.tipo+;
					  " Nao identifcado"
			=UPbeeps(LFalerta,wp_msg)
			wp_flgfecha = .T.
			m.dt_inicio = m.dt_fim + 1	
			SELE nfenimpo
************
			=UPtransacao("ABORTAR")
************
			LOOP
		ENDIF			
		SELE fornece
		SET ORDER TO TAG codigo
		SEEK nfenimpo.fornece
		m.favorecido 	= 	fornece.cgc		
		m.codforn		=   nfenimpo.fornece
		m.pedido 		=	0
********************************************************************
*<<<<<<<<<<<<< ALTERADO P/ ATENDER SITUACOES CRIADAS PELO TRANSITO
*
*		SELE notaent
*		SET ORDER TO TAG nota
*		SEEK STR(m.empresa,3)+STR(m.codforn,5)+STR(m.nota,6)+;
*				m.serie+LEFT(m.tipo,1)
********************************************************************
		SELE notaent
		SET ORDER TO TAG boletim
		SEEK STR(m.empresa,3)+STR(m.referencia,6)+STR(m.codforn,5)

		IF FOUND()
			IF LEFT(notaent.situacao,1) $ "A")
			   DO OBJ_ALER.SPR WITH ;
			   "Documento ja importado e NAO FATURADO. " + ;
			   "Apague o registro para processeguir IMPORTACAO."+ ;
			   " Doc : "+m.tipo+"  "+str(m.nota,6)+"Forn: "+STR(m.codforn,5)
				wp_flgfecha = .t.   				
			ENDIF
			IF notaent.data <> m.data
			   DO OBJ_ALER.SPR WITH ;
			   "Documento com Numero Duplicado em Datas Distintas. " + ;
			   "Verifiqu Docs."+ ;
			   " Doc : "+m.tipo+"  "+str(m.nota,6)+"Forn: "+STR(m.codforn,5)
				wp_flgfecha = .t.   				
			ENDIF

			IF LEFT(notaent.situacao,1) $ "AC")
				SELE nfenimpo
				=UPtransacao("ABORTAR")
				SKIP
				LOOP
			ENDIF
			m.pedido = notaent.pedido	&&ENCONTROU FAX DIGITADO
		ENDIF
*------->>>>>>>>>>>>    CAMPOS COM CORRESPONDENCIA DIRETA >>>>>>>>		
		m.nome 			= 	fornece.nome
		m.uf			= 	fornece.estado
		m.pais			= 	fornece.pais
		m.endereco		=	fornece.endereco
		m.bairro		=	fornece.bairro
		m.cidade		=	fornece.cidade
		m.cep			=	fornece.cep
		m.fone			= 	fornece.fone
		m.tp_pessoa		=	fornece.tp_pessoa
		m.tp_inscr		=	fornece.tp_inscr
		m.inscricao		=	fornece.inscricao
*************************************************************************
*-->>>>     VALORES ATRIBUIDOS NO FINAL DA CONV. DOS ITENS  	  <<<<--*
*************************************************************************
		m.base_icms		=	0
		m.aliq_icms		=	0
		m.vlr_icms		=	0
		m.base_outr		=	0
		m.base_isent	=	0
		m.base_subs		=	0
		m.icms_subs		=	0
		m.vlrfrete		=	0
		m.vlrseguro		=	0
		m.vlrdespes		=	0
***********************************************************************
		m.situacao		= 	"BB"   && APROVADO e LIBERADO
		m.status 		=	1
		m.tipo_nota		=	nfenimpo.tipo_nota

		m.vlr_icms		=	nfenimpo.vlr_icm   / 100
		m.icms_subs		=	nfenimpo.retido / 100
		m.cst 			=	""

 		DO CASE
			CASE m.icms_subs > 0
				m.cst			=   "2"    && SEM ICMS e C/ RETENCAO
 		 	CASE m.tipo_nota = 0 OR m.tipo_nota = 1 OR m.tipo_nota = 4
				 m.cst		  	=   "1"    && TRIBUTADA
 		 	CASE m.tipo_nota = 2 OR m.tipo_nota = 5 OR m.tipo_nota = 6
				 m.cst		  	=   "5"    && ISENTAS SEM TRIBU
			OTHERWISE
				m.cst			=   "4"    &&  OUTROS TRIBUTOS
 		ENDCASE
 		m.vlr_icms		=	0
 		m.icms_subs		=	0
		m.vlr_icms		=	nfenimpo.vlr_icm   / 100
		m.icms_subs		=	nfenimpo.retido / 100

		m.natureza      =  tipooper.descnatu
*------->>>>>>>>>>>>    CAMPOS COM CONVERCAO P/ NOVAS CONDICOES >>>>>>>>		

*>>>>>>>>>> OPERACOES EPCIFICAS POR OPERACAO ex: COMPRA/TRANS/DEV/REMS..	
		m.motivo = 0
		IF m.ch_condi = "1"
			m.condicao = 1
		ELSE
			m.condicao = 2
		ENDIF
***************
		IF m.tipo = "SCA"
			m.natu_oper   = 6
		ELSE
			m.natu_oper   = INT(VAL(m.ch_opera))
		ENDIF
**************
		DO CASE
			CASE m.ch_opera	= "1"		&& COMPRA
				DO ULopecompra
			CASE m.ch_opera	= "2"		&& TRANSF
				DO ULope_etransf
			CASE m.ch_opera	= "3"		&& REMSSS
				DO ULope_eremessa
			CASE m.ch_opera	= "4"		&& DEVOLUCAO
				DO ULope_edevol
		ENDCASE		
*>>>>>>>>>>>>>>>>>     FIM CONVERSAO P/ ORCAMENT ou OUTROPER
      							*********
*>>>>>>>>>>>>>>>>>     INICIO CONVERSAO DE ITENS P/ ORCATMP
************************************
	     m.valor     = 0
		 m.LNqtde    = 0 	&& soma das qtdes
		 m.LNbs_ipi  = 0         && base para calculo ipi
		 m.LNbs_icms = 0         && base para calculo icms
		 m.LNbs_subs = 0	     && base para calculo subs
	     m.LNbs_sbbrt= 0	     && base para abater icms do icms da subs
		 m.LNbs_iss  = 0        && base para calculo iss
		 m.LNbs_isen = 0        && mercadorias isentas
		 m.LNbs_outr = 0        && outras tributacoes
		 m.LNalqicms = 0		&& aliquota de icms
		 m.LNalqiss  = 0		&& aliquota de iss
		 m.LNicms 	 = 0		&& valor de icms
		 m.LNsubs 	 = 0		&& valor de icms por substituicao
		 m.LNiss  	 = 0		&& valor de iss
		 m.LNtotprod = 0		&& soma dos valores dos produtos
		 m.LNtot  	 = 0		&& total da nota

		m.ordem 	 = 0   &&  p/ diferenciar codigo com + de um movimento
*****
		SELE itenimpo
		SET ORDER TO TAG nota
		SEEK STR(nfenimpo.fornece,4)+STR(nfenimpo.nota,6)
		DO WHILE !EOF() AND nfenimpo.nota = itenimpo.nota ;
						AND nfenimpo.fornece = itenimpo.forn ;
						AND	!wp_flgfecha
*******************************************************************
			m.aliq_icms	=	nfenimpo.aliq_icms / 10
			m.ordem 	=	m.ordem + 1
			m.orcamento	=	m.nota
			m.codigo 	=	LEFT(itenimpo.codigo,7)
			m.codigo	=   ALLTRIM(m.codigo)+UPCALCDIG(m.codigo)
			m.qtde  	=	itenimpo.qtde

			m.preco		=	itenimpo.vlr_uni / 100
			m.vlripi	=	itenimpo.ipi / 100
          *--==============================>>> CALC. VALOR VENDA
 			m.vlrvenda   =  itenimpo.vlr_uni / 100
            m.base_calc  =  m.vlrvenda
          *--==============================>>> CALC. VALOR VENDA
			m.desconto = 0
		  *----------------------------------------------------------
			m.comissiona=	""
		   	SELECT grupo
		    SET ORDER TO  TAG codigo
		    SEEK m.codigo
***>>PARA PROCESSO POR NAO ENCONTRAR PRODUTO
			IF !FOUND() AND LEFT(m.codigo,7) <> "0000009"
				wp_msg = "Emp["+STR(m.empresa,3)+"]"+;
				         "ENTRADA No "+STR(m.referencia,6)+" de "+;
						  DTOC(m.dt_inicio)+" ITEM=>"+m.codigo+;
						  " Nao identifcado"
				=UPbeeps(LFalerta,wp_msg)
				wp_flgfecha = .T.
				m.dt_inicio = m.dt_fim + 1	
				SELE itenimpo
				LOOP
			ENDIF			
			IF LEFT(m.codigo,7) = "0000009"
				m.codigo     =  "99999999"
				m.classifica =  "99999999"
				m.descricao  =  " "
				m.tp_mercad  =  1
 	            m.movfin     =  "N"

				m.movestq    =  "N"
				m.movvalor   =  "N"
				m.movcusto   =  "N"

				m.cfo        =  tipooper.cfo
				m.info_icms  =  tipooper.info_icms
				m.aliq_iss   =  empresa.aliq_iss
				m.info_vlr   =  tipooper.info_vlr
				m.info_base  =  tipooper.info_base
				m.iva  		 =  0
			ELSE
				m.codigo     =  grupo.codigo
				m.descricao  =  LTRIM(grupo.descricao)
				m.classifica =  grupo.classifica
				m.origem     =  grupo.origem
				m.tp_mercad  =  grupo.tp_mercad
				m.movestq    =  tipooper.movestq
 	            m.movfin     =  tipooper.info_vlr

				m.movestq    =  tipooper.movestq
				m.movvalor   =  tipooper.movvalor
				m.movcusto   =  tipooper.movcusto

				m.cfo        =  tipooper.cfo
				m.info_icms  =  tipooper.info_icms
				m.aliq_iss   =  empresa.aliq_iss
				m.info_vlr   =  tipooper.info_vlr
				m.info_base  =  tipooper.info_base
				m.iva  		 =  grupo.iva
			ENDIF
			SELE notaite

			SELE notaite
			SET ORDER TO TAG chv_bkp
			SEEK STR(m.empresa,3)+STR(m.favorecido,14)+;
				 STR(m.orcamento,6)+STR(m.ordem,2)
			IF FOUND()	&& ENCONTRO ITEM DO FAX DIGITADO
				=edithand('REGRAVA')
			ELSE
				=edithand('SAVE')
			ENDIF
			do UPimpent     && CALCULO DOS VALORES FISCAIS
			SELE itenimpo
			SKIP
			UNLOCK ALL
		ENDDO
		IF 	wp_flgfecha = .T.
			=UPtransacao("ABORTAR")
 			SKIP
			UNLOCK ALL
			LOOP
		ENDIF
		SELE notaent
		m.vlrfrete		=	nfenimpo.CONHECI / 100
		m.vlrseguro		=	0
		m.vlrdespes		=	0

		m.totproduto 	= m.LNtotprod
		m.vlr_ipi		= m.LNbs_ipi
		m.base_outr 	= m.LNbs_outr
		m.base_sbbrt	= m.LNbs_sbbrt
		m.base_icms		= nfenimpo.base_calc / 100
		m.vlr_icms		= nfenimpo.vlr_icm / 100
		IF m.vlr_icms   = 0
			m.base_icms =  0	&& FORCA PARA O VALOR DA BASE IR PARA
								&&  ISENTAS		
		ENDIF
		m.base_subs	    = nfenimpo.base_retid / 100
		m.icms_subs		= nfenimpo.retido / 100
		m.total_nota =  m.totproduto + m.vlr_ipi + ;
						m.icms_subs +  m.vlrdespes
		m.base_isent	= m.total_nota - m.base_icms - ;
					  m.base_outr - m.icms_subs

		DO case

			CASE m.ch_opera $ "12" AND  m.icms_subs > 0
					m.base_isent = m.base_icms
			CASE m.ch_opera $ "12"  AND m.ch_produ = "1" AND ;
				 m.aliq_icms = 0 	AND  m.icms_subs = 0
				 	m.base_isent = m.totproduto
				 	m.base_icms  = 0
			CASE m.ch_opera $ "12"  AND m.ch_produ = "1" AND m.aliq_icms > 0
				 m.base_isent = m.totproduto - m.base_icms
			CASE m.ch_opera $ "2"  AND m.ch_desti = "1"	AND ;
				 m.ch_produ = "1"  AND m.aliq_icms = 0
				 	m.base_isent = m.totproduto
					m.base_icms  = 0
			CASE m.ch_opera $ "4"  AND m.ch_produ = "1"  AND m.aliq_icms = 0
				 	m.base_isent = m.totproduto
				 	m.base_icms  = 0
			CASE m.ch_opera $ "12"  AND m.ch_produ $ "56"
	    			m.aliq_icms  = 0
					m.base_isent = 0
					m.base_icms  = 0
					m.base_outr  = m.totproduto + m.vlr_ipi
		ENDCASE
		IF m.empresa = 10
			m.base_outr 	= m.base_outr + m.base_isent
			m.base_isent	= 0
		ENDIF

		******************  VALOR PARA FECHAMENTO ********************
		m.soma_qtde  = (m.LNqtde/100) + m.totproduto + m.vlr_ipi ;
			+  m.vlr_icms + m.base_subs	+  m.icms_subs	;
			+  m.vlrfrete + m.vlrseguro + m.vlrdespes
		***************************************************************

		SELE notaent
		IF FOUND()
			=edithand('REGRAVA')
		ELSE
			=edithand('SAVE')
		ENDIF

		=UPtransacao("TERMINAR")
*-----------------   FINAL DO REGISTRO DA PRE NOTA
*-----------------   INICIO DO FATURAMENTO
************
		=UPtransacao("INICIAR")
************

		SELE notaent
		DO SCGCF211.PRG
*>>>>>>>>>>>>>>>>>     FINAL DO FATURAMENTO
		IF 	wp_flgfecha = .T.
			=UPtransacao("ABORTAR")
		ELSE
			=UPtransacao("TERMINAR")
		ENDIF
*-----------------
		SELE nfenimpo
		SKIP
		UNLOCK ALL
	ENDDO
	=UP_fecha("nfenimpo")
	=UP_fecha("itenimpo")
*****
	DO RELFIM.PRG          && FIM VAR P/ TERMOMETRO

RETURN
