SET ESCAPE ON
SET TALK ON

SET EXCL OFF
USE Q:\SCGC\LOJA\NOTA
SET ORDER TO TAG DATA OF Q:\SCGC\LOJA\NOTA.CDX

SET NEAR ON
seek STR(1,3)+DTOS({01.07.2005})
SET NEAR OFF


do while !eof()
	IF TIPO $ "VBA/VBB"
	    =rlock()
		REPLACE CH_OPERA WITH "7"
		REPLACE CH_PRODU WITH "8"
		REPLACE CH_MOTIV WITH "9"
	ENDIF
    skip
enddo


*-----------------------------------------		
SET EXCL OFF
USE Q:\SCGC\LOJA\ITEMMOV
SET ORDER TO TAG DT_MOV OF Q:\SCGC\LOJA\ITEMMOV.CDX

SET NEAR ON
seek STR(1,3)+DTOS({01.07.2005})
SET NEAR OFF


do while !eof()
	IF TIPO $ "VBA/VBB"
	    =rlock()
		REPLACE CH_OPERA WITH "7"
		REPLACE CH_PRODU WITH "8"
		REPLACE CH_MOTIV WITH "9"
		REPLACE OPERACAO WITH "SOPS"
	ENDIF
    skip
enddo




*-----------------------------------------		
SET EXCL OFF

USE Q:\SCGC\comum\tipooper
go top

do while !eof()
	IF TIPO $ "VBA/VBB"
	    =rlock()
		REPLACE CH_OPERA WITH "7"
		REPLACE CH_PRODU WITH "8"
		REPLACE CH_MOTIV WITH "9"

	ENDIF
    skip
enddo
