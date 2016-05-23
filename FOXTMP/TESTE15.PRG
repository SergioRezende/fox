*****************************************************************
*  REGISTRO DE ITENS - 54 - ENTRADA E SAIDA
*****************************************************************

FUNCTION ULReg_54
	PARAMETERS LNemp, LNctrl, LDper_ini, LDper_fim, LN_Ctr
	PRIVATE LNctrOrdem

	*-------------------------------------------------------------------*
	*	ITENS DAS NOTAS DE SAIDA
	*-------------------------------------------------------------------*
	
	SELECT LIVROSAI
	SET ORDER TO TAG data
	SET NEAR ON
	SEEK STR(LNemp,3)+DTOS(LDper_ini)
	SET NEAR OFF

	DO WHILE !EOF()
		LSmsg = "Produtos Saida (54) "+;
				 	STR(LIVROSAI.empresa,3)+"-"+DTOC(LIVROSAI.DATA)+;
					STR(LIVROSAI.NOTA,6)
		WAIT WINDOW LSmsg NOWAIT


		LStipo  	=   "54"

		*----------------------------------------------------------*
		LScgc	=  CHRTRAN(STR(LIVROSAI.favorecido,14)," ","0")

		LSinsc	=  ALLTRIM(LIVROSAI.inscricao)
		LSuf	=	LIVROSAI.uf
		IF LIVROSAI.favorecido > 0
			SELE clientes
			SET ORDER TO TAG cliente
			SEEK LIVROSAI.favorecido
			IF  FOUND() ;
				AND	UPInscricao(clientes.estado,clientes.INSCRICAO,1,0,0,'')
				LSinsc	=  ALLTRIM(clientes.inscricao)
				LSuf	=	clientes.estado
			ELSE
				LSinsc	=  ALLTRIM(LIVROSAI.inscricao)
			ENDIF		
		ENDIF

		SELE LIVROSAI

		IF "ISENTO" $ UPPER(LSinsc)
			LSinsc	=  "ISENTO"
			LScgc	=  CHRTRAN(STR(0,14)," ","0")
		ELSE
			LSinsc	=  CHRTRAN(LSinsc,".","")
			LSinsc	=  CHRTRAN(LSinsc,"/","")
			LSinsc	=  CHRTRAN(LSinsc,"-","")
			LSinsc	=  CHRTRAN(LSinsc,"(","")
			LSinsc	=  CHRTRAN(LSinsc,")","")
		ENDIF			
		LSinsc			= LEFT(LSinsc+space(14),14)
		IF LIVROSAI.TP_PESSOA = 1
			LScgc	=  CHRTRAN(STR(0,14)," ","0")
		ENDIF			

		LSdtemi		=	STR(YEAR(LIVROSAI.data),4)+;
						STR(MONTH(LIVROSAI.data),2)+;
						STR(DAY(LIVROSAI.data),2)
		LSdtemi		=   CHRTRAN(LSdtemi," ","0")						


		LSmodelo 	=   "01" 
		LSserie		=   "  1"
		LSsubserie  = 	"  "
		LSnumero 	= 	CHRTRAN(STR(LIVROSAI.NOTA,7)," ","0")
		LSnumero 	= 	SUBS(LSnumero,2,6)

		SELE ITEMMOV
		SET ORDER TO TAG itemnota
		SET NEAR ON
		SEEK STR(LNemp,3)+"S"+STR(LIVROSAI.NOTA,7)
		SET NEAR OFF
		LNctrordem = 1		&& INDICAR ORDEM DO PRODUTO NA NOTA

		DO WHILE !EOF() AND LIVROSAI.NOTA = itemmov.nota ;
						AND LEFT(itemmov.operacao,1) = "S"
			*--------------------------------------------------*
			* 	Podem ser identificadas itens de sadida com 
			* numero de nota conincidenter  com itens de uma 
			*	SCA por isso e feito a verificacao do tipo 
			*---------------------------------------------------*
			IF 	LIVROSAI.TIPO 	 <> itemmov.tipo 
				SKIP
				LOOP
			ENDIF
			*---------------------------------------------------*
			DO ULitem_75  && REGISTRAR ITEM COMERCIALIZADO
			*---------------------------------------------------*			
			SELE ITEMMOV
			LSordem = CHRTRAN(STR(LNctrordem,2)," ","0")
			LNctrordem	= LNctrordem + 1
			LScodigo=  LEFT(itemmov.codigo,10)
			LSorigem=  CHRTRAN(STR(itemmov.origem,1)," ","0")
			LScst	=  CHRTRAN(itemmov.cst," ","0")

			LSzero  =  "0"
		*	LSunid	=  itemmov.unidade
			LSunid	=  "UN"


			LSqtde	= STR(itemmov.qtde,14,3)			
			LSqtde  = CHRTRAN(LSqtde," ","0")
			LSqtde  = CHRTRAN(LSqtde,",","")
			LSqtde  = CHRTRAN(LSqtde,".","")

			LSvalor	= STR(itemmov.vlrvenda,14,2)			
			LSvalor = CHRTRAN(LSvalor," ","0")
			LSvalor = CHRTRAN(LSvalor,",","")
			LSvalor = CHRTRAN(LSvalor,".","")

			LSbase_icms = STR(itemmov.base_calc,14,2)			
			LSbase_icms = CHRTRAN(LSbase_icms," ","0")
			LSbase_icms = CHRTRAN(LSbase_icms,",","")
			LSbase_icms = CHRTRAN(LSbase_icms,".","")

			LSbase_subs = (itemmov.base_calc*itemmov.iva)
			LSbase_subs = STR(LSbase_subs,14,2)			
			LSbase_subs = CHRTRAN(LSbase_subs," ","0")
			LSbase_subs = CHRTRAN(LSbase_subs,",","")
			LSbase_subs = CHRTRAN(LSbase_subs,".","")

			LSaliq_icms	=	str(itemmov.aliq_icms,5,2)						
			LSaliq_icms	=   CHRTRAN(LSaliq_icms," ","0")						
			LSaliq_icms	=   CHRTRAN(LSaliq_icms,",","")						
			LSaliq_icms	=   CHRTRAN(LSaliq_icms,".","")						

			
			LSvlripi	= STR(0,14,2)			
			LSvlripi	= CHRTRAN(LSvlripi," ","0")
			LSvlripi 	= CHRTRAN(LSvlripi,",","")
			LSvlripi 	= CHRTRAN(LSvlripi,".","")
			*******************************************************
			LStmp1		= LStipo+LScgc+LSdtemi+LSuf+LSmodelo+LSserie+;
						  LSsubserie+LSnumero+LSordem+;
						  LScodigo+LSorigem+LScst+LSzero+LSunid+;
						  LSqtde+LSvalor+LSbase_icms+LSbase_subs+;
						  LSaliq_icms+LSvlripi
			=FPUT(LNctrl,LStmp1,126)
			LN_Ctr	=	LN_Ctr + 1
			*******************************************************			
			SKIP
		ENDDO
		SELECT LIVROSAI
		SKIP
	ENDDO

	*-------------------------------------------------------------------*
	*	NOTAS DE ENTRADA
	*-------------------------------------------------------------------*

	SELECT LIVROENT
	SET ORDER TO TAG rldtentr
	SET NEAR ON
	SEEK STR(LNemp,3)+DTOS(LDper_ini)
	SET NEAR OFF

	DO WHILE !EOF()
		LSmsg = "Produtos Entrada (54) "+;
				 	STR(LIVROENT.empresa,3)+"-"+DTOC(LIVROENT.DATA)+;
					STR(LIVROENT.NOTA,6)
		WAIT WINDOW LSmsg NOWAIT

		LStipo  	= "54"

		*-----------------------------------------------------------*
		SELE fornece
		SET ORDER TO TAG codigo
		SEEK LIVROENT.codforn
		IF FOUND()
			LSinsc	=  ALLTRIM(fornece.inscricao)
			LScgc	=  CHRTRAN(STR(fornece.cgc,14)," ","0")
		ELSE
			LSinsc	=  ALLTRIM(LIVROENT.inscricao)
			LScgc	=  CHRTRAN(STR(LIVROENT.favorecido,14)," ","0")
		ENDIF
		*-----------------------------------------------------------*
		SELE LIVROENT

		IF "ISENTO" $ UPPER(LSinsc)
			LScgc	=  CHRTRAN(STR(0,14)," ","0")
		ENDIF

		LSdtrec		=	STR(YEAR(LIVROENT.data),4)+;
						STR(MONTH(LIVROENT.data),2)+;
						STR(DAY(LIVROENT.data),2)
		LSdtrec		=   CHRTRAN(LSdtrec," ","0")						

		LSuf		=	LIVROENT.uf
		LSmodelo 	=   "01" 
		LSserie		=   "  1"
		LSsubserie  = 	"  "
		LSnumero 	= 	CHRTRAN(STR(LIVROENT.NOTA,6)," ","0")

		IF EMPTY(LIVROENT.cfo)
			SELE TIPOOPER
			SET ORDER TO TAG TIPO 
			SEEK "E"+LIVROENT.tipo
			IF FOUND()
				LScfo	= tipooper.cfo
			ENDIF
		ELSE	
			LScfo		=   CHRTRAN(LIVROENT.cfo,".","")						
		ENDIF
		LScfo		=   CHRTRAN(LScfo,".","")						
		SELE LIVROENT

		SELE ITEMMOV
		SET ORDER TO TAG itemnota
		SET NEAR ON
		SEEK STR(LNemp,3)+"E"+STR(LIVROENT.NOTA,7)
		SET NEAR OFF
		LNctrordem	= 1

		DO WHILE !EOF() AND LIVROENT.NOTA = itemmov.nota ;
						AND LEFT(itemmov.operacao,1) = "E"
			*--------------------------------------------------*
			* 	Podem ser identificadas itens de entrada com mesmo
			* numero de nota por isso e feito a verificacao do tipo 
			* e do codiforn
			*---------------------------------------------------*
			IF 	LIVROENT.TIPO 	 <> itemmov.tipo OR ;
				LIVROENT.CODFORN <> itemmov.codforn
				SKIP
				LOOP
			ENDIF
			*---------------------------------------------------*
			DO ULitem_75  && REGISTRAR ITEM COMERCIALIZADO
			*---------------------------------------------------*			
			LSordem = CHRTRAN(STR(LNctrordem,2)," ","0")
			LNctrordem	= LNctrordem + 1
			LScodigo=  LEFT(itemmov.codigo,10)
			LSorigem=  CHRTRAN(STR(itemmov.origem,1)," ","0")
			IF LIVROENT.BASE_ISENT > 0
				LScst	=  "2"
			ELSE		
				LScst	=  CHRTRAN(itemmov.cst," ","0")
			ENDIF
			LSzero  =  "0"
		*	LSunid	=  itemmov.unidade
			LSunid	=  "UN"


			LSqtde	= STR(itemmov.qtde,14,3)			
			LSqtde  = CHRTRAN(LSqtde," ","0")
			LSqtde  = CHRTRAN(LSqtde,",","")
			LSqtde  = CHRTRAN(LSqtde,".","")

			LSvalor	= STR(itemmov.vlrvenda,14,2)			
			LSvalor = CHRTRAN(LSvalor," ","0")
			LSvalor = CHRTRAN(LSvalor,",","")
			LSvalor = CHRTRAN(LSvalor,".","")

			LSbase_icms = STR(itemmov.base_calc,14,2)			
			LSbase_icms = CHRTRAN(LSbase_icms," ","0")
			LSbase_icms = CHRTRAN(LSbase_icms,",","")
			LSbase_icms = CHRTRAN(LSbase_icms,".","")

			LSbase_subs = (itemmov.base_calc+itemmov.vlripi)*itemmov.iva
			LSbase_subs = STR(LSbase_subs,14,2)			
			LSbase_subs = CHRTRAN(LSbase_subs," ","0")
			LSbase_subs = CHRTRAN(LSbase_subs,",","")
			LSbase_subs = CHRTRAN(LSbase_subs,".","")

			LSaliq_icms	=	str(itemmov.aliq_icms,5,2)						
			LSaliq_icms	=   CHRTRAN(LSaliq_icms," ","0")						
			LSaliq_icms	=   CHRTRAN(LSaliq_icms,",","")						
			LSaliq_icms	=   CHRTRAN(LSaliq_icms,".","")						
			
			LSvlripi	= STR(itemmov.vlripi,14,2)			
			LSvlripi	= CHRTRAN(LSvlripi," ","0")
			LSvlripi 	= CHRTRAN(LSvlripi,",","")
			LSvlripi 	= CHRTRAN(LSvlripi,".","")

			*******************************************************
			LStmp1		= LStipo+LScgc+LSdtrec+LSuf+LSmodelo+LSserie+;
						  LSsubserie+LSnumero+LSordem+;
						  LScodigo+LSorigem+LScst+LSzero+LSunid+;
						  LSqtde+LSvalor+LSbase_icms+LSbase_subs+;
						  LSaliq_icms+LSvlripi
			=FPUT(LNctrl,LStmp1,126)
			LN_Ctr	=	LN_Ctr + 1
			*******************************************************			
			SKIP
		ENDDO
		SELECT LIVROENT
		SKIP
	ENDDO

RETURN
