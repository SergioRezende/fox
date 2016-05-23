      *
       IDENTIFICATION DIVISION.
      *
       PROGRAM-ID. CONVITEM.
       AUTHOR. LUIS AUGUSTO.
      *
      *    DATA DA ALTERACAO: 11/95
      *
      *    ESTE PROGRAMA GERA ARQ. TXT DE ITENS DE NOTAS DE SAIDA NOTAS
      *    ARQUIVO DE NOTAS FISCAIS - SAIDAS
       ENVIRONMENT DIVISION.
       CONFIGURATION SECTION.
       SPECIAL-NAMES.
           DECIMAL-POINT IS COMMA.
      *
       INPUT-OUTPUT SECTION.
       FILE-CONTROL.
      *
           SELECT      ARQ-TX     ASSIGN     TO   DISK
           ORGANIZATION IS LINE SEQUENTIAL
           FILE STATUS IS ESTADO.

      *
       DATA DIVISION.
       FILE SECTION.
      *
       FD  ARQ-TX
           LABEL     RECORD       STANDARD
           VALUE     OF FILE-ID   ARQNTFS-TX
           DATA      RECORD       ARQNTFS-REG-TX.
       01  ARQNTFS-REG-TX.
0001               15  FILIAL-NTFS-TX         PIC 9(02).
0005               15  NUMERO-NTFS-TX         PIC 9(06).
0441               15  CODIGO-NTFS-TX         PIC X(08).
0449               15  DESC-NTFS-TX           PIC X(25).
0474               15  QTD-NTFS-TX            PIC 9(05).
0477               15  VAL-UNIT-NTFS-TX       PIC 9(11).
0483               15  DESCONTO-NTFS-TX       PIC 9(02)V9(01).
0485               15  UNID-NTFS-TX           PIC X(02).
0487               15  GRUPO-COD-NTFS-TX      PIC 9(02).
0489               15  ISENTO-NTFS-TX         PIC X(01).
0490               15  TIPO-COD-NTFS-TX       PIC X(01).
0491               15  PESO-COD-NTFS-TX       PIC 9(04)V9(03).
0495               15  VAL-TAB-NTFS-TX        PIC 9(11).
0501               15  CST-NTFS-TX            PIC X(02).
       WORKING-STORAGE SECTION.
      *
       77  ESTADO                PIC X(02).
       77  LIDOS-77        VALUE 0             PIC 9(05).
       77  GRAVADOS-77     VALUE 0             PIC 9(05).
       77  DD-MM-77        VALUE ZEROS         PIC 99/99.
       77  I                                   PIC 9(02).
       77  E                                   PIC 9(02).
       
       01  INICIAL-WS                          PIC 9(04).
       01  FILLER REDEFINES INICIAL-WS.
           05  DIA-INI-WS                      PIC 9(02).
           05  MES-INI-WS                      PIC 9(02).
       01  FINAL-WS                            PIC 9(04).
       01  FILLER REDEFINES FINAL-WS.
           05  DIA-FIM-WS                      PIC 9(02).
           05  MES-FIM-WS                      PIC 9(02).
           
           COPY DADOS.
           COPY TELAWS.
           COPY CRIABT.

      *****************************************************************
      * REGISTRO DO ARQUIVO DE NOTAS DE SAIDA <REGNTFS.COB>
      * REGNTFS.COB                                                   *
      *****************************************************************
       01  DADOS-NTFS-WS.
           05  POS-NTFS-WS                     PIC X(128).
           05  TAM-NTFS-WS                     PIC 99 COMP-0 VALUE 1185.
      *         tamanho da parte fixa -->  503 bytes
      *         tamanho da pagina     --> 1024 (2 registros)
      *         parte variavel        -->  682 bytes
      *
       01  ARQNTFS-REG-WS.
           05  CHAVE-NTFS-WS.
0001           10  FILIAL-NTFS-WS             PIC 9(02).
0003           10  TIPO-NTFS-WS               PIC 9(01).
      *            NOTAS-FISCAIS = 1
      *            OUTRAS-SAIDAS = 2
      *            ENTRADAS      = 3
