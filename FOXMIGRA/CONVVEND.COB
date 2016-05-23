      *
       IDENTIFICATION DIVISION.
      *
       PROGRAM-ID. CONVVEND.
       AUTHOR. LUIS AUGUSTO.
      *
      *    DATA DA ALTERACAO: 11/95
      *
      *    ESTE PROGRAMA GERA ARQ. TXT DE ARQ VEND DO ESTOQUE
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
           VALUE     OF FILE-ID   ARQVEND-TX
           DATA      RECORD       REGVEND-TX.
C      01  REGVEND-TX.
C          05  CHAVE-TX.
C              10  FIL-TX                   PIC 9(02).
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

C     * ARQUIVO DE VENDEDORES <ARQVEND.COB>
C      01  DADOS-VEND-WS.
C          05  POS-VEND-WS                     PIC X(128).
C          05  TAM-VEND-WS                     PIC 99 COMP-0 VALUE 2722.
C     *         tamanho da pagina --> 512 (2 registros)
C     *         parte variavel    -->  2722 bytes
C     *
C      01  ARQVEND-WS.
C          05  U-VEND-WS                       PIC X(01).
C          05  FILLER VALUE ":ARQVEN"          PIC X(07).
C          05  FILIAL-VEND-WS                  PIC 9(02).
C          05  FILLER VALUE ".FAT"             PIC X(04).
C      01  ARQVEND-REG.
C          05  CHAVE-VEND.
C              10  COD-VEND                    PIC 9(03).
C          05  DESCR-VEND                      PIC X(25).
C          05  TIPO-VEND                       PIC X(01).
C          05  SENHA-VEND                      PIC S9(04).
C          05  STATUS-VEND                     PIC 9(01).
C          05  COND-VEND                       PIC S9(05).
C          05  FILLER                          PIC X(43).
C     *
C     *   3 ocorrencias da tabela fazem parte do tamanho do registro
C     *
C          05  RESERVA-VEND.
C              10 OCC-VEND OCCURS 48 TIMES.
C                 15  COD-MERC-VEND            PIC X(08).
C                 15  DESCR-MERC-VEND          PIC X(20).
C                 15  QTD-RES-VEND             PIC 9(05) COMP-3.
C                 15  CPF-RES-VEND             PIC 9(14) COMP-3.
C                 15  DT-RES-VEND              PIC 9(06) COMP-3.
C                 15  HS-RES-VEND              PIC 9(04) COMP-3.
C                 15  DT-FIM-VEND              PIC 9(06) COMP-3.
C                 15  HS-FIM-VEND              PIC 9(06) COMP-3.
C                 15  POS-ALX-VEND             PIC 9(01).
C     *
      *---------------------------------------------------------
       01  ARQVEND-TX.
C          05  U-VEND-TX                       PIC X(01).
C          05  FILLER VALUE ":ARQVEN"          PIC X(07).
C          05  FILIAL-VEND-TX                  PIC 9(02).
C          05  FILLER VALUE ".TXT"             PIC X(04).

      *

       PROCEDURE DIVISION.
      *
       INICIO-010.
           DISPLAY (1, 1) ERASE.
       015-DATAS.
           DISPLAY (5, 22) "* conversao ARQ VENDEDORES EM TXT *"

           DISPLAY (10, 10) "Informe o Drive dos arqs:"
           ACCEPT (, ) U-VEND-WS WITH PROMPT UPDATE
           ACCEPT ESCAPE-77 FROM ESCAPE KEY
           IF ESCAPE-77 NOT = ZEROS STOP RUN.
           MOVE U-VEND-WS TO U-VEND-TX.

           DISPLAY (11, 10) "Informe a Filial .......:"
           ACCEPT (, ) FILIAL-VEND-WS WITH PROMPT UPDATE
           IF ESCAPE-77 NOT = ZEROS GO TO INICIO-010.
           MOVE FILIAL-VEND-WS   TO FILIAL-VEND-TX.

           DISPLAY (14, 10) "LIDOS:      GRAVADOS:".

       020-ABRE-ARQ.

           OPEN OUTPUT ARQ-TX.

           MOVE 999 TO ERRO-WS CAN-WS
           MOVE ABRE-WS TO B-FUNC-WS

           MOVE -1 TO KEY-NUM-WS
           MOVE 999 TO ERRO-WS CAN-WS
           PERFORM MOVE-DADOS-VEND
           CALL "BTVCAL" USING DADOS-WS

           IF  B-STATUS-WS = 12
               MOVE ARQVEND-WS TO ARQBT-WS
               MOVE U-VEND-WS TO LETRA1BT-WS 
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
           MOVE ZEROS TO REGVEND-TX.
           MOVE REGISTRO-WS TO ARQVEND-REG.
           PERFORM MOVE-INFO

           WRITE REGVEND-TX

           ADD 1 TO GRAVADOS-77
           DISPLAY (14, 32) GRAVADOS-77
           MOVE 09 TO ERRO-WS
           MOVE 0 TO KEY-NUM-WS
           MOVE LER-PROX-WS TO B-FUNC-WS
           CALL "BTVCAL" USING DADOS-WS
           GO TO LEITURA-020.
      *
      *     -------------------------->  "DADOGRUP.COB"
       MOVE-DADOS-VEND.
      *
           MOVE POS-VEND-WS TO POS-WS
           MOVE ARQVEND-WS TO NOME-ARQ-WS
           MOVE TAM-VEND-WS TO TAMANHO-WS
           MOVE ARQVEND-REG TO REGISTRO-WS.
      *
       VOLTA-DADOS-VEND.
           MOVE POS-WS TO POS-VEND-WS
           MOVE ZERO TO ERRO-WS
           MOVE REGISTRO-WS TO ARQVEND-REG.
      *
       MOVE-INFO.
C          MOVE  FILIAL-VEND-WS   TO FIL-TX
           MOVE  COD-VEND         TO COD-TX
           MOVE  DESCR-VEND       TO  DESCRICAO-TX               
           
           
           
           
           
           
           
           
           
           


           
           
           
