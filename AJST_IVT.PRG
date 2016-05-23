SET DATE GERMAN
SET CENTU ON
SET DELE ON
SET EXCL OFF





 SET STEP ON

IF 1 = 2


	 =ULInt_tmp(1)   && GYN
	
	 SELE TMPINVT3 
	 SET STEP ON
	 COPY TO X:\SUPORTE\INVT2013\INVT_GYN

	 SELE TMPRESUM 
	 SET STEP ON
	 COPY TO X:\SUPORTE\INVT2013\RESM_GYN

ENDIF

 CLOSE DATA

 
*--------------------------------------------------------* 
 
IF 1 = 2
	 =ULInt_tmp(5)   && IPG
	 SELE TMPINVT3 
	 SET STEP ON

	 COPY TO X:\SUPORTE\INVT2013\INVT_IPG

	 SELE TMPRESUM 
	 COPY TO X:\SUPORTE\INVT2013\RESM_IPG

ENDIF


 CLOSE DATA

*--------------------------------------------------------* 
 
  
IF 1 = 2

	 =ULInt_tmp(7)   && IPG
	 SELE TMPINVT3 
	 SET STEP ON
	 COPY TO X:\SUPORTE\INVT2013\INVT_T63
	 SELE TMPRESUM 
	 COPY TO X:\SUPORTE\INVT2013\RESM_T63
ENDIF

 CLOSE DATA
*--------------------------------------------------------* 

IF 1 = 2

	 =ULInt_tmp(9)   && IDP/RIO
	 SELE TMPINVT3 
	 SET STEP ON
	 COPY TO X:\SUPORTE\INVT2013\INVT_RIO
	 SELE TMPRESUM 
	 COPY TO X:\SUPORTE\INVT2013\RESM_RIO

ENDIF

 CLOSE DATA
*--------------------------------------------------------* 

IF 1 = 2

	 =ULInt_tmp(11)   && DPO
	 SELE TMPINVT3 
	 SET STEP ON
	 COPY TO X:\SUPORTE\INVT2013\INVT_DPO
	 SELE TMPRESUM 
	 COPY TO X:\SUPORTE\INVT2013\RESM_DPO
ENDIF

 CLOSE DATA
*--------------------------------------------------------* 

IF 1 = 1

	 =ULInt_tmp(14)   && IPG
	 SELE TMPINVT3 
	 SET STEP ON
	 COPY TO X:\SUPORTE\INVT2013\INVT_ANP
	 SELE TMPRESUM 
	 COPY TO X:\SUPORTE\INVT2013\RESM_ANP
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


 IF FILE("\TMP\QLA.DBF")
    DELETE FILE "\TMP\QLA.DBF"
 ENDIF 


 IF FILE("\TMP\SCA.DBF")
    DELETE FILE "\TMP\SCA.DBF"
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


 IF FILE("\TMP\SLD_ATU.DBF")
    DELETE FILE "\TMP\SLD_ATU.DBF"
 ENDIF 


 IF FILE("\TMP\COMPLE.DBF")
    DELETE FILE "\TMP\COMPLE.DBF"
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



 

** =IV_TMPMOV(LNemp,LDdataInventario)  && FILTRA ITEMMOV


 *==================================*


 =IV_SLDANT(LNemp,LDdataInventario)


 *==================================*


 =IV_ENTRADAS(LNemp,LDdataInventario)


 =IV_SAIDAS(LNemp,LDdataInventario)


 *==================================*


 =IV_SLDATU(LNemp,LDdataInventario)


 =IV_QLA(LNemp,LDdataInventario)

 =IV_SCA(LNemp,LDdataInventario)


 =IV_COMPLE(LNemp,LDdataInventario)

 *==================================*

 =IV_Union()

 *==================================*
 
 =IV_SomaInvt()
 
 =IV_InvtFinal(LNemp,LDdataInventario)
 

 =IV_InvtResumido(LNemp,LDdataInventario)


**  =IV_NvLvrInvt(LNemp,LDdataInventario)


