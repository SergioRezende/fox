

SELECT CLIE.CLIENTE, CLIE.NOME, CLIE.CREDITO, SUM(DUPL.VLR_DOC) AS DEBITO  ;
    FROM q:\scgc\loja\CLIENTES CLIE, q:\scgc\loja\DUPLICAT DUPL ;
    WHERE CLIE.CLIENTE IN ;
	    	(SELECT CLNC.CLIENTE AS CLIENTE  ;
			    	FROM q:\scgc\loja\orcament ORCA,q:\scgc\loja\CLIENC CLNC ;
					WHERE ORCA.dt_fat = {05.02.2002} ;
    	    			  AND (ORCA.TP_PARCELA = 2 OR ORCA.TP_PARCELA = 3) ;
			        	  AND ORCA.EMPRESA = CLNC.EMPRESA AND ORCA.ORCAMENTO= CLNC.ORCAMENTO);
		  AND CLIE.CLIENTE = DUPL.CLIENTE AND EMPTY(DUPL.DT_BAIXA);
	GROUP BY CLIE.CLIENTE


	
SELECT CLIE.CLIENTE, CLIE.NOME, CLIE.CREDITO,DUPL.DUPLICATA, DUPL.VLR_DOC, DUPL.DT_VENC,DUPL.TP_COBRANC  ;
    FROM q:\scgc\loja\CLIENTES CLIE, q:\scgc\loja\DUPLICAT DUPL ;
    WHERE CLIE.CLIENTE IN ;
			(SELECT DUPL.CLIENTE FROM q:\scgc\loja\DUPLICAT DUPL ;
			   WHERE DUPL.CLIENTE IN ;
			    	(SELECT CLNC.CLIENTE AS CLIENTE  ;
				    	FROM q:\scgc\loja\orcament ORCA,q:\scgc\loja\CLIENC CLNC ;
						WHERE ORCA.dt_fat = {05.02.2002} ;
    	    				  AND (ORCA.TP_PARCELA = 2 OR ORCA.TP_PARCELA = 3) ;
			    	    	  AND ORCA.EMPRESA = CLNC.EMPRESA AND ORCA.ORCAMENTO= CLNC.ORCAMENTO);
		                      AND (DUPL.DT_VENC < DATE() ;
                                   OR DUPL.TP_COBRANC = 88 ;
                                   OR CLIE.CREDITO < (SELECT SUM(DUPL.VLR_DOC) FROM ;
                                                       q:\scgc\loja\DUPLICAT DUPL WHERE EMPTY(DUPL.DT_BAIXA) AND CLIE.CLIENT = DUPL.CLIENTE );
                     );
              );                    
		  AND CLIE.CLIENTE = DUPL.CLIENTE AND EMPTY(DUPL.DT_BAIXA);
	ORDER BY CLIE.CLIENTE,DUPL.DT_VENC,DUPL.DUPLICATA
	
          



