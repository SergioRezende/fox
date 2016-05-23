
PARAMETERS  SS
    IF !LNregistro = RECNO()   	
    	LNimpressos = LNimpressos + 1
		LNregistro = RECNO()
	ENDIF    	
	IF LNimpressos = 1
		LNpercentual = 0
	ELSE
		LNpercentual = (LNimpressos / LNimpressao)
	ENDIF
	LSEToldcons = SET("CONSOLE")
	SET CONSOLE ON
	IF CHRSAW()
		CLEAR TYPEAHEAD
		IF fox_alert("Deseja Abandonar  Processo ??? ")
			LFsegue = .f.
		ENDIF
	ENDIF
	ACTIVATE WINDOW prinstat NOSHOW
* 	@ 0,5 SAY wp_msg
*	@ 2,01 SAY ;
*	"³³³³³³³³³³³"
*	@ 3,01 SAY ;
*	"0   10   20   30   40   50   60   70   80   90   100"
****************
@ 1,5 SAY wp_msg
@ 0,1 TO 0,55 ;
	COLOR SCHEME 23
@ 7,1 TO 7,55 ;
	COLOR SCHEME 24
@ 1,56 TO 7,56 ;
	COLOR SCHEME 24
@ 7,56 SAY "Ù" ;
	SIZE 1,1, 0 ;
	COLOR SCHEME 24
@ 0,56 SAY "¿" ;
	SIZE 1,1, 0 ;
	COLOR SCHEME 24
@ 2,3 TO 2,53 ;
	COLOR SCHEME 23
@ 4,3 TO 4,53 ;
	COLOR SCHEME 24
@ 4,54 SAY "Ù" ;
	SIZE 1,1, 0 ;
	COLOR SCHEME 24
@ 3,54 SAY "³" ;
	SIZE 1,1, 0 ;
	COLOR SCHEME 24
@ 2,54 SAY "¿" ;
	SIZE 1,1, 0 ;
	COLOR SCHEME 24
@ 5,3 SAY "³³³³³³³³³³³" ;
	SIZE 1,51, 0
@ 6,2 SAY " 0   10   20   30   40   50   60   70   80   90   100" ;
	SIZE 1,53, 0
@ 1,0 TO 6,0 ;
	COLOR SCHEME 23
@ 0,0 SAY "Ú" ;
	SIZE 1,1, 0 ;
	COLOR SCHEME 23
@ 7,0 SAY "À" ;
	SIZE 1,1, 0 ;
	COLOR SCHEME 23
@ 3,2 SAY "³" ;
	SIZE 1,1, 0 ;
	COLOR SCHEME 23
@ 2,2 SAY "Ú" ;
	SIZE 1,1, 0 ;
	COLOR SCHEME 23
@ 4,2 SAY "À" ;
	SIZE 1,1, 0 ;
	COLOR SCHEME 23
****************
	ACTIVATE WINDOW prinstat
	LNpreenche = (INT(LNpercentual*50))+1
	@ 03,03 SAY REPLICATE("Û",LNpreenche) COLOR SCHEME 21
	ACTIVATE SCREEN 
	SET CONSOLE &LSEToldcons
RETURN (" ")
