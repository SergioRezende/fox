
return
*---------------------------------------------------------------*


FUNCTION NFLinhaProd
PARAMETERS PrmLinha



PRIVATE Linha,LScodigo,LsDescricao,LNQtde,LNvlrUnit,LNAlqIPI


LScodigo    = IIF(LEFT(itnfstmp.codigo,5)="99999",;
              SPACE(8), LEFT(itnfstmp.codigo,8))

LsDescricao = (UPClasNbm((wp_empresa),(itnfstmp.codigo), ;
		 	  (itnfstmp.origem) ,;
		 	  (RTRIM(itnfstmp.descricao)+RTRIM(itnfstmp.descrcompl));
		 	  ))
LsDescricao = LEFT(LsDescricao+SPACE(28),28)

LNQtde      = IIF(tipooper.ch_opera = "1" AND ;
              tipooper.ch_motiv = "3" ,0,itnfstmp.qtde)

IF itnfstmp.qtde = 0
	LNvlrUnit   = 0
ELSE
	LNvlrUnit   = itnfstmp.vlrvenda/ itnfstmp.qtde
	LNvlrUnit   = INT(LNvlrUnit * 100)/100
ENDIF


LNAlqICMS   = IIF(itnfstmp.cst $ "012",INT(itnfstmp.aliq_icms),0)
LNAlqIPI    = IIF(itnfstmp.vlripi > 0,INT(itnfstmp.aliq_ipi),0)



LSCst = IIF(EMPTY(itnfstmp.cst),"   ","0"+CHRTRAN(itnfstmp.cst," ","0")+"0")



DO CASE

	CASE itnfstmp.CENTROCUST  = "PRODUT" && LINHA DA GRID  DE PRODUTO
		Linha = ;
			LScodigo;
		   +space(1);
		   +LsDescricao;
		   +space(5);
		   +itnfstmp.cfo;
		   +space(3);
		   +LSCst;
		   +space(2);
		   +itnfstmp.unidade;
		   +space(6);
		   +TRANSFORM(LNqtde,"@Z 99999") ;
		   +space(2);
		   +TRANSFORM(LNvlrUnit,"@Z 99,999.99") ;
		   +space(5);
		   +TRANSFORM(itnfstmp.vlrvenda,"@Z 999,999.99") 
		   
		Linha = Linha ;
		   +space(1);
		   +TRANSFORM(LNAlqICMS,"@Z 99") ;
		   +space(4);
		   +TRANSFORM(LNAlqIPI,"@Z 99") 

	CASE itnfstmp.CENTROCUST  = "MSG-01"
		Linha = ;
			orc_anex.mens3
	CASE itnfstmp.CENTROCUST  = "MSG-02"
		Linha = ;
			orc_anex.mens1
	CASE itnfstmp.CENTROCUST  = "MSG-03"
		Linha = ;
			orc_anex.mens2
	CASE itnfstmp.CENTROCUST  = "SERVIC" && LINHA DA GRID  DESERVICO
	
		Linha = ;
			LScodigo;
		   +space(1);
		   +LsDescricao;
		   +space(19);
		   +itnfstmp.cfo;
		   +space(2);
		   +LSCst;
		   +space(3);
		   +itnfstmp.unidade;
		   +space(3);
		   +TRANSFORM(LNqtde,"@Z 99999") ;
		   +space(2);
		   +TRANSFORM(LNvlrUnit,"@Z 99,999.99") 

		Linha = Linha ;
		   +space(3);
		   +TRANSFORM(itnfstmp.vlrvenda,"@Z 999,999.99") 

	OTHERWISE
		LINHA = " "
ENDCASE


RETURN(Linha)




