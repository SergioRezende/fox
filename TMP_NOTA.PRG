	SET DELE ON
	SET TALK ON
	SET ESCAPE ON
	SET CENT ON
	SET DATE GERMAN

	set excl off

	=COPYNOTA()
	=COPYITEM()

	=DELNOTA()
	=DELITEM()

	=CARREGA()

RETURN

*---------------------------------------*

FUNCTION COPYNOTA
	use x:\scgc\sia\nota
	set order to tag nota

	copy to x:\tmp\00000\NF_SIA for ;
			empresa = 2 ;
		and (;
		  		nota = 9999999 ;
			OR 	nota = 9999999 ;
			OR 	nota = 9999999 ;
			OR 	nota = 9999999 ;
            )		
*---------------------------------------*
	use x:\scgc\ARG\nota
	set order TO tag nota

	copy to x:\tmp\00000\NF_ARG for ;
			empresa = 8 ;
		and (;
		  		nota = 9999999 ;
            )		
		
*---------------------------------------*
	use x:\scgc\ABO\nota
	set order TO tag nota

	copy to x:\tmp\00000\NF_ABO for ;
			empresa = 17 ;
		and (;
		  		nota = 9999999 ;
			OR 	nota = 9999999 ;
            )		
		
*---------------------------------------*
	use x:\scgc\ANP\nota
	set order TO tag nota

	copy to x:\tmp\00000\NF_ANP for ;
			empresa = 14 ;
		and (;
		  		nota = 3058507 ;
			OR 	nota = 3058738 ;
			OR 	nota = 3058773 ;
			OR 	nota = 3058342 ;
			OR 	nota = 3058766 ;
			OR 	nota = 3058221 ;
			OR 	nota = 3058978 ;
			OR 	nota = 3057999 ;
			OR 	nota = 3058677 ;
			OR 	nota = 3058314 ;
			OR 	nota = 3059058 ;
            )		



	CLOSE DATABASE

	USE  x:\tmp\00000\NF_SIA 
	copy STRU TO x:\tmp\00000\NF_TOT

	CLOSE DATABASE
	USE  x:\tmp\00000\NF_TOT

	APPEND FROM  x:\tmp\00000\NF_SIA 
	APPEND FROM  x:\tmp\00000\NF_ANP 
	APPEND FROM  x:\tmp\00000\NF_ABO
	APPEND FROM  x:\tmp\00000\NF_ARG
	


RETURN(.T.)

*---------------------------------------*
*---------------------------------------*
FUNCTION COPYITEM
	use x:\scgc\sia\ITEMMOV
	set order TO tag nota

	copy to x:\tmp\00000\IT_SIA for ;
			empresa = 2 ;
		AND	LEFT(OPERACAO,1) = "S" ;
		and (;
		  		nota = 9999999 ;
			OR 	nota = 9999999 ;
			OR 	nota = 9999999 ;
			OR 	nota = 9999999 ;
            )		
*---------------------------------------*
	use x:\scgc\ARG\ITEMMOV
	set order TO tag nota

	copy to x:\tmp\00000\IT_ARG for ;
			empresa = 8 ;
		AND	LEFT(OPERACAO,1) = "S" ;
		and (;
		  		nota = 9999999 ;
            )		
		
*---------------------------------------*
	use x:\scgc\ABO\ITEMMOV
	set order TO tag nota

	copy to x:\tmp\00000\IT_ABO for ;
			empresa = 17 ;
		AND	LEFT(OPERACAO,1) = "S" ;
		and (;
		  		nota = 9999999 ;
			OR 	nota = 9999999 ;
            )		
		
