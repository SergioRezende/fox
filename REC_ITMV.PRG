SET EXCL OFF

set dele on
set date german

use Q:\scgc\CENTRAL\ITEMMOV

GO TOP

ctr = 0


do while !eof()
	scatter memvar
	IF RLOCK()
		gather memvar
	ENDIF
    skip
    ctr = ctr + 1
 
   
    wait window str(ctr,7) nowait
enddo

