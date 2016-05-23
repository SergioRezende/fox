
use x:\scgc\comum\banco
sele 0
use x:\scgc\comum\tab002


"T"+LEFT(LStmp,1)+CHR(VAL(RIGHT(LStmp,2)))

SELECT * ;
    TB.TABEL,;
    BC.BANCO, ;
    TB.CODIGO,;
    TB.DESCRICAO ;
FROM ;
      x:\scgc\comum\tab002 TB ,;
      x:\scgc\comum\banco  BC ;
WHERE ;
      TB.TABELA = "T"+LEFT(BC.BANCO,1)+CHR(VAL(RIGHT(BC.BANCO,2)))      