return


FUNCTION IV_TMPMOV
PARAMETERS PrmEmp,PrmDtFim

	*-------------------------------------------------------------------*

	SELECT 	;  
           IT.EMPRESA,;
           IT.CODIGO,;
           IT.QTDE,;
           IT.TIPO,;
           IT.OPERACAO,;
           IT.DATA,;
           IT.MOVESTQ;
    FROM O:\SCGC2013\CENTRAL\GRUPO GR,;
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
    FROM Q:\SCGC\CENTRAL\GRUPO GR,;
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
	APPEND FROM X:\TMP\MOV_13
	APPEND FROM X:\TMP\MOV_14
	

    CLOSE DATA


	*---------------------------------------------------------------------*

	
RETURN





FUNCTION IV_SldANT
PARAMETERS PrmEmp,PrmDtFim

	*-------------------------------------------------------------------*
	SELECT 	;
			PrmEmp           AS EMPRESA,;
			GR.CODIGO        AS COD_ITEM,;	        
		    SUM(SL.VLR_ATU)  AS VL_ITEM,;
			SUM(SL.SLD_ANTE) AS SLD_ANTE,;
			SUM(LNzera)      AS ENTRADAS,;
			SUM(LNzera)      AS SAIDAS,;
			SUM(LNzera)      AS SLD_ATU,;
			SUM(LNzera)      AS QLA,;
			SUM(LNzera)      AS SCA,;
			SUM(LNzera)      AS COMPLE;
    FROM O:\SCGC2013\CENTRAL\GRUPO GR,;
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
   	INTO TABLE  X:\TMP\SLD_ANTE

*---------------------------------------------------------------------*
	GO TOP

	
RETURN








FUNCTION IV_ENTRADAS
PARAMETERS PrmEmp,PrmDtFim

	*-------------------------------------------------------------------*
	*-------------------------------------------------------------------*
	SELECT 	;  
			PrmEmp           AS EMPRESA,;
			GR.CODIGO        AS COD_ITEM,;	        
		    SUM(LNzera)      AS VL_ITEM,;
			SUM(LNzera)      AS SLD_ANTE,;
			SUM(IT.QTDE)     AS ENTRADAS,;
			SUM(LNzera)      AS SAIDAS,;
			SUM(LNzera)      AS SLD_ATU,;
			SUM(LNzera)      AS QLA,;
			SUM(LNzera)      AS SCA,;
			SUM(LNzera)      AS COMPLE;
    FROM Q:\SCGC\CENTRAL\GRUPO GR,;
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
    ORDER BY GR.CODIGO;
    GROUP BY GR.CODIGO;
   	INTO TABLE  X:\TMP\ENTRADAS

*---------------------------------------------------------------------*
	GO TOP

	
RETURN


FUNCTION IV_SAIDAS
PARAMETERS PrmEmp,PrmDtFim

	*-------------------------------------------------------------------*
	*-------------------------------------------------------------------*
	SELECT 	;  
			PrmEmp           AS EMPRESA,;
			GR.CODIGO        AS COD_ITEM,;	        
		    SUM(LNzera)      AS VL_ITEM,;
			SUM(LNzera)      AS SLD_ANTE,;
			SUM(LNzera)      AS ENTRADAS,;
			SUM(IT.QTDE)     AS SAIDAS,;
			SUM(LNzera)      AS SLD_ATU,;
			SUM(LNzera)      AS QLA,;
			SUM(LNzera)      AS SCA,;
			SUM(LNzera)      AS COMPLE;
    FROM Q:\SCGC\CENTRAL\GRUPO GR,;
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
    ORDER BY GR.CODIGO;
    GROUP BY GR.CODIGO;
   	INTO TABLE  \TMP\SAIDAS

*---------------------------------------------------------------------*
	GO TOP

	
RETURN


