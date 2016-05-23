*******************************************************
* RECUPERACAO DE ORCAMENT
*******************************************************

CLEAR
SET EXCL ON
SET TALK OFF
SET CENTU ON
SET DATE GERMAN
USE orcament

ZAP
PACK

A = FOPEN("\SCGC\TAREFA\ORCAMENT.DBF")

LER = 568
FLGgrava = .f.

DADOS =	FGETS(A,LER)
CTR = 1
REGUA = ;
"123456789 123456789 123456789 123456789 123456789 123456789 123456789 123456789"
DO WHILE !FEOF(A) AND !CHRSAW()
	CTR = CTR + 1
	clear
	@ 10,15 SAY CTR

	IF SUBS(DADOS,275,8) = "DELETADO"
		wait window "INICIO DE RECUPERACAO"
		FLGgrava = .t.
	ENDIF

	DADOS =	FGETS(A,LER)
*	?REGUA
*	?SUBS(DADOS,275)
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
		*********************


        M.TP_PESSOA  = INT(VAL(SUBS(DADOS,5,1)))
        M.CLIENTE    = INT(VAL(SUBS(DADOS,6,14)))
        M.NOME       = ((SUBS(DADOS,20,60)))
        M.ENDERECO   = ((SUBS(DADOS,80,30)))
        M.CIDADE     = ((SUBS(DADOS,110,22)))
        M.BAIRRO     = ((SUBS(DADOS,132,15)))
        M.ESTADO     = ((SUBS(DADOS,147,2)))
        M.CEP        = ((SUBS(DADOS,149,8)))
        M.FONE       = ((SUBS(DADOS,157,15)))
        M.REGIAO     = INT(VAL(SUBS(DADOS,172,3)))
        M.VEICULO    = ((SUBS(DADOS,175,15)))
        M.PLACA      = ((SUBS(DADOS,190,7)))
        M.TP_INSCR   = INT(VAL(SUBS(DADOS,197,1)))
        M.INSCRICAO  = ((SUBS(DADOS,198,18)))
        M.REVENDEDOR = ((SUBS(DADOS,216,1)))
        M.ORCAMENTO  = INT(VAL(SUBS(DADOS,217,6)))

		M.data	     = CTOD(SUBS(DADOS,229,2)+"."+SUBS(DADOS,227,2)+"."+;
					SUBS(DADOS,223,4))


        M.HORA       = ((SUBS(DADOS,231,8)))
        M.VALOR      = (VAL(SUBS(DADOS,239,10)))
        M.FORMA_PGTO = INT(VAL(SUBS(DADOS,249,2)))
        M.TP_PGTO    = INT(VAL(SUBS(DADOS,251,2)))
        M.PRAZO      = ((SUBS(DADOS,253,20)))
        M.PRAZOMEDIO = INT(VAL(SUBS(DADOS,273,3)))
        M.VLR_ENT    = (VAL(SUBS(DADOS,276,10)))
        M.JUROMES    = (VAL(SUBS(DADOS,286,6)))
        M.TAXA       = (VAL(SUBS(DADOS,292,5)))

		M.DT_RET    = CTOD(SUBS(DADOS,303,2)+"."+SUBS(DADOS,301,2)+"."+;
					SUBS(DADOS,297,4))


        M.HORA_RET   = ((SUBS(DADOS,305,8)))
        M.QTD_RET    = INT(VAL(SUBS(DADOS,313,2)))

		M.DT_RES    = CTOD(SUBS(DADOS,321,2)+"."+SUBS(DADOS,319,2)+"."+;
					SUBS(DADOS,315,4))

        M.HORA_RES   = ((SUBS(DADOS,323,8)))

		M.DT_LIBERA    = CTOD(SUBS(DADOS,337,2)+"."+SUBS(DADOS,335,2)+"."+;
					SUBS(DADOS,331,4))

        M.LIM_LIBERA = (VAL(SUBS(DADOS,339,10)))
        M.LIM_FORMA  = INT(VAL(SUBS(DADOS,349,2)))
        M.LIM_PRAZO  = INT(VAL(SUBS(DADOS,351,3)))
        M.USR_LIBERA = INT(VAL(SUBS(DADOS,354,4)))


		M.DT_FAT    = CTOD(SUBS(DADOS,364,2)+"."+SUBS(DADOS,362,2)+"."+;
					SUBS(DADOS,358,4))


        M.HORA_FAT   = ((SUBS(DADOS,366,8)))
        M.NOTA       = INT(VAL(SUBS(DADOS,374,6)))
        M.CENTROCUST = ((SUBS(DADOS,380,6)))
        M.NATU_OPER  = INT(VAL(SUBS(DADOS,386,1)))
        M.SITUACAO   = ((SUBS(DADOS,387,2)))
        M.MOTIVO     = INT(VAL(SUBS(DADOS,389,1)))
        M.BANCO      = INT(VAL(SUBS(DADOS,390,3)))
        M.AGENCIA    = INT(VAL(SUBS(DADOS,393,5)))
