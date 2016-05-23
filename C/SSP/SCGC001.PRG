************************************************************************
PROCEDURE UL_MNCLIE
	IF !NetUse("duplicat") 
		wp_msg = "Arquivo Duplicatas nao pode ser aberto."
		RETURN .F.
	ENDIF

	IF !NetUse("clientes") 
		=UP_fecha("duplicat")
		wp_msg = "Arquivo Clientes nao pode ser aberto."
		RETURN .F.
	ENDIF

	IF !NetUse("clianx_a") 
		=UP_fecha("duplicat")
		=UP_fecha("clientes")
		wp_msg = "Arquivo Anexo de Clientes nao pode ser aberto."
		RETURN .F.
	ENDIF

	IF LFbackup
		SELE clientes
		IF EMPTY(m.arquivo)
			LStmp = ALLTRIM(m.diretorio)+ALIAS()
			LStmp2 = ALLTRIM(m.diretorio)+ALIAS()
		ELSE
			SELE transmit
			SET ORDER TO TAG arquivo
			SEEK "CLIENTES"
			IF !FOUND()
			  	DO OBJ_ALER.SPR WITH ;
			   	"O arquivo de CLIENTES nao esta cadastrado no Arq. "+;
			   	"de Controle de Transmissao. Cadastre e tente Novamente."
				=UP_fecha("duplicat")
				=UP_fecha("clientes")
				=UP_fecha("clianx_a")
				RETURN .F.
		  	ENDIF
			LStmp = ALLTRIM(m.diretorio)+ALLTRIM(m.arquivo)
			LStmp2 = LStmp+transmit.chr_ident
			SELE clientes
		ENDIF

		IF FILE(LStmp2+".DBF")
		  DO OBJ_ALER.SPR WITH ;
			   "O arquivo de BACKUP de Clientes Ja  Existe. Voce Pode "+;
			   "Desistir ou Acumular os dados no Arquivo."+chr(13)+;
			   "Tecle <ENTER> e Responda a proxima Pergunta: "
		  IF !fox_alert('Arquivo '+LStmp2+' ja existe. Acumular Dados ?')
				=UP_fecha("duplicat")
				=UP_fecha("clientes")
				=UP_fecha("clianx_a")
				RETURN .F.
		  ENDIF
		ELSE
		  COPY STRU TO &LStmp2 WITH CDX
		ENDIF
		SELE 0
		USE &LStmp2 ALIAS ARQBKP_A excl
		SET ORDER TO TAG cliente

		***************************************************************

		SELE clianx_a
		IF EMPTY(m.arquivo)
			LStmp = ALLTRIM(m.diretorio)+ALIAS()
			LStmp2 = ALLTRIM(m.diretorio)+ALIAS()
		ELSE
			SELE transmit
			SET ORDER TO TAG arquivo
			SEEK "CLIANX_A"
			IF !FOUND()
			  	DO OBJ_ALER.SPR WITH ;
			   	"O arquivo ANEXO de CLIENTES nao esta cadastrado no Arq. "+;
			   	"de Controle de Transmissao. Cadastre e tente Novamente."
				=UP_fecha("duplicat")
				=UP_fecha("clientes")
				=UP_fecha("clianx_a")
				RETURN .F.
		  	ENDIF
			LStmp = ALLTRIM(m.diretorio)+ALLTRIM(m.arquivo)
			LStmp2 = LStmp+transmit.chr_ident
			SELE clianx_a
		ENDIF

		IF FILE(LStmp2+".DBF")
		  DO OBJ_ALER.SPR WITH ;
		   "O arquivo de BACKUP Anexo de Clientes Ja  Existe. Voce Pode "+;
			   "Desistir ou Acumular os dados no Arquivo."+chr(13)+;
			   "Tecle <ENTER> e Responda a proxima Pergunta: "
		  IF !fox_alert('Arquivo '+LStmp2+' ja existe. Acumular Dados ?')
				=UP_fecha("duplicat")
				=UP_fecha("clientes")
				=UP_fecha("clianx_a")
				RETURN .F.
		  ENDIF
		ELSE
		  COPY STRU TO &LStmp2 WITH CDX
		ENDIF
		SELE 0
		USE &LStmp2 ALIAS ARQBKP_B excl
		SET ORDER TO TAG cliente
	ENDIF

	SELE clientes
	SET ORDER TO TAG dt_atend
	SET NEAR ON
	SEEK m.dt_cli
	SET NEAR OFF
	SET RELATION TO cliente INTO clianx_a

	DO WHILE !EOF() AND clientes.ult_atend <= m.dtf_cli
		IF LFbackup
			SELE clianx_a
			IF !EMPTY(clianx_a.cliente)
				SCATTER MEMVAR
				SELE arqbkp_b
				SEEK m.cliente
				IF FOUND()		
					=REGLOCK(.T.)
				ELSE
	    		    =ADIREG()
				ENDIF
				GATHER MEMVAR MEMO
			ENDIF

			SELE clientes
			SCATTER MEMVAR

			SELE arqbkp_a
			SEEK m.cliente
			IF FOUND()		
				=REGLOCK(.T.)
			ELSE
	    	    =ADIREG()
			ENDIF
			GATHER MEMVAR MEMO
		ENDIF

		SELE duplicat
		SET ORDER TO TAG doc_clie
		SET NEAR ON
		SEEK STR(clientes.cliente+1,14)
		SET NEAR OFF
		SKIP -1

		&& NAO ELIMINAR QDO CLIENTE TIVER DUPLICATA ABERTA
		
		IF duplicat.cliente = clientes.cliente AND EMPTY(duplicat.dt_baixa) 
			SELE clientes
			SKIP
			LOOP
		ENDIF
		IF !EMPTY(clianx_a.cliente)
			SELE clianx_a
			IF LFelimina
				=REGLOCK(.T.)
				=edithand('APAGA')
			ENDIF
		ENDIF

		SELE clientes
		IF LFelimina
			=REGLOCK(.T.)
			=edithand('APAGA')
		ENDIF
		SKIP
	ENDDO
	=UP_fecha("ARQBKP_A")
	=UP_fecha("ARQBKP_B")
	=UP_fecha("duplicat")
	=UP_fecha("clientes")
	=UP_fecha("clianx_a")
