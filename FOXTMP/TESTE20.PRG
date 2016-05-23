PROCEDURE CRCrt_Despesas
PARAMETERS PrmEmpresa,PrmDtInicio,PrmDtFinal
    = W_DEFPROC("rotinas.spr")
	ON KEY LABEL ESCAPE 

	PRIVATE LFEmpresa,LFDuplicat,LFRetornmv
	PRIVATE LSalias
	LSalias	     = ALIAS()
    LFempresa    	= NetArq("empresa")
    LFduplicat   	= NetArq("duplicat")
    LFretornmv		= NetArq("retornmv")
    IF (LFempresa+LFduplicat+LFretornmv) > 100000 
		=UP_fecha("empresa"  ,LFempresa)
		=UP_fecha("duplicat" ,LFduplicat)
		=UP_fecha("retornmv"	 ,LFretornmv)
		IF !EMPTY(LSalias) AND USED(LSalias)
			SELECT &LSalias
		ENDIF
    	RETURN("")
    ENDIF

	SELE retornmv
	SET ORDER TO TAG DT_AVISO

	select STR(empresa,3)+STR(duplicata,9) AS CHAVE  ;
    	from retornmv ;
	    where    empresa = PrmEmpresa ;
    		 AND (banco = 0 and ocorrencia = 81) ;
	    into cursor CRPerd


	select RTN.empresa,EMP.sigla ,RTN.banco,RTN.duplicata,;
    	   RTN.vlr_dup,RTN.Out_desp,RTN.dtaviso ;
	    from empresa EMP, ;
    	     retornmv   RTN ;
	    where     EMP.empresa = PrmEmpresa ;
    	      AND EMP.empresa = RTN.empresa ;
        	  AND STR(RTN.empresa,3)+STR(RTN.duplicata,9) NOT IN ;
	                     (SELECT CHAVE FROM CRPerd);
    	      AND ;
        	  (;
	          (RTN.banco = 1 and (RTN.ocorrencia = 96 or RTN.ocorrencia = 97)) ;
    	     or ;
	       	  (RTN.banco = 237 and RTN.ocorrencia = 10 and left(RTN.motivos,2) = "14") ;
    	      );
	    into cursor CRSEL

    
	SELECT ;
	   PrmDtInicio AS Dt_Inicio, 	   PrmDtFinal AS Dt_Fim, ;
	   CRSEL.empresa,CRSEL.SIGLA,CRSEL.banco,CRSEL.duplicata,;
	   CRSEL.vlr_dup,CRSEL.Out_desp,DUPLICAT.VLR_PGTO,;
	   DUPLICAT.DT_PGTO,;
	   DUPLICAT.NOME ;
	   FROM CRSEL, DUPLICAT ;
	WHERE     CRSEL.EMPRESA = DUPLICAT.EMPRESA ;
    	    AND CRSEL.DUPLICATA = DUPLICAT.DUPLICATA;
	        AND DUPLICAT.DT_PGTO >= PrmDtInicio ;
	        AND DUPLICAT.DT_PGTO <= PrmDtFinal;
	ORDER BY CRSEL.banco,nome ;
    into cursor CRfinal


	*list empresa," ",banco," ",duplicata," ",vlr_dup," ",;
	*     Out_desp," ",VLR_PGTO," ",;
	*     DT_PGTO," ",;
    *	 NOME ;
	*    to l:\tmp\prt0001z.rel

		=UP_fecha("empresa"  ,LFempresa)
		=UP_fecha("duplicat" ,LFduplicat)
		=UP_fecha("retornmv"	 ,LFretornmv)
		IF !EMPTY(LSalias) AND USED(LSalias)
			SELECT &LSalias
		ENDIF
RETURN("CRSEL")
