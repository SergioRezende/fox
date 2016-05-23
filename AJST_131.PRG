SET CONFIRM OFF
SET DATE GERMAN
SET CENTU ON
SET DELE ON
SET EXCL OFF





 SET STEP ON

IF 1 = 1


	 =ULInt_tmp(1)   && GYN
	
	 SELE TMPINVT3 
	 SET STEP ON
	 COPY TO X:\SUPORTE\INVT2013\INVT_GYN


ENDIF

 CLOSE DATA

 
*--------------------------------------------------------* 
 
IF 1 = 2
	 =ULInt_tmp(5)   && IPG
	 SELE TMPINVT3 
	 SET STEP ON

	 COPY TO X:\SUPORTE\INVT2013\INVT_IPG


ENDIF


 CLOSE DATA

*--------------------------------------------------------* 
 
  
IF 1 = 2

	 =ULInt_tmp(7)   && T63
	 SELE TMPINVT3 
	 SET STEP ON
	 COPY TO X:\SUPORTE\INVT2013\INVT_T63

ENDIF

 CLOSE DATA
*--------------------------------------------------------* 

IF 1 = 2

	 =ULInt_tmp(9)   && IDP/RIO
	 SELE TMPINVT3 
	 SET STEP ON
	 COPY TO X:\SUPORTE\INVT2013\INVT_RIO


ENDIF

 CLOSE DATA
*--------------------------------------------------------* 

IF 1 = 2

	 =ULInt_tmp(11)   && DPO
	 SELE TMPINVT3 
	 SET STEP ON
	 COPY TO X:\SUPORTE\INVT2013\INVT_DPO

ENDIF

 CLOSE DATA
*--------------------------------------------------------* 

IF 1 = 2

	 =ULInt_tmp(14)   && IPG
	 SELE TMPINVT3 
	 SET STEP ON
	 COPY TO X:\SUPORTE\INVT2013\INVT_ANP

ENDIF

 CLOSE DATA
*--------------------------------------------------------* 
 
 

RETURN 



FUNCTION ULInt_tmp
PARAMETERS LNEmp

 ON ERROR
 ON KEY
 
 close data
 set talk on
 on key
 set sysm to defa
 set centu on 
 set date german

 SET DELE ON

 SET STEP ON

*------------------------------------------*

 LNzera = val("0000000000000000000000,00")
 LSdir      = "O:\SCGC2013\CENTRAL\"
 LSdirCOMUM = "O:\COMUM\"
 LDdataInventario = {31.12.2013}
 
 
*======================================= *

 LSFileSaldo   = LSdir + "SALDO" 
 LSFileGrupo   = LSdir + "GRUPO" 
 LSFileItemmov = LSdir + "ITEMMOV" 
 LSFileEmpresa = LSdir + "EMPRESA" 
 
 
*======================================= *

  
 


=IV_INVT(LNemp,LDdataInventario)



 

RETURN

* ======================================= *
* ======================================= *
* ======================================= *
* ======================================= *
* ======================================= *


FUNCTION IV_INVT
PARAMETERS LNemp,LDdataInventario


 IF FILE("\TMP\TMP_MOV.DBF")
    DELETE FILE "\TMP\TMP_MOV.DBF"
 ENDIF 


 IF FILE("\TMP\INVNTRIO.DBF")
    DELETE FILE "\TMP\INVNTRIO.DBF"
 ENDIF 



 IF FILE("\TMP\SLD_ANTE.DBF")
    DELETE FILE "\TMP\SLD_ANTE.DBF"
 ENDIF 


 IF FILE("\TMP\ENTRADAS.DBF")
    DELETE FILE "\TMP\ENTRADAS.DBF"
 ENDIF 


 IF FILE("\TMP\SAIDAS.DBF")
    DELETE FILE "\TMP\SAIDAS.DBF"
 ENDIF 



 IF FILE("\TMP\COMPLE.DBF")
    DELETE FILE "\TMP\COMPLE.DBF"
 ENDIF 


 IF FILE("\TMP\QLA.DBF")
    DELETE FILE "\TMP\QLA.DBF"
 ENDIF 
 IF FILE("\TMP\SCA.DBF")
    DELETE FILE "\TMP\SCA.DBF"
 ENDIF 


 IF FILE("\TMP\TMPINVT.DBF")
    DELETE FILE "\TMP\TMPINVT.DBF"
 ENDIF 


 IF FILE("\TMP\TMPINVT2.DBF")
    DELETE FILE "\TMP\TMPINVT2.DBF"
 ENDIF 

 IF FILE("\TMP\TMPINVT3.DBF")
    DELETE FILE "\TMP\TMPINVT3.DBF"
 ENDIF 

 IF FILE("\TMP\TMPRESUM.DBF")
    DELETE FILE "\TMP\TMPRESUM.DBF"
 ENDIF 

 

 =IV_TMPMOV(LNemp,LDdataInventario)  && FILTRA ITEMMOV


 *==================================*
 =IV_LISTA(LNemp)


 =IV_SLDANT(LNemp,LDdataInventario)


 *==================================*


 =IV_ENTRADAS(LNemp,LDdataInventario)


 =IV_SAIDAS(LNemp,LDdataInventario)


 *==================================*


 =IV_COMPLE(LNemp,LDdataInventario)


 =IV_QLA(LNemp,LDdataInventario)

 =IV_SCA(LNemp,LDdataInventario)

 *==================================*

 =IV_Union()

 *==================================*
 
 =IV_SomaInvt()
 
 =IV_InvtFinal(LNemp,LDdataInventario)
 



return