RETURN

**************************************************************

PROCEDURE UL_MNNFE
PARAMETERS LDdtini, LDdtfim, LSdiretorio,LSarqbkp,;
	LFbackup, LFelimina, LFdelFisica

	PRIVATE LNregGeral,LNregLidos,LNpercent
	PRIVATE LFnotaent

	LFnotaent	= NetArq("notaent",m.LFdelFisica) 
	IF (LFnotaent) > 100000 	&& HOUVE FALHA DE ABERTURA
		RETURN(.F.)
	ENDIF
	GO TOP

	IF LFbackup
		SELE notaent
		IF EMPTY(LSarqbkp)
			LStmp = ALLTRIM(LSdiretorio)+ALIAS()
			LStmp2 = ALLTRIM(LSdiretorio)+ALIAS()
		ELSE
			SELE transmit
			SET ORDER TO TAG arquivo
			SEEK "NOTAENT"
			IF !FOUND()
			  	DO OBJ_ALER.SPR WITH ;
			   	"O arquivo de NF.ENTRADA nao esta cadastrado no Arq. "+;
			   	"de Controle de Transmissao. Cadastre e tente Novamente."
				=UP_fecha("notaent",LFnotaent)
				RETURN .F.
		  	ENDIF
			LStmp = ALLTRIM(LSdiretorio)+ALLTRIM(LSarqbkp)
			LStmp2 = LStmp+transmit.chr_ident
			SELE notaent
		ENDIF

		IF FILE(LStmp2+".DBF")
		  DO OBJ_ALER.SPR WITH ;
			   "O arquivo de BACKUP de NF.ENTRADA. Ja Existe. Voce Pode "+;
			   "Desistir ou Acumular os dados no Arquivo."+chr(13)+;
			   "Tecle <ENTER> e Responda a proxima Pergunta: "
		  IF !fox_alert('Arquivo '+LStmp2+' ja existe. Acumular Dados ?')
				=UP_fecha("notaent",LFnotaent)
				RETURN .F.
		  ENDIF
		ELSE
		  COPY STRU TO &LStmp2 WITH CDX
		ENDIF
		SELE 0
		USE &LStmp2 ALIAS ARQBKP_A excl
		SET ORDER TO TAG nota
		***************************************************************
	ENDIF

	SELE notaent
	LNregGeral	=	RECCOUNT()
	LNregLidos	=	0
	LNpercent	=	0
	GO  TOP
 	LFinterrompe =  .F.
 	DO WHILE !EOF() AND  !UPinterrompe(LFinterrompe) 

		LNregLidos	=	LNregLidos + 1
		LNpercent	=	LNregLidos * 100 / LNregGeral
		LStmpmsg	=   "ENTRADAS...[ TOTAL : "+STR(LNregGeral,7)+;
						"   LIDOS...:"+STR(LNregLidos,7)+;
						"   " + STR(LNpercent,3)+"%"
		WAIT WINDOW LStmpmsg NOWAIT
		IF notaent.data < LDdtini OR  notaent.data > LDdtfim
			SKIP 
			LOOP	
		ENDIF

		IF LFbackup
			SELE arqbkp_a
			SET ORDER TO TAG nota
			SEEK STR(m.empresa,3)+STR(m.codforn,5)+STR(m.nota,6)+;
				 m.serie+LEFT(m.tipo,1)
			IF FOUND()		
				=REGLOCK(.T.)
			ELSE
	    	    =ADIREG()
			ENDIF
			GATHER MEMVAR MEMO
		ENDIF
		SELE notaent
		IF LFelimina
			=REGLOCK(.T.)
			=edithand('APAGA')
		ENDIF
		SKIP
	ENDDO
	IF	!LFinterrompe  AND m.LFdelFisica && COMPACTAR ARQUIVO
		WAIT WINDOW "Compactando Arq. NOTAS de ENTRADA " NOWAIT
		SELE notaent
		PACK
	ENDIF
	=UP_fecha("ARQBKP_A")
	=UP_fecha("notaent" ,LFnotaent)
 	IF LFinterrompe 
 		RETURN(.F.)
 	ENDIF
