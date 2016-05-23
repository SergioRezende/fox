*----------------------------------------------------------------
*  Montar Inventario VERSAO FINAL Com Vendas e Transf. do mes 11/2002
*  COM BASE NO ITEMMOV DE FORMA SINTETICA
*  NAO CONSIDERANDO PROTETORES
*---------------------------------------------------------------

SELECT 	;
		STR(SNRM.EMPRESA,3)+SNRM.CODIGO AS KEY_UNICA, ;
        SNRM.EMPRESA,;
		SNRM.CODIGO, ;
		SNRM.CLASSIFICA,;
        SNRM.SLD_ATU             				AS S10_2002,;
       (SNRM.VLR_ATU)            				AS V10_2002, ;
       (SACM.SLD_ATU - SNRM.SLD_ATU) 			AS SLD_AVER, ;
       IIF(SNRM.VLR_ATU = 0, SACM.VLR_ATU,;
           ((SNRM.VLR_ATU /SNRM.SLD_ATU) * (SACM.SLD_ATU - SNRM.SLD_ATU))) ;
           										AS VLR_AVER,;
       SACM.SLD_ATU   							AS SF102002,; 
       SNRM.VLR_ATU + IIF(SNRM.VLR_ATU = 0, SACM.VLR_ATU,;
          ((SNRM.VLR_ATU /SNRM.SLD_ATU) * (SACM.SLD_ATU - SNRM.SLD_ATU))) ;
          				 						AS VF102002,;
       SUM(V11_2002.qtde)      					AS Q11_2002,;
       SUM(V11_2002.vlrvenda)  					AS V11_2002,;
       SACM.SLD_ATU - SUM(V11_2002.qtde) 		AS SF112002,;
       ((SNRM.VLR_ATU + IIF(SNRM.VLR_ATU = 0, SACM.VLR_ATU,;
          ((SNRM.VLR_ATU /SNRM.SLD_ATU) * (SACM.SLD_ATU - SNRM.SLD_ATU)))) ;
        / ;
       SACM.SLD_ATU) * (SACM.SLD_ATU - SUM(V11_2002.qtde)) ;
       											AS VF112002,;
       GRUPO.DESCRICAO;
  FROM  C:\TEMP\S10_2002 SNRM,;
  		C:\TEMP\SLD_ACM SACM,;
  		C:\TEMP\V11_2002 ,;
  		Q:\SCGC\COMUM\GRUPO ;
  WHERE  ;
 		     (GRUPO.TP_CONTROL = 1 OR GRUPO.TP_CONTROL = 3) ;
        AND	SNRM.EMPRESA <> 10 ;
  		AND LEFT(SNRM.CLASSIFICA,5) <> "04042" ;
  		AND SNRM.CODIGO = GRUPO.CODIGO  ;
  		AND SACM.EMPRESA = SNRM.EMPRESA ;
  		AND SACM.CODIGO  = SNRM.CODIGO  ;
  		AND V11_2002.EMPRESA = SNRM.EMPRESA ;
  		AND V11_2002.CODIGO  = SNRM.CODIGO  ;
  		AND   ( V11_2002.VD_ACM  =< SACM.SLD_ATU OR ;
 	          (V11_2002.VD_ACM  > SACM.SLD_ATU AND 	;
  		         SACM.SLD_ATU + V11_2002.QTDE > V11_2002.VD_ACM));
  ORDER BY SNRM.EMPRESA,SNRM.CLASSIFICA ;
  GROUP BY SNRM.EMPRESA,SNRM.CODIGO,SNRM.CLASSIFICA ;
  INTO TABLE C:\TEMP\INV_PIS1


*----------------------------------------------------------------
*  Montar Inventario VERSAO FINAL Com Vendas e Transf. do mes 11/2002
*  COM BASE NO ITEMMOV DE FORMA SINTETICA
*   CONSIDERANDO SOMENTE PROTETORES
*---------------------------------------------------------------

