

***************************************************************
**  CANCELAMENTO DE RESERVAS POR TEMPO
***************************************************************
*---------------------------------------------------------------*
* OPERA ARQUIVOS :
*			EMPRESA
*
* OBJETIVO: LIBERA  RESERVAS POR TEMPO
*---------------------------------------------------------------*
PUSH KEY CLEAR		&& desabilita teclas de atalho def. anteriormente
******>>>> INICIO CONTROLE AMBIENTAL
PRIVATE wl_areant
PRIVATE LFitm,LForctmp,LFitanx,LFsld,LForca,LFusr
PRIVATE LNproximo
PRIVATE LNrgemp, LNrgorc, LNrgsld
PRIVATE wl_arqtmp,LStmp

STORE 0 TO LNrgemp, LNrgorc, LNrgsld

*****************************************************************
ON KEY LABEL ESCAPE
wl_areant 	= ALLTRIM(ALIAS()) && PERMITE RETORNAR A AREA ANTER. A CHAMADA

LS_areant   = ALLTRIM(ALIAS()) && PERMITE RETORNAR A AREA ANTER.
wp_flgfecha = .F. 		&& defaut nao fechamento da secao
LFitm 		= .F.		&& .F. =>  DEVE SER FECHADA NA SAIDA
LFitanx 	= .F.		&& .F. =>  DEVE SER FECHADA NA SAIDA
LForca   	= .F.		&& .F. =>  DEVE SER FECHADA NA SAIDA
LForctmp	= .F.		&& .F. =>  DEVE SER FECHADA NA SAIDA
LFsld   	= .F.		&& .F. =>  DEVE SER FECHADA NA SAIDA
LFusr   	= .F.		&& .F. =>  DEVE SER FECHADA NA SAIDA
LFemp     	= .F.		&& .F. =>  DEVE SER FECHADA NA SAIDA

******>>>> FIM CONTROLE AMBIENTAL

******>>>> INICIO CONTROLE ARQUIVOS

IF !USED("itemmov")
	LFitm	= .T.
	IF ! NetUse("itemmov")
		wp_flgfecha = .t.  && implica no fechamento da secao
	ENDIF
ENDIF

************     CHECAGEM INICIAL    **************

IF wp_flgfecha			&&    OR !REGLOCK()
	DO ULfecha
	POP KEY 			&& reabilita teclas de atalho def. anteriormente
	RETURN
ENDIF

SELE itemmov
SET ORDER TO TAG BX_RESERVA
SET NEAR ON
SEEK STR(wp_empresa,3)
SET NEAR OFF


IF EOF() OR  wp_empresa <> itemmov.empresa 
	DO ULfecha
	POP KEY 			&& reabilita teclas de atalho def. anteriormente
	RETURN
ENDIF

************************************************************************

IF !USED("empresa")
	LFemp	= .T.
	IF ! NetUse("empresa")
		wp_flgfecha = .t.  && implica no fechamento da secao
	ENDIF
ENDIF
IF !USED("itmanexo")
	LFitanx = .T.
	IF ! NetUse("itmanexo")
		wp_flgfecha = .t.  && implica no fechamento da secao
	ENDIF
ENDIF
IF !USED("orcament")
	LForca = .T.
	IF ! NetUse("orcament")
		wp_flgfecha = .t.  && implica no fechamento da secao
	ENDIF
ENDIF
IF !USED("orcatmp")
	LForctmp = .T.
	IF ! NetUse("orcatmp")
		wp_flgfecha = .t.  && implica no fechamento da secao
	ENDIF
ENDIF
IF !USED("saldo")
	LFsld = .T.
	IF ! NetUse("saldo")
		wp_flgfecha = .t.  && implica no fechamento da secao
	ENDIF
ENDIF
IF !USED("usuario")
	LFusr = .T.
	IF ! NetUse("usuario")
		wp_flgfecha = .t.  && implica no fechamento da secao
	ENDIF
ENDIF
SELE empresa 

*SET REPROCESS TO 20

IF wp_flgfecha OR !RLOCK()
	DO ULfecha
	POP KEY 			&& reabilita teclas de atalho def. anteriormente
	RETURN
