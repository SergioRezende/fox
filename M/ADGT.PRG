create table ..\FOX\DOCFISCAIS ( ;
NAT_OPER C(40),;
IND_OPER C(1),;
TP_MOV C(7),;
IND_EMI C(1),;
MOD_DOC C(2),;
CDG_SIT C(9),;
NRO_DOC C(10),;
SERIE   C(3),;
MOD_NOTA C(2),;
CHVNFE   C(44),;
DGTCHVNFE C(1),;
DT_DOC    DATE,;
DT_ENTSAI DATE,;
DT_CANC   DATE,;
VLR_DOC   N(18,4),;
TPPG 	C(1),;
TPPGDESCR C(15),;
VLRDESC	  N(18,4),;
VLRABATENT N(18,4),;
VLR_MERCAD N(18,4),;
VLR_FRETE  N(18,4),;
VLR_SEGURO N(18,4),;
VLR_DESP   N(18,4),;
OUTDSPACES N(18,4),;
BC_ICMS    N(18,4),;
VLR_ICMS   N(18,4),;
BCICMS_RTD N(18,4),;
VLRICMSRTD N(18,4),;
BC_IPI     N(18,4),;
VL_IPI     N(18,4),;
VLR_PIS    N(18,4),;
VLR_COFINS N(18,4),;
VLR_PISRTD N(18,4),;
VLR_COFRTD N(18,4),;
INF_COMPLE C(120),;
NROPROCCON C(20),;
ORGPROCCON C(1),;
TPDOCIMPO  C(1),;
NRODOCIMPO C(10),;
VLRPISIMPO N(18,4),;
VLRCOFIMPO N(18,4),;
VLRSRVCONT N(18,4),;
VLRBCISSQN N(18,4),;
VLR_ISSQN  N(18,4),;
VLR_BCIRRF N(18,4),;
VLR_IRRF   N(18,4),;
VLR_BCPREV N(18,4),;
VLR_PREV N(18,4),;
AUTSEFAZCM C(10),;
NROPASSEFI C(10),;
TEMPERATUR N(6,1),;
CPFCNPJ    C(20),;
UF         C(2),;
IE         C(20),;
NOME       C(250),;
RAZAOSOC   C(100),;
TP_LOGRAD  C(20),;
LOGRADOURO C(60),;
NRO_LOGRAD C(10),;
COMPL_LOGR C(25),;
CEP        C(10),;
ZONA       C(15),;
MUNI_IBGE  C(10),;
MUNI_NOME  C(60),;
BAIRRO     C(60),;
PAIS       C(60),;
FONE       C(10),;
IE_SUBTRIB C(20),;
SUFRAMA    C(9),;
REF_NRODOC C(10),;
REF_SERIE  C(3),;
REF_DT_DOC DATE,;
REF_INDOPE C(1),;
REF_TPMOV  C(7),;
REF_INDEMI C(1),;
REF_MODDOC C(2),;
NRO_SERECF C(25),;
NRO_CX_ECF C(5),;
NRO_CPMECF C(10);
)







create table DOCFISITENS (
NRO_ITEM        C(5),
PROD_CODIGO     C(10),
PROD_DESCRICAO  C(60),
PROD_DESCR_COMPL C(60),
UN_TAB          C(3),
UN_VENDA        C(3),
UN_PADRAO       C(3),
UNIDADE         C(3),
CONV_UN_TAB_VDA N(18,6),
CONV_UN_VDA_PADRAO N(18,6),
PRECO_TAB       N(18,4),
PRECO_UN_VDA    N(18,4),
PRECO_MAX_TABELADO N(18,4),
PRECO_MIN_TABELADO N(18,4),
PRECO_UN_PADRAO N(18,4),
PRECO_UNITARIO  N(18,4),
QTDE_UN_VENDA   N(18,6),
QTDE_UN_PADRAO  N(18,6),
QTDE            N(18,6),
VLR_DESCONTO    N(18,4),
VLR_DESP_FINANCEIRA N(18,4),
VLR_OUTRAS_DESP_ACES N(18,4),
CUSTO_FRETE    N(18,4),
CUSTO_SEGURO   N(18,4),
VLR_FINAL       N(18,4),
MENSAGEM        C(250),
IND_MOVIMENTO_ESTQ C(3),
LOTE_QTDE_ITENS N(18,6),
LOTE_NRO        C(10),
LOTE_FABRICACAO DATE,
LOTE_VALIDADE   DATE
);

create table DOCFISTITULOS (
DFTT_ID              INTEGER                        not null,
DFTT_TP_CREDITO      C(2),
DFTT_DESCR_TITULO_CREDITO C(50),
DCFS_                C(10),
DFTT_QTDE_PARC       C(5)                     not null,
DFTT_STRING_DE_VENC  C(255),
DFTT_VLR_PRIMEIRA_PARC N(18,4)                  not null
);

