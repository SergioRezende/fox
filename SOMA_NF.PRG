set excl off
set dele on
set date german
set centu on



DO DF

SELECT 0
use q:\scgc\loja\nota


SELECT 0
use q:\scgc\loja\itemmov
SET ORDER TO TAG NOTA


sele nota

set relation to STR(EMPRESA,3)+LEFT(OPERACAO,1)+STR(NOTA,7) into itemmov

set step on


SET SKIP TO ITEMMOV

COPY FIELDS NOTA.EMPRESA;
      ,NOTA.DATA;
      ,NOTA.TIPO;
      ,NOTA.OPERACAO;
      ,NOTA.ORCAMENTO;
      ,NOTA.NOTA;
      ,NOTA.TOTAL_NOTA;
      ,ITEMMOV.VLRVENDA;
      ,ITEMMOV.ICMS_SUBS ;
  TO X:\TMP\TAB ;
  FOR ;
   NOTA.STATUS <> 2;
   AND NOTA.TIPO <> "CPM"




select ;
   EMPRESA,;
   DATA,;
   OPERACAO,;
   TIPO,;
   NOTA,;
   ORCAMENTO,;
   TOTAL_NOTA,;
   SUM(VLRVENDA+ICMS_SUBS) AS VLRVENDA;
from X:\TMP\TAB ;
GROUP BY ;
   EMPRESA,;
   DATA,;
   OPERACAO,;
   TIPO,;
   NOTA,;
   ORCAMENTO,;
   TOTAL_NOTA;
WHERE ;
   DATA >= {01.10.2014} ;
ORDER  BY ;
   EMPRESA,;
   DATA,;
   OPERACAO,;
   TIPO,;
   NOTA,;
   ORCAMENTO,;
   TOTAL_NOTA;
HAVING ;
   TOTAL_NOTA <> SUM(VLRVENDA+ICMS_SUBS) ;
INTO TABLE X:\OS_ERRO   




* APAGAR ORCAMENTOS


SET STEP ON

* APAGAR ORCAMENTOS


close data

sele 0
use q:\scgc\central\duplicat
SET ORDER TO TAG nota


sele 0
use q:\scgc\central\nota
SET ORDER TO TAG nota


sele 0
use q:\scgc\central\orcatmp
SET ORDER TO TAG orcamento

sele 0
use q:\scgc\central\orcamento
SET ORDER TO TAG GERAL 



sele 0
use X:\OS_ERRO   

sele OS_ERRO
GO TOP

SET STEP ON


DO WHILE !EOF()


   SELE ORCAMENT
   SET NEAR OFF
   SEEK STR(OS_ERRO.EMPRESA,3)+STR(OS_ERRO.ORCAMENTO,6)
   IF FOUND()


	     * APAGAR ORCATMP

	      SELE ORCATMP
    	  SET NEAR ON
	      SEEK  STR(OS_ERRO.EMPRESA,3)+STR(OS_ERRO.ORCAMENTO,6)
    	  DO WHILE !EOF() ;
	       	  AND OS_ERRO.EMPRESA = ORCATMP.EMPRESA ;
    	   	  AND OS_ERRO.ORCAMENTO = ORCATMP.ORCAMENTO 
        	  DELETE
	          SKIP
    	  ENDDO     

    ENDIF

    SET NEAR OFF



     * APAGAR NOTA
     SELE NOTA
   	 SET ORDER TO TAG NOTA

     SEEK STR(OS_ERRO.EMPRESA,3)+STR(OS_ERRO.NOTA,7)
   	 IF FOUND()
          DELETE
   	 ENDIF     

    
     * APAGAR DUPLICATA

     SELE DUPLICAT
     SET ORDER TO TAG NOTA

     SEEK STR(OS_ERRO.EMPRESA,3)+STR(OS_ERRO.NOTA,7)
     IF FOUND()
	      DO WHILE !EOF() ;
   		   	  AND OS_ERRO.EMPRESA = DUPLICAT.EMPRESA ;
	       	  AND OS_ERRO.ORCAMENTO = DUPLICAT.ORCAMENTO 
   		      DELETE
    	      SKIP
    	  ENDDO     
	 ENDIF     
 
     SELE ORCAMENT
   	 DELETE
  
    sele OS_ERRO
    SKIP

ENDDO
