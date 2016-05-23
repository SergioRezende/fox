
set date german
set centu on
set excl off
m.dt_inicio = {01.07.2002}
m.dt_fim    = {15.07.2002}
m.ordem_ini  = 140
m.ordem_fim  = 500
m.LNfilial  = 1

  SELECT  GR.CODIGO,GR.DESCRICAO AS PRODUTO,;
          LEFT(tb.DESCRICAO,15) AS DESCRICAO,;
          SUM(mv.QTDE) AS QTDE ,;
          SUM(mv.VLRVENDA) AS VALOR;
      FROM  q:\scgc\comum\grupo  GR,;
      		q:\scgc\loja\ITEMMOV MV,;
	        q:\scgc\comum\tab001 TB ;
	     WHERE ;
	     		  gr.ordem >= m.ordem_ini;
	     	  AND gr.ordem <= m.ordem_fim;
	     	  AND mv.data  >= m.dt_inicio ;
		      AND mv.data  <=  m.dt_fim ;
           	  AND mv.empresa = LNfilial ;
           	  AND gr.codigo = mv.codigo ;
    		  AND (;
 			      	(left(mv.operacao,1) = "S" AND mv.ch_opera = "1")  ;
 			      );
 			  AND tb.tabela = "NTZ" ;
 			  AND CHRTRAN(STR(mv.NATU_CLI,1)," ","0") = TB.codigo;
		 ORDE  BY GR.CODIGO,tb.DESCRICAO ;
		 GROUP BY GR.CODIGO,tb.DESCRICAO ;
         INTO CURSOR TMP_ITEM
brows
