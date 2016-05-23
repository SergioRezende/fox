*-------------------------------------------------------------*
*  ACERTA A INSCRICAO DAS NOTAS CONFORME A INSCRICAO DO 
* CADASTRO SE A INSCRICAO DA NOTA FOR INVALIDA
*-------------------------------------------------------------*
ON ERROR
set procedure to rotinas.spr

SELE 0
USE \scgc\LOJA\nota

SELE 0
USE \scgc\LOJA\CLIENTES
SET ORDER TO TAG CLIENTE OF Q:\SCGC\LOJA\CLIENTES.CDX

on error
SET DELE ON
SET DATE GERMAN
set escape on
set talk off
SET STEP ON

SELE NOTA
GO TOP
DO WHILE !EOF()
	IF !UPInscricao(nota.uf,nota.INSCRICAO,1,0,0,'') 
		SELE CLIENTES
		SEEK nota.favorecido
		IF FOUND() AND UPInscricao(clientes.estado,clientes.INSCRICAO,1,0,0,'') 
			SELE nota
			=REGLOCK(.T.)
			replace nota.inscricao with clientes.inscricao
		ENDIF
	ENDIF
	SELE NOTA
	SKIP			
ENDDO

