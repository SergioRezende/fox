*------------------------------------------------------------*
*     Pneus com Movimento 
*------------------------------------------------------------*

*-------------------------------------------------------------------*
*  Obtem dias sem venda de pneus que tenham registro de venda
*-------------------------------------------------------------------*
select EMP.empresa,EMP.SIGLA,max(IT.data) AS DATA,;
           (DATE()-max(IT.data)) AS DIAS,;
           IT.codigo,IT.descricao,it.sld_estq,SL.SLD_ATU ;
   from    Q:\scgc\CENTRAL\itemmov IT,;
           Q:\scgc\CENTRAL\saldo SL,;
           Q:\scgc\CENTRAL\empresa EMP;
   where    IT.EMPRESA = SL.EMPRESA;
        AND IT.EMPRESA = EMP.EMPRESA;
        AND YEAR(SL.DTABERT)  = YEAR(DATE()) ;
        AND MONTH(SL.DTABERT) = MONTH(DATE()) ;
        AND SL.SLD_ATU        > 0 ;
        AND LEFT(IT.CLASSIFICA,2) = "00" ;
        AND IT.CLASSIFICA     = SL.CLASSIFICA ;
        AND left(IT.OPERACAO,1)= "S" ;
        AND IT.CH_OPERA = "1"  ;
  group by EMP.EMPRESA,IT.codigo;
  ORDER BY EMP.EMPRESA,DIAS ;
  INTO CURSOR TMP_1



*-------------------------------------------------------------------*
*  Obtem dias sem venda de pneus que nao tenham registro de venda
*-------------------------------------------------------------------*

select EMP.empresa,EMP.SIGLA,SL.dt_saida AS DATA,;
           (DATE()-SL.dt_saida) AS DIAS,;
           SL.codigo,GR.descricao,SL.SLD_ATU ;
   from    Q:\scgc\COMUM\grupo GR,;
           Q:\scgc\CENTRAL\saldo SL,;
           Q:\scgc\CENTRAL\empresa EMP;
   where    ;
            SL.EMPRESA = EMP.EMPRESA;
        AND YEAR(SL.DTABERT)  = YEAR(DATE()) ;
        AND MONTH(SL.DTABERT) = MONTH(DATE()) ;
        AND SL.SLD_ATU        > 0 ;
        AND LEFT(SL.CLASSIFICA,2) = "00" ;
        AND SL.CLASSIFICA     = GR.CLASSIFICA ;
        AND SL.CODIGO NOT IN (SELECT CODIGO FROM TMP_1);
  group by EMP.EMPRESA,GR.codigo;
  ORDER BY EMP.EMPRESA,DIAS ;
  INTO CURSOR TMP_2




SELECT * FROM TMP_1;
   WHERE DATA < DATE()-60;
       and sld_estq > 0 ;
   ORDER BY EMPRESA, DIAS


*****   modif  REPORT PNEUPARA

report form PNEUPARA to file l:\tmp\prt0001a.rel
modif comm l:\tmp\prt0001a.rel


SELECT * FROM TMP_2;
   WHERE DATA < DATE()-60;
       and sld_estq > 0 ;
   ORDER BY EMPRESA, DIAS

report form PNEUPARA to file l:\tmp\prt0001b.rel
modif comm l:\tmp\prt0001b.rel