SELECT 	;
		STR(SNRM.EMPRESA,3)+SNRM.CODIGO AS KEY_UNICA, ;
        SNRM.EMPRESA,;
		SNRM.CODIGO, ;
		SNRM.CLASSIFICA,;
        SNRM.SLD_ATU             				AS S10_2002,;
       (SNRM.VLR_ATU)            				AS V10_2002, ;
        0  							 			AS SLD_AVER, ;
        0 										AS VLR_AVER,;
        0           							AS SF102002,; 
        0  				 						AS VF102002,;
       SUM(V11_2002.qtde)      					AS Q11_2002,;
       SUM(V11_2002.vlrvenda)  					AS V11_2002,;
        0								 		AS SF112002,;
        0  									    AS VF112002,;
       GRUPO.DESCRICAO;
  FROM  C:\TEMP\S10_2002 SNRM,;
  		C:\TEMP\SLD_ACM SACM,;
  		C:\TEMP\V11_2002 ,;
  		Q:\SCGC\COMUM\GRUPO ;
  WHERE  ;
 		     (GRUPO.TP_CONTROL = 1 OR GRUPO.TP_CONTROL = 3) ;
        AND	SNRM.EMPRESA <> 10 ;
  		AND LEFT(SNRM.CLASSIFICA,5) = "04042" ;
  		AND SNRM.CODIGO = GRUPO.CODIGO  ;
  		AND SACM.EMPRESA = SNRM.EMPRESA ;
  		AND SACM.CODIGO  = SNRM.CODIGO  ;
  		AND V11_2002.EMPRESA = SNRM.EMPRESA ;
  		AND V11_2002.CODIGO  = SNRM.CODIGO  ;
  ORDER BY SNRM.EMPRESA,SNRM.CLASSIFICA ;
  GROUP BY SNRM.EMPRESA,SNRM.CODIGO,SNRM.CLASSIFICA ;
  INTO TABLE C:\TEMP\INV_PISB


  *----------------------------------------------------------------*
  * UNIFICAR INVENTARIO DOS PRODUTOS QUE TIVERAM MOVIMENTO 
  * COM INVENTARIO DOS QUE NAO TIVERAM MOVIMENTACAO
  * QUE SAO PROTETORES
  *----------------------------------------------------------------*

  SELECT ;
		STR(SNRM.EMPRESA,3)+SNRM.CODIGO AS KEY_UNICA, ;
        SNRM.EMPRESA,;
		SNRM.CODIGO, ;
		SNRM.CLASSIFICA,;
        SNRM.SLD_ATU             				AS S10_2002,;
       (SNRM.VLR_ATU)            				AS V10_2002, ;
        0  							 			AS SLD_AVER, ;
        0 										AS VLR_AVER,;
        0           							AS SF102002,; 
        0  				 						AS VF102002,;
        0                     					AS Q11_2002,;
        0                      					AS V11_2002,;
        0								 		AS SF112002,;
        0  									    AS VF112002,;
       GRUPO.DESCRICAO;
  FROM  C:\TEMP\S10_2002 SNRM,;
  		C:\TEMP\SLD_ACM SACM,;
  		Q:\SCGC\COMUM\GRUPO ;
  WHERE  ;
 		     (GRUPO.TP_CONTROL = 1 OR GRUPO.TP_CONTROL = 3) ;
        AND	SNRM.EMPRESA  <> 10 ;
  		AND LEFT(SNRM.CLASSIFICA,5) = "04042" ;
		AND STR(SNRM.EMPRESA,3)+SNRM.CODIGO NOT IN  ;
 		 			(SELECT KEY_UNICA FROM  C:\TEMP\INV_PIS1);
		AND STR(SNRM.EMPRESA,3)+SNRM.CODIGO NOT IN  ;
 		 			(SELECT KEY_UNICA FROM  C:\TEMP\INV_PISB);
  		AND (SNRM.CODIGO = GRUPO.CODIGO  ;
  		AND SACM.EMPRESA = SNRM.EMPRESA ;
  		AND SACM.CODIGO  = SNRM.CODIGO)  ;
  GROUP BY SNRM.EMPRESA,SNRM.CODIGO,SNRM.CLASSIFICA ;
  INTO TABLE C:\TEMP\INV_PISC
  