**********
SELECT CLNC.CLIENTE AS CLIENTE  ;
    	FROM q:\scgc\loja\orcament ORCA,q:\scgc\loja\CLIENC CLNC ;
		WHERE ORCA.dt_fat = {05.02.2002} ;
   				  AND (ORCA.TP_PARCELA = 2 OR ORCA.TP_PARCELA = 3) ;
    	    	  AND ORCA.EMPRESA = CLNC.EMPRESA AND ORCA.ORCAMENTO= CLNC.ORCAMENTO);
                  AND (DUPL.DT_VENC < DATE() OR DUPL.TP_COBRANC = 88 ;
                      OR CLIE.CREDITO < (SELECT SUM(DUPL.VLR_DOC) FROM ;
                       q:\scgc\loja\DUPLICAT DUPL WHERE EMPTY(DUPL.DT_BAIXA) AND CLIE.CLIENT = DUPL.CLIENTE );
*--------------------------------------------------------------------------*
* CLIENTES COM LIMITE INFERIOR AO DEBITO ou COM ATRAZO OU COM PROTESTO
*--------------------------------------------------------------------------*
(SELECT CLIE.CLIENTE ;
		FROM Q:\SCGC\LOJA\CLIENTES CLIE, Q:\SCGC\LOJA\DUPLICAT DUPL  ;
		WHERE  ;
				CLIE.CREDITO < (SELECT SUM(DUPL.VLR_DOC) ;
								FROM q:\scgc\loja\DUPLICAT DUPL ;
								WHERE EMPTY(DUPL.DT_BAIXA) AND DUPL.CLIENTE = CLIE.CLIENTE  );
                AND;
                    DUPL.CLIENTE = CLIE.CLIENTE AND (DUPL.DT_VENC < DATE() OR DUPL.TP_COBRANC = 88))

*--------------------------------------------------------------------------*
* CLIENTES     COM LIBERACAO NO PERIODO 
*           E  (COM LIMITE INFERIOR AO DEBITO 
*                  OU COM ATRAZO OU COM PROTESTO)
*--------------------------------------------------------------------------*
SELECT CLIE.CLIENTE, CLIE.NOME, CLIE.CREDITO,DUPL.DUPLICATA, DUPL.VLR_DOC, DUPL.DT_VENC,DUPL.TP_COBRANC  ;
    FROM q:\scgc\loja\CLIENTES CLIE, q:\scgc\loja\DUPLICAT DUPL ;
    WHERE CLIE.CLIENTE IN ;
(SELECT CLIE.CLIENTE ;
		FROM Q:\SCGC\LOJA\CLIENTES CLIE, q:\scgc\loja\DUPLICAT DUPL  ;
		WHERE  ;
				CLIE.CLIENTE IN ;
					(  	SELECT CLNC.CLIENTE AS CLIENTE  ;
					    	FROM q:\scgc\loja\orcament ORCA,q:\scgc\loja\CLIENC CLNC ;
							WHERE 	   ORCA.dt_fat >= {05.02.2002} ;
							      AND  ORCA.dt_fat <= {05.02.2002} ;
    			    			  AND (ORCA.TP_PARCELA = 2 OR ORCA.TP_PARCELA = 3) ;
			    		    	  AND ORCA.EMPRESA = CLNC.EMPRESA AND ORCA.ORCAMENTO = CLNC.ORCAMENTO;
					);
				AND CLIE.CREDITO < (SELECT SUM(DUPL.VLR_DOC) ;
								FROM q:\scgc\loja\DUPLICAT DUPL ;
								WHERE EMPTY(DUPL.DT_BAIXA) AND DUPL.CLIENTE = CLIE.CLIENTE  );
                AND;
                    DUPL.CLIENTE = CLIE.CLIENTE AND (DUPL.DT_VENC < DATE() OR DUPL.TP_COBRANC = 88);
 );
    AND CLIE.CLIENTE = DUPL.CLIENTE AND EMPTY(DUPL.DT_BAIXA);
ORDER BY CLIE.CLIENTE,DUPL.DT_VENC,DUPL.DUPLICATA
 



****
SELECT CLIE.CLIENTE, CLIE.NOME, CLIE.CREDITO, DUPL.DUPLICATA ;
    FROM q:\scgc\loja\CLIENTES CLIE, q:\scgc\loja\DUPLICAT DUPL ;
		WHERE ;
			CLIE.CLIENTE IN (SELECT CLNC.CLIENTE AS CLIENTE  ;
					    	FROM q:\scgc\loja\orcament ORCA,q:\scgc\loja\CLIENC CLNC ;
							WHERE 	   ORCA.dt_fat >= {05.02.2002} ;
							      AND  ORCA.dt_fat <= {05.02.2002} ;
    			    			  AND (ORCA.TP_PARCELA = 2 OR ORCA.TP_PARCELA = 3) ;
			    		    	  AND ORCA.EMPRESA = CLNC.EMPRESA AND ORCA.ORCAMENTO = CLNC.ORCAMENTO;
					         );
				AND( CLIE.CREDITO < (SELECT SUM(DUPL.VLR_DOC) ;
								FROM q:\scgc\loja\DUPLICAT DUPL ;
								WHERE EMPTY(DUPL.DT_BAIXA) AND DUPL.CLIENTE = CLIE.CLIENTE ;
								     );
                    OR  0 < (SELECT COUNT(*) ;
								 FROM q:\scgc\loja\DUPLICAT DUPL ;
								 WHERE DUPL.CLIENTE = CLIE.CLIENTE ;
								       AND EMPTY(DUPL.DT_BAIXA);
					    		       AND (DUPL.DT_VENC < DATE() OR DUPL.TP_COBRANC = 88);
                             );
                   );
 );
    AND CLIE.CLIENTE = DUPL.CLIENTE AND EMPTY(DUPL.DT_BAIXA);
