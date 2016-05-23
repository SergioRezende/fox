SET EXCLUSIVE ON

SELE 0
USE PRECO
ZAP
PACK

*----------------- ITENS
SELE 0
USE ESTQIMPO
ZAP 
PACK
APPEND FROM U:\EST\ARQFIXO.TXT TYPE SDF
GO TOP
m.ordem  = 0
SELE ESTQIMPO
DO WHILE !EOF()
	m.codigo 	=	LEFT(estqimpo.codigo,7)
	m.codigo	=   ALLTRIM(m.codigo)+UPCALCDIG(m.codigo)

	m.classifica =  estqimpo.grp+estqimpo.sub+estqimpo.clas+;
					estqimpo.seq+estqimpo.marca
	m.empresa   = 1
	m.tabpreco  = 1 
	m.serie     = "A"
    m.preco     =   estqimpo.valor / 100

	SELE PRECO
	APPEND BLANK
	GATHER MEMVAR MEMO
	SELE estqimpo
	SKIP
ENDDO

