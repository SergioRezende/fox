SET EXCL OFF
set talk on
set dele on
set date german
set escape on

sele 0
use \scgc\loja\CLIENTES excl
SET ORDER TO TAG cliente

sele 0
use \scgc\loja\CL0304 excl
ctr2 = 0
ctr2 = reccount()

go TOP
ctr = 1


do while !EOF()
	scatter memvar
	msg = str(ctr,6)+"    -    "+STR(ctr2,6)
	WAIT WINDOW MSG NOWAIT
	sele CLIENTES
	SEEK STR(m.CLIENTE,3)
	IF !FOUND()
		APPEND BLANK
	*	=RLOCK()
		GATHER MEMVAR
	ENDIF
	SELE CL0304
	skip 
	ctr = ctr + 1
enddo
