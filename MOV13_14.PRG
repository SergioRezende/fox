SET DATE GERMAN
SET CENTU ON



 SET STEP ON

*--------------------------------------------------------* 

 =ULInt_tmp(1)   && GYN

 SELE TMPINVT3 
 SET STEP ON
 COPY TO X:\SUPORTE\INVT2013\MOV_GYN

 CLOSE DATA

return


 
*--------------------------------------------------------* 
 
 =ULInt_tmp(5)   && IPG
 SELE TMPINVT3 
 SET STEP ON

 COPY TO X:\SUPORTE\INVT2013\MOV_IPG



 CLOSE DATA
*--------------------------------------------------------* 
 
  

 =ULInt_tmp(7)   && IPG
 SELE TMPINVT3 
 SET STEP ON
 COPY TO X:\SUPORTE\INVT2013\MOV_T63


 CLOSE DATA
*--------------------------------------------------------* 

 =ULInt_tmp(9)   && IDP/RIO
 SELE TMPINVT3 
 SET STEP ON
 COPY TO X:\SUPORTE\INVT2013\MOV_RIO


 CLOSE DATA
*--------------------------------------------------------* 


 =ULInt_tmp(11)   && DPO
 SELE TMPINVT3 
 SET STEP ON
 COPY TO X:\SUPORTE\INVT2013\MOV_DPO


 CLOSE DATA
*--------------------------------------------------------* 


 =ULInt_tmp(14)   && IPG
 SELE TMPINVT3 
 SET STEP ON
 COPY TO X:\SUPORTE\INVT2013\MOV_ANP


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
 LS13dir      = "O:\SCGC2013\CENTRAL\"
 LS13dirCOMUM = "O:\COMUM\"
 LD13dataInventario = {31.12.2013}

*------------------------------------------*

 LNzera = val("0000000000000000000000,00")
 LS14dir      = "Q:\SCGC\CENTRAL\"
 LS14dirCOMUM = "Q:\COMUM\"
 LD14dataInventario = {31.12.2014}
 
*======================================= *

 LSFlGrupo   = LS14dir + "GRUPO" 
 LSFlEmpresa = LS14dir + "EMPRESA" 



*======================================= *

 LSFl13Itemmov = LS13dir + "ITEMMOV" 
 

 LSFl14Itemmov = LS14dir + "ITEMMOV" 
 
*======================================= *

  

 sele 0
 use &LSFlGrupo alias grupo
 
 sele 0
 use &LSFlEmpresa alias EMPRESA
 

 sele 0
 use &LSFl13Itemmov alias itmov13


 sele 0
 use &LSFl14Itemmov alias itmov14



=IV_INVT(LNemp)




 

RETURN

* ======================================= *
* ======================================= *
* ======================================= *
* ======================================= *
* ======================================= *


FUNCTION IV_INVT
PARAMETERS LNemp


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



 =IV_TMPMOV(LNemp)  && FILTRA ITEMMOV


 *==================================*

 *==================================*




 =IV_QLA(LNemp)

 =IV_SCA(LNemp)


 =IV_COMPLE(LNemp)

 *==================================*

 =IV_Union()

 *==================================*
 
 =IV_SomaInvt()
 
 =IV_InvtFinal(LNemp)
 




return


