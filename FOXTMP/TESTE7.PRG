    SELECT empresa,codigo,classifica, ;
    		   operacao,movestq,data, ;
    		   descricao,qtde ;
         FROM 	ITEMMOV ;
         WHERE    data 	>=  m.dt_inicio ;
		      AND data    <=  m.dt_fim ;
           	  AND empresa = m.empresa ;
           	  AND LEFT(classifica,2) = m.GRUPO_SEL;
    		  AND (;
    		  		(left(operacao,1) = "E" AND movestq = "S")  ;
    		  		OR ;
 			      	(left(operacao,1) = "S" AND movestq = "S")  ;
 			      );
		 ORDE BY classifica ;
         INTO CURSOR TMP_ITEM
SELECT *, QTDE AS ENTRADA, 0 AS SAIDA  FROM TMP_ITEM;
    WHERE (left(operacao,1) = "E" AND movestq = "S")  
