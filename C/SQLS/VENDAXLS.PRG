*-------------------------------------------*
DIRETORIO = "Z:\SCGC2005\CENTRAL\"
ANO = 2005
*-------------------------------------------*
*-------------------------------------------*
*-------------------------------------------*


SET DELE ON
SET DATE GERMAN
SET CENTU ON
SET EXCL OFF
CLOSE DATA

ARQDEST = "Q:\SCGC\EXPORTA\VEND"+STR(ANO,4)

SELE 0
ARQ = DIRETORIO+"NOTA"
USE &ARQ ALIAS NF

SELE 0
ARQ = DIRETORIO+"EMPRESA"
USE &ARQ ALIAS EMP


SELE 0
USE Q:\SCGC\COMUM\USUARIO ALIAS USR

SELE 0
ARQ = DIRETORIO+"ITEMMOV"
USE &ARQ ALIAS IT


SELECT ;
	   EMP.SIGLA,;
	   IT.DATA,;
	   NF.NOTA,;
       NF.NOME,;
       NF.BAIRRO,;
       NF.CIDADE,;
       NF.UF,;
       IT.DESCRICAO AS PRODUTO,;
       IT.CODIGO,;
       NF.SERV_1,;
       USR.NOME,;
       IT.QTDE,;
       IT.VLRVENDA,;
       IT.CLASSIFICA,;
       IT.TP_MERCAD;
FROM ;
	 EMP,;
	 USR,;
     NF,;
     IT;
WHERE ;
     	 IT.CH_OPERA = "1" ;
     AND LEFT(IT.OPERACAO,1) = "S" ;
     AND IT.TIPO <> "CPM" ;
	 AND EMP.EMPRESA = IT.EMPRESA ;
     AND NF.EMPRESA = IT.EMPRESA ;
     AND NF.NOTA    = IT.NOTA;
     AND NF.TIPO    = IT.TIPO;
     AND NF.STATUS  <> 2 ;
     AND YEAR(NF.DATA) = ANO ;
     AND USR.USUARIO = NF.SERV_1 ;
INTO TABLE &ARQDEST

      
       
       