RETURN(.T.)

PROCEDURE UL_MNNFEIT
PARAMETERS LDdtini, LDdtfim, LSdiretorio,LSarqbkp,;
	LFbackup, LFelimina, LFdelFisica

	PRIVATE LNregGeral,LNregLidos,LNpercent
	PRIVATE LFnotaite

							&&	m.LFdelFisica => ABERT EXCLUSIVA
	LFnotaite		= NetArq("notaite",m.LFdelFisica) 
	IF (LFnotaite) > 100000 	&& HOUVE FALHA DE ABERTURA
		RETURN(.f.)
	ENDIF
	GO TOP

	IF LFbackup
		SELE notaite
		IF EMPTY(LSarqbkp)
			LStmp = ALLTRIM(LSdiretorio)+ALIAS()
			LStmp2 = ALLTRIM(LSdiretorio)+ALIAS()
		ELSE
			SELE transmit
			SET ORDER TO TAG arquivo
			SEEK "NOTAITE"
			IF !FOUND()
			  	DO OBJ_ALER.SPR WITH ;
		   	"O arquivo de ITENS NF.ENTRADA nao esta cadastrado no Arq. "+;
			   	"de Controle de Transmissao. Cadastre e tente Novamente."
				=UP_fecha("notaite",LFnotaite)
				RETURN(.F.)
		  	ENDIF
			LStmp = ALLTRIM(LSdiretorio)+ALLTRIM(LSarqbkp)
			LStmp2 = LStmp+transmit.chr_ident
			SELE notaite
		ENDIF

		IF FILE(LStmp2+".DBF")
		  DO OBJ_ALER.SPR WITH ;
	   "O arquivo de BACKUP de ITENS NF.ENTRADA. Ja Existe. Voce Pode "+;
			   "Desistir ou Acumular os dados no Arquivo."+chr(13)+;
			   "Tecle <ENTER> e Responda a proxima Pergunta: "
		  IF !fox_alert('Arquivo '+LStmp2+' ja existe. Acumular Dados ?')
				=UP_fecha("notaite",LFnotaite)
				RETURN(.F.)
		  ENDIF
		ELSE
		  COPY STRU TO &LStmp2 WITH CDX
		ENDIF
		SELE 0

		USE &LStmp2 ALIAS ARQBKP_A excl
		SET ORDER TO TAG chv_bkp
		***************************************************************
	ENDIF

	SELE notaite
	LNregGeral	=	RECCOUNT()
	LNregLidos	=	0
	LNpercent	=	0
	GO  TOP
 	LFinterrompe =  .F.
 	DO WHILE !EOF() AND  !UPinterrompe(LFinterrompe) 

		LNregLidos	=	LNregLidos + 1
		LNpercent	=	LNregLidos * 100 / LNregGeral
		LStmpmsg	=   "ITENS ENTRADAS..[ TOTAL : "+STR(LNregGeral,7)+;
						"   LIDOS...:"+STR(LNregLidos,7)+;
						"   " + STR(LNpercent,3)+"%"
		WAIT WINDOW LStmpmsg NOWAIT
		IF notaite.data < LDdtini OR  notaite.data > LDdtfim
			SKIP 
			LOOP	
		ENDIF
		SCATTER MEMVAR
		IF LFbackup
			SELE arqbkp_a
			SET ORDER TO TAG CHV_BKP
			SEEK STR(m.empresa,3)+STR(m.favorecido,14)+;
				 STR(m.orcamento,6)+STR(m.ordem,2)
			IF FOUND()		
				=REGLOCK(.T.)
			ELSE
	    	    =ADIREG()
			ENDIF
			GATHER MEMVAR MEMO
		ENDIF
		SELE notaite
		IF LFelimina
			=REGLOCK(.T.)
			=edithand('APAGA')
		ENDIF
		SKIP
	ENDDO
	IF	!LFinterrompe  AND m.LFdelFisica && COMPACTAR ARQUIVO
		WAIT WINDOW "Compactando Arq. ITENS NOTAS de ENTRADA " NOWAIT
		SELE notaite
		PACK
	ENDIF
	=UP_fecha("ARQBKP_A")
	=UP_fecha("notaite" ,LFnotaite)
 	IF LFinterrompe 
 		RETURN(.F.)
 	ENDIF
