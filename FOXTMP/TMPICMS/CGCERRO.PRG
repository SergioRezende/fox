*-------------------------------------------------------------*
*  LISTAR CGC E NOME DOS CLIENTES QUE ESTAO COM CGC INVALIDO
*-------------------------------------------------------------*
ON ERROR
set procedure to rotinas.spr
use \scgc\central\clientes
on error
SET DELE ON
SET DATE GERMAN
set escape on
set talk off
* GO TOP
* list fields cliente,RIGHT(FONE,8),left(nome,32),LEFT(CIDADE,10) for Calc_cgc(cliente) = "3" ;
*	TO \FPD26\PROG\TMPICMS\CGCERRO1.TXT OFF

* GO TOP
* list fields cliente,RIGHT(FONE,8),left(nome,32),LEFT(CIDADE,10) for ULT_ATEND > {01.01.1997} and Calc_cgc(cliente) = "3" ;
* 	TO \FPD26\PROG\TMPICMS\CGCERRO2.TXT OFF
 GO TOP
 list fields cliente,RIGHT(FONE,8),left(nome,32),LEFT(CIDADE,10) for ULT_ATEND > {01.12.1999} and Calc_cgc(cliente) = "3" ;
 	TO \FPD26\PROG\TMPICMS\CGCERRO2.TXT OFF

