SELECT  REGIAO,DATA,;
        IIF(nota.tp_parcela = 1,nota.total_nota - nota.icms_subs,0) AS AVISTA,;
        IIF(nota.tp_parcela = 1,nota.total_nota - nota.icms_subs,0) AS AVISTA,;
        
   
  FROM Q:\SCGC\LOJA\NOTA NF
  WHERE     nf.status = 1 ;
        AND left(nf.tipo,1) = "V" ;
        AND nf.empresa = 1 ;
        AND nf.data > date() - 30;
        AND nf.data < date() ;
        AND nf.ch_produ = "1" ;
        

SELECT  REGIAO,DATA,;
        IIF(dp.dt_venc = dt_emi,nota.total_nota - nota.icms_subs,0) AS AVISTA,;
        IIF(nota.tp_parcela = 1,nota.total_nota - nota.icms_subs,0) AS AVISTA,;
        
   
  FROM Q:\SCGC\LOJA\NOTA NF
  WHERE     nf.status = 1 ;
        AND left(nf.tipo,1) = "V" ;
        AND nf.empresa = 1 ;
        AND nf.data > date() - 30;
        AND nf.data < date() ;
        AND nf.ch_produ = "1" ;
        
       