*        M.OBS        = ((SUBS(DADOS,398,10)))
        M.TRANSP     = INT(VAL(SUBS(DADOS,408,14)))
        M.TP_TRANSP  = INT(VAL(SUBS(DADOS,422,1)))
        M.PLACA_TRAN = ((SUBS(DADOS,423,7)))
        M.UF_TRAN    = ((SUBS(DADOS,430,2)))
        M.QTDE_VOL   = INT(VAL(SUBS(DADOS,432,5)))
        M.ESPEC_VOL  = ((SUBS(DADOS,437,3)))
        M.NUMERO     = ((SUBS(DADOS,440,3)))
        M.MARCA      = ((SUBS(DADOS,443,10)))
        M.PES_BRT    = INT(VAL(SUBS(DADOS,453,7)))
        M.PES_LIQ    = INT(VAL(SUBS(DADOS,460,7)))
        M.PGTO_FRETE = INT(VAL(SUBS(DADOS,467,1)))
        M.VLRFRETE   = (VAL(SUBS(DADOS,468,10)))
        M.VLRSEGURO  = (VAL(SUBS(DADOS,478,10)))
        M.VLRDESPES  = (VAL(SUBS(DADOS,488,10)))
        M.PESO_BRT   = (VAL(SUBS(DADOS,498,10)))
        M.OPERADOR   = INT(VAL(SUBS(DADOS,508,4)))
        M.TIPO       = ((SUBS(DADOS,512,3)))
        M.CFO        = ((SUBS(DADOS,515,4)))
        M.TAB_CST    = INT(VAL(SUBS(DADOS,519,2)))
        M.CH_OPERA   = ((SUBS(DADOS,521,1)))
        M.CH_PRODU   = ((SUBS(DADOS,522,1)))
        M.CH_MOTIV   = ((SUBS(DADOS,523,1)))
        M.CH_DESTI   = ((SUBS(DADOS,524,1)))
        M.CH_CONTR   = ((SUBS(DADOS,525,1)))
        M.CH_CONDI   = ((SUBS(DADOS,526,1)))
        M.HODOM      = INT(VAL(SUBS(DADOS,527,6)))
        M.VIAS_OSI   = INT(VAL(SUBS(DADOS,533,2)))
        M.FECHA      = (VAL(SUBS(DADOS,535,10)))
        M.NATU_CLI   = INT(VAL(SUBS(DADOS,545,1)))
        M.QTDNFGERAD = INT(VAL(SUBS(DADOS,546,2)))
        M.DTREGIS    = ((SUBS(DADOS,548,8)))

		M.DTREGIS    = CTOD(SUBS(DADOS,554,2)+"."+SUBS(DADOS,552,2)+"."+;
					SUBS(DADOS,548,4))

        M.HREGIS     = ((SUBS(DADOS,556,8)))
        M.USRREGIS   = INT(VAL(SUBS(DADOS,564,4)))
        M.DELETADO   = ((SUBS(DADOS,568,1)))

		IF  (SUBS(DADOS,568,1)) = "T"
			M.deletado	 =  .T.
		ELSE
			M.deletado	 =  .F.
		ENDIF
		SELE orcament
		APPEND BLANK
		GATHER MEMVAR
	ENDIF

ENDDO
SELE ORCAMENT
USE
=FCLOSE(A)
