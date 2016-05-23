






PARAMETERS LSprograma
#DEFINE C_DELREC		'Apagar Registro Selecionado ?'
****************************  
****************************>>>> INICIO CONTROLE AMBIENTAL
****************************
PRIVATE wp_flgfecha, LF0012, LF0022
***********************************************
wp_flgfecha = 	.F. 		&& defaut nao fechamento da secao
********************
********************>>>>>> ABERTURA DE ARQ. GENERICOS
********************

PRIVATE LFgrfiscal,LFempresa,LFtipooper,LFtab_cita,LFparametr,LFtppgto
PRIVATE LFtab_cst,LFsaldo,LFitemmov,LFitmanexo,LFgrupo,LFprod_cms
PRIVATE LFtab001,LFtab002,LFtransprt,LFbanco,LFpedido,LFpedite,LFregiao
PRIVATE LFtabnbm,LFclasnbm, LFusuario  	

PRIVATE LFclientes,LFclienc,LForcament,LForc_anex,LForcatmp,LFnota
PRIVATE LFnf_anexo,LFpreco,LFduplicat

PRIVATE LFfornece,LFnota,LFnotaent,LFnotaite
PRIVATE LFliberacoes,LFobs_orca


STORE 0 TO  LFclientes,LFclienc,LForcament,LForc_anex,LForcatmp,LFnota
STORE 0 TO  LFnf_anexo,LFpreco,LFduplicat,LFliberacoes,LFobs_orca

STORE 0 TO  LFfornece,LFnota,LFnotaent,LFnotaite




LFgrfiscal 	= NetArq("grfiscal") 
LFempresa  	= NetArq("empresa") 
LFtipooper 	= NetArq("tipooper") 
LFtab_cita 	= NetArq("tab_cita") 
LFparametr 	= NetArq("parametr") 
LFtppgto   	= NetArq("tppgto") 
LFtab_cst  	= NetArq("tab_cst") 
LFsaldo  	= NetArq("saldo") 
LFitemmov  	= NetArq("itemmov") 
LFitmanexo 	= NetArq("itmanexo") 
LFgrupo    	= NetArq("grupo") 
LFprod_cms 	= NetArq("prod_cms") 
LFtab001   	= NetArq("tab001") 
LFtab002   	= NetArq("tab002") 
LFtransprt 	= NetArq("transprt") 
LFbanco    	= NetArq("banco") 
LFpedido   	= NetArq("pedido") 
LFpedite   	= NetArq("pedite") 
LFregiao   	= NetArq("regiao") 
LFtabnbm   	= NetArq("tabnbm") 
LFclasnbm  	= NetArq("clasnbm") 
LFusuario  	= NetArq("usuario") 

IF (LFgrfiscal+LFempresa+LFtipooper+LFtab_cita+LFparametr+LFtppgto) > 100000 
	DO ULfecha
	RETURN(.f.)
ENDIF

IF (LFtab_cst+LFsaldo+LFitemmov+LFitmanexo+LFgrupo+LFprod_cms) > 100000
	DO ULfecha
	RETURN(.f.)
ENDIF

IF (LFtab001+LFtab002+LFtransprt+LFbanco+LFpedido+LFpedite+LFregiao) > 100000
	DO ULfecha
	RETURN(.f.)
ENDIF

IF (LFtabnbm+LFclasnbm+ LFusuario) > 100000
	DO ULfecha
	RETURN(.f.)
ENDIF


**********************************************************************
*******************  CHAMADA DO PROGRAMA SOLICITADO ******************
**********************************************************************
ON KEY LABEL CTRL-F8		DO UPprotege
*--------------------------------------------------------------*
*  LSprograma  Parametro de chamada das vendas que indica a forma 
* de operacao do sistema
*	EX: DO SVD2.PRG  WITH "FAT. SEM RESERVA"
*
*		LSprograma = "FAT. SEM RESERVA" (FATURISTA COMANDA FATURAMENTO) 
*		LSprograma = "FAT. COM RESERVA" (VENDEDOR COMANDA RESERVA 
*										e FATURISTA COMANDA	FATURAMENTO)
*		LSprograma = "BALCAO"			(VENDEDOR COMANDA RESERV/EMITE OSI
*										 /ENV P/ FAT e CAIXA COMANDA FATURA)
*--------------------------------------------------------------*
wl_vendedor 	=  nUsr   && contem o codigo do vendedor atual


