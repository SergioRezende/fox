
return
*---------------------------------------------------------------*

FUNCTION NFDMSParam
PARAMETERS PrmEmpresa, PrmDataInicio, PrmDataFinal

	=W_DEFPROC("rotinas.spr")

    PRIVATE LSalias
    PRIVATE ARQ_Empresa,ALS_Empresa
    PRIVATE ARQ_Nota,ALS_Nota
    
	LSalias			= ALIAS()

    ARQ_empresa = NetArqAgain("EMPRESA")
    ALS_empresa = Alias()

    ARQ_nota  = NetArqAgain("NOTA")
    ALS_nota  = Alias()


	SELE &ALS_Nota
	SET ORDER TO TAG DATA

	SELE &ALS_Empresa
	SET ORDER TO TAG EMPRESA

	SELE 0
   	USE Q:\SCGC\COMUM\DMS  EXCL

	SELE DMS
    ZAP
	PACK

	SELE &ALS_Empresa
	seek PrmEmpresa


	LNempresa   = PrmEmpresa
    LDataInicio = PrmDataInicio
   	LDataFinal  = PrmDataFinal
   	LSPeriodo   = STR(YEAR(LDataFinal),4)+Str(Month(LDataFinal),2)
	LSPeriodo   = STRTRAN(LSPeriodo," ", "0")
   	LSExtensao  = SUBS(LSPeriodo,3,2)+".D"+SUBS(LSPeriodo,5,2)


    LNinscr_Muni = STRTRAN( &ALS_Empresa .insc_munic,".","")
    LNinscr_Muni = STRTRAN(LNinscr_Muni," ","0")
    LNinscr_Muni = STRTRAN(LNinscr_Muni,"-","")
    LNinscr_Muni = STRTRAN(LNinscr_Muni,"/","")
    LNinscr_Muni = Left(LNinscr_Muni,7)
   	LNAIDF    = &ALS_Empresa .AIDF
	LNANOAIDF = &ALS_Empresa .ANOAIDF
    LNMODISS  = &ALS_Empresa .MODISS
    LScidade  = &ALS_Empresa .cidade
	LSarqDst  = "Q:\SCGC\DMS\"+;
	            LEFT(LNinscr_Muni,6)+LSExtensao  && INSC+AA+.D MM



    LsTipo       = "H"

	sele dms

    LsEmpresa    = LEFT( &ALS_Empresa .nome + SPACE(50),50)
   	LsCNPJ       = strtran(str( &ALS_Empresa .cgc,14)," ","0")
    LsDMSNegativa= "N"
	LsEspaco     = space(83)
	LsData       = DTOS(DATE())
	LsEmail      = LEFT("deptofiscal@pneulandia.com.br"+space(35),35)
   	LsVersao     = "V.2.0"
	LsEspaco2     = space(35)
     
   	LScabecalho =   LsTipo+LNinscr_Muni+LSPeriodo+LsEmpresa+;
    		 LsCNPJ+ LsDMSNegativa+LsEspaco+LsData+LsEmail+;
    		 LsVersao+LsEspaco2
	APPEND BLANK
	REPLACE dms with  LScabecalho

