*------------------------------------------*
*==> Seleciona todas a copias de Cupons
*------------------------------------------*


SELECT NF.* ;
	FROM TMPSel_1 NF;
	WHERE nf.orcamento <> nf.referencia ;
	INTO CURSOR TdsCopias




*------------------------------------------*
*==> Seleciona todos doc qu nao sao copias e que 
*    nao tenham copias
*------------------------------------------*

SELECT nf.*  ;
	FROM TMPSel_1 NF;
	WHERE ;
		STR(NF.EMPRESA,3)+STR(nf.nota,7) ;
		NOT IN ;
		(SELECT ;
		    STR(cp.EMPRESA,3)+;
		    STR(cp.nota,7) as chave ;
		 from TdsCopias Cp);
	INTO CURSOR TdsOutros
	
	
*------------------------------------------*
*==> Uniao dos registros
*------------------------------------------*
SELECT * FROM TdsCopias;
	UNION;
SELECT * FROM TdsCupons;
	INTO CURSOR TdsDFis
