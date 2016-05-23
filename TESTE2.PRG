*---------------------------------------------*
*---------------------------------------------*
*---------------------------------------------*
*---------------------------------------------*


PROCEDURE GERACLIENC

	SET EXACT ON
	
	=W_DEFPROC("CLIENC.SPR")
	CLAlias = CNGetAlias()

	SELE &CLAlias
	SET ORDER TO TAG IDENTIFICA
	

	=W_DEFPROC("NOTA.SPR")
	NFAlias = NFGetAlias()


	SELE &NFAlias

	COUNT TO TOTAL
	CTR = 0
	GO TOP
	DO WHILE !EOF()
		
		CTR = 	CTR + 1

		
		=W_DEFPROC("CLIENTES.SPR")
		IF  CLVld_CPF_CNPJ( &NFAlias .FAVORECIDO )
			MSG = STR(CTR,7)+" DE "+STR(TOTAL,7)+" CPF/CNPJ OK"
			WAIT WINDOW MSG NOWAIT
			=CAD_VALIDO()
		ELSE
			MSG = STR(CTR,7)+" DE "+STR(TOTAL,7)+" CPF/CNPJ INVALIDO"
			WAIT WINDOW MSG NOWAIT
			=CAD_INVALIDO()

		ENDIF
		SELE &NFAlias
		SKIP

	ENDDO


RETURN



FUNCTION  CAD_VALIDO

			SELE &CLAlias
			SEEK "S"+;
			     STR( &NFAlias .FAVORECIDO ,14)+;
			     &NFAlias .UF+;
			     LEFT( &NFAlias .CIDADE,30)+;
			     ALLTRIM(LEFT(  &NFAlias .NOME ,30))


			IF !FOUND()
				SEEK "N"+;
				     STR( &NFAlias .FAVORECIDO ,14)+;
				     &NFAlias .UF+;
				     LEFT( &NFAlias .CIDADE,30)+;
			    	 ALLTRIM(LEFT(  &NFAlias .NOME ,30))

			ENDIF


            M.CPFCNPJVLD = "S"
			IF !FOUND()
    	        M.EMPRESA     = &NFAlias .EMPRESA
	            M.ORCAMENTO   = 0
    	        M.CLIENTE     = &NFAlias .FAVORECIDO
        	    M.NOME        = &NFAlias .NOME
	            M.ENDERECO    = &NFAlias .ENDERECO
    	        M.NRO_LOGR    = &NFAlias .NRO_LOGR
        	    M.CIDADE      = &NFAlias .CIDADE
	            M.BAIRRO      = &NFAlias .BAIRRO
	   	        M.ESTADO      = &NFAlias .UF
    	        M.CEP         = &NFAlias .CEP
        	    M.PAIS        = "BRASIL"
**	            M.CX_POSTAL   = &NFAlias .
    	        M.MUNI_IBGE   = &NFAlias .MUNI_IBGE
	            M.DDD         = ""
    	        M.FONE        = &NFAlias .FONE
	            M.REGIAO      = &NFAlias .REGIAO
    	        M.DSCRREGIAO  = ""
        	    M.REVENDEDOR  = &NFAlias .REVENDEDOR
	            M.NATU_CLI    = &NFAlias .NATU_CLI
    	        M.TP_PESSOA   = &NFAlias .TP_PESSOA
        	    M.TP_INSCR    = &NFAlias .TP_INSCR
	            M.INSCRICAO   = &NFAlias .INSCRICAO
	**                M.INSSUBSISS  = &NFAlias .INSSUBSISS
	
    	        M.DTREGIS     = Date()
        	    M.USRREGIS    = 9999
	
	**                M.E_MAIL      = &NFAlias .EMAL

	            M.SEGUIMENTO  = &NFAlias .SEGUIMENTO
    **	        M.RAMO_TRAB   &NFAlias .
        	    M.SUBST_ISS   = &NFAlias .SUBST_ISS

			   	M.INSCSUBST   = &NFAlias .INSCSUBST
				M.INSC_MUNI   = &NFAlias .INSC_MUNI

				APPEND BLANK
			ELSE
				SCATTER MEMVAR
	            M.CPFCNPJVLD = "S"
			ENDIF
			=RLOCK()
			GATHER MEMVAR

RETURN(.T.)