RETURN(.T.)


PROCEDURE UL_MNDPL
	IF !NetUse("duplicat") 
		wp_msg = "Arquivo de Dup. Receber nao pode ser aberto."
		RETURN .F.
	ENDIF
	SET ORDER TO TAG r_dtbaixa

	IF LFbackup
		SELE duplicat
		IF EMPTY(m.arquivo)
			LStmp = ALLTRIM(m.diretorio)+ALIAS()
			LStmp2 = ALLTRIM(m.diretorio)+ALIAS()
		ELSE
			SELE transmit
			SET ORDER TO TAG arquivo
			SEEK "DUPLICAT"
			IF !FOUND()
			  	DO OBJ_ALER.SPR WITH ;
		   	"O arquivo de DUPLICATAS nao esta cadastrado no Arq. "+;
			   	"de Controle de Transmissao. Cadastre e tente Novamente."
				=UP_fecha("duplicat")
				RETURN .F.
		  	ENDIF
			LStmp = ALLTRIM(m.diretorio)+ALLTRIM(m.arquivo)
			LStmp2 = LStmp+transmit.chr_ident
			SELE duplicat
		ENDIF

		IF FILE(LStmp2+".DBF")
		  DO OBJ_ALER.SPR WITH ;
	   "O arquivo de BACKUP de DUPLICATAS. Ja Existe. Voce Pode "+;
			   "Desistir ou Acumular os dados no Arquivo."+chr(13)+;
			   "Tecle <ENTER> e Responda a proxima Pergunta: "
		  IF !fox_alert('Arquivo '+LStmp2+' ja existe. Acumular Dados ?')
				=UP_fecha("duplicat")
				RETURN .F.
		  ENDIF
		ELSE
		  COPY STRU TO &LStmp2 WITH CDX
		ENDIF
		SELE 0
		USE &LStmp2 ALIAS ARQBKP_A excl
		SET ORDER TO TAG doc
		***************************************************************
	ENDIF

	SELE duplicat
	SET ORDER TO TAG  r_dtbaixa
	SET NEAR ON
	SEEK STR(m.empinicio,3)+DTOS(m.dt_dpl)
	SET NEAR OFF

	DO WHILE !EOF() AND m.empinicio = duplicat.empresa ;
					AND duplicat.dt_baixa <= m.dtf_dpl ;
					AND !EMPTY(duplicat.dt_baixa)

		IF LFbackup
			SCATTER MEMVAR
			SELE arqbkp_a
			SEEK STR(m.empresa,3)+STR(m.duplicata,9)
			IF FOUND()		
				=REGLOCK(.T.)
			ELSE
	    	    =ADIREG()
			ENDIF
			GATHER MEMVAR MEMO
		ENDIF
		SELE duplicat
		IF LFelimina
			=REGLOCK(.T.)
			=edithand('APAGA')
		ENDIF
		SKIP
	ENDDO
	=UP_fecha("ARQBKP_A")
	=UP_fecha("duplicat")
