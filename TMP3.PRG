   CLOSE DATA
   SET DELE ON
   SET DATE GERMAN
   SET CENTU ON



*-----------------------------------------------

    PrmEmpresa   = 1
    PrmAno       = 2011    
 
 
    PrmDir       ="Q:\SCGC2011\CENTRAL\"


*-----------------------------------------------
    * Os arquivos devem estar no dir q:\tmp\ com padrao nome EX: 2011_GYN.TXT
*-----------------------------------------------

    PrmPrfxArqTmp  ="Q:\TMP\"+STR(PrmAno,4)
    

    ARQ_SLD = PrmDir+"SALDO" 
    ARQ_ITEM = PrmDir+"ITEMMOV" 

*-----------------------------------------------


   USE  TMP_OMI_   EXCL
   ZAP 
   PACK
   
   DO CASE
   	CASE PrmEmpresa =  1   && GYN 

         TMPArq =  PrmPrfxArqTmp +  "_GYN.TXT"
         PrmSigla = "GYN"  
   
   	CASE PrmEmpresa =  14  && ANP

         TMPArq =  PrmPrfxArqTmp +  "_ANP.TXT"  
         PrmSigla = "ANP"  
   
   ENDCASE   
   
   
   APPEND FROM &TMPArq DELIMITED WITH TAB



*   =RELACAO()
  =limpa()
  =seleciona()


RETURN


FUNCTION SELECIONA

    SET TALK ON









*--------------------------
*     MONTA CURSOR IDENTIFICANDO OS CODIGOS DOS PRODUTOS
*    UNION
*     COM OS CODIGOS NAO LOCALIZADOS

*--------------------------

    select ;
         GRP.CODIGO    AS CODIGO, ;
         tmp.*  ;
    from ;
        TMP_OMI_  tmp, ;
        q:\scgc\comum\grupo grp ;
    where ;
        TMP.PRODUTOLIM ;
         =  ;
        GRP.DESCRLIMPA ;
    union;
    select ;
         "---------"   AS CODIGO, ;
         tmp.*  ;
    from ;
        TMP_OMI_  tmp ;
    where ;
        TMP.PRODUTOLIM NOT IN (SELECT GRP.DESCRLIMPA FROM q:\scgc\comum\grupo grp) ;
    INTO CURSOR TMP_CDG


*--------------------------

*  MONTA CURSOR DE saldo inicial mes janeiro

*--------------------------

    SELE 0



    SELECT ;
       TMP.CODIGO, ;
       int(SLD.SLD_ANTE)    AS SLD_INI;
    FROM ;
       TMP_CDG  TMP, ;
       &ARQ_SLD  SLD;
    WHERE ;
             SLD.EMPRESA = PrmEmpresa ;
         AND SLD.CODIGO = TMP.CODIGO ;
         AND YEAR(DTABERT) = PrmAno ;
         AND Month(DTABERT) = 1 ;
    into cursor SLD_INI

*--------------------------

*  MONTA CURSOR DE saldo inicial mes janeiro

*--------------------------

    SELE 0

    SELECT ;
       TMP.CODIGO, ;
       int(SLD.SLD_ATU)    AS SLD_FIN;
    FROM ;
       TMP_CDG  TMP, ;
       &ARQ_SLD SLD;
    WHERE ;
             SLD.EMPRESA = PrmEmpresa ;
         AND SLD.CODIGO = TMP.CODIGO ;
         AND YEAR(DTABERT) = PrmAno ;
         AND Month(DTABERT) = 12 ;
    into cursor SLD_FIN

*--------------------------

*  MONTA CURSOR DE ITEMMOV DE ITENS QUE NAO MOV ESTOQ + QLA/SCA

*--------------------------
    SELECT ;
       IT.CODIGO,; 
       IT.NOTA,;
       IT.TIPO,;
       IT.DATA,;
       IT.QTDE;
    FROM ;
           &ARQ_ITEM IT;
    WHERE ;
             IT.EMPRESA = PrmEmpresa ;
           AND ;
              ( IT.MOVESTQ = "N" OR IT.TIPO $ "QLA/SCA" );
    INTO CURSOR ;
       TMP_ITEM


