set excl off
set cent on
set date german
set dele on

select IT.empresa,EM.sigla,IT.NATU_CLI,TB.DESCRICAO AS DESC_NATU , IT.dtfat,IT.orcamento,IT.QTDE,IT.desconto,IT.prazomedio, ;
       IT.codigo, IT.descricao, CL.NOME ;
       FROM q:\scgc\central\orcament  OR, ;
       		q:\scgc\central\itemmov IT, ;
            q:\scgc\central\clienc  CL,;
            q:\scgc\central\empresa EM,;
            q:\scgc\comum\tab001 TB;
       WHERE  (OR.empresa = 1 or OR.empresa = 2 or OR.empresa = 5) ;
             AND OR.dt_fat >= {01.11.2001} ;
             AND OR.dt_fat <= {31.11.2001}  ;
			 AND LEFT(OR.SITUACAO,1) = "O" ;
			 AND OR.empresa   = IT.EMPRESA ;
			 AND OR.orcamento = IT.ORCAMENTO; 		
             AND LEFT(IT.classifica,5)='04044' ;
			 AND OR.EMPRESA   = CL.EMPRESA ;
             AND OR.ORCAMENTO = CL.ORCAMENTO ;
             AND OR.EMPRESA   = EM.EMPRESA ;
             AND 'NTZ'= TB.TABELA ;
             AND IT.NATU_CLI = VAL(TB.CODIGO) ; 
       ORDER BY IT.empresa,IT.natu_cli, IT.dtfat, IT.codigo

REPORT FORM Q:\FPD26\PROG\CONSUL~1\CONS0001.FRX TO PRINTER 
