      *
       IDENTIFICATION DIVISION.
      *
       PROGRAM-ID. CONVGRUP.
       AUTHOR. LUIS AUGUSTO.
      *
      *    DATA DA ALTERACAO: 11/95
      *
      *    ESTE PROGRAMA GERA ARQ. TXT DE ARQ GRUPO DO ESTOQUE
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
           VALUE     OF FILE-ID   ARQGRUPO-TX
           DATA      RECORD       REGGRUPO-TX.
C      01  REGGRUPO-TX.
C          05  CHAVE-TX.
C              10  COD-TX                   PIC 9(02).
C          05  DESCRICAO-TX                 PIC X(35).
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

C     * ARQUIVO DOS GRUPOS DO ESTOQUE <ARQGRUPO.COB>
C      01  DADOS-GRUPO-WS.
C          05  POS-GRUPO-WS                    PIC X(128).
C          05  TAM-GRUPO-WS                    PIC 99 COMP-0 VALUE 145.
C     *         tamanho da pagina --> 1024 (7 registros)
C      01  ARQGRUPO-WS.
C          05  U-GRUPO-WS                      PIC X(01).
C          05  FILLER VALUE ":ARQGRUPO.EST"    PIC X(13).
C     *
C      01  REGGRUPO.
C          05  CHAVE-GRUPO.
C              10  COD-GRUPO                   PIC 9(02).
C          05  DESCRICAO-GRUPO                 PIC X(35).
C          05  TAB-PESO-GRUPO.
C              10  PESO-GRUPO    OCCURS 10     PIC 9(01).
C          05  FILLER                          PIC X(14).
C          05  ISENTO-GRUPO                    PIC X(01).
C              88  ISENTO-ICM     VALUE "S".
C              88  NAO-ISENTO-ICM VALUE "N".
C          05  INTERVALO-GRUPO OCCURS 25       PIC 9(03) COMP-3.
C          05  DESCONTO-GRUPO OCCURS 10        PIC S9(02)V9(02) COMP-3.
C          05  FILLER                          PIC X(03).
C     *
      *---------------------------------------------------------
       01  ARQGRUPO-TX.
           05  U-GRUPO-TX                       PIC X(01).
           05  FILLER VALUE ":ARQGRUPO.TXT"     PIC X(13).
      *

       PROCEDURE DIVISION.
      *
       INICIO-010.
           DISPLAY (1, 1) ERASE.
       015-DATAS.
           DISPLAY (5, 22) "* conversao ARQ GRUP EM TXT *"

           DISPLAY (10, 10) "Informe o Drive dos arqs:"
           ACCEPT (, ) U-GRUPO-WS WITH PROMPT UPDATE
           ACCEPT ESCAPE-77 FROM ESCAPE KEY
           IF ESCAPE-77 NOT = ZEROS STOP RUN.
           MOVE U-GRUPO-WS TO U-GRUPO-TX.

           DISPLAY (14, 10) "LIDOS:      GRAVADOS:".

       020-ABRE-ARQ.

           OPEN OUTPUT ARQ-TX.

           MOVE 999 TO ERRO-WS CAN-WS
           MOVE ABRE-WS TO B-FUNC-WS

           MOVE -1 TO KEY-NUM-WS
           MOVE 999 TO ERRO-WS CAN-WS
           PERFORM MOVE-DADOS-GRUPO
           CALL "BTVCAL" USING DADOS-WS

           IF  B-STATUS-WS = 12
               MOVE ARQGRUPO-WS TO ARQBT-WS
               MOVE U-GRUPO-WS TO LETRA1BT-WS 
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
           MOVE ZEROS TO REGGRUPO-TX.
           MOVE REGISTRO-WS TO REGGRUPO.
           PERFORM MOVE-INFO

           WRITE REGGRUPO-TX

           ADD 1 TO GRAVADOS-77
           DISPLAY (14, 32) GRAVADOS-77
           MOVE 09 TO ERRO-WS
           MOVE 0 TO KEY-NUM-WS
           MOVE LER-PROX-WS TO B-FUNC-WS
           CALL "BTVCAL" USING DADOS-WS
           GO TO LEITURA-020.
      *
      *     -------------------------->  "DADOGRUP.COB"
       MOVE-DADOS-GRUPO.
      *
           MOVE POS-GRUPO-WS TO POS-WS
           MOVE ARQGRUPO-WS TO NOME-ARQ-WS
           MOVE TAM-GRUPO-WS TO TAMANHO-WS
           MOVE REGGRUPO TO REGISTRO-WS.
      *
       VOLTA-DADOS-GRUPO.
           MOVE POS-WS TO POS-GRUPO-WS
           MOVE ZERO TO ERRO-WS
           MOVE REGISTRO-WS TO REGGRUPO.
      *
       MOVE-INFO.
           MOVE  COD-GRUPO       TO  COD-TX              
           MOVE  DESCRICAO-GRUPO TO  DESCRICAO-TX               
           
           
           
           
           
           
           
           
           
           
           
           


           
           
           