*--------------------------
*    MONTA CURSOR DE ITEMMOV DE ITENS QUE NAO MOV ESTOQ + QLA/SCA
*  UNION
*    CUSOR DOS CODIGO NAO LOCALIZADOS   
*
*--------------------------
        
 

    SELE 0

    SELECT ;
       TMP.CODIGO, ;
       TMP.PRODUTO, ;
       IT.NOTA         AS NF_NRO,;
       IT.TIPO         AS NF_TIPO,;
       IT.DATA         AS NF_DATA,;
       IT.QTDE         AS NF_QTDE,;
       TMP.OMISSAO_EN  AS OMIS_ENT,;
       TMP.OMISSAO_SA  AS OMIS_SDA,;
       " Ini->"        AS T1,;
       SLI.sld_ini     AS PNL_SLI,;
       TMP.ESTQ_INICI  AS SFZ_SLI,;       
       " Fin->"        AS T1,;
       SLF.sld_fin     AS PNL_SLF,;
       TMP.ESTQ_FINAL  AS SFZ_SLF;       
    FROM ;
       TMP_CDG  TMP, ;
       TMP_ITEM IT,;
       SLD_INI SLI,;
       SLD_FIN SLF;
    WHERE ;
             IT.CODIGO = TMP.CODIGO ;
        AND SLI.CODIGO = TMP.CODIGO ;
        AND SLF.CODIGO = TMP.CODIGO ;
    INTO CURSOR RESULT1
    
    
    SELECT ;
       * ;
    FROM RESULT1 ;
    UNION ;
        SELECT ;
       TMP.CODIGO, ;
       TMP.PRODUTO, ;
       000000          AS NF_NRO,;
       "---"           AS NF_TIPO,;
       {}              AS NF_DATA,;
       000000          AS NF_QTDE,;
       TMP.OMISSAO_EN  AS OMIS_ENT,;
       TMP.OMISSAO_SA  AS OMIS_SDA,;
       " Ini->"        AS T1,;
       SLI.sld_ini     AS PNL_SLI,;
       TMP.ESTQ_INICI  AS SFZ_SLI,;       
       " Fin->"        AS T1,;
       SLF.sld_fin     AS PNL_SLF,;
       TMP.ESTQ_FINAL  AS SFZ_SLF;       
    FROM ;
       TMP_CDG TMP, ;
       SLD_INI SLI,;
       SLD_FIN SLF;
    WHERE ;
            SLI.CODIGO = TMP.CODIGO ;
        AND SLF.CODIGO = TMP.CODIGO ;
        AND TMP.CODIGO ;
       NOT IN ;
       ( ; 
          SELECT IT.CODIGO ;
             FROM ;
              TMP_CDG  TMP, ;
              TMP_ITEM IT;
          WHERE ;
               IT.CODIGO = TMP.CODIGO ;
       ) ;
    INTO CURSOR RESULT2
       







    SELECT ;
       * ;
    FROM RESULT2 ;
    UNION ;
        SELECT ;
       TMP.CODIGO, ;
       TMP.PRODUTO, ;
       000000          AS NF_NRO,;
       "---"           AS NF_TIPO,;
       {}              AS NF_DATA,;
       000000          AS NF_QTDE,;
       TMP.OMISSAO_EN  AS OMIS_ENT,;
       TMP.OMISSAO_SA  AS OMIS_SDA,;
       " Ini->"        AS T1,;
       0               AS PNL_SLI,;
       TMP.ESTQ_INICI  AS SFZ_SLI,;       
       " Fin->"        AS T1,;
       0               AS PNL_SLF,;
       TMP.ESTQ_FINAL  AS SFZ_SLF;       
    FROM ;
       TMP_CDG  TMP ;
    WHERE ;
       TMP.CODIGO ;
       NOT IN ;
       ( ; 
          SELECT TMP.CODIGO ;
             FROM ;
              TMP_CDG  TMP, ;
              SLD_INI SLI,;
              SLD_FIN SLF;
          WHERE ;
               SLI.CODIGO = TMP.CODIGO ;
           AND SLF.CODIGO = TMP.CODIGO ;
       ) ;
    INTO TABLE X:\TMP\RESULT
   


       
