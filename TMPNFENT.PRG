SET TALK ON
SET DATE GERMAN
SET CENTU ON
SET DELE ON
set excl off

*=LER_CAPAS()

*=LER_ITENS()

*=LER_IT_DE_CAPA()


*=COPY_CP_PRA_NOVO()

*=COPY_IT_PRA_NOVO()

*=LER_UMA_NOTA()

* =GRA_LST_ERROS()

=CMPRA_NOTAITE_ITEMMOV()


*=INSRE_RGSTR_ERROS()

RETURN


FUNCTION INSRE_RGSTR_ERROS


    CLOSE DATA
	sele 0
    USE  Q:\SCGC\CENTRAL\NOTAENT ALIAS FSCO 
    GO TOP


    
  	sele 0
    USE  Q:\SCGC\CENTRAL\NOTAITE  AGAIN shared ALIAS INDX 
    SET ORDER TO TAG ORCAMENTO


	sele 0
    USE  X:\SCGC\LOJAS\NOTAITE ALIAS LOJA

******** PRA GYN    USE  Q:\SCGC\LOJA\NOTAITE ALIAS LOJA
    SET ORDER TO TAG ORCAMENTO
    GO TOP




    SELE FSCO
    GO TOP

    CTR = 0
    CTRERRO = 0
    CTRACERTO = 0


    DO WHILE !EOF()
        SELE INDX



        MSG  = "LIDOS : "+STR(CTR,7)+"-";
             + " ERROS : "+STR(CTRERRO,7)+"-";
             + " ACERTOS : "+STR(CTRACERTO,7)+"-";
	         +STR(FSCO.EMPRESA,3);
    	     +STR(FSCO.REFERENCIA,6);
	         +STR(FSCO.CODFORN,5);
    	     +STR(FSCO.NOTA,6);
	         +FSCO.SERIE;
    	     +LEFT(FSCO.TIPO,1)

        SEEK  ;
	         +STR(FSCO.EMPRESA,3);
    	     +STR(FSCO.REFERENCIA,6);
        	 +STR(FSCO.CODFORN,5);
	         +STR(FSCO.NOTA,6);
    	     +FSCO.SERIE;
	         +LEFT(FSCO.TIPO,1)

        IF NOT FOUND()
           SELE LOJA
           SEEK  ;
	         +STR(FSCO.EMPRESA,3);
    	     +STR(FSCO.REFERENCIA,6);
        	 +STR(FSCO.CODFORN,5);
	         +STR(FSCO.NOTA,6);
    	     +FSCO.SERIE;
	         +LEFT(FSCO.TIPO,1)
          IF FOUND()
             CTRACERTO = CTRACERTO + 1 

             DO WHILE !EOF() AND ;
		          STR(FSCO.EMPRESA,3);
	    	     +STR(FSCO.REFERENCIA,6);
    	    	 +STR(FSCO.CODFORN,5);
		         +STR(FSCO.NOTA,6);
    		     +FSCO.SERIE;
		         +LEFT(FSCO.TIPO,1) ;
		            =   ;
		          STR(LOJA.EMPRESA,3);
	    	     +STR(LOJA.ORCAMENTO,6);
    	    	 +STR(LOJA.CODFORN,5);
		         +STR(LOJA.NOTA,6);
    		     +LOJA.SERIE;
		         +LEFT(LOJA.TIPO,1) 
		         
		         SCATTER MEMVAR
		         SELE INDX
		         APPEND BLANK
		         =RLOCK()   
		         GATHER MEMVAR
		         
		         SELE LOJA
		         SKIP
		     ENDDO
                  

          ENDIF           
    
          WAIT WINDOW "ERRO DE LEITURA " + MSG NOWAIT
          CTRERRO = CTRERRO + 1 

        ENDIF
        WAIT WINDOW  MSG NOWAIT
        CTR = CTR + 1 

    	SELE FSCO
    	SKIP
    ENDDO
        
   
        MSG  = "LIDOS : "+STR(CTR,7)+"-";
             + " ERROS : "+STR(CTRERRO,7)+"-";
             + " ACERTOS : "+STR(CTRACERTO,7)
             

    WAIT WINDOW  MSG


   

