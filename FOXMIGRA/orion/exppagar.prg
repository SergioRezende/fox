set talk on
set dele on
set date german
set centu on

*----> importando fornecedores para tabela de clientes
SELECT;
	001 AS EMPRESA;
	,FR.TP_PESSOA AS TP_PESSOA;
	,FR.CGC AS CLIENTE;
	,FR.NOME AS NOME;
	,FR.TP_INSCR AS TP_INSCR;
	,FR.INSCRICAO AS INSCRICAO;
	,FR.INSC_MUNI AS IM_TOMADOR;
	,FR.NOME AS FANTASIA;
	,FR.ENDERECO AS ENDERECO;
	,FR.BAIRRO AS BAIRRO;
	,FR.CIDADE AS CIDADE;
	,FR.ESTADO AS ESTADO;
	,FR.CEP AS CEP;
	,FR.MUNI_IBGE AS MUNI_IBGE;
	,FR.FONE AS FONE;
	,FR.NOME AS CBNOME;
	,FR.ENDERECO AS CBENDERECO;
	,FR.BAIRRO AS CBBAIRRO;
	,FR.CIDADE AS CBCIDADE;
	,FR.ESTADO AS CBESTADO;
	,FR.CEP AS CBCEP;
	,FR.MUNI_IBGE AS CBMUNI_IBGE;
	,FR.FONE AS CBFONE;
	,FR.DT_ALTER AS DTCAD;
FROM Q:\SCGC\COMUM\FORNECE FR;
where ;
fr.cgc not in ;
(select cliente from x:\scgc\loja\clientes) ;
INTO TABLE L:\TMP\CADTMP
	
close data
use x:\scgc\pagar\clientes	
append from L:\TMP\CADTMP
*----------------------------------------------------------------*
* importar contas a pagar para \scgc\pagar\duplicat
*----------------------------------------------------------------*
SET DELE ON
SET DATE GERMAN
SET CENTURY ON
set exclu off
SELECT ;
  pg.empresa     as EMPRESA ;
 ,'A PAGAR'      AS TIPO_DOC ;
 ,PG.FORNECEDOR  AS COD_FORN ;
 ,FR.CGC         AS FORNECEDOR;
 ,PG.TPDOCUMENT  AS COD_TP_DOC;
 ,0              AS CHQ_BANCO;
 ,0              AS CHQ_AGENCI;
 ,0              AS CHQ_NUMERO;
 ,''             AS CHQ_CTACOR;
 ,INT(VAL(  CHRTRAN(CHRTRAN(ALLTRIM(pg.referencia),'/',''),'.','')+ALLTRIM(STR(pg.sequencia,2)))) ;
                 AS DUPLICATA;
 ,ALLTRIM(pg.referencia)+'-'+ALLTRIM(STR(pg.sequencia,2))   AS CODPARCELA;
 ,PG.SEQUENCIA   AS SEQUENCIA;
 ,0              AS QTPARCELAS;
 ,0              AS CHQ_ORIGEM;
 ,''             AS CHQ_ORGDSC;
 ,900            AS BANCO ;
 ,0              AS AGENCIA;
 ,''             AS AGENCIA_DV;
 ,900            AS PORTADOR ;
 ,0              AS PAGA_EM;
 ,''             AS NUM_NO_BCO;
 ,0              AS TP_COBRAN;
 ,0              AS TP_PARCELA;
 ,0              AS MOEDA;
 ,FR.CGC         AS CLIENTE;
 ,PG.NOME_FORN   AS NOME;
 ,PG.REFERENCIA  AS ORCAMENTO;
 ,PG.REFERENCIA  AS NOTA;
 ,PG.DTEMISSAO   AS DT_EMI;
 ,PG.VALORPAGAR  AS VLR_DOC;
 ,PG.DTVENCIMTO  AS DT_VENC;
 ,0              AS DSP_COBR;
 ,0              AS OUT_DESP;
 ,PG.JUROS          AS JUROS;
 ,0              AS IOF;
 ,0              AS ABATIMENTO;
 ,PG.DESCONTO       AS DESCONTO;
 ,0              AS DEVOLUCAO;
 ,0              AS MORA;
 ,0              AS OUT_CREDT;
 ,PG.DTPGTO      AS DT_PGTO;
 ,0              AS PARC_PGTO;
 ,0              AS VLR_PGTO;
 ,'N'            AS TRF_CART;
 ,PG.DATABAIXA   AS DT_BAIXA;
 ,0              AS REGIAO;
 ,0              AS NATU;
 ,PG.DATA_LCTO   AS DTREGIS;
 ,PG.HORA_LCTO      AS HREGIS;
 ,1              AS USRREGIS;
 ,PG.OBSERVACAO  AS OBS;
FROM Q:\scgc\loja\ctpagar pg ,;
     Q:\scgc\loja\empresa emp, ;
     Q:\scgc\comum\fornece fr ;
where pg.empresa = emp.empresa ;
     and fr.codigo = pg.fornecedor ;
     AND PG.DTVENCIMTO >= {01.08.2012};
ORDER BY ;
   pg.empresa;
  ,PG.DTVENCIMTO ;  
INTO TABLE l:\TMP\PAGAR.DBF
close database

*-----ajustar numero da duplicata qdo for zerado

use q:\scgc\pagar\duplicat EXCL
zap
pack
append from l:\tmp\pagar.dbf
replace all duplicata with int(val(str(cod_forn,6,0)+chrtran(str(sequencia,3)," ",""))) for duplicata = 0

