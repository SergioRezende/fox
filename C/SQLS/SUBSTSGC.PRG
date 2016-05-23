

   =ESextrato(1,"14010216",{01.06.2004},{01.06.2999})
RETURN

FUNCTION ESextrato
PARAMETERS PrmEmpresa,PrmCodigo,PrmDtIni,PrmDtFim

	CLOSE DATABASE

	PrmCodigo = LEFT(PrmCodigo+space(11),11)


	PRIVATE LSAlias
	PRIVATE ARQ_Empresa,ALS_Empresa,ARQ_Itemmov,ALS_Itemmov

	LSAlias = Alias()

    ARQ_Empresa     = NetArqAgain("EMPRESA")
    ALS_Empresa     = Alias()

    ARQ_Itemmov     = NetArqAgain("EMPRESA")
    ALS_Itemmov     = Alias()

	=UPopentmp("",ARQ_tmp,ALS_tmp)

	SELE &ALS_Itemmov
	SET ORDER TO TAG MOVIMENTO 

	SET NEAR ON
	SEEK STR(PrmEmpresa,3)+PrmCodigo+DTOS(PrmDtIni)
	SET NEAR OFF

	IF PrmEmpresa <> empresa OR PrmCodigo <> codigo 
		SKIP -1
	ENDIF

	COPY TO &ARQ_tmp WITH CDX ;
		WHILE EMPRESA = 1 ;
		      AND CODIGO = PrmCodigo;
		      AND DATA   <= PrmDtFim

	SELECT  data, ;
			left(hora,5) AS HORA,;
			IIF(nota <> 0,"NF"+STR(nota,7),LEFT(TIPO,2)+STR(orcamento,6)) as doc,;
			operacao, ;
			tipo,;
			IIF(LEFT(OPERACAO,1)="S",qtde*(-1),qtde) AS QTDE,;
			sld_estq  AS SALDO, ;
			sld_rese  AS SALDORES,;
			IIF(sld_estq > 0,vlr_estq / sld_estq,0) AS cst_medio,;
			IIF(qtde > 0,vlrvenda / Qtde,vlrvenda) as VALOR_UNI, ;
			ULOrigDest(favorecido) AS ORIGEM,;
			IIF(negociacao = 2,"S"," ") AS vdcasada;
	FROM &ARQ_tmp ;
	ORDER BY DATA,HORA ;
	INTO CURSOR EXTRATO

	SET CENTUR OFF
	BROWSE  FIELDS ;
			DATA		:H="DATA" :R,;
			HORA		:H="HORA"  :R,;
			DOC			:H="DOC" :R,;
			OPERACAO 	:H="OPER" :R,;
			TIPO	 	:H="TIP" :R,;
			QTDE     	:H="QTDE"	:P="@r ####9" :R,;
			SALDO    	:H="SALDO"	:P="@r ####9" :R,;
			SALDORES 	:H="RES"	:P="@r ####9" :R, ;
			CST_MEDIO	:H="CST.M"	:P="@r ###9.99" :R, ;
			VALOR_UNI	:H="R$.UNI"	:P="@r ####9.99" :R, ;
			ORIGEM		:H="O/D"  :R,;
			vdcasada    :H="ENCOMENDA" :R;
			TITLE "[ MOVIMENTACAO DO PRODUTO ]";
			COLOR SCHEME 10 ;
			  NODELETE NOAPPEND NORMAL  NOEDIT
	SET CENTUR ON

    =up_fecha("&ALS_empresa")
    =up_fecha("&ALS_itemmov")
    =up_fecha("EXTRATO")
    =up_fecha("&ALS_Tmp")
	IF !EMPTY(LSalias) AND USED(LSalias)
		SELECT &LSalias
	ENDIF
	 
RETURN

FUNCTION ULOrigDest
PARAMETERS PrmCGC
	PRIVATE LSalias,LSsigla
	LSalias = Alias()
	IF EMPTY(PrmCGC)
		RETURN("  ")
	ENDIF

	SELECT &ALS_empresa
	SET ORDER TO TAG CGC
	SEEK PrmCGC
	IF FOUND()
		LSsigla = empresa.sigla
	else
		LSsigla = "   "
	ENDIF	
	SELE &LSalias
RETURN(LSsigla)
