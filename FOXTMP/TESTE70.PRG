PARAMETERS PrmPlaca   && "ALN1830"


*	SELECT STR(EMPRESA,3)+STR(NOTA,7)+TIPO AS CHAVE ,nf.* ;
*	FROM Q:\SCGC\LOJA\nota NF ;
*	WHERE  NF.tipo    <> "CPM"; 
*   	  AND NF.status  <> 2; 
*	INTO CURSOR CRS_NF 

	SELECT STR(EMPRESA,3)+STR(NOTA,7)+TIPO AS CHAVE ,nf.* ;
	FROM Q:\SCGC\CENTRAL\nota NF ;
	WHERE     NF.placa = PrmPlaca;   
    INTO CURSOR CRS_NF 

	SELECT * ;
	FROM Q:\SCGC\CENTRAL\itemmov it ;
	WHERE ;
	    STR(EMPRESA,3)+STR(NOTA,7)+TIPO ;
		IN (SELECT chave from CRS_NF) ;
	INTO CURSOR CRS_IT



	SELECT 	NF.placa,NF.nota AS DOC,;
			NF.data,it.qtde,it.descricao,;
			NF.operador,usr.nome AS VENDEDOR ;
	FROM CRS_NF  NF, ;
		 CRS_IT  it,;
		 q:\scgc\comum\usuario Usr ;
	WHERE    ;
			  usr.usuario = nf.operador ;
		  AND NF.empresa = it.empresa ;
    	  AND NF.nota    = it.nota ;
	      AND NF.tipo    = it.tipo ; 
	ORDER BY placa
RETURN