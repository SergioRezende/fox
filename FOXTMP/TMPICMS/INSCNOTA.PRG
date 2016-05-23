*-------------------------------------------------------------*
*  LISTAR CGC E NOME DOS CLIENTES QUE ESTAO COM INSCRICAO INVALIDO
*-------------------------------------------------------------*
ON ERROR
set procedure to rotinas.spr
use \scgc\LOJA\nota
on error
SET DELE ON
SET DATE GERMAN
set escape on
set talk off

GO TOP
COPY TO \FPD26\PROG\TMPICMS\INSCNOTA WITH CDX;
	FOR !UPInscricao(nota.uf,nota.INSCRICAO,1,0,0,'') 

