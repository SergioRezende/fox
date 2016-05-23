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
	 ENDIF
   
     sele OS_ERRO
     SKIP

ENDDO