RETURN

************************************************************

PROCEDURE UL_MNCCR
	IF !NetUse("retornbc") 
		wp_msg = "Arquivo de Cabecalho de Aviso Banco nao pode ser aberto."
		RETURN .F.
	ENDIF
	SET ORDER TO TAG dt_aviso

	IF LFbackup
		SELE retornbc
		IF EMPTY(m.arquivo)
			LStmp = ALLTRIM(m.diretorio)+ALIAS()
			LStmp2 = ALLTRIM(m.diretorio)+ALIAS()
		ELSE
			SELE transmit
			SET ORDER TO TAG arquivo
			SEEK "RETORNBC"
			IF !FOUND()
			  	DO OBJ_ALER.SPR WITH ;
		   	"O arquivo de RETORNO COBR. nao esta cadastrado no Arq. "+;
			   	"de Controle de Transmissao. Cadastre e tente Novamente."
				=UP_fecha("retornbc")
				RETURN .F.
		  	ENDIF
			LStmp = ALLTRIM(m.diretorio)+ALLTRIM(m.arquivo)
			LStmp2 = LStmp+transmit.chr_ident
			SELE retornbc
		ENDIF

		IF FILE(LStmp2+".DBF")
		  DO OBJ_ALER.SPR WITH ;
	   "O arquivo de BACKUP de RETORNO COBR. Ja Existe. Voce Pode "+;
			   "Desistir ou Acumular os dados no Arquivo."+chr(13)+;
			   "Tecle <ENTER> e Responda a proxima Pergunta: "
		  IF !fox_alert('Arquivo '+LStmp2+' ja existe. Acumular Dados ?')
				=UP_fecha("retornbc")
				RETURN .F.
		  ENDIF
		ELSE
		  COPY STRU TO &LStmp2 WITH CDX
		ENDIF
		SELE 0
		USE &LStmp2 ALIAS ARQBKP_A excl
		SET ORDER TO TAG aviso
		***************************************************************
	ENDIF

	SELE retornbc
	SET ORDER TO TAG  dtprocesso
	SET NEAR ON
	SEEK STR(m.empinicio,3)+DTOS(m.dt_ccr)
	SET NEAR OFF

	DO WHILE !EOF() AND m.empinicio = retornbc.empresa ;
					AND retornbc.dtprocesso <= m.dtf_dpl 

		IF LFbackup
			SCATTER MEMVAR
			SELE arqbkp_a
			SEEK STR(m.empresa,3)+STR(m.banco,3)+STR(m.aviso,8)		
			IF FOUND()		
				=REGLOCK(.T.)
			ELSE
	    	    =ADIREG()
			ENDIF
			GATHER MEMVAR MEMO
		ENDIF
		
		SELE retornbc
		IF LFelimina
			=REGLOCK(.T.)
			=edithand('APAGA')
		ENDIF
		SKIP
	ENDDO
	=UP_fecha("ARQBKP_A")
	=UP_fecha("retornbc")
RETURN

