




**************************************************************************
*  OBJ_ATLZ.PRG   : Rotina para atualizacao automatica de dados (DBF)    *
*				  colocados no diretorio (LSdiretorio\AUTOMATC\)         *
*				    Esta Rotina e chamada no MENU (SCGC.MPR)			 *
*																		 *
*				   E necessario que os arquivos da FILIAL e DATA passdas *
*				 estejam no diretorio.									 *													 *
*
*	LNfilial 	: Codigo da Filial em Operacao no Sistema
*	LSdrivetmp  : Diretorio Base (ex: \SCGC\LOJA\ ou \SCGC\CENTRAL ou \TMP\)
*	LVTdbf	 	: Vetor com o nome do arquivo 
*	LVTmrc	 	: Vetor com a marca dos arquivos  p/ importar
*	LDdata	 	: Data que se Solicita a Importacao 
*	LFsobrepor  : 1 Permanecer o mais recente
*				: 2 Sobrepor indepedente de data
*	LStpTRANS   : "A" = Automatica
*                 "M" = Manual
**************************************************************************

	PARAMETERS LNfilial,LSdrivetmp,LVTdbf,LVTmrc,;
			   LFsobrepor,LDdata,LStptrans
	PRIVATE LNind		&& INDICE DO VETOR
	PRIVATE LSarq		&& NOME DO ARQUIVO QUE RECEBERA OS DADOS
	PRIVATE LSarquivo   && NOME DO ARQUIVO QUE TRANSMISSOR OS DADOS
	PRIVATE LStmpO      && ARQ. C/ PATH DO ARQ. ORIGEM
	PRIVATE LFarq		&& FLAG DE ABERT E FECHAMENTO DO ARQ. RECEBEDOR DADOS
	PRIVATE LFerro		&& FLAG TESTE ERRO 
	PRIVATE LFtransmit	&& FLAG TESTE ERRO 

	PRIVATE LFtra_atu	 && FLAG INDICAR SE JA FOI TENTADA ATUALIZACAO DO 
						 && ARQ. TRANSMIT QUE OCORRE INDEPENDENTE DO ENVIO
	PRIVATE LTchave		 && ARMAZENAR O VLR DO CAMPO REG TRANSMIT REF AO ARQ.
	PRIVATE LTdescricao  && ARMAZENAR O VLR DO CAMPO REG TRANSMIT REF AO ARQ.
	PRIVATE LTarquivo	 && ARMAZENAR O VLR DO CAMPO REG TRANSMIT REF AO ARQ.
	PRIVATE LTindica_emp && ARMAZENAR O VLR DO CAMPO REG TRANSMIT REF AO ARQ.

	LFtransmit 	= .F.
	IF !USED("transmit")
		LFtransmit 	= .T.
		IF ! NetUse("transmit") 
			DO OBJ_ALER.SPR WITH ;
				"Nao Foi Possivel Abri Arq. de Controle de Transmissao"+;
				" ( TRANSMIT.DBF ). Nao e Possivel Fazer Importacao.."


			RETURN
		ENDIF
	ENDIF

	IF  LStptrans = "A" 
		LFtra_atu	= .F. 	&& TRANSMIT AINDA NAO ATUALIZADO
		LNind = 0
	ELSE
		LFtra_atu	= .T. 	&& TRANSMIT NAO ATUALIZAR AUTOM.
		LNind = 3			&& 1a ocorrencia com nome de arquivo
	ENDIF

	DO WHILE LNind <= ALEN(LVTdbf,1) AND (LNind = 0 OR !EMPTY(LVTdbf(LNind,1)))
		SELE transmit

		SET ORDER TO TAG chr_ident

		IF LFtra_atu	= .F. 	&& TRANSMIT AINDA NAO ATUALIZADO
			SEEK "TR" 			&& IDENTIFICADOR PARA TRANSMIT
		ELSE
			IF  LStptrans = "A" AND UPPER(SUBS(LVTdbf(LNind,1),7,2)) = "TR" && ARQ.TRANSMIT
				LNind = LNind + 1
				LOOP
			ENDIF
			if LStptrans = "M"
				IF TYPE("LVTmrc") = "C"  AND LEFT(LVTmrc(LNind,1),1) = " "
					LNind = LNind + 1
					LOOP
				ENDIF
				SET ORDER TO TAG arquivo
				SEEK SUBS(LVTdbf(LNind,1),1,8)
			ELSE
				SET ORDER TO TAG chr_ident
				SEEK SUBS(LVTdbf(LNind,1),7,2)
			ENDIF

		ENDIF
		IF !FOUND()
			KEYBOARD CHR(4)	&& APAGAR MENSSAGEM DE WAIT WIND
			
			IF LFtra_atu	= .F. 	&& TRANSMIT AINDA NAO ATUALIZADO
				DO OBJ_ALER.SPR WITH ;
			   	"Arquivo ( TRANSMIT  ) Nao Esta Configurado p/ "+;
			   	"Para Transmissao/Recepcao de Dados. Solicite Suporte..."
			ELSE
				DO OBJ_ALER.SPR WITH ;
			   	"Arquivo ( "+LVTdbf(LNind,1)+"  ) Nao Esta Configurado p/ "+;
			   	"Para Transmissao/Recepcao de Dados. Solicite Suporte..."
			ENDIF
			LFtra_atu	= .T. 	&& TRANSMIT JA ATUALIZADO
			LNind = LNind + 1
			LOOP
		ENDIF

		SCATTER MEMVAR

		LTchave			= m.chave
		LTdescricao 	= m.descricao
		LTarquivo 		= m.arquivo
		LTindica_emp	= m.indica_emp
		LTchr_ident		= m.chr_ident

		IF LFtra_atu	= .F. 	&& TRANSMIT AINDA NAO ATUALIZADO
			wp_msg = ALLTRIM(m.descricao)+" "+m.arquivo+" <== MMDDFLTR"
		ELSE
			wp_msg = ALLTRIM(m.descricao)+" "+m.arquivo+" <== "+LVTdbf(LNind,1)
		ENDIF
		wait window wp_msg nowait
		IF  !(transmit.recebe)  && ARQUIVO NAO AUTORIZADO P/ RECEBER DADOS
			IF LFtra_atu	= .F. 	&& TRANSMIT AINDA NAO ATUALIZADO
			   DO OBJ_ALER.SPR WITH ;
			   "Arquivo ( "+m.arquivo+"-"+ALLTRIM(m.descricao)+;
			   " ) Nao Tem Indicacao Para Receber Dados Enviados em "+;
			   " MMDDFLTR.DBF.  Solicite Suporte..."
			ELSE
			   DO OBJ_ALER.SPR WITH ;
			   "Arquivo ( "+m.arquivo+"-"+ALLTRIM(m.descricao)+;
			   " ) Nao Tem Indicacao Para Receber Dados Enviados em "+LVTdbf(LNind,1)+;
			   "  Solicite Suporte..."
			ENDIF
			LFtra_atu	= .T. 	&& TRANSMIT JA ATUALIZADO
			LNind = LNind + 1
			LOOP
		ENDIF
		LSarq = ALLTRIM(m.arquivo)
		LFarq	= .f.			&& NAO FECHAR ARQUIVO
		*************************************************************
		*   
		* 				 Abertura do Arquivo Destino
		*
		*************************************************************
		IF !USED(ALLTRIM(LSarq))
			LFarq	= .T.		&& FECHA ARQ. RECEBEDOR
			IF ! NetUse(ALLTRIM(LSarq)) 


