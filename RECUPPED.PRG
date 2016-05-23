SET EXCL OFF
set talk on
set dele on
set date german
set escape on

sele 0
use \scgc\loja\pedite
SET ORDER TO TAG CHV_EXCLUS

sele 0
use \scgc\loja\PD0404 excl
ctr2 = 0
ctr2 = reccount()

go TOP
ctr = 1


do while !EOF()
	scatter memvar
	msg = str(ctr,6)+"    -    "+STR(ctr2,6)
	WAIT WINDOW MSG NOWAIT
	sele pedite
	SEEK STR(M.EMPRESA,3)+STR(M.PEDIDO,7)+M.CODIGO+STR(M.ORDEM,5)
	IF !FOUND()
		APPEND BLANK
		=RLOCK()
		GATHER MEMVAR
	ENDIF
	SELE PD0404
	skip 
	ctr = ctr + 1
enddo