RETURN(.T.)



FUNCTION LER_CAPAS
   CLOSE DATA
	sele 0
    USE  X:\SCGC\CENTRAL\NOTAENT ALIAS FSCO 
    GO TOP
    
  	sele 0
    USE  X:\SCGC\CENTRAL\NOTAENT  AGAIN shared ALIAS INDX 
    SET ORDER TO TAG NOTA

    SELE FSCO
    GO TOP

    CTR = 1
    DO WHILE !EOF()

        SELE INDX


        MSG  = "Nro: "+STR(CTR,7);
             +"-";
             +STR(FSCO.EMPRESA,3);
             +STR(FSCO.CODFORN,5);
             +STR(FSCO.NOTA,6);
             +FSCO.SERIE;
             +LEFT(FSCO.TIPO,1)    

        SEEK  ;
             +STR(FSCO.EMPRESA,3);
             +STR(FSCO.CODFORN,5);
             +STR(FSCO.NOTA,6);
             +FSCO.SERIE;
             +LEFT(FSCO.TIPO,1)    
        IF NOT FOUND()
            WAIT WINDOW "ERRO DE LEITURA " + MSG
            RETURN(.F.)
        ENDIF
        WAIT WINDOW  MSG NOWAIT
        CTR = CTR + 1 

    	SELE FSCO
    	SKIP
    ENDDO
        
   


    MSG  = "Nro: "+STR(CTR,7);
           + "  OK CAPAS"

    WAIT WINDOW  MSG
   

RETURN(.T.)


FUNCTION LER_ITENS
   CLOSE DATA
	sele 0
    USE  X:\SCGC\CENTRAL\NOTAITE ALIAS FSCO 
    GO TOP
    
  	sele 0
    USE  X:\SCGC\CENTRAL\NOTAITE  AGAIN shared ALIAS INDX 
    SET ORDER TO TAG ORCAMENTO

    SELE FSCO
    GO TOP

    CTR = 1
    DO WHILE !EOF()
        SELE INDX
        MSG  = "Nro: "+STR(CTR,7)+"-"+STR(FSCO.EMPRESA,3);
             +STR(FSCO.ORCAMENTO,6);
             +STR(FSCO.CODFORN,5);
             +STR(FSCO.NOTA,6);
             +FSCO.SERIE;
             +LEFT(FSCO.TIPO,1)    

        SEEK  STR(FSCO.EMPRESA,3);
             +STR(FSCO.ORCAMENTO,6);
             +STR(FSCO.CODFORN,5);
             +STR(FSCO.NOTA,6);
             +FSCO.SERIE;
             +LEFT(FSCO.TIPO,1)    
        IF NOT FOUND()
            WAIT WINDOW "ERRO DE LEITURA " + MSG
            RETURN(.F.)
        ENDIF
        WAIT WINDOW  MSG NOWAIT
        CTR = CTR + 1 

    	SELE FSCO
    	SKIP
    ENDDO
        
   

    MSG  = "Nro: "+STR(CTR,7);
            +"  OK ITENSS"

    WAIT WINDOW  MSG


   

RETURN(.T.)