*--------------------------------------------------*
*     DESABILITADO EM 19/2 PEDIDO NELSON
*--------------------------------------------------*
*-----------------------------------------------------------------*
*			   DO OBJ_ALER.SPR WITH ;
*			   "Nao Foi Possivel Acessar Arquivo Destino "+LSarq+ ;
*		    	chr(13)+chr(13)+ "Solicite Suporte..."
*				LNind = LNind + 1
*				LFtra_atu	= .T. 	&& TRANSMIT JA ATUALIZADO
*
*-----------------------------------------------------------------*

			   wp_msg =  ;
			   "Nao Foi Possivel Acessar Arquivo Destino "+LSarq+ ;
		    	chr(13)+chr(13)+ "Solicite Suporte..."
				LNind = LNind + 1
				LFtra_atu	= .T. 	&& TRANSMIT JA ATUALIZADO

               wait window wp_msg nowait




				LOOP
			ENDIF
		ENDIF
		SELECT &LSarq
		*************************************************************
		*   
		* 				 Abertura do Arquivo Origem
		*
		*************************************************************
		IF LFtra_atu	= .F. 	&& TRANSMIT AINDA NAO ATUALIZADO
			LSnomearq = CHRTRAN(STR(MONTH(LDdata),2)," ","0") + ;
						CHRTRAN(STR(DAY(LDdata),2)," ","0") + ;
						CHRTRAN(STR(LNfilial,2)," ","0")+;
						"TR" 
		ELSE
			IF  LStptrans = "A" 	&& NOME DO ARQ. ESTA NO VETOR
				LSnomearq = SUBS(LVTdbf(LNind,1),1,8) 
			ELSE
				LSnomearq = CHRTRAN(STR(MONTH(LDdata),2)," ","0") + ;
							CHRTRAN(STR(DAY(LDdata),2)," ","0") + ;
							CHRTRAN(STR(LNfilial,2)," ","0")+;
							LTchr_ident 

			ENDIF
		ENDIF
		LStmpO 	  = LSdrivetmp+LSnomearq
		*************************************************
		LFerro = .f.
	   	ON ERROR  LFerro = .t. 
		SELECT 0
	    USE &LStmpO EXCLUSIVE ALIAS origem

		IF LFerro
		   on error
		   IF LFtra_atu	<> .F. 	&& TRANSMIT JA ATUALIZADO

