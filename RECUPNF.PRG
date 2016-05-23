SET EXCL OFF
set talk on
set dele on
set date german
set escape on

sele 0
use \scgc\loja\NOTA
SET ORDER TO TAG NOTA

sele 0
use \scgc\loja\NF0404 excl
ctr2 = 0
ctr2 = reccount()

go BOTT
ctr = 1


do while !BOF()
	scatter memvar
	msg = str(ctr,6)+"    -    "+STR(ctr2,6)
	WAIT WINDOW MSG NOWAIT
	sele NOTA
	SEEK STR(M.EMPRESA,3)+STR(M.NOTA,7)
	IF !FOUND()
		APPEND BLANK
		=RLOCK()
		GATHER MEMVAR
	ENDIF
	SELE NF0404
	skip -1
	ctr = ctr + 1
enddo