FUNCTION IV_TMPMOV
PARAMETERS PrmEmp

	*-------------------------------------------------------------------*
	SELECT 	;  
           IT.EMPRESA,;
           IT.CODIGO,;
           IT.QTDE,;
           IT.TIPO,;
           IT.OPERACAO,;
           IT.DATA,;
           IT.MOVESTQ;
    FROM GRUPO GR,;
         itmov13 IT;
    WHERE ;
        	gr.cdg_tipo = 4;
        AND (gr.tp_control = 1 or gr.tp_control = 4);
        AND STRTRAN(STR(PrmEmp,3),' ','0') $ gr.empresas ;
        AND IT.EMPRESA = PrmEmp ;
     	AND IT.CODIGO = GR.CODIGO ;
        AND YEAR(IT.DATA) = 2013;
    ORDER BY GR.CODIGO;
   	INTO TABLE  \TMP\TMPMOV13

	*---------------------------------------------------------------------*
	GO TOP

	*-------------------------------------------------------------------*
	SELECT 	;  
           IT.EMPRESA,;
           IT.CODIGO,;
           IT.QTDE,;
           IT.TIPO,;
           IT.OPERACAO,;
           IT.DATA,;
           IT.MOVESTQ;
    FROM GRUPO GR,;
         itmov14 IT;
    WHERE ;
        	gr.cdg_tipo = 4;
        AND (gr.tp_control = 1 or gr.tp_control = 4);
        AND STRTRAN(STR(PrmEmp,3),' ','0') $ gr.empresas ;
        AND IT.EMPRESA = PrmEmp ;
     	AND IT.CODIGO = GR.CODIGO ;
        AND YEAR(IT.DATA) = 2014;
        AND MONTH(IT.DATA) <= 10;
    ORDER BY GR.CODIGO;
   	INTO TABLE  \TMP\TMPMOV14

	*---------------------------------------------------------------------*
	GO TOP

	
RETURN









FUNCTION IV_QLA
PARAMETERS PrmEmp

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
    FROM GRUPO GR,;
         TMPMOV13 IT;
    WHERE ;
        	gr.cdg_tipo = 4;
        AND (gr.tp_control = 1 or gr.tp_control = 4);
        AND STRTRAN(STR(PrmEmp,3),' ','0') $ gr.empresas ;
        AND IT.EMPRESA = PrmEmp ;
     	AND IT.CODIGO = GR.CODIGO ;
     	AND IT.TIPO = "QLA" ;
        AND YEAR(IT.DATA) = 2013;
    ORDER BY GR.CODIGO;
    GROUP BY GR.CODIGO;
   	INTO TABLE  \TMP\QLA13

	GO TOP

*---------------------------------------------------------------------*
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
    FROM GRUPO GR,;
         TMPMOV14 IT;
    WHERE ;
        	gr.cdg_tipo = 4;
        AND (gr.tp_control = 1 or gr.tp_control = 4);
        AND STRTRAN(STR(PrmEmp,3),' ','0') $ gr.empresas ;
        AND IT.EMPRESA = PrmEmp ;
     	AND IT.CODIGO = GR.CODIGO ;
     	AND IT.TIPO = "QLA" ;
        AND YEAR(IT.DATA) = 2014;
        AND MONTH(IT.DATA) <= 10 ;
    ORDER BY GR.CODIGO;
    GROUP BY GR.CODIGO;
   	INTO TABLE  \TMP\QLA14

	GO TOP

	
RETURN



FUNCTION IV_SCA
PARAMETERS PrmEmp

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
    FROM GRUPO GR,;
         TMPMOV13 IT;
    WHERE ;
        	gr.cdg_tipo = 4;
        AND (gr.tp_control = 1 or gr.tp_control = 4);
        AND STRTRAN(STR(PrmEmp,3),' ','0') $ gr.empresas ;
        AND IT.EMPRESA = PrmEmp ;
     	AND IT.CODIGO = GR.CODIGO ;
     	AND IT.TIPO = "SCA" ;
        AND YEAR(IT.DATA) = 2013;
    ORDER BY GR.CODIGO;
    GROUP BY GR.CODIGO;
   	INTO TABLE  \TMP\SCA13

	GO TOP
*---------------------------------------------------------------------*
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
    FROM GRUPO GR,;
         TMPMOV14 IT;
    WHERE ;
        	gr.cdg_tipo = 4;
        AND (gr.tp_control = 1 or gr.tp_control = 4);
        AND STRTRAN(STR(PrmEmp,3),' ','0') $ gr.empresas ;
        AND IT.EMPRESA = PrmEmp ;
     	AND IT.CODIGO = GR.CODIGO ;
     	AND IT.TIPO = "SCA" ;
        AND YEAR(IT.DATA) = 2014;
        AND MONTH(IT.DATA) <= 10;
    ORDER BY GR.CODIGO;
    GROUP BY GR.CODIGO;
   	INTO TABLE  \TMP\SCA14

	GO TOP
