
DO AMB

SET STEP ON

SELECT 0
use q:\scgc\central\notaent


SELECT 0
use q:\scgc\central\notaite
SET ORDER TO TAG ITEMNOTA



SELECT 0
use q:\scgc\central\itemmov
SET ORDER TO TAG it_nf_real 


sele notaent


set relatio to;
    STR(EMPRESA,3)+LEFT(TIPO,1)+STR(CODFORN,5)+STR(NOTA,6) ;
    into notaite

SET SKIP TO notaite
    
sele notaite
    
set relation to ;
  STR(EMPRESA,3)+CODIGO+STR(FAVORECIDO,14)+TIPO+;
  STR(NOTA,7)+DTOS(DTFAT)+STR(ORDEM,3);
 into itemmov


SET SKIP TO ITEMMOV

sele notaent



COPY FIELDS ;
  notaent.EMPRESA,notaent.FAVORECIDO,notaent.TIPO,notaent.NOTA,;
  notaent.data,notaent.total_nota,itemmov.vlrvenda,;
  notaent.referencia,;
  notaent.codforn,;
  notaite.movestq,;
  itemmov.vlripi,;
  itemmov.icms_subs ;
  TO X:\TMP\TAB ;
  FOR ;
   LEFT(notaent.SITUACAO,1) = "C";




select ;
  EMPRESA,;
  FAVORECIDO,;
  movestq,;
  TIPO,;
  NOTA,;
  data,;
  total_nota,;
  referencia,;
  codforn,;
  sum(vlrvenda+icms_subs+vlripi) as tot_itens ;
from X:\TMP\TAB ;
GROUP BY ;
  EMPRESA,;
  FAVORECIDO,;
  movestq,;
  TIPO,;
  NOTA,;
  data,;
  total_nota,;
  referencia,;
  codforn;
WHERE ;
   DATA > {10.11.2014} ;
   AND   movestq = "S";
ORDER  BY ;
  EMPRESA,;
  FAVORECIDO,;
  movestq,;
  TIPO,;
  NOTA,;
  data,;
  total_nota;
HAVING ;
   ABS(TOTAL_NOTA - SUM(VLRVENDA+ICMS_SUBS+vlripi)) > 1 ;
INTO TABLE X:\TMP\OS_ERRO




* APAGAR MOTAS DE ENTRADA


SET STEP ON

* REPOCESSA ENTRADAS SEM ITENS




IF !USED("OS_ERRO")
	sele 0
	use X:\TMP\OS_ERRO
ENDIF

sele OS_ERRO
GO TOP



DO WHILE !EOF()

	*-------------------------------------------------------------------*
	=W_DEFPROC("NOTAENT.SPR")
	=NECanc_Entrada(OS_ERRO.empresa,OS_ERRO.referencia,OS_ERRO.codforn)
	*----------------------------------------------------------*



	=W_DEFPROC("NOTAENT.SPR")

	=NEReg_Entrada(OS_ERRO.empresa,;
	               OS_ERRO.referencia,;
	               OS_ERRO.codforn,;
	               "PROCESSO ENTRADA")

  
    sele OS_ERRO
    SKIP

ENDDO
