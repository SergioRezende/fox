SET TALK OFF
SET CENTU ON
SET DATE GERMAN
USE itemmov

ZAP
PACK
A = FOPEN("\SCGC\TAREFA\ITEMMOV.DBF")

LER = 346
FLGgrava = .f.

DADOS =	FGETS(A,LER)
CTR = 1
DO WHILE !FEOF(A) AND !CHRSAW()
	CTR = CTR + 1
	@ 10,15 SAY CTR

	IF SUBS(DADOS,320,2) = "LY"
		wait window "INICIO DA CORRECAO"
		FLGgrava = .t.
	ENDIF

	DADOS =	FGETS(A,LER)
	IF FLGgrava
		M.empresa 	 =  val(SUBS(DADOS,1,4))
		IF m.empresa = 0
			LOOP
		ENDIF

		M.data		 =  CTOD(SUBS(DADOS,11,2)+"."+SUBS(DADOS,9,2)+"."+;
						SUBS(DADOS,5,4))
		M.hora		 =  SUBS(DADOS,13,8)
		M.tipo		 =  SUBS(DADOS,21,3)
		M.centrocust =  SUBS(DADOS,24,6)
 		M.orcamento  =  VAL(SUBS(DADOS,30,6))
		M.tp_mercad  =  VAL(SUBS(DADOS,36,1))
		M.ch_opera   =  (SUBS(DADOS,37,1))
		M.ch_produ   =  (SUBS(DADOS,38,1))
		M.ch_motiv   =  (SUBS(DADOS,39,1))
		M.ch_desti   =  (SUBS(DADOS,40,1))
		M.ch_contr   =  (SUBS(DADOS,41,1))
		M.ch_condi   =  (SUBS(DADOS,42,1))
		M.cfo        =  (SUBS(DADOS,43,4))
		M.operacao   =  (SUBS(DADOS,47,4))
		M.movestq    =  (SUBS(DADOS,51,1))
		M.movfin     =  (SUBS(DADOS,52,1))
		M.info_icms  =  (SUBS(DADOS,53,1))
		M.aliq_icms  =  val(SUBS(DADOS,54,5))
		M.aliq_ipi   =  val(SUBS(DADOS,59,5))
		M.nota		 =  INT(val(SUBS(DADOS,64,6)))
		M.serie      =  (SUBS(DADOS,70,1))

		M.dtfat		 =  CTOD(SUBS(DADOS,77,2)+"."+SUBS(DADOS,75,2)+"."+;
						SUBS(DADOS,71,4))
		M.situacao   =  (SUBS(DADOS,79,2))
		M.motivo	 =  INT(val(SUBS(DADOS,81,1)))
		M.codforn	 =  INT(val(SUBS(DADOS,82,5)))
		M.favorecido =  INT(val(SUBS(DADOS,87,14)))
		M.tp_pgto	 =  INT(val(SUBS(DADOS,101,2)))
		M.prazomedio =  INT(val(SUBS(DADOS,103,3)))
		M.codigo	 =  (SUBS(DADOS,106,11))
		M.classifica =  (SUBS(DADOS,117,15))
		M.info_vlr 	 =  (SUBS(DADOS,132,1))
		M.preco		 =  val(SUBS(DADOS,133,10))
		M.precofinal =  val(SUBS(DADOS,143,10))
		M.origem	 =  val(SUBS(DADOS,153,1))
		M.cst		 =  (SUBS(DADOS,154,1))
		M.qtde		 =  int(val(SUBS(DADOS,155,5)))
		M.unidade	 =  (SUBS(DADOS,160,2))

***????????????????  verificar se nao ha distorcao de 1 posicao

		M.desconto	 =  val(SUBS(DADOS,162,5))