*---------------------------------------------------------------------*

	
RETURN


FUNCTION IV_COMPLE
PARAMETERS PrmEmp

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
    FROM GRUPO GR,;
         TMPMOV13 IT;
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
   	INTO TABLE  \TMP\COMPLE13

	GO TOP
*---------------------------------------------------------------------*
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
    FROM GRUPO GR,;
         TMPMOV14 IT;
    WHERE ;
        	gr.cdg_tipo = 4;
        AND (gr.tp_control = 1 or gr.tp_control = 4);
        AND STRTRAN(STR(PrmEmp,3),' ','0') $ gr.empresas ;
        AND IT.EMPRESA = PrmEmp ;
     	AND IT.CODIGO = GR.CODIGO ;
     	AND IT.TIPO $ "VFN/VFO/VFP/VLG/VLH/VLI/VLJ" ;
        AND YEAR(IT.DATA) = 2014;
        AND MONTH(IT.DATA) <= 10;
    ORDER BY GR.CODIGO;
    GROUP BY GR.CODIGO;
   	INTO TABLE  \TMP\COMPLE14

	GO TOP
*---------------------------------------------------------------------*

	
RETURN




FUNCTION IV_Union

	*-------------------------------------------------------------------*
	*-------------------------------------------------------------------*
	SELECT  	;
	  * ;
      FROM QLA13 ;
    UNION ;
	SELECT  	;
	  * ;
      FROM SCA13 ;
    UNION ;
	SELECT  	;
	  * ;
      FROM COMPLE13;
    UNION ;
	SELECT  	;
	  * ;
      FROM QLA14 ;
    UNION ;
	SELECT  	;
	  * ;
      FROM SCA14 ;
    UNION ;
	SELECT  	;
	  * ;
      FROM COMPLE14 ;
   	INTO TABLE  \TMP\TMPINVT
    

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
   	INTO TABLE  \TMP\TMPINVT2


*---------------------------------------------------------------------*
	GO TOP

	
RETURN



FUNCTION IV_InvtFinal
PARAMETERS PrmEmp
	SELECT  	;
	  INV.EMPRESA, ;
	  EMP.SIGLA,;
	  prdt.classifica,;
	  INV.COD_ITEM           AS CODIGO,;
	  PRDT.DESCRICAO,;
      INV.VL_ITEM            AS VLR_ATU,;
      INV.SLD_ANTE,;
      INV.ENTRADAS,;
      INV.SAIDAS,;
	  INV.SLD_FINAL, ;
      (INV.SLD_ANTE + INV.ENTRADAS - INV.SAIDAS - INV.SLD_FINAL) AS DIFERENCA ,;
	  INV.QLA, ;
 	  INV.SCA, ;
    ;
 	  INV.MOV_N_FISCAL,;
    ;
 	  INV.SLD_ATU                    AS INVT_REAL,;
 	  INV.SLD_ATU - INV.MOV_N_FISCAL AS INVT_AJ_QLASCA,;
  	  INV.COMPLE, ;
 	  INV.SLD_ATU - INV.MOV_N_FISCAL ;
 	              - INV.COMPLE       AS INVT_AJ_COMPLE,;
      "----"                         AS A,;
 	  INV.SLD_ATU - INV.MOV_N_FISCAL ;
 	              - INV.COMPLE       AS SLD_ATU;
    FROM TMPINVT2 INV ,;
         EMPRESA EMP ,;
         GRUPO PRDT ;
    WHERE PRDT.CODIGO = INV.COD_ITEM ;
        AND EMP.EMPRESA = PrmEMP ;
   	INTO TABLE  \TMP\TMPINVT3


*---------------------------------------------------------------------*
	GO TOP

	
RETURN