0004           10  TIPO-FAT-NTFS-WS           PIC 9(01).
      *            A-VISTA   = 1
      *            A-PRAZO   = 2
0005           10  NUMERO-NTFS-WS             PIC 9(06) COMP-3.
0009       05  CPF-CGC-NTFS-WS                PIC 9(14) COMP-3.
0017       05  OS-NTFS-WS OCCURS 5            PIC 9(06) COMP-3.
0037       05  TIPO-CLI-NTFS-WS               PIC 9(01).
0038       05  NOME-CLI-NTFS-WS               PIC X(40).
0078       05  END-CLI-NTFS-WS                PIC X(30).
0108       05  MUN-CLI-NTFS-WS                PIC X(22).
0130       05  BAIRRO-CLI-NTFS-WS             PIC X(14).
0144       05  CEP-CLI-NTFS-WS                PIC 9(05) COMP-3.
0147       05  UF-CLI-NTFS-WS                 PIC X(02).
0149       05  REGIAO-CLI-NTFS-WS             PIC 9(03) COMP-3.
0151       05  INSC-CLI-NTFS-WS               PIC 9(13) COMP-3.
0158       05  TEL-CLI-NTFS-WS                PIC 9(07) COMP-3.
0162       05  TIPO-SAI-NTFS-WS               PIC X(03).
0165       05  DESCR-SAI-NTFS-WS              PIC X(15).
0180       05  TIPO-VENDA-NTFS-WS             PIC 9(01).
      *        INTERNA = 1
      *        EXTERNA = 2
0181       05  TIPO-TRANSP-NTFS-WS            PIC 9(01).
      *        RODOVIARIO  = 1
      *        AEREO       = 2
      *        FERROVIARIO = 3
      *        MARITIMO    = 4
0182       05  IND-IMP-NTFS-WS                PIC 9(01).
      *        NENHUM         = 1
      *        SO-ICM         = 2
      *        ICM,PIS,FIN    = 3
      *        SO PIS,FIN     = 4
      *        ISS            = 5
      *        ICM P/ CONSTAR = 6
      *        ICM RETIDO     = 7
0183       05  IND-EST-NTFS-WS                PIC X(01).
      *        BAIXAR-EST = S
      *        NAO BAIXAR = N
0184       05  IND-EMISS-NTFS-WS              PIC X(01).
      *        EMITIR     = S
      *        NAO EMITIR = N
0185       05  IBGE-NTFS-WS                   PIC X(01).
      *        EMITE RESUMO     = S
      *        NAO EMITE RESUMO = N
0186       05  IND-TIPO-NTFS-WS               PIC 9(01).
      *        VENDA NORMAL     = 0
      *        TRANSF           = 1
      *        TRANSF NAO TRIB  = 2
      *        OUTRAS SAIDAS    = 3
      *        OUTRAS C/ IPI    = 4
      *        RECLAMACAO       = 5
0187       05  TAXA-NTFS-WS                   PIC 99V99 COMP-3.
0188       05  VENDEDOR-NTFS-WS               PIC 9(03) COMP-3.
0190       05  NATU-CLI-NTFS-WS               PIC 9(01).
0191       05  IND-ESTAT-NTFS-WS              PIC X(01).
      *        ATUALIZA-ESTATISTICA = S
      *        NAO ATUALIZA         = N
0192       05  TOTAL-NTFS-WS                  PIC 9(11) COMP-3.
0198       05  FRETE-NTFS-WS                  PIC 9(09) COMP-3.
0203       05  SEGURO-NTFS-WS                 PIC 9(09) COMP-3.
      *        Usado p/ guardar o valor da base de retencao
