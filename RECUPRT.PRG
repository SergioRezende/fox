SET PROCEDURE TO ROTINAS.SPR
SET EXCL OFF
set talk on
set dele on
set date german
set escape on

sele 0
use \scgc\loja\retornmv
SET ORDER TO TAG lancamento

sele 0
use \scgc\loja\rt0606 excl
ctr2 = 0
ctr2 = reccount()

go TOP
ctr = 1


do while !eof()
	scatter memvar
	msg = str(ctr,6)+"    -    "+STR(ctr2,6)+" Rec : "+str(recno(),7)
	WAIT WINDOW MSG NOWAIT
	sele retornmv
	SEEK STR(m.EMPRESA,3)+STR(m.BANCO,3)+STR(m.AVISO,8);
				+STR(m.DUPLICATA,9)+STR(m.OCORRENCIA,2)
	IF !FOUND()
		APPEND BLANK
		=REGLOCK(.T.)
		GATHER MEMVAR
	ENDIF
	SELE rt0606
	skip 
	ctr = ctr + 1
enddo