FUNCTION IV_TMPMOV
PARAMETERS PrmEmp,PrmDtFim




	SELECT 	;  
           IT.EMPRESA,;
           IT.CODIGO,;
           IT.QTDE,;
           IT.TIPO,;
           IT.OPERACAO,;
           IT.DATA,;
           IT.MOVESTQ;
    FROM Q:\SCGC\COMUM\GRUPO GR,;
         O:\SCGC2012\CENTRAL\ITEMMOV IT;
    WHERE ;
        	gr.cdg_tipo = 4;
        AND (gr.tp_control = 1 or gr.tp_control = 4);
        AND STRTRAN(STR(PrmEmp,3),' ','0') $ gr.empresas ;
        AND IT.EMPRESA = PrmEmp ;
     	AND IT.CODIGO = GR.CODIGO ;
        AND YEAR(IT.DATA) = 2012;
    ORDER BY GR.CODIGO;
   	INTO TABLE  X:\TMP\MOV_12


    CLOSE DATA

	*----------------------------------------------------------------------*



	*-------------------------------------------------------------------*

	SELECT 	;  
           IT.EMPRESA,;
           IT.CODIGO,;
           IT.QTDE,;
           IT.TIPO,;
           IT.OPERACAO,;
           IT.DATA,;
           IT.MOVESTQ;
    FROM Q:\SCGC\COMUM\GRUPO GR,;
         O:\SCGC2013\CENTRAL\ITEMMOV IT;
    WHERE ;
        	gr.cdg_tipo = 4;
        AND (gr.tp_control = 1 or gr.tp_control = 4);
        AND STRTRAN(STR(PrmEmp,3),' ','0') $ gr.empresas ;
        AND IT.EMPRESA = PrmEmp ;
     	AND IT.CODIGO = GR.CODIGO ;
        AND YEAR(IT.DATA) = 2013;
    ORDER BY GR.CODIGO;
   	INTO TABLE  X:\TMP\MOV_13


    CLOSE DATA

	*----------------------------------------------------------------------*

	SELECT 	;  
         IT.EMPRESA,;
         IT.CODIGO,;
           IT.QTDE,;
           IT.TIPO,;
           IT.OPERACAO,;
           IT.DATA,;
           IT.MOVESTQ;
    FROM Q:\SCGC\COMUM\GRUPO GR,;
         Q:\SCGC\CENTRAL\ITEMMOV IT;
    WHERE ;
        	gr.cdg_tipo = 4;
        AND (gr.tp_control = 1 or gr.tp_control = 4);
        AND STRTRAN(STR(PrmEmp,3),' ','0') $ gr.empresas ;
        AND IT.EMPRESA = PrmEmp ;
     	AND IT.CODIGO = GR.CODIGO ;
        AND YEAR(IT.DATA) = 2014;
        AND MONTH(IT.DATA) <= 9;
    ORDER BY GR.CODIGO;
   	INTO TABLE  X:\TMP\MOV_14
    

    CLOSE DATA
    
	SELE 0
	USE Q:\SCGC\CENTRAL\ITEMMOV 
	COPY STRU TO  X:\TMP\MOV_TMP WITH CDX
	USE
	
	SELE 0
	USE X:\TMP\MOV_TMP
	APPEND FROM X:\TMP\MOV_12
	APPEND FROM X:\TMP\MOV_13
	APPEND FROM X:\TMP\MOV_14
	

    CLOSE DATA


	*---------------------------------------------------------------------*

	
RETURN


FUNCTION IV_LISTA
PARAMETERS PrmEmp


	SELECT  	;
		PrmEmp           AS EMPRESA,;
		PRDT.CODIGO      AS COD_ITEM,;	        
		;
		SUM(LNzera)      AS SLD_2011,;
		SUM(LNzera)      AS SLD_2012,;
		SUM(LNzera)      AS SLD_2013,;
		SUM(LNzera)      AS SLD_2014,;
		;
		SUM(LNzera)      AS ENT_2012,;
		SUM(LNzera)      AS ENT_2013,;
		SUM(LNzera)      AS ENT_2014,;
		;
		SUM(LNzera)      AS SAI_2012,;
		SUM(LNzera)      AS SAI_2013,;
		SUM(LNzera)      AS SAI_2014,;
		;
		SUM(LNzera)      AS CMP_2012,;
		SUM(LNzera)      AS CMP_2013,;
		SUM(LNzera)      AS CMP_2014,;
		;
		SUM(LNzera)      AS QLA_2012,;
		SUM(LNzera)      AS QLA_2013,;
		SUM(LNzera)      AS QLA_2014,;
		;
		SUM(LNzera)      AS SCA_2012,;
		SUM(LNzera)      AS SCA_2013,;
		SUM(LNzera)      AS SCA_2014;
    FROM Q:\SCGC\COMUM\GRUPO PRDT;
    WHERE ;
        	PRDT.cdg_tipo = 4;
        AND (PRDT.tp_control = 1 or PRDT.tp_control = 4);
        AND STRTRAN(STR(PrmEmp,3),' ','0') $ PRDT.empresas ;
    GROUP BY ;
		PRDT.CODIGO ;
   	INTO TABLE  X:\TMP\TMPLIST


RETURN