*-------------------------------------------------------------*


	SET TALK ON

   	SELECT empresa,nota,referencia ;
	 	from &ALS_Nota where empresa = LNempresa;
 	       and tipo = "CPM";
 	       and data <=  LDataFinal ;
 	       and data >= LDataInicio ;
 	       and vlr_iss > 0;
 	    order by empresa,nota,referencia into cursor DMS_CPMs




   	SELECT nota
       data,;
   	   status,;
	   nome,;
	   tp_pessoa,;
	   Favorecido;		   	       
	   cidade,;
       base_iss,;
 	   total_nota,;
 	   aliq_iss,;
 	   vlr_iss,;
 	from &ALS_Nota where empresa = LNempresa;
       and tipo <> "CPM" ;
       and nota < 1000000 ;
       and data <=  LDataFinal ;
       and data >= LDataInicio and vlr_iss > 0;
    order by NOTA,ANONF,MESNF,DIANF into cursor DMS_A1



   	SELECT "D" AS identif,SPACE(4) AS espaco1,;
       strtran(str(nota,10)," ","0") AS NOTA,;
       strtran(str(LNAIDF,7)," ","0") AS AIDF,;
        strtran(str(LNANOAIDF,4)," ","0") AS ANOAIDF,;
        strtran(str(YEAR(data),4)," ","0")  AS ANONF,;
        strtran(str(MONTH(data),2)," ","0") AS MESNF,;
        strtran(str(DAY(data),2)," ","0") AS DIANF,;
       strtran(str(LNMODISS,1)," ","0") AS MODISS,;
		   IIF(status = 2  ,"1","0") AS sitnf,;
		   LEFT(nome+space(50),50) AS nome,;
		   IIF(tp_pessoa = 1,"F","J") AS tp_pess,;
		   strtran(str(Favorecido,14)," ","0") AS favo,;		   	       
		   IIF(cidade = LScidade,"1","0") AS CIDADE,;
		   LEFT(cidade+space(25),25)	AS cidtomad,;
 	       strtran(str(INT(base_iss*100),13)," ","0") AS baseiss,;
 	       strtran(str(INT(total_nota*100),13)," ","0") AS vlrnf,;
 	       strtran(str(INT(aliq_iss*100),4)," ","0") AS aliqiss,;
 	       strtran(str(INT(vlr_iss*100),13)," ","0") AS vlriss,;
 	       SPACE(88)  AS espaco2;
	 	from DMS_A1 ;
 	    order by NOTA,ANONF,MESNF,DIANF into cursor DMS_B1





   	SELECT CPM.nota,;
   	    NF.data,;
   	    CPM.status,;
	    NF.nome,;
	    NF.tp_pessoa,;
	    NF.Favorecido;		   	       
	    NF.cidade,;
        CPM.base_iss,;
 	    CPM.total_nota,;
 	    CPM.aliq_iss,;
 	    CPM.vlr_iss,;
 	from &ALS_Nota NF, DMS_CPMs CPM ;
	 	where NF.empresa = LNempresa;
 	       and NF.tipo <> "CPM" ;
 	       and NF.empresa= CPM.empresa ;
 	       and NF.nota= CPM.referencia ;
 	       and NF.nota > 1000000 ;
		   and NF.nota < 2000000 ;
 	       and NF.data <=  LDataFinal ;
 	       and NF.data >= LDataInicio ;
 	       and NF.vlr_iss > 0;
    order by NOTA,ANONF,MESNF,DIANF into cursor DMS_A2




   	SELECT "D" AS identif,SPACE(4) AS espaco1,;
       strtran(str(nota,10)," ","0") AS NOTA,;
       strtran(str(LNAIDF,7)," ","0") AS AIDF,;
        strtran(str(LNANOAIDF,4)," ","0") AS ANOAIDF,;
        strtran(str(YEAR(data),4)," ","0")  AS ANONF,;
        strtran(str(MONTH(data),2)," ","0") AS MESNF,;
        strtran(str(DAY(data),2)," ","0") AS DIANF,;
       strtran(str(LNMODISS,1)," ","0") AS MODISS,;
		   IIF(status = 2  ,"1","0") AS sitnf,;
		   LEFT(nome+space(50),50) AS nome,;
		   IIF(tp_pessoa = 1,"F","J") AS tp_pess,;
		   strtran(str(Favorecido,14)," ","0") AS favo,;		   	       
		   IIF(cidade = LScidade,"1","0") AS CIDADE,;
		   LEFT(cidade+space(25),25)	AS cidtomad,;
 	       strtran(str(INT(base_iss*100),13)," ","0") AS baseiss,;
 	       strtran(str(INT(total_nota*100),13)," ","0") AS vlrnf,;
 	       strtran(str(INT(aliq_iss*100),4)," ","0") AS aliqiss,;
 	       strtran(str(INT(vlr_iss*100),13)," ","0") AS vlriss,;
 	       SPACE(88)  AS espaco2;
	 	from DMS_A2 ;
 	    order by NOTA,ANONF,MESNF,DIANF into cursor DMS_B2






    SELECT * FROM DMS_B1;
    UNION ;
    SELECT * FROM DMS_B2;
 	    into cursor DMS_B3


	SELECT * FROM DMS_B3 ;
 	    order by NOTA,ANONF,MESNF,DIANF into cursor DMS_D





	SET TALK OFF

 	SELE DMS_D
   	COPY TO  L:\TMP\DMS_D  TYPE SDF
 	 
    SELECT DMS
	APPEND FROM L:\TMP\DMS_D.TXT TYPE SDF

	 *-----------------------------------------------------------*

	count to LsQtde
	LsQtde = LsQtde - 1
	GO TOP
	 
    LsTipo  = "T"
   	LsQtde  =  strtran(str(LsQtde,4)," ","0")
   	LSEspaco= space(240)

    LStotal =   LsTipo+LsQtde+Lsespaco
	APPEND BLANK
	REPLACE dms with  LStotal
	
	GO TOP 
	COPY TO &LSarqDst TYPE SDF
	USE
	
    =up_fecha("&ALS_empresa")
    =up_fecha("&ALS_Nota")
	IF !EMPTY(LSalias) AND USED(LSalias)
		SELECT &LSalias
	ENDIF
	SET TALK OFF
RETURN(.T.)
	