PROCEDURE UL_MNCCRmov
	IF !NetUse("retornmv") 
		wp_msg = "Arquivo de Itens de Aviso Banco nao pode ser aberto."
		RETURN .F.
	ENDIF

	IF LFbackup
		SELE retornmv
		IF EMPTY(m.arquivo)
			LStmp = ALLTRIM(m.diretorio)+ALIAS()
			LStmp2 = ALLTRIM(m.diretorio)+ALIAS()
		ELSE
			SELE transmit
			SET ORDER TO TAG arquivo
			SEEK "RETORNMV"
			IF !FOUND()
			  	DO OBJ_ALER.SPR WITH ;
	   	"O arquivo de ITENS RETORNO COBR. nao esta cadastrado no Arq. "+;
			   	"de Controle de Transmissao. Cadastre e tente Novamente."
				=UP_fecha("retornmv")
				RETURN .F.
		  	ENDIF
			LStmp = ALLTRIM(m.diretorio)+ALLTRIM(m.arquivo)
			LStmp2 = LStmp+transmit.chr_ident
			SELE retornmv
		ENDIF

		IF FILE(LStmp2+".DBF")
		  DO OBJ_ALER.SPR WITH ;
   "O arquivo de BACKUP de ITENS RETORNO COBR. Ja Existe. Voce Pode "+;
			   "Desistir ou Acumular os dados no Arquivo."+chr(13)+;
			   "Tecle <ENTER> e Responda a proxima Pergunta: "
		  IF !fox_alert('Arquivo '+LStmp2+' ja existe. Acumular Dados ?')
				=UP_fecha("retornmv")
				RETURN .F.
		  ENDIF
		ELSE
		  COPY STRU TO &LStmp2 WITH CDX
		ENDIF
		SELE 0
		USE &LStmp2 ALIAS ARQBKP_A excl
		SET ORDER TO TAG lancamento
		***************************************************************
	ENDIF

	SELE retornmv
	SET ORDER TO TAG  dtprocesso
	SET NEAR ON
	SEEK STR(m.empinicio,3)+DTOS(m.dt_ccr)
	SET NEAR OFF


	DO WHILE !EOF() AND m.empinicio = retornmv.empresa ;
					AND retornmv.dtprocesso <= m.dtf_dpl 

		IF LFbackup
			SCATTER MEMVAR
			SELE arqbkp_a

			SEEK STR(m.empresa,3)+STR(m.banco,3)+STR(m.aviso,8)+;
					STR(m.duplicata,9)+STR(m.ocorrencia,2)
			IF FOUND()		
				=REGLOCK(.T.)
			ELSE
    		    =ADIREG()
			ENDIF
			GATHER MEMVAR MEMO
		ENDIF
		SELE retornmv
		IF LFelimina
			=REGLOCK(.T.)
			=edithand('APAGA')
		ENDIF
		SKIP
	ENDDO
	=UP_fecha("ARQBKP_A")
	=UP_fecha("retornmv")
RETURN


PROCEDURE UL_MNSALDO
PARAMETERS LDdtini, LDdtfim, LSdiretorio,LSarqbkp,;
	LFbackup, LFelimina, LFdelFisica

	PRIVATE LNregGeral,LNregLidos,LNpercent
	PRIVATE LFsaldo
							&&	m.LFdelFisica => ABERT EXCLUSIVA
	LFsaldo		= NetArq("saldo",m.LFdelFisica) 
	IF (LFsaldo) > 100000 	&& HOUVE FALHA DE ABERTURA
		RETURN(.f.)
	ENDIF
	GO TOP

	IF LFbackup
		SELE saldo
		IF EMPTY(LSarqbkp)
			LStmp = ALLTRIM(LSdiretorio)+ALIAS()
			LStmp2 = ALLTRIM(LSdiretorio)+ALIAS()
		ELSE
			SELE transmit
			SET ORDER TO TAG arquivo
			SEEK "SALDO"
			IF !FOUND()
			  	DO OBJ_ALER.SPR WITH ;
			   	"O arquivo de SALDO nao esta cadastrado no Arq. "+;
			   	"de Controle de Transmissao. Cadastre e tente Novamente."
				=UP_fecha("saldo")
				RETURN .F.
		  	ENDIF
			LStmp = ALLTRIM(LSdiretorio)+ALLTRIM(LSarqbkp)
			LStmp2 = LStmp+transmit.chr_ident
			SELE saldo
		ENDIF

		IF FILE(LStmp2+".DBF")
		  DO OBJ_ALER.SPR WITH ;
			   "O arquivo de BACKUP de SALDO Ja Existe. Voce Pode "+;
			   "Desistir ou Acumular os dados no Arquivo."+chr(13)+;
			   "Tecle <ENTER> e Responda a proxima Pergunta: "
		  IF !fox_alert('Arquivo '+LStmp2+' ja existe. Acumular Dados ?')
				=UP_fecha("saldo")
				RETURN .F.
		  ENDIF
		ELSE
		  COPY STRU TO &LStmp2 WITH CDX
		ENDIF
		SELE 0
		USE &LStmp2 ALIAS ARQBKP_A excl
		SET ORDER TO TAG emp_mes
		***************************************************************
	ENDIF

	SELE saldo

	LNregGeral	=	RECCOUNT()
	LNregLidos	=	0
	LNpercent	=	0
	GO  TOP
 	LFinterrompe =  .F.
 	DO WHILE !EOF() AND  !UPinterrompe(LFinterrompe) 

		LNregLidos	=	LNregLidos + 1
		LNpercent	=	LNregLidos * 100 / LNregGeral
		LStmpmsg	=   "SALDOS...[ TOTAL : "+STR(LNregGeral,7)+;
						"   LIDOS...:"+STR(LNregLidos,7)+;
						"   " + STR(LNpercent,3)+"%"
		WAIT WINDOW LStmpmsg NOWAIT
		IF saldo.dtabert < LDdtini OR  saldo.dtabert > LDdtfim
			SKIP 
			LOOP	
		ENDIF

		SCATTER MEMVAR
		IF LFbackup
			SELE arqbkp_a
			SET ORDER TO TAG emp_mes
			SEEK STR(m.empresa,3)+STR(YEAR(m.dtabert),4)+;
				  STR(MONTH(m.dtabert),2)+m.classifica
			IF FOUND()		
				=REGLOCK(.T.)
			ELSE
	    	    =ADIREG()
			ENDIF
			GATHER MEMVAR MEMO
		ENDIF

		SELE saldo
		IF LFelimina
			=REGLOCK(.T.)
			=edithand('APAGA')
		ENDIF
		SKIP
	ENDDO
	IF	!LFinterrompe  AND m.LFdelFisica && COMPACTAR ARQUIVO
		WAIT WINDOW "Compactando Arq. SALDOS " NOWAIT
		SELE saldo
		PACK
	ENDIF
	=UP_fecha("ARQBKP_A")
	=UP_fecha("saldo" ,LFsaldo)
 	IF LFinterrompe 
 		RETURN(.F.)
 	ENDIF
