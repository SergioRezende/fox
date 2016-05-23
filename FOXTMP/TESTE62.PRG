close all
sele 0
use q:\scgc2003\central\retornmv
sele 0
use q:\scgc\comum\tab002
select  RT.empresa, ;
 		RT.banco, ;
 		month(RT.dtprocesso) as MES, ;
        RT.OCORRENCIA,;
        TB.DESCRICAO,;
        COUNT(*);
 FROM TAB002 TB, RETORNMV RT;
 WHERE TB.TABELA = "RET" ;
       AND INT(VAL(TB.TABELA)) = RT.OCORRENCIA;
       AND YEAR(dtprocesso) = 2003 ;
 GROUP BY RT.empresa, ;
 		  RT.banco, ;
 		  RT.month(dtprocesso) as MES, ;
          RT.OCORRENCIA;
 ORDER BY RT.empresa, ;
 		  RT.banco, ;
 		  RT.month(dtprocesso) as MES, ;
          RT.OCORRENCIA