*---------------------------------------------------------------------*

  ON ERROR
  SET STEP ON
  SELE INV_PIS1
  IF USED("INV_PIS3")
    SELE INV_PIS3
	USE
  ENDIF
  COPY STRU TO C:\TEMP\INV_PIS3
  SELE 0
  USE  C:\TEMP\INV_PIS3
	APPEND FROM   C:\TEMP\INV_PIS1
	APPEND FROM   C:\TEMP\INV_PISB
	APPEND FROM   C:\TEMP\INV_PISC


  *----------------------------------------------------------------*
  * UNIFICAR INVENTARIO DOS PRODUTOS QUE TIVERAM MOVIMENTO 
  * COM INVENTARIO DOS QUE NAO TIVERAM MOVIMENTACAO
  * QUE NAO SAO PROTETORES
  *----------------------------------------------------------------*

  SELECT ;
  		STR(SNRM.EMPRESA,3)+SNRM.CODIGO AS KEY_UNICA, ;
	    SNRM.EMPRESA,;
		SNRM.CODIGO, ;
		SNRM.CLASSIFICA,;
        SNRM.SLD_ATU             				AS S10_2002,;
       (SNRM.VLR_ATU)            				AS V10_2002, ;
       (SACM.SLD_ATU - SNRM.SLD_ATU) 			AS SLD_AVER, ;
       IIF(SNRM.VLR_ATU = 0, SACM.VLR_ATU,;
           ((SNRM.VLR_ATU /SNRM.SLD_ATU) * (SACM.SLD_ATU - SNRM.SLD_ATU))) ;
           										AS VLR_AVER,;
       SACM.SLD_ATU   							AS SF102002,; 
       SNRM.VLR_ATU + IIF(SNRM.VLR_ATU = 0, SACM.VLR_ATU,;
          ((SNRM.VLR_ATU /SNRM.SLD_ATU) * (SACM.SLD_ATU - SNRM.SLD_ATU))) ;
          				 						AS VF102002,;
       0000000000000000       					AS Q11_2002,;
       0000000000000.00   					AS V11_2002,;
       SACM.SLD_ATU   * 01.          		       AS SF112002,;
       ((SNRM.VLR_ATU + IIF(SNRM.VLR_ATU = 0, SACM.VLR_ATU,;
          ((SNRM.VLR_ATU /SNRM.SLD_ATU) * (SACM.SLD_ATU - SNRM.SLD_ATU)))) ;
        / ;
       SACM.SLD_ATU) * (SACM.SLD_ATU - 0) ;
       											AS VF112002,;
       GRUPO.DESCRICAO;
  FROM  C:\TEMP\S10_2002 SNRM,;
  		C:\TEMP\SLD_ACM SACM,;
  		Q:\SCGC\COMUM\GRUPO ;
  WHERE  ;
 		     (GRUPO.TP_CONTROL = 1 OR GRUPO.TP_CONTROL = 3) ;
        AND	SNRM.EMPRESA  <> 10 ;
  		AND LEFT(SNRM.CLASSIFICA,5) <> "04042" ;
		AND STR(SNRM.EMPRESA,3)+SNRM.CODIGO NOT IN  ;
 		 			(SELECT KEY_UNICA FROM  C:\TEMP\INV_PIS3);
  		AND (SNRM.CODIGO = GRUPO.CODIGO  ;
  		AND SACM.EMPRESA = SNRM.EMPRESA ;
  		AND SACM.CODIGO  = SNRM.CODIGO)  ;
  GROUP BY SNRM.EMPRESA,SNRM.CODIGO,SNRM.CLASSIFICA ;
  INTO TABLE C:\TEMP\INV_PIS2



  SELE INV_PIS3
	APPEND FROM   C:\TEMP\INV_PIS2


*-----------------------------------------------------------*
*  Ajustar Valores negativos
*-----------------------------------------------------------*
	SELECT INV_PIS3
	GO TOP
	DO WHILE !EOF()
		IF Q11_2002 > SF102002 AND LEFT(INV_PIS3.CLASSIFICA,5) <> "04042"
		   REPLACE V11_2002 WITH V11_2002 / Q11_2002 * SF102002
		   REPLACE Q11_2002 WITH SF102002
		   REPLACE SF112002 WITH 0
		   REPLACE VF112002 WITH 0
		ENDIF
		SKIP
	ENDDO

*-----------------------------------------------------------*
SELECT EMP.SIGLA, EMP.CGC, INV_PIS3.* FROM C:\TEMP\INV_PIS3  ,  ;
              Q:\SCGC\CENTRAL\EMPRESA EMP;
     WHERE (sf102002 > 0 OR ; 
           LEFT(INV_PIS3.CLASSIFICA,5) = "04042");
           AND INV_PIS3.EMPRESA = EMP.EMPRESA ;
     ORDER BY EMPRESA,CLASSIFICA ;
     INTO TABLE  C:\TEMP\INV_PIS4

**MODIFY REPORT TESTE26.FRX
*-------------------------------------------------------------------*
CLOSE ALL
  SELE 0
  USE  Q:\SCGC\COMUM\GRUPO
  SELE 0
  USE  C:\TEMP\INV_PIS4
SELE INV_PIS4
SET PROCEDURE TO ROTINAS.SPR


SET POINT TO ","
SET SEPARATOR  TO "."
SET TALK OFF
REPORT form TESTE26.FRX to file l:\tmp\prt0001a.rel OFF

MODIF COMM l:\tmp\prt0001a.rel