FUNCTION IV_SldANT
PARAMETERS PrmEmp,PrmDtFim


	*-------------------------------------------------------------------*
	SELECT 	;
			PrmEmp           AS EMPRESA,;
			GR.CODIGO        AS COD_ITEM,;	        
			;
			SUM(SL.SLD_ANTE) AS SLD_2011,;
			SUM(LNzera)      AS SLD_2012,;
			SUM(LNzera)      AS SLD_2013,;
			SUM(LNzera)      AS SLD_2014,;
			;
			SUM(LNzera)      AS ENT_2012,;
			SUM(LNzera)      AS ENT_2013,;
			SUM(LNzera)      AS ENT_2014,;
			;
			SUM(LNzera)      AS SAI_2012,;
			SUM(LNzera)      AS SAI_2013,;
			SUM(LNzera)      AS SAI_2014,;
			;
			SUM(LNzera)      AS CMP_2012,;
			SUM(LNzera)      AS CMP_2013,;
			SUM(LNzera)      AS CMP_2014,;
			;
			SUM(LNzera)      AS QLA_2012,;
			SUM(LNzera)      AS QLA_2013,;
			SUM(LNzera)      AS QLA_2014,;
			;
			SUM(LNzera)      AS SCA_2012,;
			SUM(LNzera)      AS SCA_2013,;
			SUM(LNzera)      AS SCA_2014;
    FROM Q:\SCGC\COMUM\GRUPO GR,;
         O:\SCGC2012\CENTRAL\SALDO SL;
    WHERE ;
        	gr.cdg_tipo = 4;
        AND (gr.tp_control = 1 or gr.tp_control = 4);
        AND STRTRAN(STR(PrmEmp,3),' ','0') $ gr.empresas ;
        AND SL.EMPRESA = PrmEmp ;
     	AND SL.CODIGO = GR.CODIGO ;
        AND YEAR(SL.DTABERT) = 2012;
        AND MONTH(DTABERT) = 1 ;
    ORDER BY GR.CODIGO;
    GROUP BY GR.CODIGO;
   	INTO TABLE  X:\TMP\SLD_2011


	*-------------------------------------------------------------------*
	SELECT 	;
			PrmEmp           AS EMPRESA,;
			GR.CODIGO        AS COD_ITEM,;	        
			;
			SUM(LNzera)      AS SLD_2011,;
			SUM(SL.SLD_ANTE) AS SLD_2012,;
			SUM(LNzera)      AS SLD_2013,;
			SUM(LNzera)      AS SLD_2014,;
			;
			SUM(LNzera)      AS ENT_2012,;
			SUM(LNzera)      AS ENT_2013,;
			SUM(LNzera)      AS ENT_2014,;
			;
			SUM(LNzera)      AS SAI_2012,;
			SUM(LNzera)      AS SAI_2013,;
			SUM(LNzera)      AS SAI_2014,;
			;
			SUM(LNzera)      AS CMP_2012,;
			SUM(LNzera)      AS CMP_2013,;
			SUM(LNzera)      AS CMP_2014,;
			;
			SUM(LNzera)      AS QLA_2012,;
			SUM(LNzera)      AS QLA_2013,;
			SUM(LNzera)      AS QLA_2014,;
			;
			SUM(LNzera)      AS SCA_2012,;
			SUM(LNzera)      AS SCA_2013,;
			SUM(LNzera)      AS SCA_2014;
    FROM Q:\SCGC\COMUM\GRUPO GR,;
         O:\SCGC2013\CENTRAL\SALDO SL;
    WHERE ;
        	gr.cdg_tipo = 4;
        AND (gr.tp_control = 1 or gr.tp_control = 4);
        AND STRTRAN(STR(PrmEmp,3),' ','0') $ gr.empresas ;
        AND SL.EMPRESA = PrmEmp ;
     	AND SL.CODIGO = GR.CODIGO ;
        AND YEAR(SL.DTABERT) = 2013;
        AND MONTH(DTABERT) = 1 ;
    ORDER BY GR.CODIGO;
    GROUP BY GR.CODIGO;
   	INTO TABLE  X:\TMP\SLD_2012


	SELECT 	;
			PrmEmp           AS EMPRESA,;
			GR.CODIGO        AS COD_ITEM,;	        
			;
			SUM(LNzera)      AS SLD_2011,;
			SUM(LNzera)      AS SLD_2012,;
			SUM(SL.SLD_ANTE) AS SLD_2013,;
			SUM(LNzera)      AS SLD_2014,;
			;
			SUM(LNzera)      AS ENT_2012,;
			SUM(LNzera)      AS ENT_2013,;
			SUM(LNzera)      AS ENT_2014,;
			;
			SUM(LNzera)      AS SAI_2012,;
			SUM(LNzera)      AS SAI_2013,;
			SUM(LNzera)      AS SAI_2014,;
			;
			SUM(LNzera)      AS CMP_2012,;
			SUM(LNzera)      AS CMP_2013,;
			SUM(LNzera)      AS CMP_2014,;
			;
			SUM(LNzera)      AS QLA_2012,;
			SUM(LNzera)      AS QLA_2013,;
			SUM(LNzera)      AS QLA_2014,;
			;
			SUM(LNzera)      AS SCA_2012,;
			SUM(LNzera)      AS SCA_2013,;
			SUM(LNzera)      AS SCA_2014;
    FROM Q:\SCGC\COMUM\GRUPO GR,;
         Q:\SCGC\CENTRAL\SALDO SL;
    WHERE ;
        	gr.cdg_tipo = 4;
        AND (gr.tp_control = 1 or gr.tp_control = 4);
        AND STRTRAN(STR(PrmEmp,3),' ','0') $ gr.empresas ;
        AND SL.EMPRESA = PrmEmp ;
     	AND SL.CODIGO = GR.CODIGO ;
        AND YEAR(SL.DTABERT) = 2014;
        AND MONTH(DTABERT) = 1 ;
    ORDER BY GR.CODIGO;
    GROUP BY GR.CODIGO;
   	INTO TABLE  X:\TMP\SLD_2013



	SELECT 	;
			PrmEmp           AS EMPRESA,;
			GR.CODIGO        AS COD_ITEM,;	        
			;
			SUM(LNzera)      AS SLD_2011,;
			SUM(LNzera)      AS SLD_2012,;
			SUM(LNzera)      AS SLD_2013,;
			SUM(SL.SLD_ANTE) AS SLD_2014,;
			;
			SUM(LNzera)      AS ENT_2012,;
			SUM(LNzera)      AS ENT_2013,;
			SUM(LNzera)      AS ENT_2014,;
			;
			SUM(LNzera)      AS SAI_2012,;
			SUM(LNzera)      AS SAI_2013,;
			SUM(LNzera)      AS SAI_2014,;
			;
			SUM(LNzera)      AS CMP_2012,;
			SUM(LNzera)      AS CMP_2013,;
			SUM(LNzera)      AS CMP_2014,;
			;
			SUM(LNzera)      AS QLA_2012,;
			SUM(LNzera)      AS QLA_2013,;
			SUM(LNzera)      AS QLA_2014,;
			;
			SUM(LNzera)      AS SCA_2012,;
			SUM(LNzera)      AS SCA_2013,;
			SUM(LNzera)      AS SCA_2014;
    FROM Q:\SCGC\COMUM\GRUPO GR,;
         Q:\SCGC\CENTRAL\SALDO SL;
    WHERE ;
        	gr.cdg_tipo = 4;
        AND (gr.tp_control = 1 or gr.tp_control = 4);
        AND STRTRAN(STR(PrmEmp,3),' ','0') $ gr.empresas ;
        AND SL.EMPRESA = PrmEmp ;
     	AND SL.CODIGO = GR.CODIGO ;
        AND YEAR(SL.DTABERT) = 2014;
        AND MONTH(DTABERT) = 10 ;
    ORDER BY GR.CODIGO;
    GROUP BY GR.CODIGO;
   	INTO TABLE  X:\TMP\SLD_2014



    CLOSE DATA
   	USE  X:\TMP\SLD_2011
    COPY TO X:\TMP\SLD_ANTE

    CLOSE DATA

    USE X:\TMP\SLD_ANTE


   	APPEND FROM X:\TMP\SLD_2012
   	APPEND FROM X:\TMP\SLD_2013
   	APPEND FROM X:\TMP\SLD_2014
   	
   	CLOSE DATA

*---------------------------------------------------------------------*

	
RETURN








