set step on
set talk on
set date german
set centu on
close all
set dele  on
set excl off

use q:\scgc\central\duplicat alias dp

SELECT 2

use q:\scgc\central\retornmv alias rt


select str(rt.empresa,3)+str(rt.duplicata,9) as chvdup;
  from dp,rt ;
  where ;
        dp.empresa = rt.empresa;
    and dp.duplicata = rt.duplicata ;
    and (dp.banco = rt.banco and rt.ocorrencia = 15) ;
  into cursor tmpdup
  
  

select dp.empresa,;
       dp.duplicata,;
       dp.dt_emi,dp.nome,;
       dp.nota,;
       dp.vlr_pgto ;
  from dp,rt ;
  where ;
        dp.empresa = rt.empresa;
    and dp.duplicata = rt.duplicata ;
    and ((rt.banco= 1 and rt.ocorrencia = 96) ;
      or (rt.banco = 237 and rt.ocorrencia = 28);
      OR (rt.ocorrencia = 81)) ;
  into table \tmp\tmprel
       

 select * from \tmp\tmprel rt;
 where; 
     str(rt.empresa,3)+str(rt.duplicata,9)  ;
        not in (select chvdup from tmpdup);
  order by ;
	   empresa,;
       duplicata,;
       dt_emi,;
       nota;
  into table \tmp\duprel