FUNCTION IV_SldATU
PARAMETERS PrmEmp,PrmDtFim

	*-------------------------------------------------------------------*
	SELECT 	;
			PrmEmp           AS EMPRESA,;
			GR.CODIGO        AS COD_ITEM,;	        
		    SUM(SL.VLR_ATU)  AS VL_ITEM,;
			SUM(LNzera)      AS SLD_ANTE,;
			SUM(LNzera)      AS ENTRADAS,;
			SUM(LNzera)      AS SAIDAS,;
			SUM(SL.SLD_ATU)  AS SLD_ATU,;
			SUM(LNzera)      AS QLA,;
			SUM(LNzera)      AS SCA,;
			SUM(LNzera)      AS COMPLE;
    FROM Q:\SCGC\CENTRAL\GRUPO GR,;
         Q:\SCGC\CENTRAL\SALDO SL;
    WHERE ;
        	gr.cdg_tipo = 4;
        AND (gr.tp_control = 1 or gr.tp_control = 4);
        AND STRTRAN(STR(PrmEmp,3),' ','0') $ gr.empresas ;
        AND SL.EMPRESA = PrmEmp ;
     	AND SL.CODIGO = GR.CODIGO ;
        AND YEAR(SL.DTABERT) = 2014;
        AND MONTH(DTABERT) = 9 ;
    ORDER BY GR.CODIGO;
    GROUP BY GR.CODIGO;
   	INTO TABLE  X:\TMP\SLD_ATU

*---------------------------------------------------------------------*
	GO TOP

	
RETURN


FUNCTION IV_QLA
PARAMETERS PrmEmp,PrmDtFim

	*-------------------------------------------------------------------*
	*-------------------------------------------------------------------*
	SELECT 	;  
			PrmEmp           AS EMPRESA,;
			GR.CODIGO        AS COD_ITEM,;	        
		    SUM(LNzera)      AS VL_ITEM,;
			SUM(LNzera)      AS SLD_ANTE,;
			SUM(LNzera)      AS ENTRADAS,;
			SUM(LNzera)      AS SAIDAS,;
			SUM(LNzera)      AS SLD_ATU,;
			SUM(IT.QTDE)     AS QLA,;
			SUM(LNzera)      AS SCA,;
			SUM(LNzera)      AS COMPLE;
    FROM Q:\SCGC\CENTRAL\GRUPO GR,;
         X:\TMP\MOV_TMP IT;
    WHERE ;
        	gr.cdg_tipo = 4;
        AND (gr.tp_control = 1 or gr.tp_control = 4);
        AND STRTRAN(STR(PrmEmp,3),' ','0') $ gr.empresas ;
        AND IT.EMPRESA = PrmEmp ;
     	AND IT.CODIGO = GR.CODIGO ;
     	AND IT.TIPO = "QLA" ;
    ORDER BY GR.CODIGO;
    GROUP BY GR.CODIGO;
   	INTO TABLE  X:\TMP\QLA

*---------------------------------------------------------------------*
	GO TOP

	
RETURN



FUNCTION IV_SCA
PARAMETERS PrmEmp,PrmDtFim

	*-------------------------------------------------------------------*
	*-------------------------------------------------------------------*
	SELECT 	;
			PrmEmp           AS EMPRESA,;
			GR.CODIGO        AS COD_ITEM,;	        
		    SUM(LNzera)      AS VL_ITEM,;
			SUM(LNzera)      AS SLD_ANTE,;
			SUM(LNzera)      AS ENTRADAS,;
			SUM(LNzera)      AS SAIDAS,;
			SUM(LNzera)      AS SLD_ATU,;
			SUM(LNzera)      AS QLA,;
			SUM(IT.QTDE)     AS SCA,;
			SUM(LNzera)      AS COMPLE;
    FROM Q:\SCGC\CENTRAL\GRUPO GR,;
         X:\TMP\MOV_TMP IT;
    WHERE ;
        	gr.cdg_tipo = 4;
        AND (gr.tp_control = 1 or gr.tp_control = 4);
        AND STRTRAN(STR(PrmEmp,3),' ','0') $ gr.empresas ;
        AND IT.EMPRESA = PrmEmp ;
     	AND IT.CODIGO = GR.CODIGO ;
     	AND IT.TIPO = "SCA" ;
    ORDER BY GR.CODIGO;
    GROUP BY GR.CODIGO;
   	INTO TABLE  X:\TMP\SCA

	*---------------------------------------------------------------------*
	GO TOP

	
