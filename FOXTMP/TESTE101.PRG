SELECT 	NF.empresa   , NF.nota,      NF.serie,    ;
        NF.codforn   , NF.inscricao,  NF.uf, ;
		NF.tipo,       NF.data,    ;
		NF.vlrfrete,   NF.vlrseguro,    NF.vlrdespes,;
        NF.total_nota  AS VlrNota,;      
		IIF(IT.tp_mercad = 1,tipooper.cfo,tipooper.cfosubs) as SET_CFO,;
	  	IT.aliq_icms,;
		SUM(IT.vlrvenda)  AS TOTAL_NOTA,;
	  	SUM(IT.base_subs) AS BASE_SUBS,;
	  	SUM(IT.icms_subs) AS ICMS_SUBS,;
	  	SUM(IT.base_calc) AS BASE_CALC,;
	  	SUM(IT.Base_calc * IT.aliq_icms/100) AS VLR_ICMS,;
		SUM(IT.base_isent) AS BASE_ISENT ,;
		SUM(IT.base_outr)  AS BASE_OUTR ;
   	FROM C:\TEMP\NOTAENT  NF,;
   	     C:\TEMP\ITEMMOV  IT,;
   	     C:\SCGC\LOJA\TIPOOPER ;
    WHERE ;
            NF.empresa = 1 ;
   	    AND NF.data >= {03.02.2003}     ;
   		AND NF.operacao =  "E"         ;
   		AND TIPOOPER.TIPO = NF.TIPO    ;
   	    AND TIPOOPER.PROCESSO $ "Ee" ;
   		AND LEFT(IT.OPERACAO,1) = "S" ;
   		AND IT.EMPRESA = NF.EMPRESA    ;
   		AND IT.NOTA    = NF.NOTA         ;
   		AND IT.SERIE   = NF.SERIE        ;
    ORDER BY NF.EMPRESA, NF.DATA, NF.NOTA, SET_CFO, IT.ALIQ_ICMS           ;
    GROUP BY NF.EMPRESA, NF.DATA, NF.NOTA, SET_CFO, IT.ALIQ_ICMS

modif 