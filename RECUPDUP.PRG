SET PROCEDURE TO ROTINAS.SPR

SET EXCL OFF
set talk on
set dele on
set date german
set escape on

sele 0
use \scgc\CENTRAL\duplicat 
SET ORDER TO TAG DOC

sele 0
use \scgc\CENTRAL\dp0505 excl
ctr2 = 0
ctr2 = reccount()

go TOP
ctr = 1


do while !bof()
	scatter memvar
	msg = str(ctr,6)+"    -    "+STR(ctr2,6)+" Rec : "+str(recno(),7)
	WAIT WINDOW MSG NOWAIT
	sele duplicat
	SEEK STR(m.EMPRESA,3)+STR(m.DUPLICATA,9)
	IF !FOUND()
		APPEND BLANK
		=REGLOCK(.T.)
		GATHER MEMVAR
	ENDIF
	SELE dp0505
	skip 
	ctr = ctr + 1
enddo