ENDIF

******* ARQ.TEMPORARIO COM REGISTROS SELECIONADAS EM ITEMMOV *****

********************>  GERANDO ARQTMP **********************
wl_arqtmp = ""
LNtmp     = 65		&& TABELA ASCII A = 65
IF !UPabretmp("tmp")
	wp_flgfecha = .t.
ENDIF
IF wp_flgfecha
	DO ULfecha
	POP KEY 			&& reabilita teclas de atalho def. anteriormente
	RETURN
ENDIF
************************************************************
LStmp = "&wp_dirtmp"+"&wl_arqtmp"
******************************************************************
PRIVATE LNrgemp, LNrgorc, LNrgsld
******************************************************************
******************************************************************
LNrgemp = IIF(EOF("EMPRESA"),0,RECNO("EMPRESA"))
LNrgorc = IIF(EOF("ORCAMENT"),0,RECNO("ORCAMENT"))
LNrgsld = IIF(EOF("SALDO"),0,RECNO("SALDO"))
******************************************************************
******************************************************************
SELE orcament
SET ORDER TO TAG orcamento

SELECT  orcatmp
SET ORDER TO TAG orcacodigo

SELE itemmov
SET ORDER TO TAG BX_RESERVA

COPY TO &LStmp WHILE wp_empresa = itemmov.empresa  WITH CDX

SELE 0 
USE &LStmp  ALIAS TMPR exclu    
SELE TMPR
SET ORDER TO TAG orcamento

*******************
*---->   (INICIALIZACAO DO CONTROLE DE STATUS IMPRESSAO)
*******************	
GO TOP
DO WHILE !EOF() 

	WAIT WINDOW TMPR.codigo NOWAIT

	*--------------------------------------------------------------*
	*    Foi inserida uma mudanca para que o item que consta na
	* reserva seja verificado no ORCATMP e  dependendo do resultado
	* segue-se :
	*	SE CONSTAR 		: Obedesce a data de baixa prevista mas 
	*				verifica a SITUACAO para indicar falha na mudan‡a
	* 				se status do item em ORCATMP ou falha no processo 
	*				de baixa de reserva
	*
	*   SE NAO CONSTAR 	: Forca a baixa do item 
	*--------------------------------------------------------------*

	SELECT  orcament

	SET ORDER TO TAG orcamento
	SEEK STR(TMPR.empresa,3)+STR(TMPR.orcamento,6)

	SELECT  orcatmp
	SET ORDER TO TAG orcacodigo
	SEEK STR(TMPR.empresa,3)+STR(TMPR.orcamento,6)+;
				 TMPR.codigo+STR(TMPR.ordem,2)

	IF FOUND("ORCAMENT") AND FOUND("ORCATMP")
		IF    LEFT(orcatmp.situacao,1) $ "O/A/Y/Z" ;
		   or EMPTY(orcatmp.situacao) ;
		   or LEFT(orcament.situacao,1) $ "O/A/Y/Z" ;
		   or EMPTY(orcatmp.situacao) 
	
			  m.STATUS	= "ERRO"

		ELSE
			IF (TMPR.dlibreserv > wp_dtsys    OR ;
				(TMPR.dlibreserv = wp_dtsys   AND ;
				 TMPR.hlibreserv >  left(time(),5))) 
		 		SELE TMPR
				SKIP 
				LOOP
			ENDIF	
		ENDIF
	ENDIF

	SELE itemmov
	SET ORDER TO TAG movimento

	SEEK STR(TMPR.empresa,3)+TMPR.codigo+DTOS(TMPR.data)+TMPR.hora+;
		 TMPR.tipo+STR(TMPR.nota,7)+STR(TMPR.ordem,3)
	IF !FOUND()
 		SELE TMPR
		SKIP 
		LOOP
	ENDIF

	IF !RLOCK()
		SELE TMPR
		SKIP 
		LOOP
	ENDIF

	****** BLOQUEIA O ORCAMENTO E VERIFICA CONDICAO P/ TIRAR RESERVA *****

	SELE orcament

	*------------------------------------------------------------*
	* Se o orcamento for encontrado mas o item en questÆo nÆo. EntÆo
	* o processo segue independente da condi‡Æo do orcamento
	*------------------------------------------------------------*
	
