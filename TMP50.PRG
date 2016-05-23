set date german
set cent on

close data

LNFilial = 9
LNNota   = 3017963

set step on

sele 1
use x:\scgc\RIO\nota alias loja
SET ORDER TO TAG NOTA 

sele 2
use q:\scgc\central\nota alias central
SET ORDER TO TAG NOTA 


sele 3
use x:\scgc\RIO\itemmov alias itloja
SET ORDER TO TAG NOTA 

sele 4
use q:\scgc\central\itemmov alias itcentral
SET ORDER TO TAG IT_NF_REAL




sele loja
seek STR(LNFilial,3)+STR(LNNota,7)

if found()
	scatter memvar
	SELECT central
	SET ORDER TO TAG NOTA 
	seek STR(LNFilial,3)+STR(LNNota,7)
	if found()
		gather memvar
	endif	
endif


sele itloja
seek STR(LNFilial,3)+"S"+STR(LNNota,7)


do while !eof() and  lnnota = itloja.nota
	scatter memvar
	SELECT itcentral
    seek STR(m.EMPRESA,3)+m.CODIGO+STR(m.FAVORECIDO,14)+m.TIPO;
          +STR(m.NOTA,7)+DTOS(m.DTFAT)+STR(m.ORDEM,3)
    if found()
		gather memvar
	endif	
    sele itloja
    skip


enddo

