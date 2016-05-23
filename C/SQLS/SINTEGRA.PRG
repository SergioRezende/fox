*-----------------------------------------------------------------*
*	SAIDAS
*-----------------------------------------------------------------*
*   SAIDAS ANALITICA
*-----------------------------------------------------------------*
	SELECT 	nota,serie, cupom, favorecido,tp_pessoa,;
			inscricao, uf, cfo,tipo,;
	        data, total_nota,;
	  		icms_subs, base_icms, aliq_icms,;
	  		(base_icms * aliq_icms/100) as vlr_icms,
		    base_isent,base_outr,aliq_icms,status;
   FROM q:\scgc\loja\nota where  ;
		        data >= {01.01.2002} ;
			AND data <= {31.01.2002} ;
   			AND operacao =  "S" AND CUPOM = 0 AND STATUS = 1 ;
    ORDER BY DATA ;
   	INTO CURSOR LIVROSAI
*-----------------------------------------------------------------*
*   SAIDAS RESUMO POR CFO
*-----------------------------------------------------------------*
	SELECT 	cfo, data, ;
			SUM(total_nota)  AS VlrContab, ;
	  		SUM(icms_subs)   AS IcmSubs,   ;
	  		SUM(base_icms)   AS BaseIcm,   ;
	  		SUM(base_icms * aliq_icms/100) AS vlr_icms,;
		    SUM(base_isent)  AS BsIsenta,  ;
		    SUM(base_outr)   AS BsOutr     ;
   FROM q:\scgc\loja\nota where  ;
		        data >= {01.01.2002} ;
			AND data <= {31.01.2002} ;
   			AND operacao =  "S" AND CUPOM = 0 AND STATUS = 1 ;
    GROUP BY cfo ;
    ORDER BY cfo ;
   	INTO CURSOR LIVROSAI


*-----------------------------------------------------------------*
*	ENTRADAS
*-----------------------------------------------------------------*
*   ENTRADAS ANALITICA
*-----------------------------------------------------------------*

  * SEM CONHECIMENTO DE TRANSPORTE 
  		    
	SELECT 	nota,serie, codforn,inscricao, data, uf, cfo,tipo,;
	        data, total_nota,;
            base_subs, base_icms, ;
	  		vlr_icms, base_isent,base_outr,aliq_icms,status;
   FROM q:\scgc\loja\notaent where  ;
		        data >= {01.01.2002} ;
			AND data <= {31.01.2002} ;
   			AND ch_produ <> "9" ; 
			AND !(ch_opera $"56") ;
			AND LEFT(notaent.situacao,1) = "C" ;
    ORDER BY DATA, NOTA ;
   	INTO CURSOR LIVROENT

  * COM CONHECIMENTO DE TRANSPORTE 
		    
	SELECT 	nota,serie, codforn,inscricao, data, uf, cfo,tipo,;
	        data, total_nota,;
            base_subs, base_icms, ;
	  		vlr_icms, base_isent,base_outr,aliq_icms,status;
   FROM q:\scgc\loja\notaent where  ;
		        data >= {01.01.2002} ;
			AND data <= {31.01.2002} ;
			AND !(ch_opera $"56") ;
			AND LEFT(notaent.situacao,1) = "C" ;
    ORDER BY DATA, NOTA ;
   	INTO CURSOR LIVROENT


*-----------------------------------------------------------------*
*   ENTRADAS RESUMO POR CFO
*-----------------------------------------------------------------*
  * SEM CONHECIMENTO DE TRANSPORTE 

	SELECT 	cfo, data, ;
			SUM(total_nota)  AS VlrContab, ;
	  		SUM(icms_subs)   AS IcmSubs,   ;
	  		SUM(base_icms)   AS BaseIcm,   ;
	  		SUM(base_icms * aliq_icms/100) AS vlr_icms,;
		    SUM(base_isent)  AS BsIsenta,  ;
		    SUM(base_outr)   AS BsOutr     ;
   FROM q:\scgc\loja\notaent where nota < 1000000 ;
		    AND data >= {01.01.2002} ;
			AND data <= {31.01.2002} ;
   			AND ch_produ <> "9" ; 
			AND !(ch_opera $"56") ;
			AND LEFT(notaent.situacao,1) = "C" ;
    GROUP BY cfo ;
    ORDER BY cfo ;
   	INTO CURSOR LIVROENT

  * COM CONHECIMENTO DE TRANSPORTE 

	SELECT 	cfo, data, ;
			SUM(total_nota)  AS VlrContab, ;
	  		SUM(icms_subs)   AS IcmSubs,   ;
	  		SUM(base_icms)   AS BaseIcm,   ;
	  		SUM(base_icms * aliq_icms/100) AS vlr_icms,;
		    SUM(base_isent)  AS BsIsenta,  ;
		    SUM(base_outr)   AS BsOutr     ;
   FROM q:\scgc\loja\notaent where nota < 1000000 ;
		    AND data >= {01.01.2002} ;
			AND data <= {31.01.2002} ;
			AND !(ch_opera $"56") ;
			AND LEFT(notaent.situacao,1) = "C" ;
    GROUP BY cfo ;
    ORDER BY cfo ;
   	INTO CURSOR LIVROENT

**************************************************
* RESUMOS DE CFO
**************************************************
	SELECT 	EMPRESA,cfo, data, ;
			SUM(total_nota)  AS VlrContab, ;
	  		SUM(icms_subs)   AS IcmSubs,   ;
	  		SUM(base_icms)   AS BaseIcm,   ;
	  		SUM(base_icms * aliq_icms/100) AS vlr_icms,;
		    SUM(base_isent)  AS BsIsenta,  ;
		    SUM(base_outr)   AS BsOutr     ;
   FROM q:\scgc\loja\nota where  ;
		        data >= {01.01.2002} ;
			AND data <= {31.01.2002} ;
   			AND operacao =  "S" AND CUPOM = 0 AND STATUS = 1;
   GROUP BY CFO ORDER BY CFO



	SELECT 	EMPRESA,cfo, data, ;
			SUM(total_nota)  AS VlrContab, ;
	  		SUM(icms_subs)   AS IcmSubs,   ;
	  		SUM(base_icms)   AS BaseIcm,   ;
	  		SUM(base_icms * aliq_icms/100) AS vlr_icms,;
		    SUM(base_isent)  AS BsIsenta,  ;
		    SUM(base_outr)   AS BsOutr     ;
   FROM q:\scgc\loja\nota where  ;
		        data >= {01.01.2002} ;
			AND data <= {31.01.2002} ;
   			AND operacao =  "S" AND CUPOM > 0 AND STATUS = 1;
   GROUP BY CFO ORDER BY CFO


	SELECT 	EMPRESA,cfo, data, ;
			SUM(total_nota)  AS VlrContab, ;
	  		SUM(icms_subs)   AS IcmSubs,   ;
	  		SUM(base_icms)   AS BaseIcm,   ;
	  		SUM(base_icms * aliq_icms/100) AS vlr_icms,;
		    SUM(base_isent)  AS BsIsenta,  ;
		    SUM(base_outr)   AS BsOutr     ;
   FROM q:\scgc\loja\nota where  ;
		        data >= {01.01.2002} ;
			AND data <= {31.01.2002} ;
   			AND operacao =  "S" AND  STATUS = 1;
   GROUP BY CFO ORDER BY CFO
