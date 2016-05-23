
SET DATE GERMAN
SELE 0
USE GRUPO
SET ORDER TO TAG codigo

SELE 0
USE SALDO
SET ORDER TO TAG emp_mes

SELE 0
USE SALDIMPO
ZAP
PACK
APPEND FROM Q:\TMP\ARQALX01.TXT TYPE SDF
GO TOP
******>> PREENCHIMENTO DOS CAMPOS
DO WHILE !EOF()
	M.EMPRESA 	     = saldimpo.filial
	M.DTABERT 	     = CTOD("01.09.96")
	M.CODIGO 		 = saldimpo.codigo
	SELE grupo
	SEEK m.codigo
   	M.CLASSIFICA     = grupo.classifica
********************************************************
	SELE saldo
	SEEK STR(m.empresa,3)+STR(YEAR(m.dtabert),4)+;
		 STR(MONTH(m.dtabert),2)+m.classifica
	IF FOUND()
		SELE SALDIMPO
		SKIP
	ENDIF
********************************************************
*	M.SLD_ANTE	     = saldimpo.sld_ante
*	M.VLR_ANTE	     = saldimpo.vlr_ante / 100
*	M.SLD_ATU		 = saldimpo.sld_ante
*	M.VLR_ATU		 = saldimpo.vlr_ante / 100

	M.SLD_ANTE	     = saldimpo.saldo
	M.VLR_ANTE	     = saldimpo.valor / 100
	M.SLD_ATU		 = saldimpo.saldo 
	M.VLR_ATU		 = saldimpo.valor / 100

   	M.DT_ENTRADA     =  LEFT(saldimpo.dt_entrada,2)+"."+;
   						SUBS(saldimpo.dt_entrada,3,2)+"."+;
						SUBS(saldimpo.dt_entrada,5,2)
   	M.DT_SAIDA       =  LEFT(saldimpo.dt_saida,2)+"."+;
   						SUBS(saldimpo.dt_saida,3,2)+"."+;
						SUBS(saldimpo.dt_saida,5,2)
	M.QTD_COMPRA	 = 0
	M.VLR_COMPRA 	 = 0
	M.QTD_VENDA	     = 0
	M.VLR_VENDA  	 = 0
	M.QTD_E_TRAN	 = 0
	M.VLR_E_TRAN 	 = 0
	M.QTD_E_OUTR	 = 0
	M.VLR_E_OUTR 	 = 0
	M.QTD_S_TRAN	 = 0
 	M.VLR_S_TRAN 	 = 0
	M.QTD_S_OUTR	 = 0
	M.VLR_S_OUTR 	 = 0
	M.VEN_TAB		 = 0
	M.VEN_CONTAB	 = 0
	M.VEN_ENC		 = 0
	SELE SALDO
	APPEND BLANK
	GATHER MEMVAR MEMO
	SELE SALDIMPO
	SKIP
ENDDO
