PARAMETERS PrmEmp

close all
set date german
set centu on


SET STEP ON

*----------------------------*
*   1 - CADASTRAR BANCO
*----------------------------*

use q:\scgc\comum\banco
SET ORDER TO TAG BANCO


SEEK 867
IF !FOUND()
   APPEND BLANK
   =RLOCK()
   REPLACE BANCO      WITH 867
   REPLACE NOME       WITH "Brasil Card"
   REPLACE TP_LANCAME WITH "EXTRA CAIXA"
ENDIF
   
*----------------------------*
*   2 - CADASTRAR COBRANCA
*----------------------------*

use q:\scgc\comum\COBRANCA
SET ORDER TO TAG BANCO


SEEK STR(PrmEmp,3)+STR(867,3)   && BRASIL CARD

IF !FOUND()
   APPEND BLANK
   =RLOCK()

   REPLACE LOJA       WITH PrmEmp
   REPLACE BANCO      WITH 867
   REPLACE OPERACAO   WITH "FINANCIAMENTO"
   REPLACE BANCO_NOME WITH "BRASIL CARD"
   REPLACE TP_INSCR   WITH "99"
ENDIF


*----------------------------*
*   3 - CADASTRAR PG_PRMTD
*----------------------------*

use q:\scgc\comum\pg_prmtd
SET ORDER TO TAG PG_PRMTD


*-------------------------------------*
M.BANCO   = 867
M.TP_PARCELA = 1
M.MOEDA      = 5
M.MODO_PGTO  = 2


SEEK ;
    STR(M.TP_PARCELA,1);
   +STR(M.MODO_PGTO,1);
   +STR(M.MOEDA,2);
   +STR(M.BANCO,3)

IF !FOUND()
   APPEND BLANK
   =RLOCK()
   GATHER MEMVAR
   

ENDIF
*-------------------------------------*
*-------------------------------------*
M.BANCO   = 867
M.TP_PARCELA = 4
M.MOEDA      = 5
M.MODO_PGTO  = 2


SEEK ;
    STR(M.TP_PARCELA,1);
   +STR(M.MODO_PGTO,1);
   +STR(M.MOEDA,2);
   +STR(M.BANCO,3)

IF !FOUND()
   APPEND BLANK
   =RLOCK()
   GATHER MEMVAR
   

ENDIF
*-------------------------------------*
*-------------------------------------*
M.BANCO   = 867
M.TP_PARCELA = 5
M.MOEDA      = 5
M.MODO_PGTO  = 2


SEEK ;
    STR(M.TP_PARCELA,1);
   +STR(M.MODO_PGTO,1);
   +STR(M.MOEDA,2);
   +STR(M.BANCO,3)

IF !FOUND()
   APPEND BLANK
   =RLOCK()
   GATHER MEMVAR
   

ENDIF
*-------------------------------------*
