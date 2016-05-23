
*-------------------------------------------------------------------*
******    ALTERACAO DATA DE LIBERACAO DE CADASTRO PARA CLIENTES *****
*-------------------------------------------------------------------*


SET DATE GERMAN
SET CENTU ON
SET STEP ON
SET TALK ON
SET ESCAPE ON
ON ERROR
ON KEY

CLOSE ALL

SELE 0

SELE 0
USE Q:\SCGC\LOJA\CLIENTES
GO TOP

DO   WHILE !EOF()


	M.dtliberacd = CLIENTES.dtliberacd

	IF EMPTY(clientes.ULT_ATEND)
		m.dtbase = DATE() - 60
	ELSE
		m.dtbase = clientes.ULT_ATEND
	ENDIF	

	IF EMPTY(clientes.DTCAD)
		m.dtcad = DATE() - 380
	ELSE
		m.dtcad = clientes.dtcad
	ENDIF	

	DO CASE
		CASE clientes.natureza = 0   && varejo  12 meses

			IF EMPTY(M.dtliberacd) OR (M.dtliberacd < (date() - 360))
				IF m.dtcad < date() - 360  && vencido
					m.dtliberacd = m.dtbase - 240   && 8 meses
				ELSE
					m.dtliberacd = m.dtcad 
				ENDIF			
			ENDIF
		OTHERWISE

			IF EMPTY(M.dtliberacd) OR (M.dtliberacd < (date() - 180))
				IF m.dtcad < date() - 180  && vencido
					m.dtliberacd = m.dtbase - 90   && 3 meses
				ELSE
					m.dtliberacd = m.dtcad 
				ENDIF			
			ENDIF
	ENDCASE

	SELE CLIENTES
	=RLOCK()
	REPLACE dtliberacd WITH M.dtliberacd
	SKIP
ENDDO