FUNCTION IV_ENTRADAS
PARAMETERS PrmEmp,PrmDtFim



	*-------------------------------------------------------------------*

	SELECT 	;  
			PrmEmp           AS EMPRESA,;
			GR.CODIGO        AS COD_ITEM,;	        
			;
			SUM(LNzera)      AS SLD_2011,;
			SUM(LNzera)      AS SLD_2012,;
			SUM(LNzera)      AS SLD_2013,;
			SUM(LNzera)      AS SLD_2014,;
			;
			SUM(IT.QTDE)     AS ENT_2012,;
			SUM(LNzera)      AS ENT_2013,;
			SUM(LNzera)      AS ENT_2014,;
			;
			;
			SUM(LNzera)      AS SAI_2012,;
			SUM(LNzera)      AS SAI_2013,;
			SUM(LNzera)      AS SAI_2014,;
			;
			SUM(LNzera)      AS CMP_2012,;
			SUM(LNzera)      AS CMP_2013,;
			SUM(LNzera)      AS CMP_2014,;
			;
			SUM(LNzera)      AS QLA_2012,;
			SUM(LNzera)      AS QLA_2013,;
			SUM(LNzera)      AS QLA_2014,;
			;
			SUM(LNzera)      AS SCA_2012,;
			SUM(LNzera)      AS SCA_2013,;
			SUM(LNzera)      AS SCA_2014;
    FROM Q:\SCGC\COMUM\GRUPO GR,;
         X:\TMP\MOV_TMP IT;
    WHERE ;
        	gr.cdg_tipo = 4;
        AND (gr.tp_control = 1 or gr.tp_control = 4);
        AND STRTRAN(STR(PrmEmp,3),' ','0') $ gr.empresas ;
        AND IT.EMPRESA = PrmEmp ;
     	AND IT.CODIGO = GR.CODIGO ;
     	AND IT.TIPO <> "QLA" ;
     	AND IT.MOVESTQ = "S" ;
     	AND LEFT(IT.OPERACAO,1) = "E";
        AND YEAR(IT.DATA) = 2012;
    ORDER BY GR.CODIGO;
    GROUP BY GR.CODIGO;
   	INTO TABLE  X:\TMP\ENT_2012


    CLOSE DATA


	*-------------------------------------------------------------------*

	SELECT 	;  
			PrmEmp           AS EMPRESA,;
			GR.CODIGO        AS COD_ITEM,;	        
			;
			SUM(LNzera)      AS SLD_2011,;
			SUM(LNzera)      AS SLD_2012,;
			SUM(LNzera)      AS SLD_2013,;
			SUM(LNzera)      AS SLD_2014,;
			;
			SUM(LNzera)      AS ENT_2012,;
			SUM(IT.QTDE)     AS ENT_2013,;
			SUM(LNzera)      AS ENT_2014,;
			;
			SUM(LNzera)      AS SAI_2012,;
			SUM(LNzera)      AS SAI_2013,;
			SUM(LNzera)      AS SAI_2014,;
			;
			SUM(LNzera)      AS CMP_2012,;
			SUM(LNzera)      AS CMP_2013,;
			SUM(LNzera)      AS CMP_2014,;
			;
			SUM(LNzera)      AS QLA_2012,;
			SUM(LNzera)      AS QLA_2013,;
			SUM(LNzera)      AS QLA_2014,;
			;
			SUM(LNzera)      AS SCA_2012,;
			SUM(LNzera)      AS SCA_2013,;
			SUM(LNzera)      AS SCA_2014;
    FROM Q:\SCGC\COMUM\GRUPO GR,;
         X:\TMP\MOV_TMP IT;
    WHERE ;
        	gr.cdg_tipo = 4;
        AND (gr.tp_control = 1 or gr.tp_control = 4);
        AND STRTRAN(STR(PrmEmp,3),' ','0') $ gr.empresas ;
        AND IT.EMPRESA = PrmEmp ;
     	AND IT.CODIGO = GR.CODIGO ;
     	AND IT.TIPO <> "QLA" ;
     	AND IT.MOVESTQ = "S" ;
     	AND LEFT(IT.OPERACAO,1) = "E";
        AND YEAR(IT.DATA) = 2013;
    ORDER BY GR.CODIGO;
    GROUP BY GR.CODIGO;
   	INTO TABLE  X:\TMP\ENT_2013


    CLOSE DATA

	*-------------------------------------------------------------------*

	SELECT 	;  
			PrmEmp           AS EMPRESA,;
			GR.CODIGO        AS COD_ITEM,;	        
			;
			SUM(LNzera)      AS SLD_2011,;
			SUM(LNzera)      AS SLD_2012,;
			SUM(LNzera)      AS SLD_2013,;
			SUM(LNzera)      AS SLD_2014,;
			;
			SUM(LNzera)      AS ENT_2012,;
			SUM(LNzera)      AS ENT_2013,;
			SUM(IT.QTDE)     AS ENT_2014,;
			;
			SUM(LNzera)      AS SAI_2012,;
			SUM(LNzera)      AS SAI_2013,;
			SUM(LNzera)      AS SAI_2014,;
			;
			SUM(LNzera)      AS CMP_2012,;
			SUM(LNzera)      AS CMP_2013,;
			SUM(LNzera)      AS CMP_2014,;
			;
			SUM(LNzera)      AS QLA_2012,;
			SUM(LNzera)      AS QLA_2013,;
			SUM(LNzera)      AS QLA_2014,;
			;
			SUM(LNzera)      AS SCA_2012,;
			SUM(LNzera)      AS SCA_2013,;
			SUM(LNzera)      AS SCA_2014;
    FROM Q:\SCGC\COMUM\GRUPO GR,;
         X:\TMP\MOV_TMP IT;
    WHERE ;
        	gr.cdg_tipo = 4;
        AND (gr.tp_control = 1 or gr.tp_control = 4);
        AND STRTRAN(STR(PrmEmp,3),' ','0') $ gr.empresas ;
        AND IT.EMPRESA = PrmEmp ;
     	AND IT.CODIGO = GR.CODIGO ;
     	AND IT.TIPO <> "QLA" ;
     	AND IT.MOVESTQ = "S" ;
     	AND LEFT(IT.OPERACAO,1) = "E";
        AND YEAR(IT.DATA) = 2014;
        AND MONTH(IT.DATA) < 10 ;
    ORDER BY GR.CODIGO;
    GROUP BY GR.CODIGO;
   	INTO TABLE  X:\TMP\ENT_2014
    


    CLOSE DATA
   	USE  X:\TMP\ENT_2012
    COPY TO X:\TMP\ENTRADAS

    CLOSE DATA

    USE X:\TMP\ENTRADAS

   	APPEND FROM X:\TMP\ENT_2013
   	APPEND FROM X:\TMP\ENT_2014
   	
   	CLOSE DATA



*---------------------------------------------------------------------*

	
RETURN


