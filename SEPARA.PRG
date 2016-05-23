SET DELE ON
SET DATE GERMAN
SET TALK ON
*******************   SEPARANDO DADOS DA EMP - W-3 **************

USE \SCGC\CENTRAL\DUPLICAT
SET ORDER TO TAG DOC
SET NEAR ON

SEEK STR(8,3)
COPY TO \SCGC\LOJA04\DUPLICAT WHILE EMPRESA = 8 WITH CDX

****************************************************************

USE \SCGC\CENTRAL\DUPLICAT
SET ORDER TO TAG DOC
SET NEAR ON

SEEK STR(8,3)
COPY TO \SCGC\LOJA04\DUPLICAT WHILE EMPRESA = 8 WITH CDX

****************************************************************

USE \SCGC\CENTRAL\ITEMMOV
SET ORDER TO TAG MOVIMENTO
SET NEAR ON

SEEK STR(8,3)
COPY TO \SCGC\LOJA04\ITEMMOV WHILE EMPRESA = 8 WITH CDX

****************************************************************

USE \SCGC\CENTRAL\ITMANEXO
SET ORDER TO TAG MOVANEXO
SET NEAR ON

SEEK STR(8,3)
COPY TO \SCGC\LOJA04\ITMANEXO WHILE EMPRESA = 8 WITH CDX

****************************************************************

USE \SCGC\CENTRAL\NF_ANEXO
SET ORDER TO TAG ANEXO
SET NEAR ON

SEEK STR(8,3)
COPY TO \SCGC\LOJA04\NF_ANEXO WHILE EMPRESA = 8 WITH CDX

****************************************************************

USE \SCGC\CENTRAL\NOTA
SET ORDER TO TAG NOTA
SET NEAR ON

SEEK STR(8,3)
COPY TO \SCGC\LOJA04\NOTA WHILE EMPRESA = 8 WITH CDX

****************************************************************

USE \SCGC\CENTRAL\NOTAENT
SET ORDER TO TAG NOTA
SET NEAR ON

SEEK STR(8,3)
COPY TO \SCGC\LOJA04\NOTAENT WHILE EMPRESA = 8 WITH CDX

****************************************************************

USE \SCGC\CENTRAL\NOTAITE
SET ORDER TO TAG ITEMNOTA
SET NEAR ON

SEEK STR(8,3)
COPY TO \SCGC\LOJA04\NOTAITE WHILE EMPRESA = 8 WITH CDX

****************************************************************

USE \SCGC\CENTRAL\SALDO
SET ORDER TO TAG EMP_MES
SET NEAR ON

SEEK STR(8,3)
COPY TO \SCGC\LOJA04\SALDO WHILE EMPRESA = 8 WITH CDX

****************************************************************

USE \SCGC\CENTRAL\RETORNBC
SET ORDER TO TAG AVISO
SET NEAR ON

SEEK STR(8,3)
COPY TO \SCGC\LOJA04\RETORNBC WHILE EMPRESA = 8 WITH CDX

****************************************************************

USE \SCGC\CENTRAL\RETORNMV
SET ORDER TO TAG AVISO
SET NEAR ON

SEEK STR(8,3)
COPY TO \SCGC\LOJA04\RETORNMV WHILE EMPRESA = 8 WITH CDX

****************************************************************

USE \SCGC\CENTRAL\ORCAMENT
COPY STRU TO \SCGC\LOJA04\ORCAMENT  WITH CDX

****************************************************************

USE \SCGC\CENTRAL\ORCATMP
COPY STRU TO \SCGC\LOJA04\ORCATMP  WITH CDX

****************************************************************

USE \SCGC\CENTRAL\ORC_ANEX
COPY STRU TO \SCGC\LOJA04\ORC_ANEX  WITH CDX

****************************************************************

USE \SCGC\CENTRAL\PEDIDO
COPY STRU TO \SCGC\LOJA04\PEDIDO  WITH CDX

****************************************************************

USE \SCGC\CENTRAL\PEDITE
COPY STRU TO \SCGC\LOJA04\PEDITE  WITH CDX

****************************************************************

USE \SCGC\CENTRAL\PRVCBSTQ
COPY STRU TO \SCGC\LOJA04\PRVCBSTQ  WITH CDX

****************************************************************

USE \SCGC\CENTRAL\PRVITSTQ
COPY STRU TO \SCGC\LOJA04\PRVITSTQ  WITH CDX

****************************************************************

USE \SCGC\CENTRAL\REMESSBC
COPY STRU TO \SCGC\LOJA04\REMESSBC  WITH CDX

****************************************************************

USE \SCGC\CENTRAL\REMESSMV
COPY STRU TO \SCGC\LOJA04\REMESSMV  WITH CDX

****************************************************************

****************************************************************
***  SEPARACAO DE CLIENTES
****************************************************************

USE \SCGC\CENTRAL\NOTA
COPY TO \TMP\CLINF FIELDS FAVORECIDO FOR EMPRESA = 8 OR EMPRESA = 10

USE \SCGC\CENTRAL\DUPLICAT
SET ORDER TO TAG DOC OF Q:\SCGC\CENTRAL\DUPLICAT.CDX
SET NEAR ON
SEEK STR(10,3)
COPY TO \TMP\CLINF2 FIELDS CLIENTE  WHILE EMPRESA = 10


USE  \TMP\CLINF EXCL
APPEND FROM \TMP\CLINF2
INDEX ON FAVORECIDO TAG FAVORECIDO ADDITIVE
SET ORDER TO TAG FAVORECIDO

SELE 0
USE  \SCGC\CENTRAL\CLIENTES
SET RELATION TO CLIENTE  INTO CLINF
COPY TO \SCGC\LOJA04\CLIENTES FOR !EMPTY(CLINF.FAVORECIDO) WITH CDX