*--------------------------------------------------*
*     DESABILITADO EM 19/2 PEDIDO NELSON
*--------------------------------------------------*
*			   DO OBJ_ALER.SPR WITH ;
*				   "Nao Foi Possivel Acessar Arquivo Origem. "+CHR(13)+;
*				   LStmpO+chr(13)+;
*	 			   "Se Persistir o Erro Informe Suporte..<ENTER> "
*
*
*--------------------------------------------------*

			   wp_msg = ;
				   "Nao Foi Possivel Acessar Arquivo Origem. "+CHR(13)+;
				   LStmpO+chr(13)+;
	 			   "Se Persistir o Erro Informe Suporte..<ENTER> "

               wait window wp_msg nowait

			ENDIF
			=UP_fecha("origem")
			IF 	LFarq
				=UP_fecha(LSarq)
			ENDIF
			LNind = LNind + 1
			LFtra_atu	= .T. 	&& TRANSMIT JA ATUALIZADO
			LOOP
		ENDIF
	    on error
		SELE &LSarq				  && ARQUIVO DESTINO
		SET ORDER TO TAG &nometag && CHAVE INDICADA EM TRANSMIT
		GO TOP
		SELE origem	
		GO TOP
		*************************************************************
		* ATENCAO => OS DADOS DE DTREGIS, HREGIS, USRREGIS, 
		*			DEVEM SER MANTIDOS CONFORME NO BACKUP PARA ISSO
		*           USA-SE OS COMANDOS GATHER E  DELETE
		*************************************************************
		DO WHILE !EOF()		