*---------------------------------------*
	use x:\scgc\ANP\ITEMMOV
	set order TO tag nota

	copy to x:\tmp\00000\IT_ANP for ;
			empresa = 14 ;
		AND	LEFT(OPERACAO,1) = "S" ;
		and (;
		  		nota = 3058507 ;
			OR 	nota = 3058738 ;
			OR 	nota = 3058773 ;
			OR 	nota = 3058342 ;
			OR 	nota = 3058766 ;
			OR 	nota = 3058221 ;
			OR 	nota = 3058978 ;
			OR 	nota = 3057999 ;
			OR 	nota = 3058677 ;
			OR 	nota = 3058314 ;
			OR 	nota = 3059058 ;
            )		



	CLOSE DATABASE

	USE  x:\tmp\00000\IT_SIA 
	copy STRU TO  x:\tmp\00000\IT_TOT

	CLOSE DATABASE
	USE  x:\tmp\00000\IT_TOT

	APPEND FROM  x:\tmp\00000\IT_SIA 
	APPEND FROM  x:\tmp\00000\IT_ANP 
	APPEND FROM  x:\tmp\00000\IT_ABO
	APPEND FROM  x:\tmp\00000\IT_ARG



RETURN(.T.)

*---------------------------------------*
*---------------------------------------*

FUNCTION DELNOTA
	use Q:\scgc\CENTRAL\nota
	set order to tag nota

	DELETE ALL FOR ;
       ( ;
			empresa = 2 ;
		and (;
		  		nota = 9999999 ;
			OR 	nota = 9999999 ;
			OR 	nota = 9999999 ;
			OR 	nota = 9999999 ;
            );
       ) ;
       OR;		
       (;
			empresa = 8 ;
		and (;
		  		nota = 9999999 ;
            );
       );
       OR ;
	   (;       
			empresa = 17 ;
		and (;
		  		nota = 9999999 ;
			OR 	nota = 9999999 ;
            );
       );		
       OR ;
      (;
      			empresa = 14 ;
		and (;
		  		nota = 3058507 ;
			OR 	nota = 3058738 ;
			OR 	nota = 3058773 ;
			OR 	nota = 3058342 ;
			OR 	nota = 3058766 ;
			OR 	nota = 3058221 ;
			OR 	nota = 3058978 ;
			OR 	nota = 3057999 ;
			OR 	nota = 3058677 ;
			OR 	nota = 3058314 ;
			OR 	nota = 3059058 ;
            );
        )
        		
RETURN(.T.)
		
FUNCTION DELITEM
	use Q:\scgc\CENTRAL\ITEMMOV
	set order to tag nota

	DELETE ALL FOR ;
       ( ;
			empresa = 2 ;
		AND	LEFT(OPERACAO,1) = "S" ;
		and (;
		  		nota = 9999999 ;
			OR 	nota = 9999999 ;
			OR 	nota = 9999999 ;
			OR 	nota = 9999999 ;
            );
       ) ;
       OR;		
       (;
			empresa = 8 ;
		AND	LEFT(OPERACAO,1) = "S" ;
		and (;
		  		nota = 9999999 ;
            );
       );
       OR ;
	   (;       
			empresa = 17 ;
		AND	LEFT(OPERACAO,1) = "S" ;
		and (;
		  		nota = 9999999 ;
			OR 	nota = 9999999 ;
            );
       );		
       OR ;
      (;
      			empresa = 14 ;
		AND	LEFT(OPERACAO,1) = "S" ;
		and (;
		  		nota = 3058507 ;
			OR 	nota = 3058738 ;
			OR 	nota = 3058773 ;
			OR 	nota = 3058342 ;
			OR 	nota = 3058766 ;
			OR 	nota = 3058221 ;
			OR 	nota = 3058978 ;
			OR 	nota = 3057999 ;
			OR 	nota = 3058677 ;
			OR 	nota = 3058314 ;
			OR 	nota = 3059058 ;
            );
        )
        		
RETURN(.T.)
		
				
FUNCTION CARREGA

	CLOSE DATABASE

	USE  Q:\SCGC\CENTRAL\NOTA

	APPEND FROM  x:\tmp\00000\NF_TOT


	USE  Q:\SCGC\CENTRAL\ITEMMOV

	APPEND FROM  x:\tmp\00000\IT_TOT



RETURN(.T.)				