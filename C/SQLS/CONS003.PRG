
*-----------------------------------------------------*
* 	Consulta o Numero de Atendimentos a Clientes
* de varejo que qdiquiriram mais de um pneu nos 
* meses de Dez/2001, Jan/2002 e Fev/2002
*-----------------------------------------------------*


SELECT 	IT.EMPRESA,;
		YEAR(IT.DTFAT) AS ANO,;
		MONTH(IT.DTFAT) AS MES,;
		IT.NOTA;
	FROM Q:\scgc\central\itemmov IT, ;
	     Q:\scgc\central\orcament OR ;
	WHERE 		IT.DTFAT 				>= {01.01.2002} ;
			AND IT.DTFAT 				<  {01.03.2002} ;
			AND IT.NATU_CLI 			= 0;
			AND IT.QTDE     			> 3;
			AND IT.CH_OPERA 			= "1";
			AND LEFT(IT.OPERACAO,1)  	= "S";
			AND IT.EMPRESA 				=  OR.EMPRESA ;
			AND IT.ORCAMENTO			=  OR.ORCAMENTO ;
			AND OR.TP_TRANSP 			= 1 ;
	GROUP BY IT.EMPRESA,ANO,MES,IT.NOTA ;
	INTO CURSOR TESTE

	
SELECT * FROM TESTE ;
	UNION;
SELECT 	IT.EMPRESA,;
		YEAR(IT.DTFAT) AS ANO,;
		MONTH(IT.DTFAT) AS MES,;
		IT.NOTA;
	FROM Q:\scgc2001\central\itemmov IT,;
		 Q:\scgc2001\central\orcament OR;
	WHERE 		IT.DTFAT 				>= {01.12.2001} ;
			AND IT.DTFAT 				<  {01.01.2002} ;
			AND IT.NATU_CLI 			= 0;
			AND IT.QTDE     			> 3;
			AND IT.CH_OPERA 			= "1";
			AND LEFT(IT.OPERACAO,1)  	= "S";
			AND IT.EMPRESA 				=  OR.EMPRESA ;
			AND IT.ORCAMENTO			=  OR.ORCAMENTO ;
			AND OR.TP_TRANSP 			= 1 ;
	GROUP BY IT.EMPRESA,ANO,MES,IT.NOTA ;
	INTO CURSOR TESTE2


 SELECT EMP.SIGLA, ;
		IT.ANO,;
		IT.MES,;
		COUNT(*);
	FROM TESTE2  IT, ;
		 Q:\SCGC\CENTRAL\EMPRESA EMP;
	WHERE IT.EMPRESA = EMP.EMPRESA;
	GROUP BY SIGLA,ANO,MES;
	ORDER BY SIGLA,ANO,MES
	
REPORT FORM TMP TO FILE L:\TMP\PRT0001A.REL	
	
