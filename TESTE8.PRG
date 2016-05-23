
return
*---------------------------------------------------------------*

FUNCTION IMGetUltCstMedioEstq
PARAMETERS PrmEmp,PrmData, PrmCodigo

	=W_DEFPROC("ROTINAS.SPR")

	PRIVATE LNVlrEstq
	PRIVATE LNSldEstq

	PRIVATE LSalias
	LSalias		= 	ALIAS()
	IF TYPE("PrmHora") <> "C"
	    PrmHora = "99:99:99"
	ENDIF

	=IMVerifyInst()
	*----------------------------------------------------------------*
	SELE &PBItemmovAlias
	SET ORDER TO TAG movimento
	SET NEAR ON
	SEEK STR(PrmEmp,3)+PrmCodigo+"1" 
										&& POSICIONA A FRENTE PARA
										&& VOLTAR E PEGAR SALDO DE
										&& FECHAMENTO OU ATUAL DO DIA
	SET NEAR OFF
	IF BOF() AND EOF()       && ITEMMOV ESTA VAZIO

		=W_DEFPROC("SALDO.SPR")
		LNVlrEstq = SLGetVlrEstq(PrmEmp, PrmData, PrmCodigo)

		=W_DEFPROC("SALDO.SPR")
		LNSldEstq= SLGetSaldo(PrmEmp, PrmData, PrmCodigo)

	ELSE
		SKIP -1
		IF BOF() OR PrmCodigo <> &PBItemmovAlias .codigo ;
			 	 OR PrmEmp    <> &PBItemmovAlias .empresa
			=W_DEFPROC("SALDO.SPR")
			LNVlrEstq = SLGetVlrEstq(PrmEmp, PrmData, PrmCodigo)

			=W_DEFPROC("SALDO.SPR")
			LNSldEstq= SLGetSaldo(PrmEmp, PrmData, PrmCodigo)

		ELSE
			LNVlrEstq   =	&PBItemmovAlias .vlr_estq
            LNSldEstq   =   &PBItemmovAlias .sld_estq 

		ENDIF
	ENDIF
   	IF LNSldEstq = 0
   		LNVlrEstq   = 0
   	ELSE
		LNVlrEstq   =	LNVlrEstq / ;
		                 LNSldEstq 
	ENDIF



	*--------------------------------------------------------------*
	IF !EMPTY(LSalias) AND USED(LSalias)
		SELECT &LSalias
	ENDIF
RETURN(LNVlrEstq) 