*	IF FOUND() AND FOUND("ORCATMP")
*		************************************************************
*		*  SITUACOES QUE NAO DEVEM SER PROCESSADAS					*
*		*			M => OSI IMPRESSA								*
*		*			F => AGUARDANDO RESERVA EM OSI COMPLEMENTAR		*
*		*			L => AGUARDANDO IMPRESSAO EM OSI COMPLEMENTAR	*
*		*															*
*		*  SITUACOES EM QUE NAO DEVEM HAVER RESERVA=>(ERRO PROC. BAIXA)*
*		*			Z => OSI IMPRESSA								*
*		*			Y => AGUARDANDO RESERVA EM OSI COMPLEMENTAR		*
*		************************************************************
*		*  SO SERA BAIXADA AUTOMATICAMENTE AS RESERVAS PURAS NAS 
*		*  QUAIS A OSI ESTA COM SITUACAO = "I"
*		*  OBS: A SITUACAO (A) PODE SER COLOCADA NA CONVERSAO DO 
*		*     PRIMEIRO ITEM IMPLICANDO QUE NOS DEMAIS ESTA SIT DEV
*		*     SER PROCESSADA
*		*************************************************************
*		IF !(LEFT(orcament.situacao,1) $  "AIZY") 
*			SELE TMPR
*			SKIP 
*			LOOP
*		ENDIF
*	ENDIF

	IF FOUND() AND !RLOCK()
		SELE TMPR
		SKIP 
		LOOP
	ENDIF
	*******************************************************************

	************ POSICIONA SALDO CASO NAO TENHA SIDO FEITO ANTES ******
	SELE saldo	
    SET ORDER TO TAG clas_saldo
    SEEK STR(itemmov.empresa,3)+itemmov.classifica+;
         STR(YEAR(itemmov.data),4)+;
         STR(MONTH(itemmov.data),2)

  	IF !FOUND() 
		SELE TMPR
		SKIP 
		LOOP
	ENDIF
	
	IF !RLOCK() 	&& CONFIRMA O BLOQUEIO DO SALDO
		SELE TMPR
		SKIP 
		LOOP
	ENDIF
	**********************************
	**********************************
	SELECT  orcatmp
	SET ORDER TO TAG orcacodigo
	SEEK STR(itemmov.empresa,3)+STR(itemmov.orcamento,6)+;
			itemmov.codigo+STR(itemmov.ordem,2)

	**********************
	** A RESERVA SO E BAIXADA QDO O ORCATMP ESTA COM SITUACAO "I" PURA
	** OU O MESMO NAO FOR ENCONTRADO
	** AS SITUACOES "ZY" FORAM INCLUIDAS POR OCORREREM FALHA NA BAIXA
	**********************
	
   	IF FOUND() AND !(LEFT(orcatmp.situacao,1) $ "ZYI") && SO ALT QDO SO RESERVADO
		SELE TMPR
		SKIP 
		LOOP
	ENDIF

	IF FOUND() AND !RLOCK()
		SELE TMPR
		SKIP 
		LOOP
	ENDIF

	**********************************
	SELE itemmov
    SET ORDER TO TAG movimento
	IF !RLOCK()
		SELE TMPR
		SKIP 
		LOOP
	ENDIF

	*-----------------------------------------------------------*
	*   Se houver falha durante o processo o registro aida fica 
	* sob o controle da rotina SCGC204.PRG para processar a 
	* baixa da reserva . A chave BX_RESERVA exige o 1§ caracter
	* igual a "R" 
	*-----------------------------------------------------------*		
	REPLACE operacao WITH "R***"   && faz o reg ser ignorado no saldo
								   && anulando seu efeito
	REPLACE dlibreserv WITH wp_dtsys
	REPLACE hlibreserv WITH time()
	***********************************************************

	**********************************
	SELECT  orcatmp
   	IF FOUND() 
		IF !FOUND("ORCAMENT")
			LSmsg = "  Existiam Reservas p/ OSI "+str(orcatmp.orcamento)+;
				" que nao foi localizada pelo Sistema. As reservas serao baixadas e "+;
				"os itens serao apagados."+CHR(13)+;
				CHR(13)+"   AVISE SUPORTE. OBRIGADO."
			=edithand('APAGA')
		ELSE
			IF  LEFT(orcament.situacao,1) $  "AI"
					REPLACE situacao WITH "A "
		 			REPLACE qtderes	 WITH  0
    		ENDIF
			***************************
			SET FIELDS TO dtregis, hregis, usrregis,deletado
			=edithand('REGRAVA')
			CLEAR FIELDS
			SET FIELDS OFF
			***************************
    	ENDIF
    ENDIF

	SELE orcament
	IF FOUND() AND LEFT(orcament.situacao,1) $  "I" && SO ALT QDO SO RESERVADO
		IF !(LEFT(orcament.situacao,1) $  "A") 
			IF RLOCK()
			
				REPLACE situacao WITH "A "
				***************************
				SET FIELDS TO dtregis, hregis, usrregis,deletado
				=edithand('REGRAVA')
				CLEAR FIELDS
				SET FIELDS OFF
			ENDIF
			***************************
		ENDIF
	ENDIF
	***********************************************************
	SELE itemmov
	LNregmov = RECNO()

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

	SELE itemmov
	GO LNregmov
	***********************************************************
	SELE itmanexo
	SET ORDER TO TAG movanexo
	SEEK STR(itemmov.empresa,3)+itemmov.codigo+;
		 DTOS(itemmov.data)+itemmov.hora+itemmov.tipo+;
		 STR(itemmov.nota,7)+STR(itemmov.ordem,3)
	IF FOUND()
		IF RLOCK()
			=edithand('APAGA')
		ENDIF
	ENDIF
	SELE itemmov
    SET ORDER TO TAG movimento
	IF RLOCK()
		=edithand('APAGA')
	ENDIF
	************    PROXIMO MOVIMENTO COM RESERVA	***********
	SELE TMPR
	SKIP 
