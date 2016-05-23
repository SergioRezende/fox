*-----------------------------------------------------------------------*
* CEPMUNI transfere para tabela CEP_MUNI E MUNICPIO os ceps encontradas
* e informados em cep enc3
*-----------------------------------------------------------------------*

CLOSE ALL

*---------------------------------------*

SELE 0
USE  X:\FPD26\CEP\CEP_MUNI.DBF ALIAS MUN
SET ORDER TO TAG UF_CIDADE


SELE 0
USE  X:\FPD26\CEP\CEP_ENC3.DBF ALIAS LOC
SET ORDER TO TAG UF_CID_OK


SELE 0
USE  X:\FPD26\CEP\MUNICPIO.DBF ALIAS NM_MUN
SET ORDER TO TAG UF_CIDADE
SET RELATION TO MUNI_UF+LEFT(ALLTRIM(NMESEMCHAR),30) INTO MUN
SET RELATION TO MUNI_UF+LEFT(ALLTRIM(NMESEMCHAR),30) INTO LOC ADDITIVE


*-------------------------------------*


IF 1=1
	GO TOP
	DO WHILE !EOF()
		IF EMPTY(NM_MUN.MUNI_CEP)
       	    IF MUN.MUNI_CEP > 0
                REPLACE NM_MUN.MUNI_CEP WITH MUN.MUNI_CEP
            ENDIF
		ENDIF
		SKIP
	ENDDO
ENDIF

*-----------
BROWS FIELDS MUN.MUNI_CEP  :H="MUN CEP",;
             LOC.CEP  :H="ENC CEP",;
             NM_MUN.MUNI_CEP,;
             NM_MUN.MUNI_UF,;
             NM_MUN.MUNI_NOME;
	  FOR     EMPTY(NM_MUN.MUNI_CEP) 
 	  FOR  !EMPTY(LOC.CEP)

*	  FOR     EMPTY(CEP.ENDE_CEP) ;
 *     AND EMPTY(MUN.MUNI_CEP) ;
 *     AND EMPTY(LOC.CEP)
             

*-----------
IF 1=2
	COPY FIELDS NF.CEP,NF.UF,NF.CIDADE ;
	  TO  X:\FPD26\CEP\CEP_INV4 ;
	  FOR     EMPTY(CEP.ENDE_CEP) ;
      AND EMPTY(MUN.MUNI_CEP) ;
       AND EMPTY(LOC.CEP)
	SELECT CEP,UF,CIDADE FROM X:\FPD26\CEP\CEP_INV4 GROUP BY UF,CIDADE INTO  TABLE X:\FPD26\CEP\CEP_INV
ENDIF
*-----------
