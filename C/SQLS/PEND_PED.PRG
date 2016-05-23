PROCEDURE PDImpPendPedido

	PRIVATE LSAlias
	PRIVATE ARQ_Empresa,ALS_Empresa,ARQ_Grupo,ALS_Grupo
	PRIVATE ARQ_TabForn,ALS_TabForn,ARQ_PedIte,ALS_Pedite

	LSAlias = Alias()

    ARQ_Empresa     = NetArqAgain("EMPRESA")
    ALS_Empresa     = Alias()

    ARQ_Grupo       = NetArqAgain("GRUPO")
    ALS_Grupo       = Alias()

    ARQ_TabForn     = NetArqAgain("TABFORN")
    ALS_TabForn     = Alias()

    ARQ_PedIte      = NetArqAgain("PEDITE")
    ALS_Pedite      = Alias()

	IF (ARQ_empresa+ARQ_Grupo+ARQ_TabForn+ARQ_Pedite) > 100000 ;
							&& HOUVE FALHA DE ABERTURA
	    =up_fecha("&ALS_empresa")
	    =up_fecha("&ALS_grupo")
	    =up_fecha("&ALS_TabForn")
	    =up_fecha("&ALS_Pedite")
		IF !EMPTY(LSalias) AND USED(LSalias)
			SELECT &LSalias
		ENDIF
		RETURN
	ENDIF

	SELECT pd.empresa as filial, ;
	   lj.sigla,;
	   pd.data,;
	   pd.codigo,;
	   tb.cdgprdforn,;
	   grp.ordem,;
	   grp.descricao,;
	   pd.situacao,;
	   pd.pedido,;
	   pd.qtde     AS QtdPedida,;
	   pd.qtdeatd  AS QtAtendida,;
	   pd.qtdetr   AS QtTransito,;
	   (pd.qtde - pd.qtdeatd - pd.qtdetr) AS QtdPendente  ;
	FROM ;   
      &ALS_Empresa lj ,;
      &ALS_Grupo grp, ;
      &ALS_TabForn tb ,;
      &ALS_Pedite pd;
	WHERE ;
		  lj.empresa = pd.empresa ;
	  AND grp.codigo = pd.codigo ;
	  AND LEFT(grp.classifica,2) $ "00";
	  AND tb.codforn = pd.codforn ;
	  AND tb.codigo  = pd.codigo ;
	  AND (pd.qtde - pd.qtdeatd - pd.qtdetr) > 0 ;
	  AND LEFT(pd.SITUACAO,1) = "B" ;   
	ORDER BY pd.EMPRESA,grp.ordem,pd.CODIGO,pd.PEDIDO

	*--------------------------------------------------------------*
	*	modif report q:\fpd26\prog\sqls\rpendped
	* 	report form q:\fpd26\prog\sqls\rpendped to file l:\tmp\prt0001x.rel
	*--------------------------------------------------------------*

	DO UPPreImpressao WITH  "rpendped", .T. , .F., .T.

	*--------------------------------------------------------------*
    =up_fecha("&ALS_empresa")
    =up_fecha("&ALS_grupo")
    =up_fecha("&ALS_TabForn")
    =up_fecha("&ALS_Pedite")
	IF !EMPTY(LSalias) AND USED(LSalias)
		SELECT &LSalias
	ENDIF

	
RETURN
