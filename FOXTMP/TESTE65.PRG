SET EXCL OFF
SET DELE ON

SET DATE TO GERMAN
SET CENTU ON
SET ESCAPE ON
SET TALK ON
ON ERROR
ON KEY


CLOSE ALL

SELE 0
USE Q:\SCGC\COMUM\TIPOOPER
SET ORDER TO TAG TIPO




SELE 0
use q:\scgc\CENTRAL\NOTA
SET ORDER TO TAG NOTA

SELE 0
use q:\scgc\CENTRAL\itemmov
SET ORDER TO TAG DT_MOV


SET NEAR ON

SEEK STR(10,3)+DTOS({01.01.2005})

do while !eof()

	if  EMPRESA <> 10
	     EXIT
	ENDIF
  



	if NOT ITEMMOV.TIPO $ "VLB/VFB/VLP/VFW"
			skip
			loop
	endif
	


	SELE NOTA
	SEEK STR(ITEMMOV.EMPRESA,3)+STR(ITEMMOV.NOTA,7)
  
  	SELE ITEMMOV
  
    =RLOCK()

    REPLACE ITEMMOV.CH_OPERA WITH NOTA.CH_OPERA
    REPLACE ITEMMOV.CH_PRODU WITH NOTA.CH_PRODU
    REPLACE ITEMMOV.CH_MOTIV WITH NOTA.CH_MOTIV
    REPLACE ITEMMOV.CH_DESTI WITH NOTA.CH_DESTI
    REPLACE ITEMMOV.CH_CONTR WITH NOTA.CH_CONTR
    REPLACE ITEMMOV.CH_CONDI WITH NOTA.CH_CONDI
    REPLACE ITEMMOV.TIPO     WITH NOTA.TIPO
    REPLACE ITEMMOV.CFO      WITH NOTA.CFO


	skip
enddo

