return

FUNCTION ULItmSda54
	*-------------------------------------------------------------------*
	*	ITENS DAS NOTAS DE SAIDA
	*-------------------------------------------------------------------*

   SELECT ;
          "1"  AS IND_OPER,;
          "0"  AS IND_EMIT,;
   		  "01"  AS COD_MOD,;
   		  "00"  AS COD_SIT,;
   		  NF.EMPRESA, NF.NOTA,;
   		  NF.SERIE, NF.CUPOM, NF.FAVORECIDO, NF.TP_PESSOA, NF.INSCRICAO,;
          NF.UF, NF.tipo, NF.data, NF.vlrfrete,;
		  NF.vlrseguro, NF.vlrdespes, NF.status,;
          NF.total_nota AS VlrNota,;      
		  ULdefCfo(NF.empresa,NF.tipo,it.tp_mercad,"SAIDA") AS SET_CFO,;
	  	  IT.codigo, IT.CLASSIFICA, IT.DESCRICAO, IT.UNIDADE,;
	  	  IT.ORIGEM,IT.CST,IT.ALIQ_IPI, IT.ALIQ_ICMS,;
	  	  IT.IVA, IT.TP_MERCAD, IT.QTDE, IT.VLRVENDA, IT.BASE_CALC,;
	  	  IT.BASE_SUBS,;
	 	  IT.base_isent,;
		  IT.base_outr, ;
	  	  IT.base_ipi,;
	  	  IT.vlripi,;
	 	  IT.base_isipi,;
		  0,00  AS VL_OUT_IPI;
   	FROM  &dbf_NFSTMP NF,;
   	      &dbf_TIPTMP TP,;
   	      &dbf_ITMTMP IT ;
    WHERE ;
              NF.status = 1 ;
   		  AND NF.operacao = "S" AND NF.CUPOM = 0 ;
   		  AND TP.KEY_TIPO = NF.KEY_TIPO ;
   	      AND TP.PROCESSO $ "Ss" ;
   		  AND LEFT(IT.OPERACAO,1) = "S" ;
   	 	  AND IT.EMPRESA = NF.EMPRESA ;
   		  AND IT.NOTA    = NF.NOTA ;
   		  AND IT.SERIE   = NF.SERIE ;
    ORDER BY NF.EMPRESA, NF.DATA, NF.NOTA, IT.CODIGO ;
  	INTO CURSOR TMP_1LS


	*-------------------------------------------------------------------*
	*	ITENS DAS COPIAS DE CUPONS EM NOTAS DE SAIDA
	*-------------------------------------------------------------------*

   SELECT * FROM TMP_1LS ;
   UNION ;
   SELECT ;
          "1"  AS IND_OPER,;
          "0"  AS IND_EMIT,;
   		  "01"  AS COD_MOD,;
   		  "00"  AS COD_SIT,;
   		  CP.EMPRESA, CP.NOTA,;
   		  CP.SERIE, CP.CUPOM, CP.FAVORECIDO, CP.TP_PESSOA, CP.INSCRICAO,;
          CP.UF, CP.tipo, CP.data, CP.vlrfrete,;
		  CP.vlrseguro, CP.vlrdespes, CP.status,;
          CP.total_nota AS VlrNota,;      
		  ULdefCfo(CP.empresa,CP.tipo,it.tp_mercad,"SAIDA") AS SET_CFO,;
	  	  IT.codigo, IT.CLASSIFICA, IT.DESCRICAO, IT.UNIDADE,;
	  	  IT.ORIGEM,IT.CST,IT.ALIQ_IPI, IT.ALIQ_ICMS,;
	  	  IT.IVA, IT.TP_MERCAD, IT.QTDE, IT.VLRVENDA, IT.BASE_CALC,;
	  	  IT.BASE_SUBS,;
	 	  IT.base_isent,;
		  IT.base_outr, ;
	  	  IT.base_ipi,;
	  	  IT.vlripi,;
	 	  IT.base_isipi,;
		  0,00  AS VL_OUT_IPI;
   	FROM  &dbf_NFSTMP CP,;
   	      &dbf_NFSTMP NF,;
   	      &dbf_TIPTMP TP,;
   	      &dbf_ITMTMP IT ;
    WHERE CP.status = 1 ;
   		  AND CP.operacao = "C" AND CP.CUPOM > 0 ;
   	 	  AND NF.EMPRESA = CP.EMPRESA ;
   		  AND NF.NOTA    = CP.REFERENCIA ;
   		  AND NF.SERIE   = CP.SERIE ;
   		  AND TP.KEY_TIPO = NF.KEY_TIPO ;
   	      AND TP.PROCESSO $ "Ss" ;
   		  AND LEFT(IT.OPERACAO,1) = "S" ;
   	 	  AND IT.EMPRESA = NF.EMPRESA ;
   		  AND IT.NOTA    = NF.NOTA ;
   		  AND IT.SERIE   = NF.SERIE ;
  	INTO CURSOR TMP_2LS

	
	SELECT * FROM TMP_2LS ;
    ORDER BY EMPRESA, DATA, NOTA, CODIGO ;
	INTO CURSOR	ILIVROSAI

RETURN
