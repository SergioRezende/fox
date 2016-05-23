CLOSE ALL
SET DATE GERMAN
USE FORNECE
ZAP
PACK
SELE 0
USE FORNIMPO
ZAP
PACK
APPEND FROM Q:\SCGC01\ARQFORN.TXT TYPE SDF
******>> PREENCHIMENTO DOS CAMPOS
SELE fornimpo
go top
DO WHILE !eof()
	m.codigo 		= fornimpo.cod
	m.tp_pessoa		= 1
	m.cgc	 		= fornimpo.cgc
	m.nome			= fornimpo.nome	
	m.tp_inscr		= 1
	m.inscricao		= fornimpo.insc
	m.estado		= fornimpo.UF
	m.pais			= "BRASIL"
	
	SELE FORNECE
	APPEND BLANK
	GATHER MEMVAR MEMO
	SELE fornimpo
	SKIP

   *
ENDDO