0208       05  MERCAD-NTFS-WS                 PIC 9(11) COMP-3.
0214       05  SERVICO-NTFS-WS                PIC 9(11) COMP-3.
0220       05  BASE-CALC-NTFS-WS              PIC 9(11) COMP-3.
0226       05  COD-TRANSP-NTFS-WS             PIC 9(03)  COMP-3.
0228       05  PLACA-NTFS-WS                  PIC X(06).
0234       05  PESO-NTFS-WS                   PIC 9(05)V9(03)  COMP-3.
0238       05  CARACTERIST-NTFS-WS            PIC X(30).
0268       05  OBS-NTFS-WS                    PIC X(66).
0334       05  VAL-DUP-NTFS-WS                PIC 9(11) COMP-3.
0340       05  VENC-DUP-NTFS-WS               PIC 9(06)  COMP-3.
0344       05  QTD-DUP-NTFS-WS                PIC 9(01).
0345       05  INTERV-DUP-NTFS-WS             PIC 9(02).
0347       05  DT-EMISS-NTFS-WS               PIC 9(06)  COMP-3.
0351       05  CFO-NTFS-WS                    PIC 9(03)  COMP-3.
0353       05  ALQ-ICM-NTFS-WS                PIC 9(02)V9(01) COMP-3.
0355       05  ALQ-ISS-NTFS-WS                PIC 9(02)V9(01) COMP-3.
0357       05  IND-CLI-NTFS-WS                PIC X(01).
      *        CLIENTE GRAVADO  = "S"
      *        CLIENTE ALTERADO = "A"
0358       05  VALOR-IPI-NTFS-WS              PIC 9(09) COMP-3.
0363       05  ATUALIZADO-NTFS-WS             PIC X(01).
0364       05  LIMITE-CLI-NTFS-WS             PIC 9(05) COMP-3.
0367       05  TIPO-ANT-NTFS-WS               PIC X(03).
0370       05  COBRANCA-NTFS-WS               PIC 9(03) COMP-3.
0372       05  VEND-CLI-NTFS-WS               PIC 9(03) COMP-3.
0374       05  TIPO-MONT-NTFS-WS              PIC X(01).
0375       05  CEP2-CLI-NTFS-WS               PIC 9(03) COMP-3.
0377       05  IND-COMPL-NTFS-WS              PIC X(01).
0378       05  CONV-NOVO-WS                   PIC X(01).
0379       05  AGENCIA-NTFS-WS                PIC 9(05) COMP-3.
0382       05  BASE-REDUZIDA-NTFS-WS          PIC X(01).
0383       05  BASE-RETIDO-NTFS-WS            PIC 9(11) COMP-3.
0389       05  VLR-RETIDO-NTFS-WS             PIC 9(11) COMP-3.
0395       05  FATURISTA-NTFS-WS              PIC X(05).
0400       05  FILLER-NTFS-WS                 PIC X(41).
      *
      *   - 1 ocorrencias fazem parte do tamanho do registro
      *   - tamanho de cada ocorrencia --> 62 bytes
      *   - 12 * 62 = 744
           05  TAB-NTFS-WS.
               10  ITENS-NTFS-WS OCCURS 12.
0441               15  CODIGO-NTFS-WS         PIC X(08).
0449               15  DESC-NTFS-WS           PIC X(25).
0474               15  QTD-NTFS-WS            PIC 9(05)  COMP-3.
0477               15  VAL-UNIT-NTFS-WS       PIC 9(11)  COMP-3.
0483               15  DESCONTO-NTFS-WS       PIC 9(02)V9(01) COMP-3.
0485               15  UNID-NTFS-WS           PIC X(02).
0487               15  GRUPO-COD-NTFS-WS      PIC 9(02).
0489               15  ISENTO-NTFS-WS         PIC X(01).
      *                ISENTO-DE-ICM = S
      *                NAO-ISENTO    = N
0490               15  TIPO-COD-NTFS-WS       PIC X(01).
      *                MERCADORIA = M
      *                SERVICO    = S