FUNCTION IV_SAIDAS
PARAMETERS PrmEmp,PrmDtFim

	*-------------------------------------------------------------------*
	*-------------------------------------------------------------------*
	SELECT 	;  
			PrmEmp           AS EMPRESA,;
			GR.CODIGO        AS COD_ITEM,;	        
			;
			SUM(LNzera)      AS SLD_2011,;
			SUM(LNzera)      AS SLD_2012,;
			SUM(LNzera)      AS SLD_2013,;
			SUM(LNzera)      AS SLD_2014,;
			;
			SUM(LNzera)      AS ENT_2012,;
			SUM(LNzera)      AS ENT_2013,;
			SUM(LNzera)      AS ENT_2014,;
			;
			SUM(LNzera)      AS SAI_2012,;
			SUM(IT.QTDE)     AS SAI_2013,;
			SUM(LNzera)      AS SAI_2014,;
			;
			SUM(LNzera)      AS CMP_2012,;
			SUM(LNzera)      AS CMP_2013,;
			SUM(LNzera)      AS CMP_2014,;
			;
			SUM(LNzera)      AS QLA_2012,;
			SUM(LNzera)      AS QLA_2013,;
			SUM(LNzera)      AS QLA_2014,;
			;
			SUM(LNzera)      AS SCA_2012,;
			SUM(LNzera)      AS SCA_2013,;
			SUM(LNzera)      AS SCA_2014;
    FROM Q:\SCGC\COMUM\GRUPO GR,;
         X:\TMP\MOV_TMP IT;
    WHERE ;
        	gr.cdg_tipo = 4;
        AND (gr.tp_control = 1 or gr.tp_control = 4);
        AND STRTRAN(STR(PrmEmp,3),' ','0') $ gr.empresas ;
        AND IT.EMPRESA = PrmEmp ;
     	AND IT.CODIGO = GR.CODIGO ;
     	AND IT.TIPO <> "SCA" ;
     	AND IT.MOVESTQ = "S" ;
     	AND LEFT(IT.OPERACAO,1) = "S";
        AND YEAR(IT.DATA) = 2012;
    ORDER BY GR.CODIGO;
    GROUP BY GR.CODIGO;
   	INTO TABLE  \TMP\SAI_2012

    CLOSE DATA
	*-------------------------------------------------------------------*
	SELECT 	;  
			PrmEmp           AS EMPRESA,;
			GR.CODIGO        AS COD_ITEM,;	        
			;
			SUM(LNzera)      AS SLD_2011,;
			SUM(LNzera)      AS SLD_2012,;
			SUM(LNzera)      AS SLD_2013,;
			SUM(LNzera)      AS SLD_2014,;
			;
			SUM(LNzera)      AS ENT_2012,;
			SUM(LNzera)      AS ENT_2013,;
			SUM(LNzera)      AS ENT_2014,;
			;
			SUM(LNzera)      AS SAI_2012,;
			SUM(IT.QTDE)     AS SAI_2013,;
			SUM(LNzera)      AS SAI_2014,;
			;
			SUM(LNzera)      AS CMP_2012,;
			SUM(LNzera)      AS CMP_2013,;
			SUM(LNzera)      AS CMP_2014,;
			;
			SUM(LNzera)      AS QLA_2012,;
			SUM(LNzera)      AS QLA_2013,;
			SUM(LNzera)      AS QLA_2014,;
			;
			SUM(LNzera)      AS SCA_2012,;
			SUM(LNzera)      AS SCA_2013,;
			SUM(LNzera)      AS SCA_2014;
    FROM Q:\SCGC\COMUM\GRUPO GR,;
         X:\TMP\MOV_TMP IT;
    WHERE ;
        	gr.cdg_tipo = 4;
        AND (gr.tp_control = 1 or gr.tp_control = 4);
        AND STRTRAN(STR(PrmEmp,3),' ','0') $ gr.empresas ;
        AND IT.EMPRESA = PrmEmp ;
     	AND IT.CODIGO = GR.CODIGO ;
     	AND IT.TIPO <> "SCA" ;
     	AND IT.MOVESTQ = "S" ;
     	AND LEFT(IT.OPERACAO,1) = "S";
        AND YEAR(IT.DATA) = 2013;
    ORDER BY GR.CODIGO;
    GROUP BY GR.CODIGO;
   	INTO TABLE  \TMP\SAI_2013

    CLOSE DATA
    

	SELECT 	;  
			PrmEmp           AS EMPRESA,;
			GR.CODIGO        AS COD_ITEM,;	        
			;
			SUM(LNzera)      AS SLD_2011,;
			SUM(LNzera)      AS SLD_2012,;
			SUM(LNzera)      AS SLD_2013,;
			SUM(LNzera)      AS SLD_2014,;
			;
			SUM(LNzera)      AS ENT_2012,;
			SUM(LNzera)      AS ENT_2013,;
			SUM(LNzera)      AS ENT_2014,;
			;
			SUM(LNzera)      AS SAI_2012,;
			SUM(LNzera)      AS SAI_2013,;
			SUM(IT.QTDE)     AS SAI_2014,;
			;
			SUM(LNzera)      AS CMP_2012,;
			SUM(LNzera)      AS CMP_2013,;
			SUM(LNzera)      AS CMP_2014,;
			;
			SUM(LNzera)      AS QLA_2012,;
			SUM(LNzera)      AS QLA_2013,;
			SUM(LNzera)      AS QLA_2014,;
			;
			SUM(LNzera)      AS SCA_2012,;
			SUM(LNzera)      AS SCA_2013,;
			SUM(LNzera)      AS SCA_2014;
    FROM Q:\SCGC\COMUM\GRUPO GR,;
         X:\TMP\MOV_TMP IT;
    WHERE ;
        	gr.cdg_tipo = 4;
        AND (gr.tp_control = 1 or gr.tp_control = 4);
        AND STRTRAN(STR(PrmEmp,3),' ','0') $ gr.empresas ;
        AND IT.EMPRESA = PrmEmp ;
     	AND IT.CODIGO = GR.CODIGO ;
     	AND IT.TIPO <> "SCA" ;
     	AND IT.MOVESTQ = "S" ;
     	AND LEFT(IT.OPERACAO,1) = "S";
        AND YEAR(IT.DATA) = 2014;
        AND MONTH(IT.DATA) < 10 ;
    ORDER BY GR.CODIGO;
    GROUP BY GR.CODIGO;
   	INTO TABLE  \TMP\SAI_2014



*---------------------------------------------------------------------*

    CLOSE DATA
   	USE  X:\TMP\SAI_2012
    COPY TO X:\TMP\SAIDAS

    CLOSE DATA

    USE X:\TMP\SAIDAS

   	APPEND FROM X:\TMP\SAI_2013
   	APPEND FROM X:\TMP\SAI_2014
   	
   	CLOSE DATA



*---------------------------------------------------------------------*

	
RETURN





