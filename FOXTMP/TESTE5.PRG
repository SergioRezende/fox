
    SELECT GR.*, PR.PRECO,PR.CLAS_CMS,;
            PRM.desc_varej,PRM.desc_frota,PRM.desc_reven,PRM.desc_ppubl;
        FROM TMPGRUPO GR,;
             Q:\SCGC\LOJA\PRECO PR,;
             Q:\SCGC\COMUM\PROMOCAO PRM       ;
        WHERE ;
                   GR.codigo       = PR.codigo;
               AND LNempReferencia = PR.EMPRESA;
               AND m.tbbase        = PR.TABPRECO;
               AND m.sbase         = PR.SERIE;
              ;
               AND LNempReferencia = PRM.EMPRESA    ;
               AND GR.codigo       = PRM.codigo ;
               AND PRM.DT_INICIO  <= DATE()   ;
               AND PRM.DT_FIM     >= DATE()  ;
        INTO CURSOR TMPPROMO



    SELECT GR.*, PR.PRECO,PR.CLAS_CMS,;
            cms.desc_varej,cms.desc_frota,cms.desc_reven,cms.desc_ppubl;
        FROM TMPGRUPO GR,;
             Q:\SCGC\LOJA\PRECO PR,;
             Q:\SCGC\LOJA\PROD_CMS CMS;
        WHERE ;
                   GR.codigo       = PR.codigo;
               AND LNempReferencia = PR.EMPRESA;
               AND m.tbbase        = PR.TABPRECO;
               AND m.sbase         = PR.SERIE;
               AND m.empbase       = CMS.EMPRESA;
               AND m.tbbase        = CMS.TABPRECO;
               AND m.sbase         = CMS.SERIE;
               AND PR.clas_cms     = CMS.CODIGO;
               AND CMS.NIVEL       = 0;
               AND GR.CODIGO  not IN (SELECT CODIGO FROM TMPPROMO);
        INTO CURSOR TMPPRECO
  
       SELECT * FROM TMPPRECO UNION SELECT * FROM TMPPROMO ;
        INTO CURSOR TMPPRINT 
