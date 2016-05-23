set talk on
set date german
set centu on
close all
use q:\scgc\central\duplicatc alias dp

SELECT 2

use q:\scgc\central\retornmv alias rt

select dp.empresa,;
       dp.duplicata,;
       dp.dt_emi,;
       dp.nota,;
       dp.vlr_pgto ;
  from dp,rt ;
  where ;
        dp.vlr_pgto = 0 ;
    and dp.empresa = rt.empresa;
    and dp.duplicata = rt.duplicata ;
    and (rt.ocorrencia = 05 or rt.ocorrencia = 06 or rt.ocorrencia = 15);
  order by ;
	   dp.empresa,;
       dp.duplicata,;
       dp.dt_emi,;
       dp.nota

