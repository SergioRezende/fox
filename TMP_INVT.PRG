
	PARAMETERS PrmEmp,PrmDtFim

	CLOSE ALL

	SET TALK ON


*	=INVT_ORION(PrmEmp,PrmDtFim)


	=INVT_TXT_SPED(PrmEmp,PrmDtFim)



RETURN

FUNCTION INVT_ORION
*----------------------------------------------*
* GERA INVENTARIO PARA IMPORTACAO NO ORION
*----------------------------------------------*

	PARAMETERS PrmEmp,PrmDtFim




	SET EXCL OFF
	SET DATE GERMAN
	SET CENTU ON 
	SET DELE ON



	SELECT 	;
			PrmEmp AS EMPRESA,;
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
    FROM Q:\SCGC\COMUM\GRUPO GR,;
         Q:\SCGC\LOJA\SALDO SL;
    WHERE ;
        	gr.cdg_tipo = 4;
        AND (gr.tp_control = 1 or gr.tp_control = 4);
        AND SL.EMPRESA = PrmEmp ;
     	AND SL.CODIGO = GR.CODIGO ;
        AND YEAR(SL.DTABERT) = YEAR(PrmDtFim);
        AND MONTH(SL.DTABERT) = MONTH(PrmDtFim) ;
    ORDER BY GR.CODIGO;
   	INTO TABLE  \TMP\INVNTRIO

RETURN


FUNCTION INVT_TXT_SPED
*----------------------------------------------*
* GERA INVENTARIO PARA IMPORTACAO NO ORION
*----------------------------------------------*

	PARAMETERS PrmEmp,PrmDtFim




	SET EXCL OFF
	SET DATE GERMAN
	SET CENTU ON 
	SET DELE ON



	SELECT 	;
			"|"+"H010"        	AS REG,;
			"|"+GR.CODIGO 		AS COD_ITEM,;	        
			"|"+"UN"       		AS UNID,;
			"|"+STR(SL.SLD_ATU,12,3) AS QTD,;
			"|"+STR(;
			IIF(SL.SLD_ATU=0,SL.SLD_ATU*0,SL.VLR_ATU/SL.SLD_ATU),14,2);
							    AS VL_UNIT,;
			"|"+STR(SL.VLR_ATU,14,2) AS VL_ITEM,;
			"|"+"1"             AS IND_PROP,;
			"|"+STR(EMP.CGC,14,0)    AS COD_PART,;
			"|"                 AS TXT_COMPL,;
			"|"+GR.CTA_CONTAB   AS COD_CTA, ;
			"|"+STR(SL.VLR_ATU,14,2) AS VL_ITEM_IR,;
			"|"                 AS TXT_1;
    FROM Q:\SCGC\COMUM\GRUPO GR,;
         Q:\SCGC\CENTRAL\SALDO SL,;
         Q:\SCGC\CENTRAL\EMPRESA EMP;
    WHERE ;
        	gr.cdg_tipo = 4;
        AND (gr.tp_control = 1 or gr.tp_control = 4);
        AND SL.EMPRESA = PrmEmp ;
     	AND SL.CODIGO = GR.CODIGO ;
        AND YEAR(SL.DTABERT) = YEAR(PrmDtFim);
        AND MONTH(SL.DTABERT) = MONTH(PrmDtFim) ;
        AND EMP.EMPRESA = SL.EMPRESA ;
        AND SL.SLD_ATU > 0;
    ORDER BY GR.CODIGO;
   	INTO TABLE  \TMP\TMP_INV

	SELECT ;
    	CHRTRAN(REG +     ;
    	COD_ITEM    +     ;
    	UNID        +     ;
    	CHRTRAN(QTD,".",",")     +     ;
    	CHRTRAN(VL_UNIT,".",",")   +     ;
    	CHRTRAN(VL_ITEM,".",",")     +     ;
    	IND_PROP    +     ;
    	COD_PART    +     ;
    	TXT_COMPL   +     ;
   		CHRTRAN(COD_CTA,".","")     +     ;
   		CHRTRAN(VL_ITEM_IR,".",",")  +     ;
   		TXT_1," ","")       AS LINHA;     
	FROM   \TMP\TMP_INV;
   	INTO TABLE  \TMP\INVNTRIO
   	
   	

	COPY TO \TMP\INVNTRIO.TXT TYPE SDF


RETURN