select STR(EMPRESA,3)+STR(NOTA,7) AS CHAVE,;
       empresa,nota,tipo ;
 from q:\scgc\central\nota ;
 where ;
        empresa = 6 ;
    and data >= {22.09.2006} ;
    INTO CURSOR CRS_CENT
    
    
SELECT * ;
 from x:\scgc\LOJA_CGB\nota ;
 where ;
        empresa = 6 ;
    and data >= {22.09.2006} ;
    and tipo = "CPM" ;
    AND STR(EMPRESA,3)+STR(NOTA,7) NOT IN (SELECT CHAVE FROM CRS_CENT);
    INTO TABLE X:\TMP\TMP_CPM
    
CLOSE DATA
USE  q:\scgc\central\nota 
APPEND FROM  X:\TMP\TMP_CPM