0491               15  PESO-COD-NTFS-WS       PIC 9(04)V9(03) COMP-3.
0495               15  VAL-TAB-NTFS-WS        PIC 9(11) COMP-3.
0501               15  CST-NTFS-WS            PIC X(02).
                   15  FILLER REDEFINES CST-NTFS-WS.
                       20  CST-ORIGEM-NTFS-WS  PIC 9(01).
                       20  CST-IMPOSTO-NTFS-WS PIC 9(01).
0503
       01  ARQNTFS-WS.
           05  U-NTFS-WS                       PIC X(01).
           05  FILLER VALUE ":MV"              PIC X(03).
           05  DATA-MV-WS                      PIC 9(04).
           05  FILIAL-MV-WS                    PIC 9(02).
           05  FILLER VALUE ".FAT"             PIC X(04).
       01  CHAVE-NTFS1.
           05  NUMERO-NTFS1                   PIC 9(06) COMP-3.
      *---------------------------------------------------------
      *
       01  ARQNTFS-TX.
           05  U-NTFS-TX                       PIC X(01).
           05  FILLER VALUE ":IT"              PIC X(03).
           05  DATA-MV-TX                      PIC 9(04).
           05  FILIAL-MV-TX                    PIC 9(02).
           05  FILLER VALUE ".FTX"             PIC X(04).


       PROCEDURE DIVISION.
      *
       INICIO-010.
           DISPLAY (1, 1) ERASE.
       015-DATAS.
           DISPLAY (5, 22) "* conversao notas SAIDAS EM TXT *"

           DISPLAY (10, 10) "Informe o Drive dos arqs:"
           ACCEPT (, ) U-NTFS-WS WITH PROMPT UPDATE
           ACCEPT ESCAPE-77 FROM ESCAPE KEY
           IF ESCAPE-77 NOT = ZEROS STOP RUN.
           MOVE U-NTFS-WS TO U-NTFS-TX.

           DISPLAY (11, 10) "Informe a Filial .......:"
           ACCEPT (, ) FILIAL-MV-WS WITH PROMPT UPDATE
           IF ESCAPE-77 NOT = ZEROS GO TO INICIO-010.
           MOVE FILIAL-MV-WS   TO FILIAL-MV-TX.

           DISPLAY (12, 10) "Data Inicial (dd/mm)....:"
           ACCEPT (, ) DD-MM-77 WITH PROMPT UPDATE
           IF ESCAPE-77 NOT = ZEROS GO TO INICIO-010.
           MOVE DD-MM-77 TO INICIAL-WS FINAL-WS

           IF DIA-INI-WS = ZEROS GO TO INICIO-010.
           DISPLAY (13, 10) "Data Final   (dd/mm)....:" DD-MM-77
           ACCEPT (13, 35) DIA-FIM-WS WITH PROMPT UPDATE
           IF ESCAPE-77 NOT = ZEROS GO TO INICIO-010.

           DISPLAY (14, 10) "LIDOS:      GRAVADOS:".
           MOVE FILIAL-MV-WS TO FILIAL-MV-TX
           SUBTRACT 1 FROM DIA-INI-WS.

       020-ABRE-ARQ.

           ADD 1 TO DIA-INI-WS
           IF DIA-INI-WS > DIA-FIM-WS
              GO TO 015-DATAS.
           MOVE INICIAL-WS TO DATA-MV-WS DATA-MV-TX

           OPEN OUTPUT ARQ-TX.

           MOVE 999 TO ERRO-WS CAN-WS
           MOVE ABRE-WS TO B-FUNC-WS

           MOVE -1 TO KEY-NUM-WS
           MOVE 999 TO ERRO-WS CAN-WS
           PERFORM MOVE-DADOS-NTFS
           CALL "BTVCAL" USING DADOS-WS

           IF  B-STATUS-WS = 12
               MOVE ARQNTFS-WS TO ARQBT-WS
               MOVE U-NTFS-WS TO LETRA1BT-WS 
               MOVE "P" TO LETRA2BT-WS
               MOVE "CRINTFS.BTV" TO DEFBT-WS
               CALL X"91" USING RESULT-77 F-77 CRIABT-WS
               MOVE ZEROS TO ERRO-WS CAN-WS
               MOVE ABRE-WS TO B-FUNC-WS
               CALL "BTVCAL" USING DADOS-WS.
           IF  B-STATUS-WS NOT = ZEROS
               MOVE RESET-WS TO B-FUNC-WS
               CALL "BTVCAL" USING DADOS-WS
               CLOSE ARQ-TX
               GO 020-ABRE-ARQ.

           MOVE 0 TO KEY-NUM-WS LIDOS-77 GRAVADOS-77
           MOVE LER-PRIMEIRO-WS TO B-FUNC-WS
           MOVE 09 TO ERRO-WS CAN-WS
           CALL "BTVCAL" USING DADOS-WS.
           

       LEITURA-020.
           IF B-STATUS-WS NOT = ZEROS
              MOVE FECHA-WS TO B-FUNC-WS
              CALL "BTVCAL" USING DADOS-WS
               CLOSE ARQ-TX
              GO 020-ABRE-ARQ.

           ADD 1 TO LIDOS-77 DISPLAY (14, 16) LIDOS-77

           MOVE REGISTRO-WS TO ARQNTFS-REG-WS.

           PERFORM VARYING I FROM 1 BY 1 UNTIL I = 13
            OR CODIGO-ANT-WS (I) = SPACES
               IF  CODIGO-ANT-WS (I) IS NOT = SPACES
	           MOVE  FILIAL-NTFS-WS         TO FILIAL-NTFS-TX
	           MOVE  NUMERO-NTFS-WS         TO NUMERO-NTFS-TX
                   MOVE  CODIGO-ANT-WS (I) TO CODIGO-NTFS-TX
                   MOVE  DESC-ANT-WS (I) TO DESC-NTFS-TX
                   MOVE  QTD-ANT-WS (I) TO QTD-NTFS-TX
                   MOVE  VAL-UNIT-ANT-WS (I) TO VAL-UNIT-NTFS-TX
                   MOVE  DESCONTO-ANT-WS (I) TO DESCONTO-NTFS-TX
                   MOVE  UNID-ANT-WS (I) TO UNID-NTFS-TX
                   MOVE  GRUPO-COD-ANT-WS (I) TO GRUPO-COD-NTFS-TX
                   MOVE  ISENTO-ANT-WS (I) TO ISENTO-NTFS-TX
                   MOVE  TIPO-COD-ANT-WS (I) TO TIPO-COD-NTFS-TX
                   MOVE  PESO-COD-ANT-WS (I) TO PESO-COD-NTFS-TX
                   MOVE  VAL-TAB-ANT-WS (I) TO VAL-TAB-NTFS-TX
                   MOVE  CST-NTFS-WS    (I) TO CST-NTFS-TX
	           WRITE ARQNTFS-REG-TX
	           ADD 1 TO GRAVADOS-77
	           DISPLAY (14, 32) GRAVADOS-77
                END-IF
           END-PERFORM

           DISPLAY (16, 32) NUMERO-NTFS-WS
           MOVE 09 TO ERRO-WS
           MOVE 0 TO KEY-NUM-WS
           MOVE LER-PROX-WS TO B-FUNC-WS
           CALL "BTVCAL" USING DADOS-WS
           GO TO LEITURA-020.
      *
      *     -------------------------->  "DADONTFS.COB"
       MOVE-DADOS-NTFS.
      *
           MOVE POS-NTFS-WS TO POS-WS
           MOVE ARQNTFS-WS TO NOME-ARQ-WS
           MOVE TAM-NTFS-WS TO TAMANHO-WS
           MOVE ARQNTFS-REG-WS TO REGISTRO-WS.
      *
       VOLTA-DADOS-NTFS.
           MOVE POS-WS TO POS-NTFS-WS
           MOVE ZERO TO ERRO-WS
           MOVE REGISTRO-WS TO ARQNTFS-REG-WS.
      *


