   SELECT NF.nota AS A ,  NF.serie,   NF.data,  NF.HORA  ;
          NF.uf, ;
		  IIF(IT.tp_mercad <> 2 ,TP.cfo, TP.cfosubs) as B,;
   		  NF.status, NF.OPERACAO, NF.cupom, ;
		  SUM(IT.base_iss)  AS C,;
		  SUM(IT.base_iss)  AS D,;
		  NF.ALIQ_ISS,;
		  SUM(IT.vlr_iss)   AS E,;
	  	  SUM(IT.base_calc) AS F,;
	  	  IT.aliq_icms,;
	  	  SUM(IT.Base_calc * IT.aliq_icms/100) AS VLR_ICMS,;
	  	  SUM(IT.base_sbbrt) AS BASE_SBBRT,;
	  	  SUM(IT.base_subs)  AS BASE_SUBS ,;
	  	  SUM(IT.icms_subs)  AS ICMS_SUBS ,;
	 	  SUM(IT.base_isent) AS BASE_ISENT ,;
		  SUM(IT.base_outr)  AS BASE_OUTR, ;
		  SUM(IT.base_isipi)  AS BASE_ISIPI, ;
		  SUM(IT.base_ipi)  AS BASE_IPI, ;
		  SUM(IT.vlripi)    AS VLR_IPI, ;
		  NF.vlrfrete,   NF.vlrseguro,    NF.vlrdespes,;
		  SUM(IT.vlrvenda)  AS TOTAL_NOTA;
   	FROM  &dbf_NFSTMP  NF,;
   	      &dbf_TIP     TP,;
   	      &dbf_ITMTMP  IT ;
    WHERE ;
              NF.status = 1;
   		  AND NF.operacao =  "S";
   		  AND NF.CUPOM = 0;
   		  AND TP.TIPO = NF.TIPO;
   	      AND TP.PROCESSO $ "Ss";
   		  AND LEFT(IT.OPERACAO,1) = "S" ;
   	 	  AND IT.EMPRESA = NF.EMPRESA;
   		  AND IT.NOTA    = NF.NOTA;
   		  AND IT.SERIE   = NF.SERIE;
    GROUP BY NF.NOTA, SET_CFO, IT.ALIQ_ICMS ;
    INTO TABLE L:\TMP\TMP1