RETURN


FUNCTION IV_COMPLE
PARAMETERS PrmEmp,PrmDtFim

	*-------------------------------------------------------------------*
	*-------------------------------------------------------------------*
	SELECT 	;
			PrmEmp           AS EMPRESA,;
			GR.CODIGO        AS COD_ITEM,;	        
		    SUM(LNzera)      AS VL_ITEM,;
			SUM(LNzera)      AS SLD_ANTE,;
			SUM(LNzera)      AS ENTRADAS,;
			SUM(LNzera)      AS SAIDAS,;
			SUM(LNzera)      AS SLD_ATU,;
			SUM(LNzera)      AS QLA,;
			SUM(LNzera)      AS SCA,;
			SUM(IT.QTDE)     AS COMPLE;
    FROM Q:\SCGC\CENTRAL\GRUPO GR,;
         X:\TMP\MOV_TMP IT;
    WHERE ;
        	gr.cdg_tipo = 4;
        AND (gr.tp_control = 1 or gr.tp_control = 4);
        AND STRTRAN(STR(PrmEmp,3),' ','0') $ gr.empresas ;
        AND IT.EMPRESA = PrmEmp ;
     	AND IT.CODIGO = GR.CODIGO ;
     	AND IT.TIPO $ "VFN/VFO/VFP/VLG/VLH/VLI/VLJ" ;
    ORDER BY GR.CODIGO;
    GROUP BY GR.CODIGO;
   	INTO TABLE  X:\TMP\COMPLE

*---------------------------------------------------------------------*
	GO TOP

	
RETURN




FUNCTION IV_Union

	*-------------------------------------------------------------------*
	*-------------------------------------------------------------------*
	SELECT  	;
	  * ;
      FROM SLD_ANTE ;
    UNION ;
	SELECT  	;
	  * ;
      FROM ENTRADAS ;
    UNION ;
	SELECT  	;
	  * ;
      FROM SAIDAS ;
    UNION ;
	SELECT  	;
	  * ;
      FROM SLD_ATU ;
    UNION ;
	SELECT  	;
	  * ;
      FROM QLA ;
    UNION ;
	SELECT  	;
	  * ;
      FROM SCA ;
    UNION ;
	SELECT  	;
	  * ;
      FROM COMPLE ;
   	INTO TABLE  X:\TMP\TMPINVT
    

*---------------------------------------------------------------------*
	GO TOP

	
RETURN



FUNCTION IV_SomaInvt
	SELECT  	;
	  EMPRESA, ;
	  COD_ITEM,;
      SUM(VL_ITEM)          AS VL_ITEM,;
      SUM(SLD_ANTE)         AS SLD_ANTE,;
 	  SUM(ENTRADAS)         AS ENTRADAS,;
	  SUM(SAIDAS)           AS SAIDAS,;
	  SUM(SLD_ATU)          AS SLD_FINAL, ;
	  SUM(SLD_ATU)          AS SLD_ATU, ;
	  SUM(QLA)              AS QLA, ;
 	  SUM(SCA)              AS SCA, ;
 	  SUM(COMPLE)           AS COMPLE, ;
 	  SUM(QLA-SCA)          AS MOV_N_FISCAL;
    FROM TMPINVT ;
    GROUP BY ;
	  EMPRESA, ;
	  COD_ITEM;
   	INTO TABLE  X:\TMP\TMPINVT2

	*---------------------------------------------------------------------*
	GO TOP

	
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
      INV.SLD_ANTE,;
      INV.ENTRADAS,;
      INV.SAIDAS,;
  	  INV.COMPLE, ;
      (INV.SLD_ANTE + INV.ENTRADAS - INV.SAIDAS - INV.COMPLE  ) AS INVT_FISCAL ,;
	  INV.SLD_FINAL  AS INVT_REAL,  ;
