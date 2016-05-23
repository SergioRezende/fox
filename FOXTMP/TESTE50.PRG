
select pdd.pedido ,;
	   pdi.codforn,;
	   for.nome,;
	   pdi.classifica,;
	   pdi.codigo,;
	   grp.descricao,;
	   pdi.empresa,;
	   emp.nome as NOME_EMP,;
	   emp.sigla as SIGLA,;
	   IIF(pdi.EMPRESA=1,QTDE,0) AS qt_prvgyn,;
	   IIF(pdi.EMPRESA=2,QTDE,0) AS qt_prvsia,;
	   IIF(pdi.EMPRESA=4,QTDE,0) AS qt_prvbgs,;
	   IIF(pdi.EMPRESA=6,QTDE,0) AS qt_prvcgb,;
	   IIF(pdi.EMPRESA=8,QTDE,0) AS qt_prvarg;
  from d:\scgc\loja\empresa emp, ;
        d:\scgc\loja\pedido pdd, ;
        d:\scgc\comum\grupo grp, ;
        d:\scgc\comum\fornece for, ;
        d:\scgc\loja\pedite pdi ;
 where     pdd.pedido = 2306 ;
       and emp.empresa = wp_emp ;
       and pdi.codforn = for.codigo ;
	   and pdi.classifica = grp.classifica ;
	   and pdd.pedido = pdi.pedido ;
 group by pdi.pedido,pdi.codigo,pdi.codforn ;
 order by pdi.pedido,pdi.codforn,pdi.ordem,pdi.empresa 