FUNCTION LER_UMA_NOTA

    CLOSE DATA
	sele 0
    USE  X:\SCGC\CENTRAL\NOTAENT ALIAS FSCO 
    GO TOP
    
  	sele 0
    USE  X:\SCGC\CENTRAL\NOTAITE  AGAIN shared ALIAS INDX 
    SET ORDER TO TAG ORCAMENTO

    set step on
    SELE FSCO
    GO 35692
    

    CTR = 0
    CTRERRO = 0

        SELE INDX



        MSG  = "LIDOS : "+STR(CTR,7)+"-";
             + " ERROS : "+STR(CTRERRO,7)+"-";
	         +STR(FSCO.EMPRESA,3);
    	     +STR(FSCO.REFERENCIA,6);
	         +STR(FSCO.CODFORN,5);
    	     +STR(FSCO.NOTA,6);
	         +FSCO.SERIE;
    	     +LEFT(FSCO.TIPO,1)

        SEEK  ;
	         +STR(FSCO.EMPRESA,3);
    	     +STR(FSCO.REFERENCIA,6);
        	 +STR(FSCO.CODFORN,5);
	         +STR(FSCO.NOTA,6);
    	     +FSCO.SERIE;
	         +LEFT(FSCO.TIPO,1)
        IF NOT FOUND()
            WAIT WINDOW "ERRO DE LEITURA " + MSG NOWAIT
            CTRERRO = CTRERRO + 1 
        ENDIF
        WAIT WINDOW  MSG NOWAIT
        CTR = CTR + 1 

    	SELE FSCO
    	SKIP
        
   
    MSG  = "LIDOS : "+STR(CTR,7)+"-";
           +    " ERROS : "+STR(CTRERRO,7)+"-"

    WAIT WINDOW  MSG


   

RETURN(.T.)






FUNCTION LER_IT_DE_CAPA

    CLOSE DATA
	sele 0
    USE  X:\SCGC\CENTRAL\NOTAENT ALIAS FSCO 
    GO TOP
    
  	sele 0
    USE  X:\SCGC\CENTRAL\NOTAITE  AGAIN shared ALIAS INDX 
    SET ORDER TO TAG ORCAMENTO

    SELE FSCO
    GO TOP

    CTR = 0
    CTRERRO = 0
    DO WHILE !EOF()
        SELE INDX



        MSG  = "LIDOS : "+STR(CTR,7)+"-";
             + " ERROS : "+STR(CTRERRO,7)+"-";
	         +STR(FSCO.EMPRESA,3);
    	     +STR(FSCO.REFERENCIA,6);
	         +STR(FSCO.CODFORN,5);
    	     +STR(FSCO.NOTA,6);
	         +FSCO.SERIE;
    	     +LEFT(FSCO.TIPO,1)

        SEEK  ;
	         +STR(FSCO.EMPRESA,3);
    	     +STR(FSCO.REFERENCIA,6);
        	 +STR(FSCO.CODFORN,5);
	         +STR(FSCO.NOTA,6);
    	     +FSCO.SERIE;
	         +LEFT(FSCO.TIPO,1)
        IF NOT FOUND()
            WAIT WINDOW "ERRO DE LEITURA " + MSG NOWAIT
            CTRERRO = CTRERRO + 1 
        ENDIF
        WAIT WINDOW  MSG NOWAIT
        CTR = CTR + 1 

    	SELE FSCO
    	SKIP
    ENDDO
        
   
    MSG  = "LIDOS : "+STR(CTR,7)+"-";
           +    " ERROS : "+STR(CTRERRO,7)+"-"

    WAIT WINDOW  MSG


   

RETURN(.T.)




