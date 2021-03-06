
CLOSE ALL
USE X:\SCGC\LOJA_CGB\NOTA ALIAS CGB
SET ORDER TO TAG DT_GERAL OF X:\SCGC\LOJA_CGB\NOTA.CDX

SELE 0
USE Q:\SCGC\CENTRAL\NOTA ALIAS CENTRAL
SET ORDER TO TAG NOTA OF Q:\SCGC\CENTRAL\NOTA.CDX


SELECT CGB
SET RELATION TO STR(EMPRESA,3)+STR(NOTA,7) INTO CENTRAL

SET STEP ON
	     

BROWS FIELDS CGB.DATA,;
     CGB.REFERENCIA,;
     CENTRAL.REFERENCIA,;
     CGB.STATUS,;
     SIT = IIF(CGB.TIPO<>CENTRAL.TIPO ;
        .OR. CGB.NOTA<>CENTRAL.NOTA ;
        .OR. CGB.TOTAL_NOTA<>CENTRAL.TOTAL_NOTA ,"ERRO","    "),;
     CGB.NOTA,;
     CGB.TIPO,;
     CENTRAL.NOTA,;
     CENTRAL.TIPO,;
     CGB.TOTAL_NOTA,;
     CENTRAL.TOTAL_NOTA

*LIST  FIELDS CGB.DATA,CGB.REFERENCIA,CENTRAL.REFERENCIA,CGB.NOTA,CGB.TIPO,CENTRAL.NOTA,CENTRAL.TIPO,CGB.TOTAL_NOTA,CENTRAL.TOTAL_NOTA, IIF(CGB.TIPO<>CENTRAL.TIPO .OR. CGB.NOTA<>CENTRAL.NOTA .OR. CGB.TOTAL_NOTA<>CENTRAL.TOTAL_NOTA ,"ERRO","    ") WHILE !EOF() TO L:\TMP\PRT0001A.REL OFF
LIST  FIELDS CGB.DATA,CGB.REFERENCIA,CENTRAL.REFERENCIA,CGB.STATUS,IIF(CGB.TIPO<>CENTRAL.TIPO .OR. CGB.NOTA<>CENTRAL.NOTA .OR. CGB.TOTAL_NOTA<>CENTRAL.TOTAL_NOTA ,"ERRO","    "),CGB.NOTA,CGB.TIPO,CENTRAL.NOTA,CENTRAL.TIPO,CGB.TOTAL_NOTA,CENTRAL.TOTAL_NOTA WHILE !EOF() TO L:\TMP\PRT0001A.REL OFF


*SELECT CGB.ORCAMENTO AS OSI_CGB,;
*	   CEN.ORCAMENTO AS OSI_CEN,;
*	   CGB.DT_FAT AS DATA,;
*	   CGB.NOTA AS NF_CGB,;
*	   CEN.NOTA AS NF_CEN;
*    FROM X:\SCGC\LOJA_CGB\ORCAMENT CGB,;
*		Q:\SCGC\CENTRAL\ORCAMENT CEN;
*    WHERE ;
*           CGB.DT_FAT >={20.09.2006} ;
*	   AND CEN.EMPRESA  = CGB.EMPRESA ;
*       AND CEN.ORCAMENTO = CGB.ORCAMENTO ;
*       AND CEN.NOTA <> CGB.NOTA