ENDDO
SELE empresa
REPLACE ultlib_res   WITH TIME()
wp_ultlib    = time()
UNLOCK

SELE saldo
UNLOCK
SELE itemmov
UNLOCK
SELE itmanexo
UNLOCK
SELE orcament
UNLOCK
SELE orcatmp
UNLOCK

DO ULfecha
POP KEY 			&& reabilita teclas de atalho def. anteriormente
RETURN
**********************************************************
**********************************************************
**********************************************************

PROCEDURE ULfecha
	*****************
	IF LNrgemp <> 0
		SELE empresa
		GO LNrgemp 
	ENDIF
	IF LNrgorc <> 0
		SELE orcament
		GO LNrgorc 
	ENDIF
	IF LNrgsld <> 0
		SELE saldo
		GO LNrgsld
	ENDIF
	*****************

	IF LFitm   		&& .t. =>  DEVE SER FECHADA NA SAIDA
		=UP_fecha("itemmov")
	ENDIF
	IF LFitanx   		&& .t. =>  DEVE SER FECHADA NA SAIDA
		=UP_fecha("itmanexo")
	ENDIF
	IF LForca   		&& .t. =>  DEVE SER FECHADA NA SAIDA
		=UP_fecha("orcament")
	ENDIF
	IF LForctmp   		&& .t. =>  DEVE SER FECHADA NA SAIDA
		=UP_fecha("orcatmp")
	ENDIF
	IF LFsld   		&& .t. =>  DEVE SER FECHADA NA SAIDA
		=UP_fecha("saldo")
	ENDIF
	IF LFusr   		&& .t. =>  DEVE SER FECHADA NA SAIDA
		=UP_fecha("usuario")
	ENDIF
	***

	=UP_fecha("TMPR")		&& ARQUIVO TEMPORARIO

	***
	wp_flgfecha = .F. 		&& defaut nao fechamento da secao
	IF !EMPTY(wl_areant)
		SELECT &wl_areant
	ENDIF
	ON KEY LABEL ESCAPE
	SET FORMAT TO 
RETURN
