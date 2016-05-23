PARAMETERS  SS
    PUBLIC LNimpressao
    if type("lnregistro") = "U"
	    PUBLIC LNregistro
	ENDIF
    PUBLIC LNimpressos
    PUBLIC LNpercentual
    PUBLIC LFsegue
    	

*	PUBLIC LNimpressao   && registro para impressao
*	PUBLIC LNregistro    && posicao do arquivo antes de processos
*	PUBLIC LNimpressos   && registros impressos
*	PUBLIC LNpercentual  && percentual completado
*   PUBLIC LFsegue      && continuidade da impressao

	wp_msg = "Processando ............."
	LFsegue = .t.
	LNregistro = RECNO()
   	IF NOT WEXIST("PRINSTAT")
   		ACTIVATE SCREEN
  * 		DEFINE WINDOW prinstat FROM 18,12 TO 24,67 DOUBLE ;
  * 		TITLE "STATUS" COLOR SCHEME 12
		DEFINE WINDOW prinstat ;
			FROM 2, 2 ;
			TO 9,58 ;
			FLOAT ;
			NOCLOSE ;
			NOMINIMIZE ;
			NONE ;
			TITLE "STATUS" COLOR SCHEME 1
   	ENDIF
RETURN (" ")