DO CASE 
	CASE LSprograma = "CAIXA"
		IF ULarqvenda()
			DO OBJ_ECF2.spr WITH "CAIXA"
		ENDIF
		=ULfchvenda()

	CASE LSprograma = "CAIXA NOVO"
		IF ULarqvenda()
			DO OBJ_ECF3.spr WITH "CAIXA"
		ENDIF
		=ULfchvenda()



	CASE LSprograma = "CAIXA OUTRAS"
		IF ULarqvenda()
			DO OBJ_ECF4.spr WITH "CAIXA"
		ENDIF
		=ULfchvenda()



	CASE LSprograma = "NOTA"
		IF ULarqvenda()
			DO SCGC202.SPR
		ENDIF
		=ULfchvenda()
	***********************************   ENTRADAS
	CASE LSprograma = "COMPRA"
		IF ULarqcompra()
			DO SCGC210.SPR
		ENDIF
		=ULfchcompra()
	CASE LSprograma = "ENOTA"
		IF ULarqcompra()
			DO SCGC216.SPR
		ENDIF
		=ULfchcompra()
	*----------------------------------------------------------*
	OTHERWISE
		IF ULarqvenda()
			DO SVD0500.SPR WITH LSprograma
		ENDIF
		=ULfchvenda()
ENDCASE
ON KEY LABEL F8	

	DO UPcapparam	&& MONTAR PARAM.DA EMP.NO DIRETO DE DADOS SELECIONADO

   =W_DEFPROC("ACESSO.SPR")
   =ACredmenu(wp_acesso)  && REDEFINE MENU

RETURN 
 
 
 ********************************************
* //////
 *********************************************
 	
PROCEDURE ULfecha
    =UP_FECHA("tppgto"   ,LFtppgto)
 	=UP_FECHA("grfiscal",LFgrfiscal) 
  	=UP_FECHA("empresa",LFempresa) 
 	=UP_FECHA("tipooper",LFtipooper) 
 	=UP_FECHA("tab_cita",LFtab_cita) 
 	=UP_FECHA("paramet",LFparametr) 
   	=UP_FECHA("tppgto",LFtppgto) 
  	=UP_FECHA("tab_cst",LFtab_cst) 
  	=UP_FECHA("saldo",LFsaldo) 
  	=UP_FECHA("itemmov",LFitemmov) 
 	=UP_FECHA("itmanexo",LFitmanexo) 
   	=UP_FECHA("grupo",LFgrupo) 
 	=UP_FECHA("prod_cms",LFprod_cms) 
   	=UP_FECHA("tab001",LFtab001) 
   	=UP_FECHA("tab002",LFtab002) 
 	=UP_FECHA("transprt",LFtransprt) 
   	=UP_FECHA("banco",LFbanco) 
   	=UP_FECHA("pedido",LFpedido) 
   	=UP_FECHA("pedite",LFpedite) 
   	=UP_FECHA("regiao",LFregiao) 
   	=UP_FECHA("tabnbm",LFtabnbm) 
  	=UP_FECHA("clasnbm",LFclasnbm) 
  	=UP_FECHA("usuario",LFusuario) 

	wp_flgfecha = .F. 		&& defaut nao fechamento da secao
	IF !EMPTY(LS2areant)
		SELECT &LS2areant
	ENDIF
	ON KEY LABEL ESCAPE
	SET FORMAT TO 
	ON KEY LABEL CTRL-I 

RETURN
	
***************************** ARQUIVOS ESPECIFICOS

FUNCTION ULarqvenda
	LFclientes 	= NetArq("clientes") 
	LFclienc 	= NetArq("clienc") 
	LForcament 	= NetArq("orcament") 
	LForc_anex 	= NetArq("orc_anex") 
	LForcatmp 	= NetArq("orcatmp") 
	LFnota	 	= NetArq("nota") 
	LFnf_anexo 	= NetArq("nf_anexo") 
	LFpreco 	= NetArq("preco") 
	LFduplicat 	= NetArq("duplicat") 
	LFliberacoes = NetArq("liberaco") 
	LFobs_orca  = NetArq("obs_orca") 
	IF (LFclientes+LFclienc+LForcament+LForc_anex+LForcatmp+LFnota) > 100000
		RETURN(.F.)
	ENDIF
	IF (LFnf_anexo+LFpreco+LFduplicat+LFliberacoes+LFobs_orca) > 100000		
		RETURN(.F.)
	ENDIF