create table DOCFISTRANSPORTE (
DFTR_ID              INTEGER                        not null,
DFTR_TEMPERATURA     N(6,1)                   not null,
DFTR_TP_FRETE        C(1)                     not null,
DFTR_TP_CARGA        C(1),
DFTR_PLACA_UF        C(2),
DFTR_PLACA_VEICULO   C(7),
DFTR_CPFCNPJ         C(20),
DFTR_NOME            C(60),
DFTR_UF              C(2),
DFTR_IE              C(20),
DFTR_TP_LOGRADOURO   C(20),
DFTR_LOGRADOURO      C(60),
DFTR_NRO             C(10),
DFTR_COMPLEMENTO     C(25),
DCFS_TRANSP_CEP_     C(10),
DCFS_PART_MUNI_IBGE2 C(10),
DFTR_MUNI_NOME       C(60),
DFTR_BAIRRO          C(60),
DFTR_PAIS            C(60),
DFTR_FONE            C(10),
DFTR_LOCAL_COLETA_CPFCNPJ C(20),
DFTR_LOCAL_COLETA_IE C(20),
DFTR_LOCAL_COLETA_NOME C(250),
DFTR_LOCAL_COLETA_MUNI_IBGE C(10),
DFTR_LOCAL_COLETA_ENDERECO C(100),
DFTR_LOCAL_ENTREGA_CPFCNPJ C(20),
DFTR_LOCAL_ENTREGA_IE C(20),
DFTR_LOCAL_ENTREGA_NOME C(250),
DFTR_LOCAL_ENTREGA_MUNI_IBGE C(10),
DFTR_LOCAL_ENTREGA_END C(100),
DFTR_QTDE_VOLUMES    N(18,6)                  not null,
DFTR_ESPECIE         C(5)                     not null,
DFTR_MARCA           C(5)                     not null,
DFTR_PESO_BRUTO      N(18,6)                  not null,
DFTR_PESO_LIQUIDO    N(18,6)                  not null,
DFTR_HORA_SAIDA      DATE                           not null
);

create table DOCFISTRBITENS (
DFTI_PK              INTEGER                        not null,
DFTI_VLR_A_TRIBUTAR  N(18,4)                  not null,
DFTI_CUSTO_NA_OPERACAO N(18,4)                  not null,
DFTI_CUSTO_MEDIO_ANT N(18,4)                  not null,
DFTI_SALDO_ANTERIOR  N(18,6)                  not null,
DFTI_CUSTO_MEDIO_ATUAL N(18,4)                  not null,
DFTI_SALDO_ATUAL     N(18,6)                  not null,
DFTI_CUSTO_CONTABIL  N(18,4)                  not null,
DFTI_CFO             C(5)                     not null,
DFTI_CST_ICMS        C(3)                     not null,
DFTI_CST_IPI         C(2)                     not null,
DFTI_CST_ISS         C(2)                     not null,
DFTI_CST_PIS         C(2)                     not null,
DFTI_CST_COFINS      C(2)                     not null,
DFTI_CST_IR          C(2)                     not null,
DFTI_BC_BRUTA_ICMS   N(18,4)                  not null,
DFTI_IND_REDUCAO     N(6,3)                   not null,
DFTI_BC_ICMS         N(18,4)                  not null,
DFTI_ALIQ_ICMS_ORIGEM N(6,3)                   not null,
DFTI_ALIQ_ICMS_DESTINO N(6,3)                   not null,
DFTI_DIF_ALIQUOTA    N(18,4)                  not null,
DFTI_ALIQ_ICMS       N(6,3)                   not null,
DFTI_VLR_ICMS        N(18,4)                  not null,
DFTI_REG_FISCAL_TRIB_ORIGEM C(23)                    not null,
DFTI_REG_FISCAL_TRIB_DESTINO C(23)                    not null,
DFTI_BASE_ISENTA_ICMS N(18,4)                  not null,
DFTI_BASE_OUTR_ICMS  N(18,4)                  not null,
DFTI_BC_BRUTA_RTD    N(18,4)                  not null,
DFTI_IVA             N(6,3)                   not null,
DFTI_BC_SUBST        N(18,4)                  not null,
DFTI_ALIQ_ICMS_SUBST N(6,3)                   not null,
DFTI_ICMS_SUBST_RTD_SAIDA N(18,4)                  not null,
DFTI_BC_BRUTA_RTD_ENTRADA N(18,4)                  not null,
DFTI_BC_RTD_ENTRADA  N(18,4)                  not null,
DFTI_ICMS_RTD_ENTRADA N(18,4)                  not null,
DFTI_IND_APURACAO_IPI C(9)                     not null,
DFTI_CON_ENQ_IPI     C(3)                     not null,
DFTI_BC_IPI          N(18,4)                  not null,
DFTI_ALIQ_IPI        N(6,3)                   not null,
DFTI_VLR_IPI         N(18,4)                  not null,
DFTI_BC_ISS          N(18,4)                  not null,
DFTI_ALIQ_ISS        N(6,3)                   not null,
DFTI_VLR_ISS         N(18,4)                  not null,
DFTI_BC_ISS_RTD      N(18,4)                  not null,
DFTI_ALIQ_ISS_RTD    N(6,3)                   not null,
DFTI_ISS_RTD         N(18,4)                  not null,
DFTI_BC_PIS          N(18,4)                  not null,
DFTI_ALIQ_PIS        N(6,3)                   not null,
DFTI_QTDE_BASE_PIS   N(18,6)                  not null,
DFTI_VLR_PIS         N(18,4)                  not null,
DFTI_PIS_RTD         N(18,4)                  not null,
DFTI_BC_COFINS       N(18,4)                  not null,
DFTI_ALIQ_COFINS     N(6,3)                   not null,
DFTI_QTDE_BASE_COFINS N(18,6)                  not null,
DFTI_VLR_COFINS      N(18,4)                  not null,
DFTI_COFINS_RTD      N(18,4)                  not null,
DFTI_BC_IR           N(18,4)                  not null,
DFTI_ALIQ_IR         N(6,3)                   not null,
DFTI_VLR_IR          N(18,4)                  not null,
DFTI_IR_RTD          N(18,4)                  not null,
DFTI_BC_CSLL         N(18,4)                  not null,
DFTI_ALIQ_CSLL       N(6,3)                   not null,
DFTI_VLR_CSLL        N(18,4)                  not null,
DFTI_ADIANTAMENTO_CSLL N(18,4)                  not null,
DFTI_LANC_AUTOMATICO C(3)                     not null
);