*		M.taxa		 =  val(SUBS(DADOS,168,5))
*		M.vlrvenda	 =  val(SUBS(DADOS,173,10))
*		M.vlripi	 =  val(SUBS(DADOS,183,10))
*		M.iva		 =  val(SUBS(DADOS,193,5))
*		M.custo_ind	 =  val(SUBS(DADOS,198,10))
*		M.info_base	 =  (SUBS(DADOS,208,1))
*		M.base_calc	 =  val(SUBS(DADOS,209,10))
*		M.descricao	 =  (SUBS(DADOS,219,25))
*		M.comissiona =  (SUBS(DADOS,244,9))
*		M.peso		 =  val(SUBS(DADOS,253,10))
*		M.clas_cms	 =  (SUBS(DADOS,263,4))
*		M.sld_estq	 =  val(SUBS(DADOS,267,10))
*		M.vlr_estq	 =  val(SUBS(DADOS,277,10))
*		M.sld_rese	 =  val(SUBS(DADOS,287,10))
*		M.ordem		 =  int(val(SUBS(DADOS,297,2)))
*		M.operador	 =  int(val(SUBS(DADOS,299,4)))
*		M.desc_alt	 =  (val(SUBS(DADOS,303,6)))
*		M.usr_dalt	 =  int(val(SUBS(DADOS,309,4)))
*		M.dlibreserv =  CTOD(SUBS(DADOS,319,2)+"."+SUBS(DADOS,317,2)+"."+;
*						SUBS(DADOS,313,4))
*		M.hlibreserv =  (SUBS(DADOS,321,5))
*		M.natu_cli	 =  int(val(SUBS(DADOS,326,1)))
*		M.dtregis	 =  CTOD(SUBS(DADOS,333,2)+"."+SUBS(DADOS,331,2)+"."+;
*						SUBS(DADOS,327,4))
*		M.hregis	 =  (SUBS(DADOS,335,8))
*		M.usrregis	 =  int(val(SUBS(DADOS,343,4)))
*
*		IF  (SUBS(DADOS,347,1)) = "T"
*			M.deletado	 =  .T.
*		ELSE
*			M.deletado	 =  .F.
*		ENDIF

		M.taxa		 =  val(SUBS(DADOS,167,5))
		M.vlrvenda	 =  val(SUBS(DADOS,172,10))
		M.vlripi	 =  val(SUBS(DADOS,182,10))
		M.iva		 =  val(SUBS(DADOS,192,5))
		M.custo_ind	 =  val(SUBS(DADOS,197,10))
		M.info_base	 =  (SUBS(DADOS,207,1))
		M.base_calc	 =  val(SUBS(DADOS,208,10))
		M.descricao	 =  (SUBS(DADOS,218,25))
		M.comissiona =  (SUBS(DADOS,243,9))
		M.peso		 =  val(SUBS(DADOS,252,10))
		M.clas_cms	 =  (SUBS(DADOS,262,4))
		M.sld_estq	 =  val(SUBS(DADOS,266,10))
		M.vlr_estq	 =  val(SUBS(DADOS,276,10))
		M.sld_rese	 =  val(SUBS(DADOS,286,10))
		M.ordem		 =  int(val(SUBS(DADOS,296,2)))
		M.operador	 =  int(val(SUBS(DADOS,298,4)))
		M.desc_alt	 =  (val(SUBS(DADOS,302,6)))
		M.usr_dalt	 =  int(val(SUBS(DADOS,308,4)))
		M.dlibreserv =  CTOD(SUBS(DADOS,318,2)+"."+SUBS(DADOS,316,2)+"."+;
						SUBS(DADOS,312,4))
		M.hlibreserv =  (SUBS(DADOS,320,5))
		M.natu_cli	 =  int(val(SUBS(DADOS,325,1)))
		M.dtregis	 =  CTOD(SUBS(DADOS,332,2)+"."+SUBS(DADOS,330,2)+"."+;
						SUBS(DADOS,326,4))
		M.hregis	 =  (SUBS(DADOS,334,8))
		M.usrregis	 =  int(val(SUBS(DADOS,342,4)))

		IF  (SUBS(DADOS,346,1)) = "T"
			M.deletado	 =  .T.
		ELSE
			M.deletado	 =  .F.
		ENDIF

		SELE itemmov
		APPEND BLANK
		GATHER MEMVAR
	ENDIF

	IF LASTKEY() =  27
		EXIT
	ENDIF
ENDDO
SELE ITEMMOV
USE
=FCLOSE(A)