FUNCTION IV_COMPLE
PARAMETERS PrmEmp,PrmDtFim

	*-------------------------------------------------------------------*
	SELECT 	;
			PrmEmp           AS EMPRESA,;
			GR.CODIGO        AS COD_ITEM,;	        
			;
			SUM(LNzera)      AS SLD_2011,;
			SUM(LNzera)      AS SLD_2012,;
			SUM(LNzera)      AS SLD_2013,;
			SUM(LNzera)      AS SLD_2014,;
			;
			SUM(LNzera)      AS ENT_2012,;
			SUM(LNzera)      AS ENT_2013,;
			SUM(LNzera)      AS ENT_2014,;
			;
			SUM(LNzera)      AS SAI_2012,;
			SUM(LNzera)      AS SAI_2013,;
			SUM(LNzera)      AS SAI_2014,;
			;
			SUM(IT.QTDE)     AS CMP_2012,;
			SUM(LNzera)      AS CMP_2013,;
			SUM(LNzera)      AS CMP_2014,;
			;
			SUM(LNzera)      AS QLA_2012,;
			SUM(LNzera)      AS QLA_2013,;
			SUM(LNzera)      AS QLA_2014,;
			;
			SUM(LNzera)      AS SCA_2012,;
			SUM(LNzera)      AS SCA_2013,;
			SUM(LNzera)      AS SCA_2014;
    FROM Q:\SCGC\COMUM\GRUPO GR,;
         X:\TMP\MOV_TMP IT;
    WHERE ;
        	gr.cdg_tipo = 4;
        AND (gr.tp_control = 1 or gr.tp_control = 4);
        AND STRTRAN(STR(PrmEmp,3),' ','0') $ gr.empresas ;
        AND IT.EMPRESA = PrmEmp ;
     	AND IT.CODIGO = GR.CODIGO ;
     	AND IT.TIPO $ "VFN/VFO/VFP/VLG/VLH/VLI/VLJ" ;
        AND YEAR(IT.DATA) = 2012;
    ORDER BY GR.CODIGO;
    GROUP BY GR.CODIGO;
   	INTO TABLE  X:\TMP\COM_2012

    CLOSE DATA
	*-------------------------------------------------------------------*
	SELECT 	;
			PrmEmp           AS EMPRESA,;
			GR.CODIGO        AS COD_ITEM,;	        
			;
			SUM(LNzera)      AS SLD_2011,;
			SUM(LNzera)      AS SLD_2012,;
			SUM(LNzera)      AS SLD_2013,;
			SUM(LNzera)      AS SLD_2014,;
			;
			SUM(LNzera)      AS ENT_2012,;
			SUM(LNzera)      AS ENT_2013,;
			SUM(LNzera)      AS ENT_2014,;
			;
			SUM(LNzera)      AS SAI_2012,;
			SUM(LNzera)      AS SAI_2013,;
			SUM(LNzera)      AS SAI_2014,;
			;
			SUM(LNzera)      AS CMP_2012,;
			SUM(IT.QTDE)     AS CMP_2013,;
			SUM(LNzera)      AS CMP_2014,;
			;
			SUM(LNzera)      AS QLA_2012,;
			SUM(LNzera)      AS QLA_2013,;
			SUM(LNzera)      AS QLA_2014,;
			;
			SUM(LNzera)      AS SCA_2012,;
			SUM(LNzera)      AS SCA_2013,;
			SUM(LNzera)      AS SCA_2014;
    FROM Q:\SCGC\COMUM\GRUPO GR,;
         X:\TMP\MOV_TMP IT;
    WHERE ;
        	gr.cdg_tipo = 4;
        AND (gr.tp_control = 1 or gr.tp_control = 4);
        AND STRTRAN(STR(PrmEmp,3),' ','0') $ gr.empresas ;
        AND IT.EMPRESA = PrmEmp ;
     	AND IT.CODIGO = GR.CODIGO ;
     	AND IT.TIPO $ "VFN/VFO/VFP/VLG/VLH/VLI/VLJ" ;
        AND YEAR(IT.DATA) = 2013;
    ORDER BY GR.CODIGO;
    GROUP BY GR.CODIGO;
   	INTO TABLE  X:\TMP\COM_2013

    CLOSE DATA

	SELECT 	;
			PrmEmp           AS EMPRESA,;
			GR.CODIGO        AS COD_ITEM,;	        
			;
			SUM(LNzera)      AS SLD_2011,;
			SUM(LNzera)      AS SLD_2012,;
			SUM(LNzera)      AS SLD_2013,;
			SUM(LNzera)      AS SLD_2014,;
			;
			SUM(LNzera)      AS ENT_2012,;
			SUM(LNzera)      AS ENT_2013,;
			SUM(LNzera)      AS ENT_2014,;
			;
			SUM(LNzera)      AS SAI_2012,;
			SUM(LNzera)      AS SAI_2013,;
			SUM(LNzera)      AS SAI_2014,;
			;
			SUM(LNzera)      AS CMP_2012,;
			SUM(LNzera)      AS CMP_2013,;
			SUM(IT.QTDE)     AS CMP_2014,;
			;
			SUM(LNzera)      AS QLA_2012,;
			SUM(LNzera)      AS QLA_2013,;
			SUM(LNzera)      AS QLA_2014,;
			;
			SUM(LNzera)      AS SCA_2012,;
			SUM(LNzera)      AS SCA_2013,;
			SUM(LNzera)      AS SCA_2014;
    FROM Q:\SCGC\COMUM\GRUPO GR,;
         X:\TMP\MOV_TMP IT;
    WHERE ;
        	gr.cdg_tipo = 4;
        AND (gr.tp_control = 1 or gr.tp_control = 4);
        AND STRTRAN(STR(PrmEmp,3),' ','0') $ gr.empresas ;
        AND IT.EMPRESA = PrmEmp ;
     	AND IT.CODIGO = GR.CODIGO ;
     	AND IT.TIPO $ "VFN/VFO/VFP/VLG/VLH/VLI/VLJ" ;
        AND YEAR(IT.DATA) = 2014;
        AND MONTH(IT.DATA) < 10 ;
    ORDER BY GR.CODIGO;
    GROUP BY GR.CODIGO;
   	INTO TABLE  X:\TMP\COM_2014




*---------------------------------------------------------------------*

    CLOSE DATA
   	USE  X:\TMP\COM_2012
    COPY TO X:\TMP\COMPLE

    CLOSE DATA

    USE X:\TMP\COMPLE

   	APPEND FROM X:\TMP\COM_2013
   	APPEND FROM X:\TMP\COM_2014
   	
   	CLOSE DATA



*---------------------------------------------------------------------*

	
RETURN


FUNCTION IV_QLA
PARAMETERS PrmEmp,PrmDtFim

	*-------------------------------------------------------------------*
	SELECT 	;
			PrmEmp           AS EMPRESA,;
			GR.CODIGO        AS COD_ITEM,;	        
			;
			SUM(LNzera)      AS SLD_2011,;
			SUM(LNzera)      AS SLD_2012,;
			SUM(LNzera)      AS SLD_2013,;
			SUM(LNzera)      AS SLD_2014,;
			;
			SUM(LNzera)      AS ENT_2012,;
			SUM(LNzera)      AS ENT_2013,;
			SUM(LNzera)      AS ENT_2014,;
			;
			SUM(LNzera)      AS SAI_2012,;
			SUM(LNzera)      AS SAI_2013,;
			SUM(LNzera)      AS SAI_2014,;
			;
			SUM(LNzera)      AS CMP_2012,;
			SUM(LNzera)      AS CMP_2013,;
			SUM(LNzera)      AS CMP_2014,;
			;
			SUM(IT.QTDE)     AS QLA_2012,;
			SUM(LNzera)      AS QLA_2013,;
			SUM(LNzera)      AS QLA_2014,;
			;
			SUM(LNzera)      AS SCA_2012,;
			SUM(LNzera)      AS SCA_2013,;
			SUM(LNzera)      AS SCA_2014;
    FROM Q:\SCGC\COMUM\GRUPO GR,;
         X:\TMP\MOV_TMP IT;
    WHERE ;
        	gr.cdg_tipo = 4;
        AND (gr.tp_control = 1 or gr.tp_control = 4);
        AND STRTRAN(STR(PrmEmp,3),' ','0') $ gr.empresas ;
        AND IT.EMPRESA = PrmEmp ;
     	AND IT.CODIGO = GR.CODIGO ;
     	AND IT.TIPO $ "QLA" ;
        AND YEAR(IT.DATA) = 2012;
    ORDER BY GR.CODIGO;
    GROUP BY GR.CODIGO;
   	INTO TABLE  X:\TMP\QLA_2012

    CLOSE DATA
*----------------------------------------------------------------------*
	*-------------------------------------------------------------------*
	SELECT 	;
			PrmEmp           AS EMPRESA,;
			GR.CODIGO        AS COD_ITEM,;	        
			;
			SUM(LNzera)      AS SLD_2011,;
			SUM(LNzera)      AS SLD_2012,;
			SUM(LNzera)      AS SLD_2013,;
			SUM(LNzera)      AS SLD_2014,;
			;
			SUM(LNzera)      AS ENT_2012,;
			SUM(LNzera)      AS ENT_2013,;
			SUM(LNzera)      AS ENT_2014,;
			;
			SUM(LNzera)      AS SAI_2012,;
			SUM(LNzera)      AS SAI_2013,;
			SUM(LNzera)      AS SAI_2014,;
			;
			SUM(LNzera)      AS CMP_2012,;
			SUM(LNzera)      AS CMP_2013,;
			SUM(LNzera)      AS CMP_2014,;
			;
			SUM(LNzera)      AS QLA_2012,;
			SUM(IT.QTDE)     AS QLA_2013,;
			SUM(LNzera)      AS QLA_2014,;
			;
			SUM(LNzera)      AS SCA_2012,;
			SUM(LNzera)      AS SCA_2013,;
			SUM(LNzera)      AS SCA_2014;
    FROM Q:\SCGC\COMUM\GRUPO GR,;
         X:\TMP\MOV_TMP IT;
    WHERE ;
        	gr.cdg_tipo = 4;
        AND (gr.tp_control = 1 or gr.tp_control = 4);
        AND STRTRAN(STR(PrmEmp,3),' ','0') $ gr.empresas ;
        AND IT.EMPRESA = PrmEmp ;
     	AND IT.CODIGO = GR.CODIGO ;
     	AND IT.TIPO $ "QLA" ;
        AND YEAR(IT.DATA) = 2013;
    ORDER BY GR.CODIGO;
    GROUP BY GR.CODIGO;
   	INTO TABLE  X:\TMP\QLA_2013

    CLOSE DATA