FUNCTION  CAD_INVALIDO

			SELE &CLAlias
			SEEK "N"+;
			     STR(0 ,14)+;
			     &NFAlias .UF+;
			     LEFT( &NFAlias .CIDADE,30)+;
			     ALLTRIM(LEFT(  &NFAlias .NOME ,30))



            M.CPFCNPJVLD = "N"
			IF !FOUND()
    	        M.EMPRESA     = &NFAlias .EMPRESA
	            M.ORCAMENTO   = 0
    	        M.CLIENTE     = &NFAlias .FAVORECIDO
        	    M.NOME        = &NFAlias .NOME
	            M.ENDERECO    = &NFAlias .ENDERECO
    	        M.NRO_LOGR    = &NFAlias .NRO_LOGR
        	    M.CIDADE      = &NFAlias .CIDADE
	            M.BAIRRO      = &NFAlias .BAIRRO
	   	        M.ESTADO      = &NFAlias .UF
    	        M.CEP         = &NFAlias .CEP
        	    M.PAIS        = "BRASIL"
	**            M.CX_POSTAL   = &NFAlias .
    	        M.MUNI_IBGE   = &NFAlias .MUNI_IBGE
	            M.DDD         = ""
    	        M.FONE        = &NFAlias .FONE
	            M.REGIAO      = &NFAlias .REGIAO
    	        M.DSCRREGIAO  = ""
        	    M.REVENDEDOR  = &NFAlias .REVENDEDOR
	            M.NATU_CLI    = &NFAlias .NATU_CLI
    	        M.TP_PESSOA   = &NFAlias .TP_PESSOA
        	    M.TP_INSCR    = &NFAlias .TP_INSCR
	            M.INSCRICAO   = &NFAlias .INSCRICAO
	**                M.INSSUBSISS  = &NFAlias .INSSUBSISS
	
    	        M.DTREGIS     = Date()
        	    M.USRREGIS    = 9999
	
	**                M.E_MAIL      = &NFAlias .EMAL

	            M.SEGUIMENTO  = &NFAlias .SEGUIMENTO
    **	        M.RAMO_TRAB   = &NFAlias .
        	    M.SUBST_ISS   = &NFAlias .SUBST_ISS

			   	M.INSCSUBST   = &NFAlias .INSCSUBST
				M.INSC_MUNI   = &NFAlias .INSC_MUNI

				APPEND BLANK
			ELSE
				SCATTER MEMVAR
	            M.CPFCNPJVLD = "N"
			ENDIF
			=RLOCK()
			GATHER MEMVAR

RETURN(.T.)

*---------------------------------------------*
*---------------------------------------------*
*---------------------------------------------*
*---------------------------------------------*


PROCEDURE VLDACLIENC

	SET EXACT ON
	
	=W_DEFPROC("CLIENC.SPR")
	CLAlias = CNGetAlias()

	SELE &CLAlias
	SET ORDER TO 
	GO TOP

	COUNT TO TOTAL
	CTR = 608800
	GO TOP
	skip 608800

	DO WHILE !EOF()
		
		CTR = 	CTR + 1


		MSG = STR(CTR,7)+" DE "+STR(TOTAL,7)+" CPF/CNPJ"
		WAIT WINDOW MSG NOWAIT

        IF &CLAlias .CPFCNPJVLD = "S"
        	SKIP
        	LOOP
        ENDIF

		
		=W_DEFPROC("CLIENTES.SPR")
		IF  CLVld_CPF_CNPJ( &CLAlias .CLIENTE )
            M.CPFCNPJVLD = "S"
		ELSE
            M.CPFCNPJVLD = "N"
		ENDIF
		=RLOCK()
		REPLACE CPFCNPJVLD  WITH M.CPFCNPJVLD
	
		SELE &CLAlias
		SKIP

	ENDDO


RETURN

*---------------------------------------------*
*---------------------------------------------*
*---------------------------------------------*
*---------------------------------------------*

