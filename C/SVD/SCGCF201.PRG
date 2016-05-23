
*****************************************************************
* 				Inicio Verificacao de Requisitos				*
*****************************************************************
*****************************************************************
* 				Inicio Verificacao de Requisitos				*
*****************************************************************

SELE clientes
SET ORDER TO TAG cliente
SEEK m.cliente
IF m.tp_pgto = 3 AND (m.cliente = 0 OR !FOUND())
	WAIT WINDOW "Cliente deve ser Cadastrado . Execute <Cadastro> "
   WAIT WINDOW m.tipo+" "+"Saida "+STR(m.orcamento,6)+" nao bloqueado p/ proc."
   wp_flgfecha = .t.
   SELE orcament
   RETURN
ENDIF

*===============>>>>>  funciona como um sinaleiro
SELECT empresa
SELE empresa
SET ORDER TO TAG empresa
SEEK m.empresa				&& EMPRESA OPERADORA DO SISTEMA
IF !FOUND()
   WAIT WINDOW ;
   	" Recadastrar a Empresa Gereciadora do Sistema <Suporte Sistema>"
   WAIT WINDOW m.tipo+" "+"Saida "+STR(m.orcamento,6)+" nao bloqueado p/ proc."
   wp_flgfecha = .t.
   SELE orcament
   RETURN
ENDIF

SELE orcament
IF !REGLOCK()
   WAIT WINDOW m.tipo+" "+"Saida "+STR(m.orcamento,6)+" nao bloqueado p/ proc."
   wp_flgfecha = .t.
   RETURN
ENDIF
*****************************************************************
* 				Fim Verificacao de Requisitos					*
*****************************************************************
*****************************************************************
* 				Inicio Informacoes Complementares
*****************************************************************
SELE tipooper
SET ORDER TO TAG tipo
SEEK 's'+m.tipo
IF !FOUND()
	SEEK 'S'+m.tipo  
ENDIF
IF !FOUND()
   WAIT WINDOW m.tipo+" "+"Saida "+STR(m.orcamento,6)+" tipo nao Classificado."
   SELE orcament
   wp_flgfecha = .t.
   RETURN
ENDIF
******************************************************************
m.mens1 	= 	" "
m.mens2 	=   " "
SELE tab_cita
SEEK empresa.estado+STR(tipooper.citacao,2)
*****************************************************************
* 				Fim Informacoes Complementares
*****************************************************************
*****************************************************************
* 				Inicio Verificacao Previa dos Itens
*****************************************************************


SELECT  orcatmp
SET ORDER TO TAG orcamento
SEEK STR(wp_empresa,3)+LEFT(m.tipo,1)+STR(m.orcamento,6)
LFflgtrans = .t.
IF !FOUND()
	LFflgtrans = .F.
ENDIF
LNiteminicio = RECNO()


m.datanf		= orcament.dt_fat    && REGISTRA A DATA DA GERACAO DA NF
m.horanf		= orcament.hora_fat  && REGISTRA A HORA - nao inf. impor

DO WHILE !eof() AND m.orcamento = orcamento AND wp_empresa = EMPRESA ;
				AND LEFT(m.tipo,1) = LEFT(tipo,1)

		***  NAO PROCESSAR ITENS CANCELADOS, ALEM DO FECHAMENTO

		IF LEFT(orcatmp.situacao,1) $ "Yyke"
			SKIP
			LOOP
		ENDIF

		*********************************************************
		*  A situacao O indica que o item ja foi faturado 
		*  A permissao de reprocessar visa corrigir problemas por
		*  interrupcao de faturamento anterior (TRANSACAO)
		**********************************************************

		IF  FOUND("TAB_CITA") AND ;
			!EMPTY(ALLTRIM(orcatmp.cst)) AND ;
			orcatmp.cst $ tipooper.citaremcst
			m.mens2 	= ALLTRIM(tab_cita.texto1)
		ENDIF
	    IF !(LEFT(orcatmp.situacao,1) $ "A") 
			LFflgtrans = .F.
			EXIT
		ENDIF
	   	
		*----------------------------------------------------------*
	   	PRIVATE LFlockReg
   		PRIVATE LFabreAuto
		PRIVATE LNJaReserv	
	   	LFlockReg	= .T.	&& BLOQUEAR REGISTRO
    	LFabreAuto	= .T. 	&& ABRIR CONTROLE AUTOMATICAMENTE
		LNJaReserv	= 0		&& QTDE JA RESERVADA DESTE ITEM NESTE DOC
		=W_DEFPROC("ESTOQUE.SPR")
		IF !ESversaldo(orcatmp.empresa,orcatmp.codigo ,;
					orcatmp.classifica , orcament.dt_fat,;
					orcatmp.qtde,LNJaReserv,LFabreAuto, LFlockReg,"SAIDA",;
					orcament.hora_fat,orcatmp.movestq)
			LFflgtrans = .F.
			EXIT
	   	ENDIF
		*----------------------------------------------------------*
		SELE orcatmp
		SKIP
ENDDO
IF !LFflgtrans
   WAIT WINDOW m.tipo+" "+"Saida "+STR(m.orcamento,6)+" itens irregulares."
   SELE orcament
   wp_flgfecha = .t.
   RETURN
