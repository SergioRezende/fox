RELEASE ALL
close all

set talk ON
set escap on
SET DATE GERMAN
SET CENTU ON




set eXcl off


USE Q:\SCGC\CENTRAL\SALDO
SET ORDER TO TAG SALDO

SELE 0

USE Q:\SCGC\CENTRAL\EMPRESA
SET ORDER TO TAG EMPRESA
GO TOP
DO WHILE !EOF()

	IF 	EMPRESA.EMPRESA  <> 18
			SELE EMPRESA
			SKIP
			LOOP

	ENDIF

	NLoja = EMPRESA.EMPRESA

	*----------------------------------------------------*
	DO CASE

		CASE NLoja = 1
			LNLoja = 1
			LSFile     = "X:\SUPORTE\EFD2016\EFD_GYN.TXT"
			LSFileErro = "X:\SUPORTE\EFD2016\EFD_GYN.ERR"

		CASE NLoja = 4
			LNLoja = 4
			LSFile     = "X:\SUPORTE\EFD2016\EFD_BGS.TXT"
			LSFileErro = "X:\SUPORTE\EFD2016\EFD_BGS.ERR"




		CASE NLoja = 5
			LNLoja = 5
			LSFile     = "X:\SUPORTE\EFD2016\EFD_IPG.TXT"
			LSFileErro = "X:\SUPORTE\EFD2016\EFD_IPG.ERR"


		CASE NLoja = 6
			LNLoja = 6
			LSFile     = "X:\SUPORTE\EFD2016\EFD_CGB.TXT"
			LSFileErro = "X:\SUPORTE\EFD2016\EFD_CGB.ERR"




		CASE NLoja = 7
			LNLoja = 7
			LSFile     = "X:\SUPORTE\EFD2016\EFD_T63.TXT"
			LSFileErro = "X:\SUPORTE\EFD2016\EFD_T63.ERR"



		CASE NLoja = 8
			LNLoja = 8
			LSFile     = "X:\SUPORTE\EFD2016\EFD_ARG.TXT"
			LSFileErro = "X:\SUPORTE\EFD2016\EFD_ARG.ERR"




		CASE NLoja = 9
			LNLoja = 9
			LSFile     = "X:\SUPORTE\EFD2016\EFD_RIO.TXT"
			LSFileErro = "X:\SUPORTE\EFD2016\EFD_RIO.ERR"




		CASE NLoja = 14
			LNLoja = 14
			LSFile     = "X:\SUPORTE\EFD2016\EFD_ANP.TXT"
			LSFileErro = "X:\SUPORTE\EFD2016\EFD_ANP.ERR"



		CASE NLoja = 17
			LNLoja = 17
			LSFile     = "X:\SUPORTE\EFD2016\EFD_ABO.TXT"
			LSFileErro = "X:\SUPORTE\EFD2016\EFD_ABO.ERR"

		CASE NLoja = 18
			LNLoja = 18
			LSFile     = "X:\SUPORTE\EFD2016\EFD_T2.TXT"
			LSFileErro = "X:\SUPORTE\EFD2016\EFD_T2.ERR"


		OTHERWISE
			SELE EMPRESA
			SKIP
			LOOP
	ENDCASE

	*----------------------------------------------------*


	LSProduto = ""
	LSSaldo = ""
	
	LNSaldo = 0
	LDData  = {31.12.2015}
	*----------------------------------------------------*

	DELETE FILE &LSFileErro


	LNfile    =FOPEN(LSFile,12)	


	IF LNfile > 0
		LNerrfile = FCREATE(LSFileErro)
		IF LNerrfile > 0
			=FPUTS(LNerrfile,  TIME() + " Ver erros "+ LSFile)

			LSstatus=""
			DO WHILE !FEOF(LNfile)

				LSstatus  = UPPER(fgets(LNfile,255)) + "|"
				IF "H010" $ left(LSstatus,6)

					LSProduto = SUBS(LSstatus,7,8)

					*------------*  SALDO

					LSSaldo   = SUBS(LSstatus,19,10)
					LSSld  = SUBS(LSstatus,19,AT("|",LSSaldo)-1)
					LNSld  = VAL(LSSld)

					*------------*  VALOR

					LSValor   = SUBS(LSstatus,AT("|",LSstatus,11)+1)


					LSVlr     = SUBS(LSValor,1,AT("|",LSValor)-1)
					LNVlr  = VAL(LSVlr)
	
					*------------*

					SELE SALDO
					SEEK STR(LNLoja,3)+STR(YEAR(LDData),4)+STR(MONTH(LDData),2)+LSProduto


					IF !FOUND() 
						=FPUTS(LNerrfile, LSstatus+ " Nao localizou Reg Saldo")
				    ELSE
						IF  LNSld <> saldo.sld_atu
							=FPUTS(LNerrfile, LSstatus+ " Dif Qtde Estoque => "+ STR(saldo.sld_atu,14,2))
						ENDIF
	
						IF ABS(LNVlr - saldo.vlr_atu ) >= 1
							=FPUTS(LNerrfile, LSstatus+ " Dif Valor Estoque => " + STR(saldo.vlr_atu,14,2))
						ENDIF
					ENDIF
				ENDIF
			ENDDO
			=FCLOSE(LNfile)
			=FCLOSE(LNerrfile)

		ENDIF
	ENDIF
	SELE EMPRESA
	SKIP
ENDDO

RETURN