FUNCTION CMPRA_NOTAITE_ITEMMOV

    CLOSE DATA
	sele 0
    USE  x:\SCGC\CENTRAL\NOTAENT ALIAS FSCO 
    GO TOP


    COPY STRU TO X:\TMP\LST_ERROS WITH CDX
    
  	sele 0
    USE  X:\TMP\LST_ERROS EXCL ALIAS ERROS
    SET ORDER TO TAG NOTA




    
  	sele 0
    USE  x:\SCGC\CENTRAL\NOTAITE  AGAIN ALIAS INDX 
    SET ORDER TO TAG ORCAMENTO


  	sele 0
    USE  x:\SCGC\CENTRAL\ITEMMOV  AGAIN ALIAS INDX2 
    SET ORDER TO TAG IT_DA_NOTA


    SELE FSCO
    GO TOP


    SET STEP ON

    CTR = 0
    CTRERRO = 0
    DO WHILE !EOF()



        SELE INDX

        MSG  = "LIDOS : "+STR(CTR,7)+"-";
             + " ERROS : "+STR(CTRERRO,7)+"-";


        SEEK  ;
	          STR(FSCO.EMPRESA,3);
    	     +STR(FSCO.REFERENCIA,6);
        	 +STR(FSCO.CODFORN,5);
	         +STR(FSCO.NOTA,6);
    	     +FSCO.SERIE;
	         +LEFT(FSCO.TIPO,1)

        IF NOT FOUND()
            SELE  FSCO
            SCATTER MEMVAR
            
            SELE ERROS
            APPEND BLANK
            GATHER MEMVAR
    
            WAIT WINDOW "ERRO DE LEITURA " + MSG NOWAIT
            CTRERRO = CTRERRO + 1 
        ELSE
           DO WHILE !EOF() AND ;
	          STR(FSCO.EMPRESA,3);
    	     +STR(FSCO.REFERENCIA,6);
        	 +STR(FSCO.CODFORN,5);
	         +STR(FSCO.NOTA,6);
    	     +DTOS(FSCO.DATA_EMI);
	         +LEFT(FSCO.TIPO,1)  ;
	         = ;
	          STR(INDX.EMPRESA,3);
    	     +STR(INDX.NOTA,6);
        	 +STR(INDX.CODFORN,5);
	         +STR(INDX.NOTA,6);
    	     +DTOS(INDX.DTFAT);
	         +LEFT(INDX.TIPO,1)  ;
	    
	         SELE INDX2
             SET ORDER TO TAG IT_DA_NOTA

    	     SEEK  ;
                 STR(INDX.EMPRESA,3);
                 +INDX.CODIGO;
                 +STR(INDX.FAVORECIDO,14);
                 +INDX.TIPO;
                 +STR(INDX.NOTA,7);
                 +DTOS(INDX.DTFAT);
	                +STR(INDX.ORDEM,3)
		
		
		
		     IF NOT FOUND()
    	        SELE  FSCO
        	    SCATTER MEMVAR
            
            	SELE ERROS
	            APPEND BLANK
    	        GATHER MEMVAR
    	
        	    WAIT WINDOW "ERRO DE LEITURA " + MSG NOWAIT
	            CTRERRO = CTRERRO + 1 
                SELE INDX
                EXIT
    		 ENDIF             
             SELE INDX
             SKIP
		  ENDDO
        ENDIF
        WAIT WINDOW  MSG NOWAIT
        CTR = CTR + 1 

    	SELE FSCO
    	SKIP
    ENDDO
        
   
    MSG  = "LIDOS : "+STR(CTR,7)+"-";
           +    " ERROS : "+STR(CTRERRO,7)+"-"

    WAIT WINDOW  MSG


RETURN

FUNCTION GRA_LST_ERROS

    CLOSE DATA
	sele 0
    USE  Q:\SCGC\LOJA\NOTAENT ALIAS FSCO 
    GO TOP


    COPY STRU TO X:\TMP\LST_ERROS WITH CDX
    
  	sele 0
    USE  X:\TMP\LST_ERROS EXCL ALIAS ERROS
    SET ORDER TO TAG NOTA




    
  	sele 0
    USE  Q:\SCGC\LOJA\NOTAITE  AGAIN shared ALIAS INDX 
    SET ORDER TO TAG ORCAMENTO

    SELE FSCO
    GO TOP

    CTR = 0
    CTRERRO = 0
    DO WHILE !EOF()
        SELE INDX



        MSG  = "LIDOS : "+STR(CTR,7)+"-";
             + " ERROS : "+STR(CTRERRO,7)+"-";
	         +STR(FSCO.EMPRESA,3);
    	     +STR(FSCO.REFERENCIA,6);
	         +STR(FSCO.CODFORN,5);
    	     +STR(FSCO.NOTA,6);
	         +FSCO.SERIE;
    	     +LEFT(FSCO.TIPO,1)

        SEEK  ;
	         +STR(FSCO.EMPRESA,3);
    	     +STR(FSCO.REFERENCIA,6);
        	 +STR(FSCO.CODFORN,5);
	         +STR(FSCO.NOTA,6);
    	     +FSCO.SERIE;
	         +LEFT(FSCO.TIPO,1)

        IF NOT FOUND()
            SELE  FSCO
            SCATTER MEMVAR
            
            SELE ERROS
            APPEND BLANK
            GATHER MEMVAR
    
            WAIT WINDOW "ERRO DE LEITURA " + MSG NOWAIT
            CTRERRO = CTRERRO + 1 
        ENDIF
        WAIT WINDOW  MSG NOWAIT
        CTR = CTR + 1 

    	SELE FSCO
    	SKIP
    ENDDO
        
   
    MSG  = "LIDOS : "+STR(CTR,7)+"-";
           +    " ERROS : "+STR(CTRERRO,7)+"-"

    WAIT WINDOW  MSG


   