***          IT.TIPO $ "VLG/VLH/VLI/VLJ/QLA/SCA" ; 




RETURN






FUNCTION LIMPA
  CLOSE DATA
  
  USE q:\scgc\comum\grupo EXCL
  REPLACE ALL DESCRLIMPA WITH LCFLimpaString(UPPER(ALLTRIM(DESCRICAO)))


  USE TMP_OMI_ EXCL
  REPLACE ALL PRODUTOLIM WITH LCFLimpaString(UPPER(ALLTRIM(PRODUTO)))



RETURN     




FUNCTION LCFLimpaString
PARAMETERS PrmString
	*-------------------------------------------------------*
	PRIVATE LSstatus
	LSstatus = "" 
	*-------------------------------------------------------*


	PRMString = UPPER(PRMString)

*    IF "TURANZA" $ PRMSTRING
*       set step on
*    ENDIF


	PRMString = chrtran(PRMString,"€","C")       && 01
	PRMString = chrtran(PRMString,"‡","c")       && 02
	PRMString = chrtran(PRMString,"¦","-")       && 04
	PRMString = chrtran(PRMString,"§","-")       && 05
	PRMString = chrtran(PRMString,"°",'')        && 06
	PRMString = chrtran(PRMString,"º",'')        && 07
	PRMString = chrtran(PRMString,"",'E')       && 08
	PRMString = chrtran(PRMString,"‚",'e')       && 09
	PRMString = chrtran(PRMString,"Ç",'A')       && 10
	PRMString = chrtran(PRMString,"Æ",'a')       && 11
	PRMString = chrtran(PRMString,"ø",'')        && 12
	PRMString = chrtran(PRMString,chr(0),'')     && 13
	PRMString = chrtran(PRMString,'"','')        && 14
	PRMString = chrtran(PRMString,'Ã','A')        && 14
	PRMString = chrtran(PRMString,'>',' ')        && 14
	PRMString = chrtran(PRMString,'<',' ')        && 14
	
	PRMString = chrtran(PRMString,'/',' ')        && 14
	PRMString = chrtran(PRMString,'.',' ')        && 14
	PRMString = chrtran(PRMString,'-',' ')        && 14


	PRMString = chrtran(PRMString,' ','')        && 14


	PRMString = strtran(PRMString,"&","&amp;")       && 03
	


RETURN(PrmString)


FUNCTION RELACAO
  CLOSE DATA
  
  SELE 0  
  USE  X:\TMP\GRP.DBF EXCL
  SET ORDER TO TAG DESCRLIMPA

  SELE 0  

  USE TMP_OMI_
  SET RELATION TO ALLTRIM(PRODUTO) INTO GRP
     
     
 BROWSE FIELDS TMP_OMI_.PRODUTO,GRP.DESCRLIMPA

RETURN


FUNCTION COPITEMMOV

   USE &ARQ_ITEM 
   SET ORDER TO TAG MOVSIMPLES
 
 
   SELECT ;
       PrmSigla    AS LOJA,;
       CODIGO      ,;
       DATA        AS DT_EMISSA,   ;
       DTFAT       AS DT_FAT_ENT,;
       NOTA     ,;
       MOVESTQ,;
       OPERACAO    AS OPER,;
       QTDE,;
       0           AS SALDO,;
       CFO,;
       ""          AS CFOP_DESCRICAO,;
       UNIDADE ,;
       DESCRICAO,;
       TIPO,;
       OPERACAO,;
       FAVORECIDO;
    FROM &ARQ_ITEM   ;
       WHERE      EMPRESA  = PrmEmpresa ;
         AND YEAR(DATA)  = PrmAno ;
    INTO TABLE  x:\tmp\tb_dbf

         
        
   



RETURN

