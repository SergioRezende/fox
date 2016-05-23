      *
       IDENTIFICATION DIVISION.
      *
       PROGRAM-ID. CONVSUBG.
       AUTHOR. LUIS AUGUSTO.
      *
      *    DATA DA ALTERACAO: 11/95
      *
      *    ESTE PROGRAMA GERA ARQ. TXT DE ARQ SUBGR DO ESTOQUE
      *    ARQUIVO DE ARQGRUP
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
           VALUE     OF FILE-ID   ARQSUBGR-TX
           DATA      RECORD       REGSUBGR-TX.
C      01  REGSUBGR-TX.
C          05  CHAVE-SUB.
C              10  GRUPO-TX                    PIC 9(02).
C              10  SUBGR-TX                    PIC 9(03).
C          05  DESCRICAO-TX                 PIC X(25).
C     *

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

C     * ARQUIVO DOS SUBGRUPOS DO ESTOQUE <ARQSUBGR.COB>
C      01  DADOS-SUBGR-WS.
C          05  POS-SUBGR-WS                    PIC X(128).
C          05  TAM-SUBGR-WS                    PIC 99 COMP-0 VALUE 203.
C     *         tamanho da pagina --> 1024 (5 registros)
C      01  ARQSUBGR-WS.
C          05  U-SUBGR-WS                      PIC X(01).
C          05  FILLER VALUE ":ARQSUBGR.EST"    PIC X(13).
C     *
C      01  ARQSUBGR-REG.
C          05  CHAVE-SUB.
C              10  GRUPO-SUB                   PIC 9(02).
C              10  SUBGR-SUB                   PIC 9(03).
C          05  DESCRICAO-SUB                   PIC X(25).
C          05  DESCONTO-SUB OCCURS 10          PIC S9(02)V9(02) COMP-3.
C          05  TAB-PESO-SUB.
C              10  PESO-SUB     OCCURS 10      PIC 9(01).
C          05  FILLER                          PIC X(14).
C          05  INTERVALO-SUB OCCURS 50         PIC 9(03) COMP-3.
C          05  FILLER                          PIC X(19).
C     *
      *---------------------------------------------------------
       01  ARQSUBGR-TX.
           05  U-SUBGR-TX                       PIC X(01).
           05  FILLER VALUE ":ARQSUBGR.TXT"     PIC X(13).
      *

       PROCEDURE DIVISION.
      *
       INICIO-010.
           DISPLAY (1, 1) ERASE.
       015-DATAS.
           DISPLAY (5, 22) "* conversao ARQ SUBGRUP EM TXT *"

           DISPLAY (10, 10) "Informe o Drive dos arqs:"
           ACCEPT (, ) U-SUBGR-WS WITH PROMPT UPDATE
           ACCEPT ESCAPE-77 FROM ESCAPE KEY
           IF ESCAPE-77 NOT = ZEROS STOP RUN.
           MOVE U-SUBGR-WS TO U-SUBGR-TX.

           DISPLAY (14, 10) "LIDOS:      GRAVADOS:".

       020-ABRE-ARQ.

           OPEN OUTPUT ARQ-TX.

           MOVE 999 TO ERRO-WS CAN-WS
           MOVE ABRE-WS TO B-FUNC-WS

           MOVE -1 TO KEY-NUM-WS
           MOVE 999 TO ERRO-WS CAN-WS
           PERFORM MOVE-DADOS-SUBGR
           CALL "BTVCAL" USING DADOS-WS

           IF  B-STATUS-WS = 12
               MOVE ARQSUBGR-WS TO ARQBT-WS
               MOVE U-SUBGR-WS TO LETRA1BT-WS 
               MOVE "P" TO LETRA2BT-WS
               MOVE "CRIGRUP.BTV" TO DEFBT-WS
               CALL X"91" USING RESULT-77 F-77 CRIABT-WS
               MOVE ZEROS TO ERRO-WS CAN-WS
               MOVE ABRE-WS TO B-FUNC-WS
               CALL "BTVCAL" USING DADOS-WS.
           IF  B-STATUS-WS NOT = ZEROS
               MOVE RESET-WS TO B-FUNC-WS
               CALL "BTVCAL" USING DADOS-WS
               CLOSE ARQ-TX
               GO TO 015-DATAS.

           MOVE 0 TO KEY-NUM-WS LIDOS-77 GRAVADOS-77 GRAVADOS2-77
           MOVE LER-PRIMEIRO-WS TO B-FUNC-WS
           MOVE 09 TO ERRO-WS CAN-WS
           CALL "BTVCAL" USING DADOS-WS.
           

       LEITURA-020.
           IF B-STATUS-WS NOT = ZEROS
              MOVE FECHA-WS TO B-FUNC-WS
              CALL "BTVCAL" USING DADOS-WS
               CLOSE ARQ-TX
              GO 015-DATAS.

           ADD 1 TO LIDOS-77 DISPLAY (14, 16) LIDOS-77
           MOVE ZEROS TO REGSUBGR-TX.
           MOVE REGISTRO-WS TO ARQSUBGR-REG.
           PERFORM MOVE-INFO

           WRITE REGSUBGR-TX

           ADD 1 TO GRAVADOS-77
           DISPLAY (14, 32) GRAVADOS-77
           MOVE 09 TO ERRO-WS
           MOVE 0 TO KEY-NUM-WS
           MOVE LER-PROX-WS TO B-FUNC-WS
           CALL "BTVCAL" USING DADOS-WS
           GO TO LEITURA-020.
      *
      *     -------------------------->  "DADOGRUP.COB"
       MOVE-DADOS-SUBGR.
      *
           MOVE POS-SUBGR-WS TO POS-WS
           MOVE ARQSUBGR-WS TO NOME-ARQ-WS
           MOVE TAM-SUBGR-WS TO TAMANHO-WS
           MOVE ARQSUBGR-REG TO REGISTRO-WS.
      *
       VOLTA-DADOS-SUBGR.
           MOVE POS-WS TO POS-SUBGR-WS
           MOVE ZERO TO ERRO-WS
           MOVE REGISTRO-WS TO ARQSUBGR-REG.
      *
       MOVE-INFO.
C          MOVE  GRUPO-SUB       TO GRUPO-TX
C          MOVE  SUBGR-SUB       TO SUBGR-TX
           MOVE  DESCRICAO-SUB TO  DESCRICAO-TX               
           
           
           
           
           
           
           
           
           
           
           
           


           
           
           
