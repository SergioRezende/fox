*------------------------------------------------------------*
LSalias		= ALIAS()
LFpedido 	= NetArq("pedido") 
LFpedite 	= NetArq("pedite") 
LFnotaent 	= NetArq("notaent") 
LFnotaite  	= NetArq("notaite") 
*------------------------------------------------------------*
IF (LFpedido+LFpedite+LFnotaent+LFnotaite) > 100000 
  	WAIT WINDOW "(ESversaldo)- Falha Abertura de Tabelas.<ENTER>" 
	RETURN(.f.)
ENDIF


SET STEP ON

SELE NOTAENT
SET ORDER TO TAG PEDIDO 

SELE NOTAITE
SET ORDER TO TAG orcamento

SELE notaent

SET NEAR ON 
SEEK 4800
SET NEAR OFF

DO WHILE !EOF() AND notaent.pedido = 4800
	SELECT  notaite
	SET ORDER TO TAG orcamento
	SEEK STR(notaent.empresa,3)+STR(notaent.referencia,6)+;
		   STR(notaent.codforn,5)+STR(notaent.nota,6)+;
		   notaent.serie+LEFT(notaent.tipo,1)

	DO WHILE !EOF() ;
			AND notaent.empresa 		= notaite.EMPRESA ;
			AND notaent.referencia 		= notaite.orcamento ;
			AND notaent.codforn 	 	= notaite.codforn ;
			AND notaent.nota 			= notaite.nota ;
			AND notaent.serie			= notaite.serie ;
			AND LEFT(notaent.tipo,1)  	= LEFT(notaite.tipo,1)

		DO CASE
			 CASE  LEFT(notaent.situacao,1) = "B"
				 =W_DEFPROC("PEDIDO.SPR")
				 =PDregistra_qte(notaent.empresa,notaent.pedido,notaite.codigo,;
							notaite.qtde,"REG.TRANSITO")
			 CASE  LEFT(notaent.situacao,1) = "C"
				  =W_DEFPROC("PEDIDO.SPR")
				  =PDregistra_qte(notaent.empresa,notaent.pedido,notaite.codigo,;
				  		    notaite.qtde,"REG.ENTRADA")
		ENDCASE		
		SELE notaite
		skip
	ENDDO
	SELE notaent
	skip
ENDDO
