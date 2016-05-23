*******************************************************
* RECUPERACAO DE ITMANEXO
*******************************************************

CLEAR
SET TALK OFF
SET CENTU ON
SET DATE GERMAN
USE itmanexo

ZAP
PACK
A = FOPEN("\SCGC\TAREFA\ITMANEXO.DBF")

LER = 213
FLGgrava = .f.

DADOS =	FGETS(A,LER)
CTR = 1
REGUA = ;
"123456789 123456789 123456789 123456789 123456789 123456789 123456789 123456789"
DO WHILE !FEOF(A) AND !CHRSAW()
	CTR = CTR + 1
	@ 10,15 SAY CTR

	IF SUBS(DADOS,179,8) = "DELETADO"
		wait window "INICIO DE RECUPERACAO"
		FLGgrava = .t.
	ENDIF

	DADOS =	FGETS(A,LER)
*	?REGUA
*?DADOS
*=inkey(0)
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
		M.codigo	 =  SUBS(DADOS,5,11)
		M.data		 =  CTOD(SUBS(DADOS,22,2)+"."+SUBS(DADOS,20,2)+"."+;
						SUBS(DADOS,16,4))
		M.hora		 =  SUBS(DADOS,24,8)
		M.tipo		 =  SUBS(DADOS,32,3)
		M.nota		 =  INT(val(SUBS(DADOS,35,6)))
		M.ordem		 =  INT(val(SUBS(DADOS,41,2)))
		M.q_compra	 =  (val(SUBS(DADOS,43,10)))
		M.v_compra	 =  (val(SUBS(DADOS,53,10)))
		M.q_venda	 =  (val(SUBS(DADOS,63,10)))
		M.v_venda	 =  (val(SUBS(DADOS,73,10)))
		M.qe_tran	 =  (val(SUBS(DADOS,83,10)))
		M.ve_tran	 =  (val(SUBS(DADOS,93,10)))
		M.qe_outr	 =  (val(SUBS(DADOS,103,10)))
		M.ve_outr	 =  (val(SUBS(DADOS,113,10)))
		
		M.qs_tran	 =  (val(SUBS(DADOS,123,10)))
		M.vs_tran	 =  (val(SUBS(DADOS,133,10)))
		M.qs_outr	 =  (val(SUBS(DADOS,143,10)))
		M.vs_outr	 =  (val(SUBS(DADOS,153,10)))

		M.v_tab		 =  (val(SUBS(DADOS,163,10)))
		M.v_contab	 =  (val(SUBS(DADOS,173,10)))
		M.v_enc		 =  (val(SUBS(DADOS,183,10)))
		M.dtregis	 =  CTOD(SUBS(DADOS,199,2)+"."+SUBS(DADOS,197,2)+"."+;
						SUBS(DADOS,193,4))

		M.hregis	 =  (SUBS(DADOS,201,8))
		M.usrregis	 =  int(val(SUBS(DADOS,209,4)))
		IF  (SUBS(DADOS,213,1)) = "T"
			M.deletado	 =  .T.
		ELSE
			M.deletado	 =  .F.
		ENDIF
		SELE itmanexo
		APPEND BLANK
		GATHER MEMVAR
	ENDIF

ENDDO
SELE ITMANEXO
USE
=FCLOSE(A)