RETURN(.T.)	

FUNCTION ULfchvenda
   	=UP_FECHA("clientes",LFclientes) 
   	=UP_FECHA("clienc",LFclienc) 
   	=UP_FECHA("orcament",LForcament) 
   	=UP_FECHA("orc_anex",LForc_anex) 
   	=UP_FECHA("orcatmp",LForcatmp) 
   	=UP_FECHA("nota",LFnota) 
   	=UP_FECHA("nf_anexo",LFnf_anexo) 
   	=UP_FECHA("preco",LFpreco) 
   	=UP_FECHA("duplicat",LFduplicat) 
   	=UP_FECHA("liberaco",LFliberacoes) 
   	=UP_FECHA("obs_orca",LFobs_orca) 

RETURN(.T.)
******************************************************************
*---------------
******************************************************************
FUNCTION ULarqcompra
	LFfornece 	= NetArq("fornece") 
	LFnota	 	= NetArq("nota") 
	LFnotaent 	= NetArq("notaent") 
	LFnotaite 	= NetArq("notaite") 
	IF (LFfornece+LFnota+LFnotaent+LFnotaite) > 100000
		RETURN(.F.)
	ENDIF
RETURN(.T.)	

FUNCTION ULfchcompra
   	=UP_FECHA("fornece",LFfornece) 
   	=UP_FECHA("nota",LFnota) 
   	=UP_FECHA("notaente",LFnotaent) 
   	=UP_FECHA("notaite",LFnotaite) 
RETURN(.T.)
*************************************************************************
*************************************************************************
* ROTINAS COMUNS PARA SCGC201 E SCGC201A					
*************************************************************************
*************************************************************************


