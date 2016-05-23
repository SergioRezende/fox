	SELECT empresa,duplicata,dt_emi,dt_pgto,vlr_doc,vlr_pgto,;
	       ((vlr_pgto - (vlr_doc + mora + juros + out_credt ;
	      				- devolucao - abatimento - desconto))) as DIFERENCA,;
    	    mora,juros,out_credt, ;
       		devolucao,abatimento , desconto, nome ;
		FROM  q:\scgc\loja\duplicat ;
		WHERE  ;
			   dt_emi > {01.01.2000};
		       AND ;
		       (;
				    (dt_pgto = {} ;
				       AND (vlr_pgto <> parc_pgto);
				    );
			    OR (;
					 (dt_pgto > {} ;
					   AND abs(vlr_pgto - (vlr_doc + mora + juros + out_credt ;
	      				- devolucao - abatimento - desconto)) > 2;
				     );
		           );  
		        );
		 ORDER BY empresa, dt_emi;
		INTO CURSOR DPL_BUG




    SELE 0
	USE Q:\SCGC\LOJA\DUPLICAT
	SET ORDER TO TAG DOC


	SELECT DPL_BUG
	GO TOP
	DO WHILE !EOF()
		SELE DUPLICAT
		SEEK STR(DPL_BUG.EMPRESA,3)+STR(DPL_BUG.DUPLICATA,9)
		IF FOUND()
			SET PROCEDURE TO DUPLICAT.SPR
			m.pago = CRobtvlrpg(DPL_BUG.EMPRESA,DPL_BUG.DUPLICATA)
			=rlock()
			REPLACE vlr_pgto WITH m.pago
		ENDIF		   
		SELE DPL_BUG
		SKIP
	ENDDO



*MODIF REPORT TESTE6

REPORT FORM TESTE6 TO L:\TMP\DPLDBR.TXT

