   SET DATE GERMAN
   SET CENTU ON
   
 
   SET DELE ON

   SET STEP ON 
   on error


   CLOSE DATA
   SET DATE GERMAN
   SET CENTU ON
   

   SET NEAR ON   
   SELE 0
   use x:\scgc\anp2013\itcomiss
   SET ORDER TO TAG MOVIMENTO
   SEEK STR(14,3)+STR(1161,4)
   

   SET NEAR OFF   

	SELE itcomiss
	WAIT WINDOW "Aguarde. Gerando Arq. Temporario " NOWAIT



	COPY TO X:\TMP\WILKER FOR 1161 = itcomiss.vendedor ;
			 WHILE 1161 = itcomiss.vendedor AND 14 = empresa 
	WAIT WINDOW "OK ! " NOWAIT



    SELE 0 
    USE X:\TMP\WILKER exclu    
	INDEX ON STR(vendedor,4)+STR(NOTA,7) TAG tmp ADDITIVE
	SET ORDER TO TAG tmp
	GO TOP
*******************
    SELE 0 
	USE Q:\SCGC\LOJA\empresa
	SET ORDER TO TAG empresa

    SELE 0 
	USE Q:\SCGC\COMUM\tab001
	SET ORDER TO TAG codigo

	SELE 0 
	USE Q:\SCGC\COMUM\funcao 
	SET ORDER TO TAG nivel

    SELE 0 
	USE Q:\SCGC\COMUM\grupo
	SET ORDER TO TAG classifica

    SELE 0 
	USE Q:\SCGC\COMUM\usuario
	SET ORDER TO TAG usuario
	SET RELATION TO nivel_com  INTO funcao 

    SELE 0 
	USE x:\scgc\anp2013\nota
	SET ORDER TO TAG nota

    SELE 0 
	USE x:\scgc\anp2013\itemmov
	SET ORDER TO TAG movimento

	SET RELATION TO "NTZ"+CHRTRAN(STR(natu_cli,1)," ","0") ;
							INTO tab001 ADDITIVE

	SELE WILKER
	SET RELATION TO vendedor INTO usuario 
	SET RELATION TO classifica INTO grupo ADDITIVE
	SET RELATION TO STR(EMPRESA,3)+STR(NOTA,7) INTO nota ADDITIVE
	SET RELATION TO EMPRESA INTO empresa ADDITIVE
	SET RELATION TO ;
	 			STR(EMPRESA,3)+CODIGO+DTOS(DATA)+HORA+TIPO+;
				STR(NOTA,7)+STR(ORDEM,3) INTO itemmov ADDITIVE

   COPY  FIELDS ;
      WILKER.vendedor,;
      funcao.nivel,;
      WILKER.data,;
      WILKER.nota,;
      WILKER.TIPO,;
      nota.nome,;
      itemmov.prazomedio,;
      WILKER.CLAS_CMS,;
      WILKER.codigo,;
      grupo.descricao,;
      itemmov.qtde,;
      itemmov.preco,;
      itemmov.desconto,;
      WILKER.motivo,;
      itemmov.vlrvenda,;
      WILKER.valor,;
      WILKER.comissao;
      TO ;
   X:\TMP\WANP2013
   


return   


