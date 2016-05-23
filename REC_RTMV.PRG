SET EXCL OFF
set talk on
set dele on
set date german
set escape on

sele 0
use Q:\scgc\CENTRAL\RETORNMV


go TOP
ctr = 1


do while !bof()
	scatter memvar
	msg = str(ctr,6)+"    -    "+" Rec : "+str(recno(),7)
	WAIT WINDOW MSG NOWAIT
	=RLOCK()
	GATHER MEMVAR
	skip 
	ctr = ctr + 1
enddo
