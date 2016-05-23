      *
       IDENTIFICATION DIVISION.
      *
       PROGRAM-ID. CONVCLAS.
       AUTHOR. LUIS AUGUSTO.
      *
      *    DATA DA ALTERACAO: 11/95
      *
      *    ESTE PROGRAMA GERA ARQ. TXT DE ARQ CLASS DO ESTOQUE
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
           VALUE     OF FILE-ID   ARQCLASS-TX
           DATA      RECORD       REGCLASS-TX.
C      01  REGCLASS-TX.
C          05  CHAVE-TX.
C              10  GRUPO-TX                 PIC 9(02).
C              10  SUB-GRUPO-TX             PIC 9(03).
C              10  COD-TX                   PIC 9(03).
C          05  DESCRICAO-TX                 PIC X(30).

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

C     * ARQUIVO DE CLASSIFICACAO DOS CLASSUPOS DO ESTOQUE <ARQCLASS.COB>
C     *
C       01  DADOS-CLASS-WS.
C          05  POS-CLASS-WS                    PIC X(128).
C          05  TAM-CLASS-WS                    PIC 99 COMP-0 VALUE 63.
C     *         tamanho da pagina --> 512 (8 registros)
C      01  ARQCLASS-WS.
C          05  U-CLASS-WS                      PIC X(01).
C          05  FILLER VALUE ":ARQCLASS.EST"    PIC X(13).
C     *
C      01  ARQCLASS-REG.
C          05  CHAVE-CLASS.
C              10  GRUPO-CLASS                 PIC 9(02).
C              10  SUB-GRUPO-CLASS             PIC 9(03).
C              10  COD-CLASS                   PIC 9(03).
C          05  DESCRICAO-CLASS                 PIC X(30).
C          05  TAB-PESO-CLASS.
C              10  PESO-CLASS OCCURS 10        PIC 9(01).
C          05  FILLER                          PIC X(15).
C     *
      *---------------------------------------------------------
       01  ARQCLASS-TX.
           05  U-CLASS-TX                       PIC X(01).
           05  FILLER VALUE ":ARQCLASS.TXT"     PIC X(13).
      *

       PROCEDURE DIVISION.
      *
       INICIO-010.
           DISPLAY (1, 1) ERASE.
       015-DATAS.
           DISPLAY (5, 22) "* conversao ARQ CLASSES ESTQ EM TXT *"

           DISPLAY (10, 10) "Informe o Drive dos arqs:"
           ACCEPT (, ) U-CLASS-WS WITH PROMPT UPDATE
           ACCEPT ESCAPE-77 FROM ESCAPE KEY
           IF ESCAPE-77 NOT = ZEROS STOP RUN.
           MOVE U-CLASS-WS TO U-CLASS-TX.

           DISPLAY (14, 10) "LIDOS:      GRAVADOS:".

       020-ABRE-ARQ.

           OPEN OUTPUT ARQ-TX.

           MOVE 999 TO ERRO-WS CAN-WS
           MOVE ABRE-WS TO B-FUNC-WS

           MOVE -1 TO KEY-NUM-WS
           MOVE 999 TO ERRO-WS CAN-WS
           PERFORM MOVE-DADOS-CLASS
           CALL "BTVCAL" USING DADOS-WS

           IF  B-STATUS-WS = 12
               MOVE ARQCLASS-WS TO ARQBT-WS
               MOVE U-CLASS-WS TO LETRA1BT-WS 
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
           MOVE ZEROS TO REGCLASS-TX.
           MOVE REGISTRO-WS TO ARQCLASS-REG.
           PERFORM MOVE-INFO

           WRITE REGCLASS-TX

           ADD 1 TO GRAVADOS-77
           DISPLAY (14, 32) GRAVADOS-77
           MOVE 09 TO ERRO-WS
           MOVE 0 TO KEY-NUM-WS
           MOVE LER-PROX-WS TO B-FUNC-WS
           CALL "BTVCAL" USING DADOS-WS
           GO TO LEITURA-020.
      *
      *     -------------------------->  "DADOGRUP.COB"
       MOVE-DADOS-CLASS.
      *
           MOVE POS-CLASS-WS TO POS-WS
           MOVE ARQCLASS-WS TO NOME-ARQ-WS
           MOVE TAM-CLASS-WS TO TAMANHO-WS
           MOVE ARQCLASS-REG TO REGISTRO-WS.
      *
       VOLTA-DADOS-CLASS.
           MOVE POS-WS TO POS-CLASS-WS
           MOVE ZERO TO ERRO-WS
           MOVE REGISTRO-WS TO ARQCLASS-REG.
      *
       MOVE-INFO.
C          MOVE  GRUPO-CLASS       TO GRUPO-TX
C          MOVE  SUB-GRUPO-CLASS   TO SUB-GRUPO-TX
	   MOVE  COD-CLASS         TO COD-TX
           MOVE  DESCRICAO-CLASS   TO  DESCRICAO-TX               
           
           
           
           
           
           
           
           
           
           
           


           
           
           
