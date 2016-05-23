
      *
       IDENTIFICATION DIVISION.
      *
       PROGRAM-ID. CONVENTR.
       AUTHOR. LUIS AUGUSTO.
      *
      *    DATA DA ALTERACAO: 11/95
      *
      *    ESTE PROGRAMA GERA ARQ. TXT DE NOTAS
      *    ARQUIVO DE NOTAS FISCAIS - ENTRADAS
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

           SELECT      ARQ-IT     ASSIGN     TO   DISK
           ORGANIZATION IS LINE SEQUENTIAL
           FILE STATUS IS ESTADO.
      *
       DATA DIVISION.
       FILE SECTION.
      *
       FD  ARQ-TX
           LABEL     RECORD       STANDARD
           VALUE     OF FILE-ID   ARQNTENT-TX
           DATA      RECORD       ARQNTENT-REG-TX.
       01  ARQNTENT-REG-TX.
           05  CHAVE-NTENT-TX.
               10  FILIAL-NTENT-TX             PIC 9(02).
               10  TIPO-NTENT-TX               PIC 9(01).
               10  FORN-NTENT-TX               PIC 9(04).
               10  NUMERO-NTENT-TX             PIC 9(06).
           05  PEDIDO-NTENT-TX                 PIC 9(06).
           05  DT-EMISS-NTENT-TX               PIC 9(06).
           05  TIPO-ENT-NTENT-TX               PIC X(03).
           05  IND-EST-NTENT-TX                PIC X(01).
           05  ESTAT-NTENT-TX                  PIC X(01).
           05  IND-TIPO-NTENT-TX               PIC 9(01).
           05  TOTAL-NTENT-TX                  PIC 9(13).
           05  FRETE-NTENT-TX                  PIC 9(11).
           05  CONHEC-NTENT-TX                 PIC 9(11).
           05  BASE-CALC-NTENT-TX              PIC 9(13).
           05  CFO-NTENT-TX                    PIC 9(03).
           05  ALQ-ICM-NTENT-TX                PIC 99V9.
           05  FILIAL-TRANS-NTENT-TX           PIC X(03).
           05  IND-CRI-NTENT-TX                PIC X(01).
           05  IND-MEDIO-NTENT-TX              PIC X(01).
           05  SERIE-NTENT-TX                  PIC X(03).
           05  DT-NTF-NTENT-TX                 PIC 9(06).
           05  IND-ATU-NTENT-TX                PIC X(01).
           05  ICM-NTENT-TX                    PIC 9(13).
           05  RETIDO-NTENT-TX                 PIC 9(11).
           05  BASE-RET-NTENT-TX               PIC 9(13).
           05  FILLER                          PIC X(01).

       FD  ARQ-IT
           LABEL     RECORD       STANDARD
           VALUE     OF FILE-ID   ARQNTENT-IT
           DATA      RECORD       ARQNTENT-REG-IT.
       01  ARQNTENT-REG-IT.
               05  FILIAL-NTENT-IT         PIC 9(02).
               05  TIPO-NTENT-IT           PIC 9(01).
               05  FORN-NTENT-IT           PIC 9(04).
               05  NUMERO-NTENT-IT         PIC 9(06).
               05  QTD-NTENT-IT            PIC 9(05).
               05  CODIGO-NTENT-IT         PIC X(08).
               05  VAL-UNIT-NTENT-IT       PIC 9(13).
               05  VAL-DESC-NTENT-IT       PIC 9(11).
               05  VAL-IPI-NTENT-IT        PIC 9(11).
               05  GRUPO-COD-NTENT-IT      PIC 9(02).
               05  ISENTO-NTENT-IT         PIC X(01).


       WORKING-STORAGE SECTION.
      *
       77  ESTADO                PIC X(02).
       77  LIDOS-77        VALUE 0             PIC 9(05).
       77  GRAVADOS-77     VALUE 0             PIC 9(05).
       77  GRAVADOS2-77     VALUE 0             PIC 9(05).
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
      * --------------------------------------------------------
      * REGISTRO DO ARQUIVO DE NOTAS DE ENTRADA <REGNTENT.COB>*
      * --------------------------------------------------------
       01  DADOS-NTENT-WS.
           05  POS-NTENT-WS                    PIC X(128).
           05  TAM-NTENT-WS                    PIC 99 COMP-0 VALUE 749.
      *         tamanho da parte fixa --> 247 bytes
      *         tamanho da pagina     --> 512 (2 registros)
      *         parte variavel        --> 495 bytes
       01  ARQNTENT-WS.
           05  U-NTENT-WS                      PIC X(01).
           05  FILLER VALUE ":EN"              PIC X(03).
           05  DATA-EN-WS                   PIC 9(04).
           05  FILIAL-EN-WS                  PIC 9(02).
           05  FILLER VALUE ".EST"             PIC X(04).
      *
       01  ARQNTENT-REG-WS.
           05  CHAVE-NTENT-WS.
               10  FILIAL-NTENT-WS             PIC 9(02).
               10  TIPO-NTENT-WS               PIC 9(01).
      *            NOTAS FISCAIS   = 1
      *            OUTRAS-ENTRADAS = 2, 3
               10  FORN-NTENT-WS               PIC 9(04).
               10  NUMERO-NTENT-WS             PIC 9(06) COMP-3.
           05  PEDIDO-NTENT-WS                 PIC 9(06) COMP-3.
           05  DT-EMISS-NTENT-WS               PIC 9(06) COMP-3.
           05  TIPO-ENT-NTENT-WS               PIC X(03).
           05  IND-EST-NTENT-WS                PIC X(01).
      *        ATUALIZAR-EST = S
      *        NAO ATUALIZAR = N
           05  ESTAT-NTENT-WS                  PIC X(01).
      *        ALIMENTA ESTATISTICA = S
      *        NAO ALIMENTA         = N
           05  IND-TIPO-NTENT-WS               PIC 9(01).
      *        ENTRADAS        = 0
      *        TRANSF          = 1
      *        TRANSF NAO TRIB = 2
      *        OUTRAS ENTRADAS = 3
      *        RECLAMACAO      = 4
      *        CARCACA         = 5
           05  TOTAL-NTENT-WS                  PIC 9(13) COMP-3.
           05  FRETE-NTENT-WS                  PIC 9(11) COMP-3.
           05  CONHEC-NTENT-WS                 PIC 9(11) COMP-3.
           05  BASE-CALC-NTENT-WS              PIC 9(13) COMP-3.
           05  CFO-NTENT-WS                    PIC 9(03) COMP-3.
           05  ALQ-ICM-NTENT-WS                PIC 99V9  COMP-3.
           05  FILIAL-TRANS-NTENT-WS           PIC X(03).
           05  IND-CRI-NTENT-WS                PIC X(01).
      *        ACERTO DE INVENTARIO = 'E'
      *        NAO CRITICAR         = ' '
           05  IND-MEDIO-NTENT-WS              PIC X(01).
      *        ATUALIZA-PELO-CUSTO-MEDIO  = 'N'
      *        ATUALIZA-PELO-ULTIMO-CUSTO = 'S'
      *        ATUALIZA-PELO-PRECO-TABELA = 'T'
           05  SERIE-NTENT-WS                  PIC X(03).
           05  DT-NTF-NTENT-WS                 PIC 9(06) COMP-3.
           05  IND-ATU-NTENT-WS                PIC X(01).
      *        ESTOQUE-ATUALIZADO = 'S'
           05  ICM-NTENT-WS                    PIC 9(13) COMP-3.
           05  RETIDO-NTENT-WS                 PIC 9(11) COMP-3.
           05  BASE-RET-NTENT-WS               PIC 9(13) COMP-3.
           05  FILLER                          PIC X(01).
      *
      *   - 5 ocorrencias fazem parte do tamanho do registro
      *   - tamanho de cada ocorrencia --> 33 bytes.
      *
           05  TAB-NTENT-WS.
               10  ITENS-NTENT-WS OCCURS 20.
                   15  QTD-NTENT-WS            PIC S9(05) COMP-3.
                   15  CODIGO-NTENT-WS         PIC X(08).
                   15  VAL-UNIT-NTENT-WS       PIC 9(13) COMP-3.
                   15  VAL-DESC-NTENT-WS       PIC 9(11) COMP-3.
                   15  VAL-IPI-NTENT-WS        PIC 9(11) COMP-3.
                   15  GRUPO-COD-NTENT-WS      PIC 9(02).
                   15  ISENTO-NTENT-WS         PIC X(01).
      *                ISENTO DE ICM = S
      *                NAO ISENTO    = N

      *---------------------------------------------------------
      *
       01  ARQNTENT-TX.
           05  U-NTENT-TX                       PIC X(01).
           05  FILLER VALUE ":MV"              PIC X(03).
           05  DATA-MV-TX                      PIC 9(04).
           05  FILIAL-MV-TX                    PIC 9(02).
           05  FILLER VALUE ".ETX"             PIC X(04).
      *
       01  ARQNTENT-IT.
           05  U-NTENT-IT                       PIC X(01).
           05  FILLER VALUE ":IT"              PIC X(03).
           05  DATA-MV-IT                      PIC 9(04).
           05  FILIAL-MV-IT                    PIC 9(02).
           05  FILLER VALUE ".ETX"             PIC X(04).


       PROCEDURE DIVISION.
      *
       INICIO-010.
           DISPLAY (1, 1) ERASE.
       015-DATAS.
           DISPLAY (5, 22) "* conversao notas ENTRADAS EM TXT *"

           DISPLAY (10, 10) "Informe o Drive dos arqs:"
           ACCEPT (, ) U-NTENT-WS WITH PROMPT UPDATE
           ACCEPT ESCAPE-77 FROM ESCAPE KEY
           IF ESCAPE-77 NOT = ZEROS STOP RUN.
           MOVE U-NTENT-WS TO U-NTENT-TX.
           MOVE U-NTENT-WS TO U-NTENT-IT.

           DISPLAY (11, 10) "Informe a Filial .......:"
           ACCEPT (, ) FILIAL-EN-WS WITH PROMPT UPDATE
           IF ESCAPE-77 NOT = ZEROS GO TO INICIO-010.
           MOVE FILIAL-EN-WS   TO FILIAL-MV-TX.
           MOVE FILIAL-EN-WS   TO FILIAL-MV-IT.

           DISPLAY (12, 10) "Data Inicial (dd/mm)....:"
           ACCEPT (, ) DD-MM-77 WITH PROMPT UPDATE
           IF ESCAPE-77 NOT = ZEROS GO TO INICIO-010.
           MOVE DD-MM-77 TO INICIAL-WS FINAL-WS

           IF DIA-INI-WS = ZEROS GO TO INICIO-010.
           DISPLAY (13, 10) "Data Final   (dd/mm)....:" DD-MM-77
           ACCEPT (13, 35) DIA-FIM-WS WITH PROMPT UPDATE
           IF ESCAPE-77 NOT = ZEROS GO TO INICIO-010.

           DISPLAY (14, 10) "LIDOS:      GRAVADOS:".
           SUBTRACT 1 FROM DIA-INI-WS.

       020-ABRE-ARQ.

           ADD 1 TO DIA-INI-WS
           IF DIA-INI-WS > DIA-FIM-WS
              GO TO 015-DATAS.
           MOVE INICIAL-WS TO DATA-EN-WS DATA-MV-TX DATA-MV-IT

           OPEN OUTPUT ARQ-TX.
           OPEN OUTPUT ARQ-IT.

           MOVE 999 TO ERRO-WS CAN-WS
           MOVE ABRE-WS TO B-FUNC-WS

           MOVE -1 TO KEY-NUM-WS
           MOVE 999 TO ERRO-WS CAN-WS
           PERFORM MOVE-DADOS-NTENT
           CALL "BTVCAL" USING DADOS-WS

           IF  B-STATUS-WS NOT = ZEROS
               MOVE RESET-WS TO B-FUNC-WS
               CALL "BTVCAL" USING DADOS-WS
               CLOSE ARQ-TX
               CLOSE ARQ-IT
               GO 020-ABRE-ARQ.

           MOVE 0 TO KEY-NUM-WS LIDOS-77 GRAVADOS-77 GRAVADOS2-77
           MOVE LER-PRIMEIRO-WS TO B-FUNC-WS
           MOVE 09 TO ERRO-WS CAN-WS
           CALL "BTVCAL" USING DADOS-WS.
           

       LEITURA-020.
           IF B-STATUS-WS NOT = ZEROS
              MOVE FECHA-WS TO B-FUNC-WS
              CALL "BTVCAL" USING DADOS-WS
               CLOSE ARQ-IT
               CLOSE ARQ-TX
              GO 020-ABRE-ARQ.

           ADD 1 TO LIDOS-77 DISPLAY (14, 16) LIDOS-77

           MOVE REGISTRO-WS TO ARQNTENT-REG-WS.
      *     MOVE ARQNTENT-REG-WS  TO ARQNTENT-REG-TX
           PERFORM MOVE-INFO

           WRITE ARQNTENT-REG-TX

           PERFORM VARYING I FROM 1 BY 1 UNTIL I = 21
      *      OR CODIGO-NTENT-WS (I) = SPACES
               IF  CODIGO-NTENT-WS  (I) IS NOT = SPACES
                   MOVE  FILIAL-NTENT-WS         TO FILIAL-NTENT-IT
                   MOVE  NUMERO-NTENT-WS         TO NUMERO-NTENT-IT
                   MOVE  TIPO-NTENT-WS           TO TIPO-NTENT-IT   
                   MOVE  FORN-NTENT-WS           TO FORN-NTENT-IT

                   MOVE   QTD-NTENT-WS (I)       TO QTD-NTENT-IT       
                   MOVE   CODIGO-NTENT-WS (I)    TO CODIGO-NTENT-IT    
                   MOVE   VAL-UNIT-NTENT-WS (I)  TO VAL-UNIT-NTENT-IT  
                   MOVE   VAL-DESC-NTENT-WS (I)  TO VAL-DESC-NTENT-IT  
                   MOVE   VAL-IPI-NTENT-WS (I)   TO VAL-IPI-NTENT-IT   
                   MOVE   GRUPO-COD-NTENT-WS (I) TO GRUPO-COD-NTENT-IT 
                   MOVE   ISENTO-NTENT-WS (I)    TO ISENTO-NTENT-IT    

                   WRITE ARQNTENT-REG-IT
                   ADD 1 TO GRAVADOS2-77
                   DISPLAY (15, 32) GRAVADOS2-77
                END-IF
           END-PERFORM

           ADD 1 TO GRAVADOS-77
           DISPLAY (14, 32) GRAVADOS-77
           DISPLAY (16, 32) NUMERO-NTENT-WS
           MOVE 09 TO ERRO-WS
           MOVE 0 TO KEY-NUM-WS
           MOVE LER-PROX-WS TO B-FUNC-WS
           CALL "BTVCAL" USING DADOS-WS
           GO TO LEITURA-020.
      *
      *     -------------------------->  "DADONTENT.COB"
       MOVE-DADOS-NTENT.
      *
           MOVE POS-NTENT-WS TO POS-WS
           MOVE ARQNTENT-WS TO NOME-ARQ-WS
           MOVE TAM-NTENT-WS TO TAMANHO-WS
           MOVE ARQNTENT-REG-WS TO REGISTRO-WS.
      *
       VOLTA-DADOS-NTENT.
           MOVE POS-WS TO POS-NTENT-WS
           MOVE ZERO TO ERRO-WS
           MOVE REGISTRO-WS TO ARQNTENT-REG-WS.
      *
       MOVE-INFO.
           MOVE  FILIAL-NTENT-WS        TO  FILIAL-NTENT-TX     
           MOVE  TIPO-NTENT-WS          TO  TIPO-NTENT-TX       
           MOVE  FORN-NTENT-WS          TO  FORN-NTENT-TX       
           MOVE  NUMERO-NTENT-WS        TO  NUMERO-NTENT-TX     
           MOVE  PEDIDO-NTENT-WS        TO  PEDIDO-NTENT-TX     
           MOVE  DT-EMISS-NTENT-WS      TO  DT-EMISS-NTENT-TX   
           MOVE  TIPO-ENT-NTENT-WS      TO  TIPO-ENT-NTENT-TX   
           MOVE  IND-EST-NTENT-WS       TO  IND-EST-NTENT-TX    
           MOVE  ESTAT-NTENT-WS         TO  ESTAT-NTENT-TX      
           MOVE  IND-TIPO-NTENT-WS      TO  IND-TIPO-NTENT-TX   
           MOVE  TOTAL-NTENT-WS         TO  TOTAL-NTENT-TX      
           MOVE  FRETE-NTENT-WS         TO  FRETE-NTENT-TX      
           MOVE  CONHEC-NTENT-WS        TO  CONHEC-NTENT-TX     
           MOVE  BASE-CALC-NTENT-WS     TO  BASE-CALC-NTENT-TX  
           MOVE  CFO-NTENT-WS           TO  CFO-NTENT-TX        
           MOVE  ALQ-ICM-NTENT-WS       TO  ALQ-ICM-NTENT-TX    
           MOVE  FILIAL-TRANS-NTENT-WS  TO  FILIAL-TRANS-NTENT-TX 
           MOVE  IND-CRI-NTENT-WS       TO  IND-CRI-NTENT-TX    
           MOVE  IND-MEDIO-NTENT-WS     TO  IND-MEDIO-NTENT-TX  
           MOVE  SERIE-NTENT-WS         TO  SERIE-NTENT-TX      
           MOVE  DT-NTF-NTENT-WS        TO  DT-NTF-NTENT-TX     
           MOVE  IND-ATU-NTENT-WS       TO  IND-ATU-NTENT-TX    
           MOVE  ICM-NTENT-WS           TO  ICM-NTENT-TX        
           MOVE  RETIDO-NTENT-WS        TO  RETIDO-NTENT-TX     
           MOVE  BASE-RET-NTENT-WS      TO  BASE-RET-NTENT-TX.   
