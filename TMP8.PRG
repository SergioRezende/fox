

RETURN

*****************************************************************
FUNCTION ULNVMapaResumoECF
PARAMETERS PrmEmp,PrmDtIni,PrmDtFin


    SET STEP ON

	=ULLvrAnlCpm()

	=ULcfoPreponderante()


   * "0"                 		AS IND_MR,;
   *   LEFT(EMP.ecf_serie+SPACE(15),15)	AS ECF_FAB,;


	SELECT ;
	   STR(EMP.CGC,14) 			AS UNEM_CNPJ,;
	   "1"                 		AS IND_MR,;
	   LEFT(EMP.ecf_serie+SPACE(20),20)	AS ECF_FAB,;
	   "2D"                 	AS COD_MOD,;
	   EMP.TIPO_ECF             AS ECF_MOD,;
       STR(MP.ECF,4)   			AS ECF_CX,;
	   STR(MP.CTRREINICI,6)		AS CRO,;
	   STR(MP.CTRREDUCAO,6) 	AS CRZ,;
	   STR(MP.CTO_INICIO,6) 	AS NUM_DOC_INI,;
	   STR(MP.CTO_FIM,6)		AS NUM_DOC_FIN,;
	   STR(MP.GT_INICIAL,12,2) 	AS GT_INI,;
	   STR(MP.GT_FINAL,12,2)   	AS GT_FIN,;
	   MP.DATA AS DT_DOC,;
      "5504"	        AS CFO_PREP,;
	  MP.ALIQUOTA       AS  ALIQ_ICMS,;
	  MP.VLRCONTAB      AS VL_BRT,;
      MP.CANC_ISSQN     AS VLCANISSQN,;
      MP.CANC_ICMS  	AS VLCANICMS,;
	  MP.CANCELA     	AS VL_CAN,;
      MP.DESC_ISSQN	    AS VLDSCISSQN,;
	  MP.DESC_ICMS 	    AS VLDSCICMS,;
      MP.DESCONTO		AS VLDSC,;
      MP.ACMO_ISSQN	    AS VLACMISSQN,;
	  MP.ACMO_ICMS	    AS VLACMICMS,;
	  MP.ACRESCIMO	   	AS VLACM,;
	  MP.VLRSERVICO     AS VL_ISSQN,;
      MP.VLRCONTAB 	    AS VL_CONT,;
  	  0    AS VL_BC_ICMS,;
   	  0    AS VL_ICMS,;
   	  MP.VLRISENT	AS VL_ISEN,;
   	  MP.BASE_ALIQ	AS VL_LIQ,;
	  0          	AS VL_NT,;
   	  MP.VLRSUBST	AS VL_ST,;
      "0"			AS COD_INF_OBS;
	  FROM 	EMPRESA  EMP, ;
	       	MAPAECF  MP ;
	  WHERE EMP.EMPRESA = PrmEmp ;
	  	AND MP.EMPRESA = PrmEmp ;
	  	AND MP.DATA >= PrmDtIni ;
	  	AND MP.DATA <= PrmDtFin ;
	  GROUP BY UNEM_CNPJ,;
  			DT_DOC,;
  			ECF_CX;
	  ORDER  BY UNEM_CNPJ,;
  			DT_DOC,;
  			ECF_CX;
	  INTO CURSOR  TMPReducao





	


	SELECT  *;
	        ;
	FROM TMPReducao ;
	WHERE CP.DATA = CFO.DATA ;
	INTO TABLE  \TMP\LVMapaECF

	*-------------------------------------------------------------------*

RETURN