*			IF UPPER(LSarq) = "CLIENTES"
*              set step on
*           ENDIF

			wp_msg = ALLTRIM(LTdescricao)+" "+;
						 LTarquivo+" em "+LSnomearq+"-"+STR(RECNO(),6)
			wait window wp_msg nowait
			SCATTER MEMVAR MEMO

			*---------------------------------------------------*
			*   N∆o se importa registros de saldo da propria 
			* filial para n∆o conrromper os dados
			*---------------------------------------------------*
			
			IF UPPER(LSarq) = "SALDO"
				IF LNfilial = m.empresa
					SKIP
					LOOP
				ENDIF
			ENDIF

			IF UPPER(LSarq) = "CLIENTES"
			   *--------------------------------------------*
			   *    NAO IMPORTAR REGISTROS DE CLIENTES DELETADOS PARA
			   * NAO CAUSAR FALHA NO CONTROLE DE CLIENTES
			   * NAO SE DELETA CLIENTES
			   *--------------------------------------------*
			   IF  TYPE("M.DELETADO") = "L" AND m.deletado   
					SKIP
					LOOP
			   ENDIF
			ENDIF
			******************************************************
			* Condicao para importar apenas registro referentes a
			* filial informada
			******************************************************
			IF  LTindica_emp ;
				AND TYPE("M.EMPRESA")  <> "U" ;
				AND m.empresa <> LNfilial
				SKIP
				LOOP
			ENDIF
			SELE &LSarq
			SEEK &LTchave
			IF !FOUND()   		 && NAO EXISTE NO ARQ. DE DADOS
			   IF  TYPE("M.DELETADO") = "U" OR !m.deletado   && NAO ESTA DELETADO ENTAO ATIVA
					SET DELE OFF
					SEEK &LTchave
					IF !FOUND()	OR ;
						LFsobrepor = 2 OR ;
						(TYPE("M.DTREGIS") <> "U" AND ; 
						((m.dtregis > &LSarq .dtregis) OR ;
						 (m.dtregis = &LSarq .dtregis AND ;
						  m.hregis >= &LSarq .hregis)))
						IF FOUND()
						    RECALL
						    =REGLOCK(.T.) 
						ELSE
					   		=ADIREG()	
					   	ENDIF
						GATHER MEMVAR MEMO  &&permanece o dt/h/usr back
					ENDIF
					SET DELE ON
			   ENDIF
			ELSE
			   IF LFsobrepor = 2 OR ;
				  TYPE("M.DTREGIS") = "U" OR ; 
				  ((m.dtregis > &LSarq .dtregis) OR ;
				  (m.dtregis = &LSarq .dtregis AND ;
				   m.hregis >= &LSarq .hregis))
				  =REGLOCK(.T.) 
			  	  DO CASE
						CASE UPPER(LSarq) = "CLIENTES"
							=w_defproc("CLIENTES.SPR")
							IF !CLInscricao(origem.ESTADO,origem.INSCRICAO,1,0,0,'')
								m.inscricao = LTRIM(clientes.INSCRICAO)
							ELSE
								m.inscricao = LTRIM(m.inscricao)
							ENDIF
							LSinsc			= CHRTRAN(m.inscricao," ","")
							LSinsc			= CHRTRAN(LSinsc,".","")
							LSinsc			= CHRTRAN(LSinsc,"/","")
							LSinsc			= CHRTRAN(LSinsc,"-","")
							LSinsc			= LEFT(LSinsc+space(14),14)
							m.inscricao = LSinsc
						CASE UPPER(LSarq) = "PEDITE"
							*****************************************
							* Os Campos a seguir so podem ser
							* aterados por processamento.
							*****************************************
							m.situacao  = pedite.situacao
							m.qtdetr	= pedite.qtdetr
							m.qtdeatd	= pedite.qtdeatd
							*****************************************
							DO CASE
								CASE m.qtde <  m.QTDETR + m.QTDEATD
									 m.qtde =  m.QTDETR + m.QTDEATD
								CASE m.qtde =  m.QTDETR + m.QTDEATD
								   	IF m.QTDETR = 0		
									  	m.situacao = "C"+RIGHT(pedite.situacao,1)
									ELSE
									  	m.situacao = "B"+RIGHT(m.situacao,1) 
									ENDIF
							ENDCASE
						CASE UPPER(LSarq) = "PRECO"
							*****************************************
							* A classificacao da comissao e especifica
							* da filial, nao deve ser sobreposta
							*****************************************
							*m.clas_cms  = preco.clas_cms
							* Apos 01/04/99 a clas_cms foi padronizada
							* em todas filiais, passando a ser
							* substituida nas importacoes
							****************************************
							*****************************************
							* Em Brasilia nao atualiza preco servico
							*****************************************
							IF LNfilial = 2 OR LNfilial = 3
								IF SUBS(m.codigo,3,1) = "9"
									m.preco = preco.preco
								ENDIF
							ENDIF
						CASE UPPER(LSarq) = "PROD_CMS"
							*****************************************
							*   So sao repassados os percentuais de
							* Descontos. Os percentuais de COMISSAO e
							* SUPERAVIT sao de responsabilidade do
							* operador local
							*****************************************
*							m.comissao   = prod_cms.comissao
*							m.com_supera = prod_cms.com_supera
				   ENDCASE
				   GATHER MEMVAR MEMO  && permanece o dt/h/usr backup
				   IF TYPE("M.DELETADO") <> "U" AND m.deletado 
					   DELETE
				   ENDIF				
				ENDIF
			ENDIF
			SELE origem
			SKIP	
		ENDDO
		=UP_fecha("origem")
		IF 	LFarq
			=UP_fecha(LSarq)
		ENDIF
		LStmpO 	  = LStmpO+".DBF"
		IF  LStptrans = "A" 	&& APAGA SO NA IMP. AUTOMATICA
			DELETE FILE &LStmpO	
		ENDIF
		**************************************************
		*   FIM DA TRANSFERENCIA DE DADOS			  *
		**************************************************
		SET DELE ON
		LNind = LNind + 1
		LFtra_atu	= .T. 	&& TRANSMIT JA ATUALIZADO
ENDDO	
IF 	LFtransmit 	= .T.
	=UP_fecha("transmit")
ENDIF
KEYBOARD CHR(4)	&& APAGAR MENSSAGEM DE WAIT WIND
=INKEY(0.1)			

RETURN