RETURN(.T.)








FUNCTION COPY_CP_PRA_NOVO
   CLOSE DATA
	sele 0
    USE  X:\SCGC\CENTRAL\NOTAENT ALIAS FSCO 
    GO TOP
    
    COPY STRU TO X:\SCGC\CENTRAL\NTCP_NW WITH CDX
    
  	sele 0
    USE  X:\SCGC\CENTRAL\NTCP_NW EXCL ALIAS INDX 
    SET ORDER TO TAG NOTA

    SELE FSCO
    GO TOP

    CTR = 0
    CTRERRO = 0

    DO WHILE !EOF()
	    SELE FSCO
        SCATTER MEMVAR
    
        SELE INDX
        APPEND BLANK
        GATHER MEMVAR
        
        GO TOP

        MSG  = "LIDOS : "+STR(CTR,7)+"-";
             + " ERROS : "+STR(CTRERRO,7)+"-";
             +STR(FSCO.EMPRESA,3);
             +STR(FSCO.CODFORN,5);
             +STR(FSCO.NOTA,6);
             +FSCO.SERIE;
             +LEFT(FSCO.TIPO,1)    

        SEEK ;
              STR(FSCO.EMPRESA,3);
             +STR(FSCO.CODFORN,5);
             +STR(FSCO.NOTA,6);
             +FSCO.SERIE;
             +LEFT(FSCO.TIPO,1)    

        IF NOT FOUND()
            WAIT WINDOW "ERRO DE LEITURA " + MSG NOWAIT
            CTRERRO = CTRERRO + 1 
        ENDIF
        WAIT WINDOW  MSG NOWAIT
        CTR = CTR + 1 

    	SELE FSCO
    	SKIP
    ENDDO
        
   
    MSG  = "LIDOS : "+STR(CTR,7)+"-";
           +    " ERROS : "+STR(CTRERRO,7)+"-"

    WAIT WINDOW  MSG


   

RETURN(.T.)