*----------------------------------------------------------------------*

	SELECT 	;
			PrmEmp           AS EMPRESA,;
			GR.CODIGO        AS COD_ITEM,;	        
			;
			;
			SUM(LNzera)      AS SLD_2011,;
			SUM(LNzera)      AS SLD_2012,;
			SUM(LNzera)      AS SLD_2013,;
			SUM(LNzera)      AS SLD_2014,;
			;
			SUM(LNzera)      AS ENT_2012,;
			SUM(LNzera)      AS ENT_2013,;
			SUM(LNzera)      AS ENT_2014,;
			;
			SUM(LNzera)      AS SAI_2012,;
			SUM(LNzera)      AS SAI_2013,;
			SUM(LNzera)      AS SAI_2014,;
			;
			SUM(LNzera)      AS CMP_2012,;
			SUM(LNzera)      AS CMP_2013,;
			SUM(LNzera)      AS CMP_2014,;
			;
			SUM(LNzera)      AS QLA_2012,;
			SUM(LNzera)     AS QLA_2013,;
			SUM(IT.QTDE)      AS QLA_2014,;
			;
			SUM(LNzera)      AS SCA_2012,;
			SUM(LNzera)      AS SCA_2013,;
			SUM(LNzera)      AS SCA_2014;
    FROM Q:\SCGC\COMUM\GRUPO GR,;
         X:\TMP\MOV_TMP IT;
    WHERE ;
        	gr.cdg_tipo = 4;
        AND (gr.tp_control = 1 or gr.tp_control = 4);
        AND STRTRAN(STR(PrmEmp,3),' ','0') $ gr.empresas ;
        AND IT.EMPRESA = PrmEmp ;
     	AND IT.CODIGO = GR.CODIGO ;
     	AND IT.TIPO $ "QLA" ;
        AND YEAR(IT.DATA) = 2014;
        AND MONTH(IT.DATA) < 10 ;
    ORDER BY GR.CODIGO;
    GROUP BY GR.CODIGO;
   	INTO TABLE  X:\TMP\QLA_2014




*---------------------------------------------------------------------*

    CLOSE DATA
   	USE  X:\TMP\QLA_2012
    COPY TO X:\TMP\QLA

    CLOSE DATA

    USE X:\TMP\QLA

   	APPEND FROM X:\TMP\QLA_2013
   	APPEND FROM X:\TMP\QLA_2014
   	
   	CLOSE DATA



*---------------------------------------------------------------------*

	
RETURN





FUNCTION IV_SCA
PARAMETERS PrmEmp,PrmDtFim

	*-------------------------------------------------------------------*
	SELECT 	;
			PrmEmp           AS EMPRESA,;
			GR.CODIGO        AS COD_ITEM,;	        
			;
			;
			SUM(LNzera)      AS SLD_2011,;
			SUM(LNzera)      AS SLD_2012,;
			SUM(LNzera)      AS SLD_2013,;
			SUM(LNzera)      AS SLD_2014,;
			;
			SUM(LNzera)      AS ENT_2012,;
			SUM(LNzera)      AS ENT_2013,;
			SUM(LNzera)      AS ENT_2014,;
			;
			SUM(LNzera)      AS SAI_2012,;
			SUM(LNzera)      AS SAI_2013,;
			SUM(LNzera)      AS SAI_2014,;
			;
			SUM(LNzera)      AS CMP_2012,;
			SUM(LNzera)      AS CMP_2013,;
			SUM(LNzera)      AS CMP_2014,;
			;
			SUM(LNzera)      AS QLA_2012,;
			SUM(LNzera)      AS QLA_2013,;
			SUM(IT.QTDE)     AS QLA_2014,;
			;
			SUM(IT.QTDE)     AS SCA_2012,;
			SUM(LNzera)      AS SCA_2013,;
			SUM(LNzera)      AS SCA_2014;
    FROM Q:\SCGC\COMUM\GRUPO GR,;
         X:\TMP\MOV_TMP IT;
    WHERE ;
        	gr.cdg_tipo = 4;
        AND (gr.tp_control = 1 or gr.tp_control = 4);
        AND STRTRAN(STR(PrmEmp,3),' ','0') $ gr.empresas ;
        AND IT.EMPRESA = PrmEmp ;
     	AND IT.CODIGO = GR.CODIGO ;
     	AND IT.TIPO $ "SCA" ;
        AND YEAR(IT.DATA) = 2012;
    ORDER BY GR.CODIGO;
    GROUP BY GR.CODIGO;
   	INTO TABLE  X:\TMP\SCA_2012

    CLOSE DATA
	*-------------------------------------------------------------------*
	SELECT 	;
			PrmEmp           AS EMPRESA,;
			GR.CODIGO        AS COD_ITEM,;	        
			;
			;
			SUM(LNzera)      AS SLD_2011,;
			SUM(LNzera)      AS SLD_2012,;
			SUM(LNzera)      AS SLD_2013,;
			SUM(LNzera)      AS SLD_2014,;
			;
			SUM(LNzera)      AS ENT_2012,;
			SUM(LNzera)      AS ENT_2013,;
			SUM(LNzera)      AS ENT_2014,;
			;
			SUM(LNzera)      AS SAI_2012,;
			SUM(LNzera)      AS SAI_2013,;
			SUM(LNzera)      AS SAI_2014,;
			;
			SUM(LNzera)      AS CMP_2012,;
			SUM(LNzera)      AS CMP_2013,;
			SUM(LNzera)      AS CMP_2014,;
			;
			SUM(LNzera)      AS QLA_2012,;
			SUM(LNzera)     AS QLA_2013,;
			SUM(IT.QTDE)      AS QLA_2014,;
			;
			SUM(LNzera)      AS SCA_2012,;
			SUM(IT.QTDE)      AS SCA_2013,;
			SUM(LNzera)      AS SCA_2014;
    FROM Q:\SCGC\COMUM\GRUPO GR,;
         X:\TMP\MOV_TMP IT;
    WHERE ;
        	gr.cdg_tipo = 4;
        AND (gr.tp_control = 1 or gr.tp_control = 4);
        AND STRTRAN(STR(PrmEmp,3),' ','0') $ gr.empresas ;
        AND IT.EMPRESA = PrmEmp ;
     	AND IT.CODIGO = GR.CODIGO ;
     	AND IT.TIPO $ "SCA" ;
        AND YEAR(IT.DATA) = 2013;
    ORDER BY GR.CODIGO;
    GROUP BY GR.CODIGO;
   	INTO TABLE  X:\TMP\SCA_2013

    CLOSE DATA
