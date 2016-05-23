      *
       IDENTIFICATION DIVISION.
      *
       PROGRAM-ID. CONVFORN.
       AUTHOR. LUIS AUGUSTO.
      *
      *    DATA DA ALTERACAO: 11/95
      *
      *    ESTE PROGRAMA GERA ARQ. TXT DE ARQ FORN DO ESTOQUE
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
           VALUE     OF FILE-ID   ARQFORN-TX
           DATA      RECORD       REGFORN-TX.
C      01  REGFORN-TX.
C          05  CHAVE-TX.
C              10  COD-TX                    PIC 9(04).
C          05  DESC-TX                       PIC X(39).
C          05  CGC-TX                        PIC 9(14).
C          05  INSC-TX                       PIC 9(12).
C          05  UF-TX                         PIC X(02).

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

C     * ARQUIVO DE FORNECEDORES <ARQFORN.COB>
C       01  DADOS-FORN-WS.
C          05  POS-FORN-WS                     PIC X(128).
C          05  TAM-FORN-WS                     PIC 99 COMP-0 VALUE 71.
C     *         tamanho da pagina --> 512 (07 registros)
C      01  ARQFORN-WS.
C          05  U-FORN-WS                       PIC X(01).
C          05  FILLER VALUE ":ARQFORN.EST"     PIC X(13).
C     *
C      01  ARQFORN-REG.
C          05  CHAVE-FORN.
C              10  COD-FORN                    PIC 9(04).
C          05  DESC-FORN                       PIC X(39).
C          05  CGC-FORN                        PIC 9(14).
C          05  INSC-FORN                       PIC 9(12).
C          05  UF-FORN                         PIC X(02).
C     *
      *---------------------------------------------------------
       01  ARQFORN-TX.
C          05  U-FORN-TX                       PIC X(01).
C          05  FILLER VALUE ":ARQFORN"          PIC X(08).
C          05  FILLER VALUE ".TXT"             PIC X(04).

      *

       PROCEDURE DIVISION.
      *
       INICIO-010.
           DISPLAY (1, 1) ERASE.
       015-DATAS.
           DISPLAY (5, 22) "* conversao ARQ FORN EM TXT *"

           DISPLAY (10, 10) "Informe o Drive dos arqs:"
           ACCEPT (, ) U-FORN-WS WITH PROMPT UPDATE
           ACCEPT ESCAPE-77 FROM ESCAPE KEY
           IF ESCAPE-77 NOT = ZEROS STOP RUN.
           MOVE U-FORN-WS TO U-FORN-TX.


           DISPLAY (14, 10) "LIDOS:      GRAVADOS:".

       020-ABRE-ARQ.

           OPEN OUTPUT ARQ-TX.

           MOVE 999 TO ERRO-WS CAN-WS
           MOVE ABRE-WS TO B-FUNC-WS

           MOVE -1 TO KEY-NUM-WS
           MOVE 999 TO ERRO-WS CAN-WS
           PERFORM MOVE-DADOS-FORN
           CALL "BTVCAL" USING DADOS-WS

           IF  B-STATUS-WS = 12
               MOVE ARQFORN-WS TO ARQBT-WS
               MOVE U-FORN-WS TO LETRA1BT-WS 
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
           MOVE ZEROS TO REGFORN-TX.
           MOVE REGISTRO-WS TO ARQFORN-REG.

           PERFORM MOVE-INFO

           WRITE REGFORN-TX

           ADD 1 TO GRAVADOS-77
           DISPLAY (14, 32) GRAVADOS-77
           MOVE 09 TO ERRO-WS
           MOVE 0 TO KEY-NUM-WS
           MOVE LER-PROX-WS TO B-FUNC-WS
           CALL "BTVCAL" USING DADOS-WS
           GO TO LEITURA-020.
      *
      *     -------------------------->  "DADOGRUP.COB"
       MOVE-DADOS-FORN.
      *
           MOVE POS-FORN-WS TO POS-WS
           MOVE ARQFORN-WS TO NOME-ARQ-WS
           MOVE TAM-FORN-WS TO TAMANHO-WS
           MOVE ARQFORN-REG TO REGISTRO-WS.
      *
       VOLTA-DADOS-FORN.
           MOVE POS-WS TO POS-FORN-WS
           MOVE ZERO TO ERRO-WS
           MOVE REGISTRO-WS TO ARQFORN-REG.
      *
       MOVE-INFO.
C          MOVE  COD-FORN       TO   COD-TX  
C          MOVE  DESC-FORN      TO   DESC-TX 
C          MOVE  CGC-FORN       TO   CGC-TX  
C          MOVE  INSC-FORN      TO   INSC-TX 
C          MOVE  UF-FORN        TO   UF-TX   
           
           
           
           
           


           
           
           























