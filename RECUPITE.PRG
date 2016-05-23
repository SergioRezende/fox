set excl off
set talk on
set dele on
set date german
set escape on
set step on
sele 0

use q:\scgc\central\itemmov

go top

do while !eof()
	scatter memvar
	=RLOCK()
	GATHER MEMVAR
	skip 
enddo
