
use x:\scgc\comum\banco
sele 0
use x:\scgc\comum\tab002


"T"+LEFT(LStmp,1)+CHR(VAL(RIGHT(LStmp,2)))

SELECT  ;
    CHRTRAN(STR(BC.BANCO,3)," ","0"), ;
    TB.CODIGO,;
    TB.DESCRICAO ;
FROM ;
      x:\scgc\comum\tab002 TB ,;
      x:\scgc\comum\banco  BC ;
WHERE ;
      TB.TABELA = "T"+LEFT(STR(BC.BANCO,3),1)+CHR(VAL(RIGHT(STR(BC.BANCO,3),2)))
