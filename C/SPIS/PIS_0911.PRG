








*---------------------------------------------------------*
* OBS: Este nao trabalha com PROTETORES
*      os protetores nao constam desde 02/205
*---------------------------------------------------------*


*-----------------------------------------------------------------------*
**  {01.05.2004}   ===> {01.06.2004}
**  {31.05.2004}   ===> {30.06.2004}
**  X:\SCGC\BD_PIS\DAT_0404 ===> X:\SCGC\BD_PIS\DAT_0504
** COPY TO X:\SCGC\BD_PIS\DAT_0504.DBF 
**                         ====> COPY TO X:\SCGC\BD_PIS\DAT_0604.DBF
*-----------------------------------------------------------------------*

close all
SET DELE ON
set excl off
SET STEP ON
SET CONFIRM OFF

SET PATH TO X:\PROJETOS\FOX\C\SPIS
SET defa TO X:\PROJETOS\FOX\C\SPIS



*=======================================================================*
SET DATE GERMAN
SET CENTU ON

arq_ant = "x:\SCGC\BD_PIS\DAT_0911"
arq_nov = "x:\SCGC\BD_PIS\DAT_1011"
arq_bkp = "X:\SCGC\BD_PIS\DAT_1011"


IF 1 = 4
	USE X:\SCGC\CENTRAL\ITEMMOV
	COPY TO  L:\TMP\ITEMTMP  ;
         FOR DATA >= {01.10.2011} AND DATA <= {31.10.2011} WITH CDX
	USE L:\TMP\ITEMTMP EXCL
	pack
	reindex
	use
	
ENDIF
*=======================================================================*



SET DELE ON
SET DATE GERMAN
SET CENTU ON

*----------------------------------------------------------------
*    Separar Saldos REAIS  do mes 10/2002 
*    Descartando os dados da loja GYN obtidos na CENTRAL por 
*  problemas com o valor de estoque relatados pelo SR.Celio
*  ==> Pegar dados da GYN no diretorio da propria loja
*----------------------------------------------------------------


SELECT EMPRESA, CODIGO,CLASSIFICA, ;
        0  AS SLD_ATU,;
        0  AS VLR_ATU ;
   FROM     X:\SCGC\BD_PIS\DAT_1102;
 INTO TABLE X:\TEMP\S10_2002


*----------------------------------------------------------------
*    Separar Saldo do mes 10/2002 
*    Reagregado das Entradas do Mes 11/2002 que foram emitidas ainda 
*    sob o regime de PIS-COFINS antigo (Sem Retencao)
*----------------------------------------------------------------

SELECT EMPRESA, CODIGO,CLASSIFICA, ;
        SF112002 AS SLD_ATU,;
        VF112002 AS VLR_ATU ;
   FROM   &arq_ant; 
INTO TABLE X:\TEMP\SLD_ACM

*----------------------------------------------------------------
*  Montar Inventario Com Vendas e Transf. do mes 06/2003
*  COM BASE NO ITEMMOV
*---------------------------------------------------------------


SELECT EMPRESA,CODIGO,QTDE,VLRVENDA, 00000000000 AS VD_ACM ;
    FROM L:\TMP\ITEMTMP ;
    WHERE  CH_OPERA = "1" ;
        AND LEFT(OPERACAO,1) = "S";
    INTO TABLE X:\TEMP\V11_2002

*---------------------------------------------------------------
*  AJUSTANDO ITEMMOV PARA ATENDER AO SELECT
*---------------------------------------------------------------
	    

SELE V11_2002
GO TOP
QBR_E = V11_2002.EMPRESA
QBR_C = V11_2002.CODIGO
ACM = 0
DO WHILE !EOF()
	IF QBR_C <> V11_2002.CODIGO OR QBR_E <> V11_2002.EMPRESA
		QBR_E = V11_2002.EMPRESA
		QBR_C = V11_2002.CODIGO
		ACM = 0
    ENDIF
	ACM = ACM + V11_2002.QTDE
	=RLOCK()
	REPLACE VD_ACM WITH ACM
	SKIP
ENDDO

*----------------------------------------------------------------
*  Montar Inventario VERSAO FINAL Com Vendas e Transf. do mes 03/2003
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
  FROM  X:\TEMP\S10_2002 SNRM,;
  		X:\TEMP\SLD_ACM SACM,;
  		X:\TEMP\V11_2002 ,;
  		X:\SCGC\COMUM\GRUPO ;
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
  INTO TABLE X:\TEMP\INV_PIS1



  *----------------------------------------------------------------*

  ON ERROR
  SELE INV_PIS1
  IF USED("INV_PIS3")
    SELE INV_PIS3
	USE
  ENDIF
  COPY STRU TO X:\TEMP\INV_PIS3
  SELE 0
  USE  X:\TEMP\INV_PIS3
	APPEND FROM   X:\TEMP\INV_PIS1


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
  FROM  X:\TEMP\S10_2002 SNRM,;
  		X:\TEMP\SLD_ACM SACM,;
  		X:\SCGC\COMUM\GRUPO ;
  WHERE  ;
 		     (GRUPO.TP_CONTROL = 1 OR GRUPO.TP_CONTROL = 3) ;
        AND	SNRM.EMPRESA  <> 10 ;
  		AND LEFT(SNRM.CLASSIFICA,5) <> "04042" ;
		AND STR(SNRM.EMPRESA,3)+SNRM.CODIGO NOT IN  ;
 		 			(SELECT KEY_UNICA FROM  X:\TEMP\INV_PIS3);
  		AND (SNRM.CODIGO = GRUPO.CODIGO  ;
  		AND SACM.EMPRESA = SNRM.EMPRESA ;
  		AND SACM.CODIGO  = SNRM.CODIGO)  ;
  GROUP BY SNRM.EMPRESA,SNRM.CODIGO,SNRM.CLASSIFICA ;
  INTO TABLE X:\TEMP\INV_PIS2



  SELE INV_PIS3
  APPEND FROM   X:\TEMP\INV_PIS2


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
SELECT EMP.SIGLA, EMP.CGC, INV_PIS3.* FROM X:\TEMP\INV_PIS3  ,  ;
              X:\SCGC\CENTRAL\EMPRESA EMP;
     WHERE (sf102002 > 0 OR ; 
           LEFT(INV_PIS3.CLASSIFICA,5) = "04042");
           AND INV_PIS3.EMPRESA = EMP.EMPRESA ;
     ORDER BY EMPRESA,CLASSIFICA ;
     INTO TABLE  X:\TEMP\INV_PIS4

**MODIFY REPORT TESTE26.FRX
*-------------------------------------------------------------------*
CLOSE ALL
  SELE 0
  USE  X:\SCGC\COMUM\GRUPO
  SELE 0
  USE  X:\TEMP\INV_PIS4

SELE INV_PIS4
set procedure to X:\PROJETOS\FOX\C\SOBJ2\geral.spr
COPY TO   &arq_nov 
COPY TO   &arq_bkp


SET POINT TO ","
SET SEPARATOR  TO "."
SET TALK OFF
REPORT form X:\PROJETOS\FOX\C\SPIS\TESTE26A.FRX to file l:\tmp\prt0001a.rel OFF

MODIF COMM l:\tmp\prt0001a.rel