RETURN(.T.)





PROCEDURE UL_MNtbp
	IF !NetUse("preco") 
		wp_msg = "Arq.de Tab. Preco nao pode ser aberto."
		RETURN .F.
	ENDIF

	IF LFbackup
		SELE preco
		IF EMPTY(m.arquivo)
			LStmp = ALLTRIM(m.diretorio)+ALIAS()
			LStmp2 = ALLTRIM(m.diretorio)+ALIAS()
		ELSE
			SELE transmit
			SET ORDER TO TAG arquivo
			SEEK "PRECO"
			IF !FOUND()
			  	DO OBJ_ALER.SPR WITH ;
			   	"O arquivo de PRECO nao esta cadastrado no Arq. "+;
			   	"de Controle de Transmissao. Cadastre e tente Novamente."
				=UP_fecha("preco")
				RETURN .F.
		  	ENDIF
			LStmp = ALLTRIM(m.diretorio)+ALLTRIM(m.arquivo)
			LStmp2 = LStmp+transmit.chr_ident
			SELE preco
		ENDIF

		IF FILE(LStmp2+".DBF")
		  DO OBJ_ALER.SPR WITH ;
			   "O arquivo de BACKUP de PRECO Ja Existe. Voce Pode "+;
			   "Desistir ou Acumular os dados no Arquivo."+chr(13)+;
			   "Tecle <ENTER> e Responda a proxima Pergunta: "
		  IF !fox_alert('Arquivo '+LStmp2+' ja existe. Acumular Dados ?')
				=UP_fecha("preco")
				RETURN .F.
		  ENDIF
		ELSE
		  COPY STRU TO &LStmp2 WITH CDX
		ENDIF
		SELE 0
		USE &LStmp2 ALIAS ARQBKP_A excl
		SET ORDER TO TAG tabela
		***************************************************************
	ENDIF

	SELE preco
	SET ORDER TO TAG  tabela
	SET NEAR ON
	SEEK STR(m.empinicio,3)+STR(m.mmaa_tbp,3)
	SET NEAR OFF

	DO WHILE !EOF() AND m.empinicio = preco.empresa ;
					AND preco.tabpreco = m.mmaa_tbp

		SCATTER MEMVAR
		SELE arqbkp_a

		SEEK STR(m.empresa,3)+STR(m.tabpreco,3)+m.serie+m.codigo
		
		IF FOUND()		
			=REGLOCK(.T.)
		ELSE
    	    =ADIREG()
		ENDIF
		GATHER MEMVAR MEMO

		SELE preco
		IF LFelimina
			=REGLOCK(.T.)
			=edithand('APAGA')
		ENDIF
		SKIP
	ENDDO
	=UP_fecha("ARQBKP_A")
	=UP_fecha("preco")
RETURN