PROCEDURE VLDA_NF

	SET EXACT ON
	
	=W_DEFPROC("NOTA.SPR")
	NFAlias = NFGetAlias()

	SELE &NFAlias
	SET ORDER TO 
	GO TOP

		
	CTR = 0

	COUNT TO TOTAL
	GO TOP

	DO WHILE !EOF()
		
		CTR = 	CTR + 1


		MSG = STR(CTR,7)+" DE "+STR(TOTAL,7)+" CPF/CNPJ"
		WAIT WINDOW MSG NOWAIT

		*-->	 CPFCNPJVLD
				 	    && C=CERTA ORIGINALMENTE 
	                    && E=ERRO 
	                    && A=ACERTADA POR PROCESSO LOCALIZOU CPFCNPJ

        IF &NFAlias .CPFCNPJVLD <> "E"
        	SKIP
        	LOOP
        ENDIF

		
		=W_DEFPROC("CLIENTES.SPR")
		IF  CLVld_CPF_CNPJ( &NFAlias .FAVORECIDO )
            M.CPFCNPJVLD = "A"
		ELSE
            M.CPFCNPJVLD = "E"
		ENDIF
		=RLOCK()
		REPLACE CPFCNPJVLD  WITH M.CPFCNPJVLD
	
		SELE &NFAlias
		SKIP

	ENDDO


RETURN

*---------------------------------------------*
*---------------------------------------------*
*---------------------------------------------*
*---------------------------------------------*

PROCEDURE CORRIGENF

	SET EXACT ON
	
	=W_DEFPROC("CLIENC.SPR")
	CLAlias = CNGetAlias()

	SELE &CLAlias
	SET ORDER TO TAG HOMONIMO
	

	=W_DEFPROC("NOTA.SPR")
	NFAlias = NFGetAlias()


	SELE &NFAlias

	COUNT TO TOTAL

	CTR = 3955
	CTRERRADAS = 102
	CTRCERTAS = 3809
	CTRCORRIGIDAS =44
	FLAG_CERTA = "C"    && C=CERTA ORIGINALMENTE 
	                    && E=ERRO 
	                    && A=ACERTADA POR PROCESSO LOCALIZOU CPFCNPJ
	
	GO TOP
	
	SKIP 3954

	DO WHILE !EOF()
		
		CTR = 	CTR + 1
		
		=W_DEFPROC("CLIENTES.SPR")
		IF  !CLVld_CPF_CNPJ( &NFAlias .FAVORECIDO )

			=ACERTANF()

		ELSE
			FLAG_CERTA = "C"    && C=CERTA ORIGINALMENTE 
		ENDIF



		DO CASE

			CASE FLAG_CERTA = "C"    && C=CERTA ORIGINALMENTE 
				CTRCERTAS = CTRCERTAS + 1

			CASE FLAG_CERTA = "E"    && E=ERRADA
				CTRERRADAS = CTRERRADAS + 1

			CASE FLAG_CERTA = "A"    && A=ACERTADA
				CTRCORRIGIDAS = CTRCORRIGIDAS + 1

		
		ENDCASE




		MSG = "LIDAS:"+STR(CTR,6)+;
		      "TOT:"+STR(TOTAL,6)+;
		      "CERTA:"+STR(CTRCERTAS,6)+;
		      "ERROS:"+STR(CTRERRADAS,6)+;
		      "CRGDA:"+STR(CTRCORRIGIDAS,6)

		WAIT WINDOW MSG NOWAIT

		SELE &NFAlias
		=RLOCK()

		REPLACE CPFCNPJVLD WITH FLAG_CERTA

		IF FLAG_CERTA = "A"    && A=ACERTADA

			REPLACE FAVORECIDO WITH &CLAlias .CLIENTE

		ENDIF

		SKIP

	ENDDO

	MSG = "**LIDAS:"+STR(CTR,6)+;
		      "TOT:"+STR(TOTAL,6)+;
		      "CERTA:"+STR(CTRCERTAS,6)+;
		      "ERROS:"+STR(CTRERRADAS,6)+;
		      "CRGDA:"+STR(CTRCORRIGIDAS,6)
	WAIT WINDOW MSG 
	=INKEY(1)
	WAIT WINDOW MSG 

RETURN



FUNCTION  ACERTANF

			IF EMPTY( &NFAlias .CIDADE) OR ;
			   EMPTY( &NFAlias .NOME )  OR ;
			   EMPTY( &NFAlias .UF)			

				FLAG_CERTA = "E"    && E=ERRO 
				RETURN(.F.)
			ENDIF


			SELE &CLAlias
			SEEK "S"+;
			     &NFAlias .UF+;
			     LEFT( &NFAlias .CIDADE,30)+;
			     ALLTRIM(LEFT(  &NFAlias .NOME ,30))

			IF !FOUND()

				FLAG_CERTA = "E"    && E=ERRO 

			ELSE
				FLAG_CERTA = "A"    && A=ACERTADA POR PROCESSO LOCALIZOU CPFCNPJ
			ENDIF

RETURN(.T.)

