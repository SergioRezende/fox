  SET STEP ON	
  SET DATE GERMAN
  SET CENTU ON	
  DO DIApuraIcms WITH 4, {01.01.2009},{31.01.2009}

return

PROCEDURE DIApuraICMS
PARAMETERS ;
		PrmEmpresa,;
		PrmDtInicio,;
		PrmDtFinal

	PRIVATE LSAlias

	=DIVerifyInst()


	LSAlias = 	DIGetAlias()
	
	*--------------------------------------*
	* SELECAO GERAL DO ITENS CONFORME CRITERIO
	* DE EMPRESA E DATAS
	* ---> NAO CONTABILIZA COPIA DE CUPOM
	*--------------------------------------*

	SELECT ;
		   CFOP, ;
	       VLR_FINAL, ;
		   bc_icms,;
		   vlr_icms,;
		   base_isent,;
		   base_outr,;
		   bc_iss,;
		   icm_rtd_s;
	FROM &LSAlias ;
	WHERE ;
		     &LSAlias .empresa = PrmEmpresa ;
		 AND &LSAlias .dt_EntSai  >= PrmDtInicio ;
		 AND &LSAlias .dt_EntSai  <= PrmDtFinal ;
		 AND !(&LSAlias .CFOP	$ "5929/6929" ;
    into cursor SEL_itens

	*--------------------------------------*

	SELECT ;
		   "RG001"         AS TP_REG,;	
		   CFOP            AS CFOP_AP, ;
	       SUM(VLR_FINAL)  AS VLR_CONTB, ;
		   SUM(bc_icms)    AS BASE_ICMS,;
		   SUM(vlr_icms)   AS VLR_ICMS,;
		   SUM(base_isent) AS VLR_ISENT,;
		   SUM(base_outr+bc_iss)  AS OUTRAS,;
		   SUM(icm_rtd_s)  AS ICMS_RTD;
	FROM SEL_itens ;
	GROUP BY CFOP_AP ;
	UNION ;
	SELECT ;
		   "RG002"  AS TP_REG,;	
		   (LEFT(CFOP,1)+"--->") AS CFOP_AP, ;
	       SUM(VLR_FINAL) AS VLR_CONTB,  ;
		   SUM(bc_icms)    AS BASE_ICMS,;
		   SUM(vlr_icms)   AS VLR_ICMS,;
		   SUM(base_isent) AS VLR_ISENT,;
		   SUM(base_outr+bc_iss)  AS OUTRAS,;
		   SUM(icm_rtd_s)  AS ICMS_RTD;
	FROM SEL_itens ;
	GROUP BY CFOP_AP;
	UNION ;
	SELECT ;
		   "RG003"         AS TP_REG,;	
		  "TEnt="          AS CFOP_AP, ;
	       SUM(IT.VLR_FINAL)  AS VLR_CONTB,  ;
		   SUM(IT.bc_icms)    AS BASE_ICMS,;
		   SUM(IT.vlr_icms)   AS VLR_ICMS,;
		   SUM(IT.base_isent) AS VLR_ISENT,;
		   SUM(IT.base_outr+bc_iss)  AS OUTRAS,;
		   SUM(IT.icm_rtd_s)  AS ICMS_RTD;
	FROM SEL_itens IT;
	WHERE IT.CFOP_AP < "5000" ;
	GROUP BY CFOP_AP;
	UNION ;
	SELECT ;
		   "RG003"         AS TP_REG,;	
		  "TSai="          AS CFOP_AP, ;
	       SUM(IT.VLR_FINAL)  AS VLR_CONTB,  ;
		   SUM(IT.bc_icms)    AS BASE_ICMS,;
		   SUM(IT.vlr_icms)   AS VLR_ICMS,;
		   SUM(IT.base_isent) AS VLR_ISENT,;
		   SUM(IT.base_outr+bc_iss)  AS OUTRAS,;
		   SUM(IT.icm_rtd_s)  AS ICMS_RTD;
	FROM SEL_itens IT;
	WHERE IT.CFOP_AP >= "5000" ;
	GROUP BY CFOP_AP;
	order by TP_REG,CFOP_AP;
	into cursor APUracao

	SELECT ;
		  CFOP_AP AS CFOP, ;
	      VLR_CONTB,  ;
		  BASE_ICMS,;
		  VLR_ICMS,;
		  VLR_ISENT,;
		  OUTRAS,;
		  ICMS_RTD;
	FROM APUracao ;
	into cursor APUFinal
	


	=W_DEFPROC("rotinas.spr")
	DO loc_dlog WITH  .t.,.F.,.F.,.F.,.F.,.t.

	SELE APURACAO
	USE
	SELE SEL_itens
	use
	
	SELE APUFinal
	use

	

RETURN	