;
      (INV.SLD_ANTE + INV.ENTRADAS - INV.SAIDAS - INV.COMPLE - INV.SLD_FINAL  ) AS DIFERENCA ,;
	  INV.QLA, ;
 	  INV.SCA, ;
    ;
 	  INV.MOV_N_FISCAL;
    FROM TMPINVT2 INV ,;
         Q:\SCGC\CENTRAL\GRUPO PRDT,;
         Q:\SCGC\CENTRAL\EMPRESA EMP ;
    WHERE PRDT.CODIGO = INV.COD_ITEM ;
        AND EMP.EMPRESA = PrmEMP ;
   	INTO TABLE  X:\TMP\TMPINVT3


*---------------------------------------------------------------------*
	GO TOP

	
RETURN


FUNCTION IV_InvtResumido
PARAMETERS PrmEmp,PrmDtFim


	SELECT  	;
	  INV.EMPRESA, ;
	  EMP.SIGLA,;
	  prdt.classifica,;
	  INV.COD_ITEM               AS CODIGO,;
	  PRDT.DESCRICAO,;
      (INV.SLD_ANTE+INV.ENTRADAS)   AS ESTOQUE ,;
      (INV.SAIDAS + INV.COMPLE )    AS SAIDAS,;
	  INV.SLD_FINAL, ;
      (INV.SLD_ANTE + INV.ENTRADAS  ;
                    - INV.SAIDAS ;
                    - INV.COMPLE ;
                    - INV.SLD_FINAL) AS AJUSTE ;
    FROM TMPINVT2 INV ,;
         Q:\SCGC\CENTRAL\GRUPO PRDT,;
         Q:\SCGC\CENTRAL\EMPRESA EMP ;
    WHERE PRDT.CODIGO = INV.COD_ITEM ;
        AND EMP.EMPRESA = PrmEMP ;
        AND       (INV.SLD_ANTE + INV.ENTRADAS  ;
                    - INV.SAIDAS ;
                    - INV.COMPLE ;
                    - INV.SLD_FINAL) <> 0 ;
   	INTO TABLE  X:\TMP\TMPRESUM


	*---------------------------------------------------------------------*

	GO TOP

	
RETURN



FUNCTION IV_NvLvrInvt
PARAMETERS PrmEmp,PrmDtFim

	*-------------------------------------------------------------------*
	*-------------------------------------------------------------------*
	SELECT 	;
			PrmEmp AS EMPRESA,;
			EMP.SIGLA,;
			PrmDtFim AS DATA,;			
			"0" AS IND_PROP,;
	        "00000000000" AS CPF,;
	        "00000000000000" AS CNPJ,;
	        "0" AS IND_INV,;
	        GR.COD_NCM,;
			GR.CODIGO AS COD_ITEM,;	        
			gr.unidade as unid,;
			IIF(SL.SLD_ATU=0,SL.SLD_ATU*0,SL.VLR_ATU/SL.SLD_ATU);
			     AS VL_UNIT,;
			SL.SLD_ATU AS QTD,;
			SL.VLR_ATU AS VL_ITEM,;
			GR.CTA_CONTAB, ;
			GR.DESCRICAO ;
    FROM Q:\SCGC\CENTRAL\GRUPO GR,;
         Q:\SCGC\CENTRAL\EMPRESA EMP ,;
         X:\TMP\TMPINVT3 SL   WHERE ;
        	gr.cdg_tipo = 4;
        AND EMP.EMPRESA = PrmEmp ;
        AND (gr.tp_control = 1 or gr.tp_control = 4);
        AND STRTRAN(STR(PrmEmp,3),' ','0') $ gr.empresas ;
     	AND SL.CODIGO = GR.CODIGO ;
    ORDER BY GR.CODIGO;
   	INTO TABLE  X:\TMP\INVNTRIO

*---------------------------------------------------------------------*
	GO TOP

	
RETURN