ORDER BY CLIE.CLIENTE,DUPL.DT_VENC,DUPL.DUPLICATA


SELECT CLIE.CLIENTE, CLIE.NOME, CLIE.CREDITO, DUPL.DUPLICATA ;
    FROM q:\scgc\loja\CLIENTES CLIE, q:\scgc\loja\DUPLICAT DUPL ;
		WHERE;
			CLIE.CLIENTE IN (SELECT CLNC.CLIENTE AS CLIENTE  ;
					    	FROM q:\scgc\loja\orcament ORCA,q:\scgc\loja\CLIENC CLNC ;
							WHERE 	   ORCA.dt_fat >= {05.02.2002} ;
							      AND  ORCA.dt_fat <= {05.02.2002} ;
    			    			  AND (ORCA.TP_PARCELA = 2 OR ORCA.TP_PARCELA = 3) ;
			    		    	  AND ORCA.EMPRESA = CLNC.EMPRESA AND ORCA.ORCAMENTO = CLNC.ORCAMENTO;
					         );
            AND ( ;
			       		(CLIE.CLIENTE IN ;
					 		 (SELECT DUPL.CLIENTE ;
								 FROM q:\scgc\loja\DUPLICAT DUPL ;
								 WHERE DUPL.CLIENTE = CLIE.CLIENTE ;
								       AND EMPTY(DUPL.DT_BAIXA);
				    		       AND (DUPL.DT_VENC < DATE() OR DUPL.TP_COBRANC = 88); 			
                             );
                         );
                    OR ;
                        (CLIE.CREDITO < (SELECT SUM(DUPL.VLR_DOC) ;
											FROM q:\scgc\loja\DUPLICAT DUPL ;
											WHERE EMPTY(DUPL.DT_BAIXA) AND DUPL.CLIENTE = CLIE.CLIENTE ;
                                        );
						);                     
			     ) ;
		    AND  clie.cliente = dupl.cliente 
****
*-------------------------------------------------------------*
SELECT CLNC.CLIENTE AS CLIENTE  ;
   	FROM q:\scgc\loja\orcament ORCA,q:\scgc\loja\CLIENC CLNC ;
	WHERE  		ORCA.dt_fat >= {05.02.2002} ;
		AND  ORCA.dt_fat <= {05.02.2002} ;
    	AND (ORCA.TP_PARCELA = 2 OR ORCA.TP_PARCELA = 3) ;
		AND ORCA.EMPRESA = CLNC.EMPRESA AND ORCA.ORCAMENTO = CLNC.ORCAMENTO;
		into table c:\tmp\ATENDIDO

SELECT CLIE.CLIENTE, CLIE.NOME, CLIE.CREDITO ;
   	FROM q:\scgc\loja\CLIENTES  CLIE,;
   		 c:\tmp\ATENDIDO        ATDO ;
	WHERE       CLIE.CLIENTE = ATDO.CLIENTE ;
	       AND (;     
	                  (CLIE.CREDITO < (SELECT SUM(DUPL.VLR_DOC) ;
				   	  	    	 		FROM q:\scgc\loja\DUPLICAT DUPL ;
								    	WHERE EMPTY(DUPL.DT_BAIXA) AND DUPL.CLIENTE = CLIE.CLIENTE ;
                                     );
	                   );
	               OR ;
	       		       (CLIE.CLIENTE IN ;
					 		 (SELECT DUPL.CLIENTE ;
								 FROM q:\scgc\loja\DUPLICAT DUPL ;
								 WHERE DUPL.CLIENTE = CLIE.CLIENTE ;
								       AND EMPTY(DUPL.DT_BAIXA);
				    		       AND (DUPL.DT_VENC < DATE() OR DUPL.TP_COBRANC = 88); 			
                             );
                         );
                );
		into table c:\tmp\SELECAO
                
SELECT CLIE.CLIENTE, CLIE.NOME, CLIE.CREDITO,DUPL.DUPLICATA, DUPL.VLR_DOC, DUPL.DT_VENC,DUPL.TP_COBRANC  ;
    FROM c:\tmp\SELECAO CLIE, q:\scgc\loja\DUPLICAT DUPL ;
    WHERE       CLIE.CLIENTE = DUPL.CLIENTE ;
           AND  EMPTY(DUPL.DT_BAIXA);
	ORDER BY CLIE.NOME, CLIE.CLIENTE,DUPL.DT_VENC,DUPL.DUPLICATA
