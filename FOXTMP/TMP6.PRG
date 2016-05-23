set escape on
set talk on
close all
SET EXCL OFF

SELE 0
USE \SCGC\LOJA\DUPLICAT
SET ORDER TO TAG DOC_CLIE
GO TOP
SELE 0
USE \SCGC\LOJA\CLIENTES
SET ORDER TO TAG CLIENTE

SELE DUPLICAT
GO TOP
DO WHILE !EOF()
	SELE CLIENTES
	SEEK duplicat.cliente
	IF !found()
		sele duplicat
		skip
		loop
	endif
	sele duplicat
	do while !eof() and duplicat.cliente = clientes.cliente
		=rlock()
		replace duplicat.nome with clientes.nome
		skip
	enddo

ENDDO
