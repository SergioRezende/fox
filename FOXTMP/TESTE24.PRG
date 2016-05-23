varejo
select EMPRESA,REFERENCIA;
	from O:\scgc2004\CENTRAL\nota ;
    where (natu_cli = 1 ) AND (EMPRESA = 2  OR EMPRESA = 3);
           and tipo <> "CPM" ;
           AND CH_OPERA = "1" ;
           AND STATUS <> 2;
           AND DATA >= {29.11.2004};
           AND DATA <= {11.12.2004};
group by   EMPRESA,REFERENCIA         
           

frota
select EMPRESA,REFERENCIA;
	from O:\scgc2004\CENTRAL\nota ;
    where (natu_cli = 3) AND (EMPRESA = 2  OR EMPRESA = 3);
           and tipo <> "CPM" ;
           AND CH_OPERA = "1" ;
           AND STATUS <> 2;
           AND DATA >= {29.11.2004};
           AND DATA <= {11.12.2004};
group by   EMPRESA,REFERENCIA         
           

revenda
select EMPRESA,REFERENCIA;
	from O:\scgc2004\CENTRAL\nota ;
    where (natu_cli = 1) AND (EMPRESA = 2  OR EMPRESA = 3);
           and tipo <> "CPM" ;
           AND CH_OPERA = "1" ;
           AND STATUS <> 2;
           AND DATA >= {29.11.2004};
           AND DATA <= {11.12.2004};
group by   EMPRESA,REFERENCIA         

pp
select EMPRESA,REFERENCIA;
	from O:\scgc2004\CENTRAL\nota ;
    where (natu_cli = 2) AND (EMPRESA = 2  OR EMPRESA = 3);
           and tipo <> "CPM" ;
           AND CH_OPERA = "1" ;
           AND STATUS <> 2;
           AND DATA >= {29.11.2004};
           AND DATA <= {11.12.2004};
group by   EMPRESA,REFERENCIA         



todos
select EMPRESA,nota;
	from O:\scgc2004\CENTRAL\nota ;
    where  (EMPRESA = 2  OR EMPRESA = 3);
           and tipo <> "CPM" ;
           AND CH_OPERA = "1" ;
           AND STATUS <> 2;
           AND DATA >= {29.11.2004};
           AND DATA <= {11.12.2004};
group by   EMPRESA,REFERENCIA         
