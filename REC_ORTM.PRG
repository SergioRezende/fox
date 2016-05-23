*******************************************************
* RECUPERACAO DE ORCATMP
*******************************************************

CLEAR
SET EXCL ON
SET TALK OFF
SET CENTU ON
SET DATE GERMAN
USE orcatmp

ZAP
PACK

A = FOPEN("\SCGC\TAREFA\ORCATMP.DBF")

LER = 289
FLGgrava = .f.

DADOS =	FGETS(A,LER)
CTR = 1
REGUA = ;
"123456789 123456789 123456789 123456789 123456789 123456789 123456789 123456789"
DO WHILE !FEOF(A) AND !CHRSAW()
	CTR = CTR + 1
	clear
	@ 10,15 SAY CTR

	IF SUBS(DADOS,53,8) = "DELETADO"
		wait window "INICIO DE RECUPERACAO"
		FLGgrava = .t.
	ENDIF

	DADOS =	FGETS(A,LER)
*	?REGUA
*	?SUBS(DADOS,1)
*	?DADOS
*	=inkey(0)
	IF LASTKEY() =  27
		EXIT
	ENDIF
	IF FLGgrava
				M.empresa 	 =  val(SUBS(DADOS,1,4))
				*********************
				IF m.empresa = 0		&& CAMPO DELETADO NAO ESTA MARCADO
					LOOP
				ENDIF

		        M.DELETADO     = ((SUBS(DADOS,289,1)))                    

				IF  m.deletado = "T"
					LOOP
				endif

				*********************

                M.EMPRESA      = ((SUBS(DADOS,2,3)))                    

				M.DATA	     = CTOD(SUBS(DADOS,11,2)+"."+SUBS(DADOS,9,2)+"."+;
					SUBS(DADOS,5,4))

                M.HORA         = ((SUBS(DADOS,13,8)))                    
                M.TIPO         = ((SUBS(DADOS,21,3)))                    
                M.CENTROCUST   = ((SUBS(DADOS,24,6)))                    
                M.ORCAMENTO    = ((SUBS(DADOS,30,6)))                    
                M.TP_MERCAD    = ((SUBS(DADOS,36,1)))                    
                M.CH_OPERA     = ((SUBS(DADOS,37,1)))                    
                M.CH_PRODU     = ((SUBS(DADOS,38,1)))                    
                M.CH_MOTIV     = ((SUBS(DADOS,39,1)))                    
                M.CH_DESTI     = ((SUBS(DADOS,40,1)))                    
                M.CH_CONTR     = ((SUBS(DADOS,41,1)))                    
                M.CH_CONDI     = ((SUBS(DADOS,42,1)))                    
                M.CFO          = ((SUBS(DADOS,43,4)))                    
                M.OPERACAO     = ((SUBS(DADOS,47,4)))                    
                M.MOVESTQ      = ((SUBS(DADOS,51,1)))                    
                M.MOVFIN       = ((SUBS(DADOS,52,1)))                    
                M.INFO_ICMS    = ((SUBS(DADOS,53,1)))                    
                M.ALIQ_ICMS    = ((SUBS(DADOS,54,5)))                    
                M.ALIQ_IPI     = ((SUBS(DADOS,59,5)))                    
                M.ALIQ_ISS     = ((SUBS(DADOS,64,5)))                    
                M.NOTA         = ((SUBS(DADOS,69,6)))                    


				M.DTFAT	     = CTOD(SUBS(DADOS,81,2)+"."+SUBS(DADOS,79,2)+"."+;
					SUBS(DADOS,75,4))

                M.SITUACAO     = ((SUBS(DADOS,83,2)))                    
                M.MOTIVO       = ((SUBS(DADOS,85,1)))                    
                M.FAVORECIDO   = ((SUBS(DADOS,86,14)))                    
                M.TP_PGTO      = ((SUBS(DADOS,100,2)))                    
                M.PRAZOMEDIO   = ((SUBS(DADOS,102,3)))                    
                M.CODIGO       = ((SUBS(DADOS,105,11)))                    
                M.CLASSIFICA   = ((SUBS(DADOS,116,15)))                    
                M.INFO_VLR     = ((SUBS(DADOS,131,1)))                    
                M.PRECO        = ((SUBS(DADOS,132,10)))                    
                M.PRECOFINAL   = ((SUBS(DADOS,142,10)))                    
                M.ORIGEM       = ((SUBS(DADOS,152,1)))                    
                M.CST          = ((SUBS(DADOS,153,1)))                    
                M.QTDE         = ((SUBS(DADOS,154,5)))                    
                M.UNIDADE      = ((SUBS(DADOS,159,2)))                    
                M.DESCONTO     = ((SUBS(DADOS,161,6)))                    
                M.TAXA         = ((SUBS(DADOS,167,5)))                    
                M.VLRVENDA     = ((SUBS(DADOS,172,10)))                    
                M.VLRIPI       = ((SUBS(DADOS,182,10)))                    
                M.IVA          = ((SUBS(DADOS,192,5)))                    
                M.INFO_BASE    = ((SUBS(DADOS,197,1)))                    
                M.BASE_CALC    = ((SUBS(DADOS,198,10)))                    
                M.DESCRICAO    = ((SUBS(DADOS,208,25)))                    
                M.QTDERES	   = ((SUBS(DADOS,233,5)))                    

			   * NEWFIELD  C 4 ** PREENCHIMENTO
			
                M.PESO         = ((SUBS(DADOS,242,10)))                    
                M.CLAS_CMS     = ((SUBS(DADOS,252,4)))                    
                M.ORDEM        = ((SUBS(DADOS,256,2)))                    
                M.DESC_ALT     = ((SUBS(DADOS,258,6)))                    
                M.USR_DALT     = ((SUBS(DADOS,264,4)))                    
                M.NATU_CLI     = ((SUBS(DADOS,268,1)))                    


				M.DTREGIS     = CTOD(SUBS(DADOS,275,2)+"."+SUBS(DADOS,273,2)+"."+;
					SUBS(DADOS,269,4))

                M.HREGIS       = ((SUBS(DADOS,277,8)))                    
                M.USRREGIS     = ((SUBS(DADOS,285,4)))                    
		 		M.deletado	 =  .F.
				SELE orcatmp
				APPEND BLANK
				GATHER MEMVAR
	ENDIF

ENDDO
SELE ORCATMP
USE
=FCLOSE(A)
