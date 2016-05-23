set dele on
set date german

use x:\scgc\w3\clientes
copy stru to x:\tmp\new_clie with cdx

sele 0
use  x:\tmp\new_clie
ctr = 0

sele clientes
do while !eof()
	scatter memvar
	sele  new_clie
	append blank
	gather memvar
	
    sele clientes
    skip
    ctr = ctr + 1
 
   
    wait window str(ctr,7) nowait
enddo