ENDIF
*****************************************************************
* 				Fim Verificacao Previa dos Itens
*****************************************************************
*****************************************************************
* 				Inicio  ---- F A T U R A M E N T O  ----
*****************************************************************
SELE empresa
SET ORDER TO TAG empresa

m.serie 		=	"U"
m.referencia 	= 	m.orcamento
m.cgc_emit		= 	empresa.cgc
LTmp        	=   "empresa.insc_"+empresa.estado
m.insc_emit		= 	&LTmp
m.insc_muni 	=	empresa.insc_munic
m.uf			=	m.estado
m.favorecido	=	m.cliente
SELE clientes
SET ORDER TO TAG cliente
SEEK m.cliente

IF FOUND() AND m.cliente > 0
	m.nome		=	clientes.nome
	m.tp_pessoa = 	clientes.tp_pessoa
	m.endereco	=	clientes.endereco
	m.bairro	=	clientes.bairro
	m.cidade	=	clientes.cidade
	m.cep		=	clientes.cep
	m.fone		=	clientes.fone
	m.uf		=	clientes.estado
	m.tp_inscr	= 	clientes.tp_inscr
	m.inscricao	=	clientes.inscricao
	***************************
	=REGLOCK(.T.)
	SET FIELDS TO dtregis, hregis, usrregis,deletado, ult_atend
	m.ult_atend =  wp_dtoper
	=edithand('REGRAVA')
	SET FIELDS OFF
	***************************
ENDIF

m.inscsubst	= 	empresa.insc_&uf
m.aliq_iss	= 	empresa.aliq_iss
m.natureza	=	tipooper.descnatu
m.cod_cita	=	tipooper.citacao
IF !EMPTY(ALLTRIM(m.mens2))
	m.citacao 	= 	m.mens2
ELSE
	m.citacao 	= 	" "
ENDIF

SELECT  orcatmp
SET ORDER TO TAG orcamento
SEEK STR(m.empresa,3)+LEFT(m.tipo,1)+STR(m.orcamento,6)

*********** SINALEIRO PARA NUMERO DA NOTA FISCAL 
SELECT empresa
IF !REGLOCK()
   WAIT WINDOW "Nao foi possivel bloquear reg. Empresa p/ parametros"
   WAIT WINDOW m.tipo+" "+"Saida "+STR(m.orcamento,6)+" itens irregulares."
   SELE orcament
   wp_flgfecha = .t.
   RETURN
ENDIF

m.datanf		= orcament.dt_fat    && REGISTRA A DATA DA GERACAO DA NF
m.horanf		= orcament.hora_fat  && REGISTRA A HORA - nao inf. impor

LNnroNF    		= orcament.nota - 1
LNcupom			= orcament.cupom
LNnfinicio      = LNnroNF + 1 
LNnffim 		= LNnroNF + 1
m.doc_cobr 		= LNnroNF + 1

SELE nota 
SEEK STR(m.empresa,3)+STR(LNnroNF+1,7)
IF FOUND()
   WAIT WINDOW m.tipo+" "+"Saida "+STR(m.orcamento,7)+" duplicado na NF."
   SELE orcament
   UNLOCK ALL
   wp_flgfecha = .t.
   RETURN
ENDIF
SELE orcatmp
LFflgtrans = .t.

m.tmp_aliq_icms	= orcatmp.aliq_icms

m.LNalqicms 	= 0		&& aliquota de icms
m.tot_fatura 	= 0		&& acumula valore de varias notas pra duplicatas
*---------------------------------------------------------*
=W_DEFPROC("NOTA.SPR")
IF !NFFatura(orcament.empresa,orcament.orcamento,(LNnroNF),(LNcupom),;
		"REC.NOTA/CUPOM",(m.datanf),(m.horanf),"FATURISTA SIMPLES",LNnffim)
    WAIT WINDOW m.tipo+" "+"Saida "+STR(orcament.orcamento,6)+" Faturamento Interrompido."
	UNLOCK ALL
	SELE ORCAMENT
    wp_flgfecha = .t.
	RETURN
ENDIF			
************
IF M.NATU_OPER = 1
	*----------------------------------------------------------------*
	=W_DEFPROC("DUPLICAT.SPR")
	DO  CRgeradupl WITH ;
			(orcament.empresa),(orcament.tp_pgto),(orcament.banco),;
			(orcament.vlr_ent),(orcament.prazo),(nota.data),;
			(empresa.multa),(empresa.mora),(empresa.bonus),;
			(empresa.prem_pont),(orcament.regiao),(orcament.natu_cli),;
			(orcament.nome),(orcament.valor),(m.LNnfinicio) ,"GRAVAR DUP"	
	*----------------------------------------------------------------*
ENDIF
************
SELECT orcament
REPLACE situacao WITH "OC"		&& FATURAMENTO DIRETO
***************************
SET FIELDS TO dtregis, hregis, usrregis,deletado
=edithand('REGRAVA')
CLEAR FIELDS
SET FIELDS OFF
************************************

************************************
UNLOCK ALL
SELECT orcament
RETURN
*****************************************************************
* 				Fim  ---- F A T U R A M E N T O  ----
*****************************************************************


