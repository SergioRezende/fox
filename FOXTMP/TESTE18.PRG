SET EXCL OFF
 close all
 USE Q:\SCGC\CENTRAL\NOTA
 SET ORDER TO TAG DT_GERAL OF Q:\SCGC\CENTRAL\NOTA.CDX
 SET DELE ON
 SET DATE GERMAN
 SET NEAR ON
 SEEK DTOS({16.01.2001})
 COPY TO Q:\TMP\NFTMP FOR CH_OPERA = "1" AND OPERACAO = "S" AND !(TIPO $ "CPM/ENT") AND STATUS <> 2  WHILE DATA <={15.02.2001}
 USE Q:\TMP\NFTMP EXCL
 INDEX ON STR(EMPRESA,3)+STR(NATU_CLI,1) TAG NATU_CLIE ADDITIVE

*
*    Se Forem comparados os valores deste relatorio com o acumulado de 
*	vendas pode ocorrer diferencas em funcao das vendas de pneus de 
*   cliente serem englobadas neste e nao estarem no acumulado
*
*


CLOSE ALL
SELE 0
USE Q:\SCGC\CENTRAL\EMPRESA
SET ORDER TO TAG EMPRESA

sele 0
USE Q:\SCGC\COMUM\tab001
SELECT tab001
SET ORDER TO TAG codigo

SELE 0

USE Q:\TMP\NFTMP
SELECT NFTMP
SET ORDER TO TAG NATU_CLIE
SET RELATION TO 'NTZ'+CHRTRAN(STR(natu_cli,1)," ","0") INTO tab001
SET RELATION TO EMPRESA INTO EMPRESA ADDITIVE
REPOR FORM \FPD26\TEMP\FAT_NATU TO PRINTER OFF