FUNCTION COPY_IT_PRA_NOVO
   CLOSE DATA
	sele 0
    USE  X:\SCGC\CENTRAL\NOTAITE ALIAS FSCO 
    GO TOP
    
    COPY STRU TO X:\SCGC\CENTRAL\NTIT_NW WITH CDX
    
  	sele 0
    USE  X:\SCGC\CENTRAL\NTIT_NW EXCL ALIAS INDX 
    SET ORDER TO TAG ORCAMENTO

    SELE FSCO
    GO TOP

    CTR = 0
    CTRERRO = 0

    DO WHILE !EOF()
	    SELE FSCO
        SCATTER MEMVAR
    
        SELE INDX
        APPEND BLANK
        GATHER MEMVAR
        
        GO TOP

        MSG  = "LIDOS : "+STR(CTR,7)+"-";
             + " ERROS : "+STR(CTRERRO,7)+"-";
			 +STR(FSCO.EMPRESA,3);
             +STR(FSCO.ORCAMENTO,6);
             +STR(FSCO.CODFORN,5);
             +STR(FSCO.NOTA,6);
             +FSCO.SERIE;
             +LEFT(FSCO.TIPO,1)    

        SEEK  STR(FSCO.EMPRESA,3);
             +STR(FSCO.ORCAMENTO,6);
             +STR(FSCO.CODFORN,5);
             +STR(FSCO.NOTA,6);
             +FSCO.SERIE;
             +LEFT(FSCO.TIPO,1)    

        IF NOT FOUND()
            WAIT WINDOW "ERRO DE LEITURA " + MSG NOWAIT
            CTRERRO = CTRERRO + 1 
        ENDIF
        WAIT WINDOW  MSG NOWAIT
        CTR = CTR + 1 

    	SELE FSCO
    	SKIP
    ENDDO
        
   
    MSG  = "LIDOS : "+STR(CTR,7)+"-";
           +    " ERROS : "+STR(CTRERRO,7)+"-"

    WAIT WINDOW  MSG


   

RETURN(.T.)

*************************************************



use Q:\scgc\CENTRAL\notaent 
SET ORDER TO TAG NOTA

*       STR(EMPRESA,3)+STR(ORCAMENTO,6)+STR(CODFORN,5)+STR(NOTA,6)+SERIE+LEFT(TIPO,1)
*
*
*		SELECT  notaite
*		SET ORDER TO TAG orcamento
*		SEEK STR(wp_empresa,3)+STR(m.referencia,6)+;
*				   STR(m.codforn,5)+STR(m.nota,6)+m.serie+LEFT(m.tipo,1)
*
select ;
    IT.EMPRESA;
   ,IT.ORCAMENTO ;
   ,IT.CODFORN;
   ,IT.NOTA ;
   ,IT.SERIE ;
   ,IT.TIPO;
   ,SUM(IT.VLRVENDA+IT.ICMS_SUBS) AS TOTALNOTA;
 from ;
  Q:\scgc\CENTRAL\notaite  it ;
GROUP BY ;
    IT.EMPRESA;
   ,IT.ORCAMENTO ;
   ,IT.CODFORN;
   ,IT.NOTA ;
   ,IT.SERIE ;
   ,IT.TIPO;
into TABLE Q:\TMP\IT_TMP


INDEX ON    STR(EMPRESA,3)+STR(ORCAMENTO,6)+STR(CODFORN,5)+STR(NOTA,6)+SERIE+LEFT(TIPO,1) TAG ORCAMENTO ADDITIVE


SELE NOTAENT

SET RELATIO TO  ;
  STR(EMPRESA,3)+STR(REFERENCIA,6)+STR(CODFORN,5)+STR(NOTA,6)+SERIE+LEFT(TIPO,1) ;
  INTO IT_TMP

  
SET SKIP TO IT_TMP

COPY   ;
  TO  Q:\TMP\IT_DLET ;   
 FIELDS ;
    EMPRESA;
   ,TIPO;
   ,CODFORN;
   ,NOTA ;
   ,SERIE ;
   ,situacao ;
   ,DATA;
   ,TOTAL_NOTA;
   ,IT_TMP.TOTALNOTA ;
   FOR ;
    IT_TMP.TOTALNOTA = 0 ;
    AND DATA > {01.09.2014} ;
    AND LEFT(SITUACAO,1) $ "Cc"

RETURN

BROWS FIELDS ;
    EMPRESA;
   ,TIPO;
   ,CODFORN;
   ,NOTA ;
   ,SERIE ;
   ,DATA;
   ,TOTAL_NOTA;
   ,IT_TMP.TOTALNOTA ;
   FOR ;
    IT_TMP.TOTALNOTA = 0 ;
    AND DATA > {01.09.2014}

  

*    IT_TMP.TOTALNOTA <> NOTAENT.TOTAL_NOTA ;
  

