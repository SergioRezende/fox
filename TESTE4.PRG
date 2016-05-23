
	close data
	USE X:\SCGC\CENTRAL\DOCFISIT


	SELECT ;
		   "RG001"         AS TP_REG,;	
		   CFOP            AS CFOP_AP, ;
	       SUM(VLR_FINAL)  AS VLR_CONTB, ;
		   SUM(bc_icms)    AS BASE_ICMS,;
		   SUM(vlr_icms)   AS VLR_ICMS,;
		   SUM(base_isent) AS VLR_ISENT,;
		   SUM(base_outr)  AS OUTRAS,;
		   SUM(icm_rtd_s)  AS ICMS_RTD;
	FROM DOCFISIT ;
	WHERE CFOP < "5000" ;
	GROUP BY CFOP_AP ;
	UNION ;
	SELECT ;
		   "RG002"  AS TP_REG,;	
		   (LEFT(CFOP,1)+"--->") AS CFOP_AP, ;
	       SUM(VLR_FINAL) AS VLR_CONTB,  ;
		   SUM(bc_icms)    AS BASE_ICMS,;
		   SUM(vlr_icms)   AS VLR_ICMS,;
		   SUM(base_isent) AS VLR_ISENT,;
		   SUM(base_outr)  AS OUTRAS,;
		   SUM(icm_rtd_s)  AS ICMS_RTD;
	FROM DOCFISIT ;
	WHERE CFOP < "5000" ;
	GROUP BY CFOP_AP;
	UNION ;
	SELECT ;
		   "RG003"  AS TP_REG,;	
		  "T>Ent" AS CFOP_AP, ;
	       SUM(VLR_FINAL) AS VLR_CONTB,  ;
		   SUM(bc_icms)    AS BASE_ICMS,;
		   SUM(vlr_icms)   AS VLR_ICMS,;
		   SUM(base_isent) AS VLR_ISENT,;
		   SUM(base_outr)  AS OUTRAS,;
		   SUM(icm_rtd_s)  AS ICMS_RTD;
	FROM DOCFISIT ;
	WHERE CFOP < "5000" ;
	GROUP BY CFOP_AP;
	;
	UNION ;
	;
		SELECT ;
		   "RG004"  AS TP_REG,;	
		   CFOP  AS CFOP_AP, ;
	       SUM(VLR_FINAL) AS VLR_CONTB, ;
		   SUM(bc_icms)    AS BASE_ICMS,;
		   SUM(vlr_icms)   AS VLR_ICMS,;
		   SUM(base_isent) AS VLR_ISENT,;
		   SUM(base_outr)  AS OUTRAS,;
		   SUM(icm_rtd_s)  AS ICMS_RTD;
	FROM DOCFISIT ;
	WHERE CFOP >= "5000" ;
	GROUP BY CFOP_AP ;
	UNION ;
	SELECT ;
		   "RG005"  AS TP_REG,;	
		   (LEFT(CFOP,1)+"--->") AS CFOP_AP, ;
	       SUM(VLR_FINAL) AS VLR_CONTB,  ;
		   SUM(bc_icms)    AS BASE_ICMS,;
		   SUM(vlr_icms)   AS VLR_ICMS,;
		   SUM(base_isent) AS VLR_ISENT,;
		   SUM(base_outr)  AS OUTRAS,;
		   SUM(icm_rtd_s)  AS ICMS_RTD;
	FROM DOCFISIT ;
	WHERE CFOP >= "5000" ;
	GROUP BY CFOP_AP;
	UNION ;
	SELECT ;
		   "RG006"  AS TP_REG,;	
		  "T>Sai" AS CFOP_AP, ;
	       SUM(VLR_FINAL) AS VLR_CONTB,  ;
		   SUM(bc_icms)    AS BASE_ICMS,;
		   SUM(vlr_icms)   AS VLR_ICMS,;
		   SUM(base_isent) AS VLR_ISENT,;
		   SUM(base_outr)  AS OUTRAS,;
		   SUM(icm_rtd_s)  AS ICMS_RTD;
	FROM DOCFISIT ;
	WHERE CFOP >= "5000" ;
	GROUP BY CFOP_AP;
	order by TP_REG,CFOP_AP
	

	