PROCEDURE BTN_VAL2		&& ESPECIFICA P/ SCGC201 E SCGC201A
	PARAMETER tecla, m.chv_ler, m.chv_compara, m.chv_brow
	#DEFINE C_DELREC		'Apagar Registro Selecionado ?'

	SELE orcament
	
	DO CASE
	  CASE m.ver = 1					&& ver proprios
		SET ORDER TO TAG vend_orca
	  CASE m.ver = 2					&& ver todos abertos
		SET ORDER TO TAG orcamento
	  CASE m.ver = 3					&& ver geral independente de status
		SET ORDER TO TAG geral
	ENDCASE

	_CUROBJ = 1
    DO CASE
		CASE tecla = "ADD"
			PRIVATE LNemp,LNorcamento
			LNemp		= 	wp_empresa
			LNorcamento	=	0
			*--------------------------------------------
			=W_DEFPROC("ORCAMENT.SPR")
			IF ORadorcament((LNemp),LNorcamento)
				SELE orcament
				SET ORDER TO TAG geral
				SEEK STR(LNemp,3)+STR(LNorcamento,6)
				IF FOUND()
					DO ULsaveScreen
					DO SVD0300.SPR WITH (LNemp),(LNorcamento),"INCLUSAO"
					DO SVD0100.SPR WITH (LNemp),(LNorcamento)
					DO SVD0400.SPR WITH (LNemp),(LNorcamento),(LSprograma)
					DO ULrestScreen
				ENDIF
			ENDIF
			*--------------------------------------------
			RETURN 
		CASE tecla = "EDIT" 

			IF !lMaster AND orcament.protegido ;
				AND orcament.operador <> wl_vendedor)

				wp_msg = "Orcamento Protegido ......    <ENTER>"
				=UPbeeps(.F.,wp_msg)
				return
			ENDIF
			*--------------------------------------------
			LNemp 		=	orcament.empresa
			LNorcament	=	orcament.orcamento
			=W_DEFPROC("ORCAMENT.SPR")
			DO ULsaveScreen
			DO SVD0300.SPR WITH (LNemp),(LNorcamento),"EDICAO"
			DO SVD0100.SPR WITH (LNemp),(LNorcamento)
			DO SVD0510.SPR WITH (LNemp),(LNorcamento)
			DO ULrestScreen
			*--------------------------------------------
        CASE tecla = "DELETE"
			IF EOF() OR BOF()
			   WAIT WINDOW C_ENDFILE NOWAIT
			   RETURN
			ENDIF
	
			IF !lMaster and nUsr <> 1001

				RETURN
			ENDIF
			*--------------------------------------------------*    
			*    OS ORCAMENTOS NAO PODEM SER EXCLUIDOS
			*  DEVEM SER CANCELADOS
			*--------------------------------------------------*
			IF !fox_alert(C_DELREC)
			   RETURN
 			ENDIF
			SELECT  orcatmp
			SET ORDER TO TAG orcamento
			SET NEAR ON
			SEEK STR(orcament.empresa,3)+STR(orcament.orcamento,6)
			SET NEAR OFF
			DO WHILE !EOF() AND orcament.orcamento = orcatmp.orcamento ;
							AND orcament.empresa   = orcatmp.empresa 
			   =REGLOCK(.T.)
			   =edithand('APAGA')
			   SKIP
			ENDDO   
			SELECT orcament
		    =edithand('APAGA')
            IF TYPE("chv_ler") = "U"
		       STORE "" TO  m.chv_ler, m.chv_compara, m.chv_brow
			ENDIF            


		    DO btn_val with "NEXT", m.chv_ler, m.chv_compara, m.chv_brow
        CASE tecla = "LOCATE"
			*------------------------------------------------------------*
			=W_DEFPROC("ORCAMENT.SPR")
			DO ORloc_orc WITH "ABCDEFGHIJKLMNOPQRSTUVXWYZ",.F.
			*------------------------------------------------------------*
        CASE tecla = "PRINT"
			*-----------------------------------------------------*
			=W_DEFPROC("orcament.spr")
			=ORimp_orca()
			*-----------------------------------------------------*
		OTHERWISE     
		    DO btn_val with tecla, m.chv_ler, m.chv_compara, m.chv_brow
	ENDCASE		      

	SELE clienc
	SET ORDER TO TAG emporca
	SEEK STR(orcament.EMPRESA,3)+STR(orcament.ORCAMENTO,6)

	SELE obs_orca
	SET ORDER TO TAG pobs_orca
	SEEK STR(orcament.EMPRESA,3)+STR(orcament.ORCAMENTO,6)
    IF FOUND()
	   m.OBS  =  obs_orca.obs
       m.ac   =  obs_orca.AC
       m.PRZENTREGA  = obs_orca.PRZENTREGA
	ELSE
	   m.OBS  =  ""
       m.ac   =  ""
       m.PRZENTREGA  = ""
    ENDIF
 
	SELE TAB002
	SEEK 'PRC'+CHRTRAN(STR(orcament.tp_parcela,2)," ","0")
	m.nome_parcela = tab002.descricao
	SELE TAB001
	SEEK 'INS'+STR(clienc.tp_inscr,1)
	m.nome_inscr = tab001.descricao

	SEEK 'NTZ'+CHRTRAN(STR(clienc.natu_cli,1)," ","0")
	m.nome_natu = tab001.descricao

	SEEK "ST1"+LEFT(orcament.situacao,1)
	m.nome_sit = RTRIM(tab001.descricao)
	SEEK "ST2"+RIGHT(orcament.situacao,1)
	m.nome_sit = m.nome_sit+" "+RTRIM(tab001.descricao)

	SELE tipooper
	SET ORDER TO TAG tipo
	SEEK 'S'+orcament.tipo
	IF !FOUND()
		SEEK 's'+orcament.tipo  
	ENDIF
	m.natureza = tipooper.descnatu
	SELE transprt
	SEEK m.transp
	m.transp = transprt.cgc
	m.nome_trans = transprt.nome

	SELE usuario
	SET ORDER TO TAG usuario
	SEEK orcament.operador
	m.nome_vend = usuario.nome
	SELE orcament
	m.cgccliente = str(clienc.cliente,14)
	*---------------------------------------------------------*
	=W_DEFPROC("ORCAMENT.SPR")
	DO ORVTmotivos
	*---------------------------------------------------------*
	IF WPprgativo = "SCGC201"
		m.vias = orcament.vias_osi - 1
	ENDIF
	*----------------------------------------------------------*
	SHOW GETS
*	_CUROBJ = 1
	UNLOCK ALL
RETURN
*------------>
