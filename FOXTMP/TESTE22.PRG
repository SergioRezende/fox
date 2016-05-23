set talk on
set escape on
USE Q:\SCGC\CENTRAL\ITEMMOV
SET NEAR ON
SET ORDER TO TAG DT_MOV OF Q:\SCGC\CENTRAL\ITEMMOV.CDX
SEEK STR(10,3)+DTOS({01.08.2000})
SET STEP ON
DO WHILE !EOF() AND EMPRESA = 10

	SCATTER MEMVAR
	IF LEFT(m.operacao,1) <> "S" OR m.ch_opera $ "56"
		SKIP
		LOOP
	ENDIF

	=W_DEFPROC("PRECO.SPR")
	IF !PRpreco((m.empresa),m.ch_opera,m.tipo,;
				(m.codigo),(m.data),m.preco,m.clas_cms)
		SELE ITEMMOV
		SKIP
		LOOP
	ENDIF
	LSid_chamada = ("DADO VALOR FINAL (VLRVENDA)") 
	*----------------------------------------------------------*
	=W_DEFPROC("ORCAMENT.SPR")
	=ORcalc_vlres(m.preco,(m.qtde),m.DESCONTO,(m.taxa),;
					m.precofinal,m.vlrvenda,LSid_chamada)
	SELE itemmov

	=LOCK()
	GATHER MEMVAR
	SKIP
ENDDO
