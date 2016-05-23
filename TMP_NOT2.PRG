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
		
*---------------------------------------*
	use x:\scgc\ABO\nota
	set order TO tag nota

	copy to x:\tmp\00000\NF_ABO for ;
			empresa = 17 ;
		and (;
		  		nota = 30085658 ;
            )		
		
*---------------------------------------*
	use x:\scgc\ANP\nota
	set order TO tag nota

	copy to x:\tmp\00000\NF_ANP for ;
			empresa = 14 ;
		and (;
		  		nota = 3057160 ;
			OR 	nota = 3057827 ;
			OR 	nota = 3057903 ;
            )		



	CLOSE DATABASE

	USE  x:\tmp\00000\NF_ANP
	copy STRU TO x:\tmp\00000\NF_TOT

	CLOSE DATABASE
	USE  x:\tmp\00000\NF_TOT

	APPEND FROM  x:\tmp\00000\NF_ANP 
	APPEND FROM  x:\tmp\00000\NF_ABO
	


RETURN(.T.)

*---------------------------------------*
*---------------------------------------*
FUNCTION COPYITEM
	use x:\scgc\sia\ITEMMOV
	set order TO tag nota

*---------------------------------------*
	use x:\scgc\ABO\ITEMMOV
	set order TO tag nota

	copy to x:\tmp\00000\IT_ABO for ;
			empresa = 17 ;
		AND	LEFT(OPERACAO,1) = "S" ;
		and (;
		  		nota = 3008565 ;
            )		
		
*---------------------------------------*
	use x:\scgc\ANP\ITEMMOV
	set order TO tag nota

	copy to x:\tmp\00000\IT_ANP for ;
			empresa = 14 ;
		AND	LEFT(OPERACAO,1) = "S" ;
		and (;
		  		nota = 3057160 ;
			OR 	nota = 3057827 ;
			OR 	nota = 3057903 ;
            )		



	CLOSE DATABASE

	USE  x:\tmp\00000\IT_ABO
	copy STRU TO  x:\tmp\00000\IT_TOT

	CLOSE DATABASE
	USE  x:\tmp\00000\IT_TOT

	APPEND FROM  x:\tmp\00000\IT_ANP 
	APPEND FROM  x:\tmp\00000\IT_ABO



RETURN(.T.)

*---------------------------------------*
*---------------------------------------*

FUNCTION DELNOTA
	use Q:\scgc\CENTRAL\nota
	set order to tag nota

	DELETE ALL FOR ;
	   (;       
			empresa = 17 ;
		and (;
		  		nota = 3008565 ;
            );
       );		
       OR ;
      (;
      			empresa = 14 ;
		and (;
		  		nota = 3057160 ;
			OR 	nota = 3057827 ;
			OR 	nota = 3057903 ;
            );
        )
        		
RETURN(.T.)
		
FUNCTION DELITEM
	use Q:\scgc\CENTRAL\ITEMMOV
	set order to tag nota

	DELETE ALL FOR ;
	   (;       
			empresa = 17 ;
		AND	LEFT(OPERACAO,1) = "S" ;
		and (;
		  		nota = 3008565 ;
            );
       );		
       OR ;
      (;
      			empresa = 14 ;
		AND	LEFT(OPERACAO,1) = "S" ;
		and (;
		  		nota = 3057160 ;
			OR 	nota = 3057827 ;
			OR 	nota = 3057903 ;
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