*----------------------------------------------------------------*
	SELECT 	;
			PrmEmp           AS EMPRESA,;
			GR.CODIGO        AS COD_ITEM,;	        
			;
			SUM(LNzera)      AS SLD_2011,;
			SUM(LNzera)      AS SLD_2012,;
			SUM(LNzera)      AS SLD_2013,;
			SUM(LNzera)      AS SLD_2014,;
			;
			SUM(LNzera)      AS ENT_2012,;
			SUM(LNzera)      AS ENT_2013,;
			SUM(LNzera)      AS ENT_2014,;
			;
			SUM(LNzera)      AS SAI_2012,;
			SUM(LNzera)      AS SAI_2013,;
			SUM(LNzera)      AS SAI_2014,;
			;
			SUM(LNzera)      AS CMP_2012,;
			SUM(LNzera)      AS CMP_2013,;
			SUM(LNzera)      AS CMP_2014,;
			;
			SUM(LNzera)      AS QLA_2012,;
			SUM(LNzera)     AS QLA_2013,;
			SUM(IT.QTDE)      AS QLA_2014,;
			;
			SUM(LNzera)      AS SCA_2012,;
			SUM(LNzera)      AS SCA_2013,;
			SUM(IT.QTDE)      AS SCA_2014;
    FROM Q:\SCGC\COMUM\GRUPO GR,;
         X:\TMP\MOV_TMP IT;
    WHERE ;
        	gr.cdg_tipo = 4;
        AND (gr.tp_control = 1 or gr.tp_control = 4);
        AND STRTRAN(STR(PrmEmp,3),' ','0') $ gr.empresas ;
        AND IT.EMPRESA = PrmEmp ;
     	AND IT.CODIGO = GR.CODIGO ;
     	AND IT.TIPO $ "SCA" ;
        AND YEAR(IT.DATA) = 2014;
        AND MONTH(IT.DATA) < 10 ;
    ORDER BY GR.CODIGO;
    GROUP BY GR.CODIGO;
   	INTO TABLE  X:\TMP\SCA_2014




*---------------------------------------------------------------------*

    CLOSE DATA
   	USE  X:\TMP\SCA_2012
    COPY TO X:\TMP\SCA

    CLOSE DATA

    USE X:\TMP\SCA

   	APPEND FROM X:\TMP\SCA_2013
   	APPEND FROM X:\TMP\SCA_2014
   	
   	CLOSE DATA



*---------------------------------------------------------------------*

	
RETURN



FUNCTION IV_Union

	*-------------------------------------------------------------------*
	*-------------------------------------------------------------------*



	SELECT  	;
	  * ;
      FROM X:\TMP\TMPLIST ;
    UNION ;
	SELECT  	;
	  * ;
      FROM X:\TMP\SLD_ANTE ;
    UNION ;
	SELECT  	;
	  * ;
      FROM X:\TMP\ENTRADAS ;
    UNION ;
	SELECT  	;
	  * ;
      FROM X:\TMP\SAIDAS ;
    UNION ;
	SELECT  	;
	  * ;
      FROM X:\TMP\COMPLE ;
    UNION ;
	SELECT  	;
	  * ;
      FROM X:\TMP\QLA ;
    UNION ;
	SELECT  	;
	  * ;
      FROM X:\TMP\SCA ;
   	INTO TABLE  X:\TMP\TMPINVT

*---------------------------------------------------------------------*

	
RETURN



FUNCTION IV_SomaInvt
	SELECT  	;
		EMPRESA           AS EMPRESA,;
		COD_ITEM        AS COD_ITEM,;	        
		;
		SUM(SLD_2011)      AS SLD_2011,;
		SUM(SLD_2012)      AS SLD_2012,;
		SUM(SLD_2013)      AS SLD_2013,;
		SUM(SLD_2014)      AS SLD_2014,;
		;
		SUM(ENT_2012)      AS ENT_2012,;
		SUM(ENT_2013)      AS ENT_2013,;
		SUM(ENT_2014)      AS ENT_2014,;
		;
		SUM(SAI_2012)      AS SAI_2012,;
		SUM(SAI_2013)      AS SAI_2013,;
		SUM(SAI_2014)      AS SAI_2014,;
		;
		SUM(CMP_2012)      AS CMP_2012,;
		SUM(CMP_2013)      AS CMP_2013,;
		SUM(CMP_2014)      AS CMP_2014,;
		;
		SUM(QLA_2012)      AS QLA_2012,;
		SUM(QLA_2013)      AS QLA_2013,;
		SUM(QLA_2014)      AS QLA_2014,;
		;
		SUM(SCA_2012)      AS SCA_2012,;
		SUM(SCA_2013)      AS SCA_2013,;
		SUM(SCA_2014)      AS SCA_2014;
    FROM TMPINVT ;
    GROUP BY ;
	  EMPRESA, ;
	  COD_ITEM;
   	INTO TABLE  X:\TMP\TMPINVT2

	*---------------------------------------------------------------------*

	
RETURN



FUNCTION IV_InvtFinal
PARAMETERS PrmEmp,PrmDtFim
	SELECT  	;
	  INV.EMPRESA, ;
	  EMP.SIGLA,;
	  prdt.classifica,;
	  INV.COD_ITEM           AS CODIGO,;
	  PRDT.DESCRICAO,;
		;
		SLD_2011,;
		;
		ENT_2012,;
		SAI_2012,;
		CMP_2012,;
        (SLD_2011 + ENT_2012 - SAI_2012 - CMP_2012) AS FISC_2012,;
		SLD_2012                                    AS REAL_2012,;
		;
		ENT_2013,;
		SAI_2013,;
		CMP_2013,;
        (SLD_2011 + ENT_2012 - SAI_2012 - CMP_2012 ; 
                  + ENT_2013 - SAI_2013 - CMP_2013) AS FSC_12A13,;
        (SLD_2012 + ENT_2013 - SAI_2013 - CMP_2013) AS FISC_2013,;
		SLD_2013                                    AS REAL_2013,;
		ENT_2014,;
		SAI_2014,;
		CMP_2014,;
        (SLD_2011 + ENT_2012 - SAI_2012 - CMP_2012 ; 
                  + ENT_2013 - SAI_2013 - CMP_2013 ;
                  + ENT_2014 - SAI_2014 - CMP_2014) AS FSC_12A14,;
        (SLD_2012 + ENT_2013 - SAI_2013 - CMP_2013 ;
                  + ENT_2014 - SAI_2014 - CMP_2014) AS FISC_2014,;
		SLD_2014                                    AS REAL_2014,;
       ;
		QLA_2012,;
		QLA_2013,;
		QLA_2014,;
      ;
		SCA_2012,;
		SCA_2013,;
		SCA_2014;
    FROM TMPINVT2 INV ,;
         Q:\SCGC\COMUM\GRUPO PRDT,;
         Q:\SCGC\CENTRAL\EMPRESA EMP ;
    WHERE PRDT.CODIGO = INV.COD_ITEM ;
        AND EMP.EMPRESA = PrmEMP ;
   	INTO TABLE  X:\TMP\TMPINVT3


*---------------------------------------------------------------------*

	
RETURN


