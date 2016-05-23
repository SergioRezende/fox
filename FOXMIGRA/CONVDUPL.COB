      *
       IDENTIFICATION DIVISION.
      *
       PROGRAM-ID. CONVDUPL.
       AUTHOR. LUIS AUGUSTO.
      *
      *    DATA DA ALTERACAO: 11/95
      *
      *    ESTE PROGRAMA GERA ARQ. TXT DE ARQ DUPLICATAS
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
           VALUE     OF FILE-ID   ARQDUP-TX
           DATA      RECORD       REGDUP-TX.
       01  REGDUP-TX.
           05  CHAVE-TX.
               10  FILIAL-TX                  PIC 9(02).
               10  CPF-CGC-TX                 PIC 9(14).
               10  CODIGO-TX                  PIC 9(08).
           05  IND-PAGA-TX                    PIC X(01).
           05  IND-NPAGA-TX                   PIC X(01).
           05  STATUS-TX                      PIC X(01).
           05  VEND-TX                        PIC 9(03).
           05  DT-EMIS-TX                     PIC 9(06).
           05  DT-VENC-TX                     PIC 9(06).
           05  DT-BORDERO-TX                  PIC 9(06).
           05  REGIAO-TX                      PIC 9(03).
           05  BANCO-TX                       PIC 9(03).
           05  AGENCIA-TX                     PIC 9(04).
           05  NATU-TX                        PIC 9(02).
           05  VALOR-TX                       PIC 9(11).
           05  SALDO-TX                       PIC 9(11).
           05  DT-PAG-TX                      PIC 9(06).
           05  ANO-MES-PAG-TX.
               10  ANO-PAG-TX                 PIC 9(02).
               10  MES-PAG-TX                 PIC 9(02).

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

      * --->> "REGDUP.COB"
       01  DADOS-DUP-WS.
           05  POS-DUP-WS                      PIC X(128).
           05  TAM-DUP-WS                      PIC 99 COMP-0 VALUE 72.
      *         tamanho da pagina --> 512 (7 registros)
       01  CADDUP-WS.
           05  U-DUP-WS                        PIC X(01).
           05  FILLER VALUE ":CADDUP"          PIC X(07).
           05  FILIAL-DUP-WS                   PIC X(02).
           05  FILLER VALUE ".CRC"             PIC X(04).
       01  REG-DUP.
           05  CHAVE-DUP.
               10  FILIAL-DUP                  PIC 9(02).
               10  CPF-CGC-DUP                 PIC 9(14) COMP-3.
               10  CODIGO-DUP                  PIC 9(08).
               10  FILLER REDEFINES CODIGO-DUP.
                   15  CORPO-DUP               PIC 9(06).
                   15  PARC-DUP                PIC 9(01).
                   15  TIPO-DUP                PIC 9(01).
           05  IND-PAGA-DUP                    PIC X(01).
           05  IND-NPAGA-DUP                   PIC X(01).
           05  STATUS-DUP                      PIC X(01).
               88  DUP-DO-FATURAMENTO VALUE "F".
               88  DUP-PAGA           VALUE "P".
               88  INCOBRAVEL         VALUE "I".
           05  VEND-DUP                        PIC S9(03) COMP-3.
           05  DT-EMIS-DUP                     PIC S9(06) COMP-3.
           05  DT-VENC-DUP                     PIC S9(06) COMP-3.
           05  DT-BORDERO-DUP                  PIC S9(06) COMP-3.
           05  REGIAO-DUP                      PIC S9(03) COMP-3.
           05  BANCO-DUP                       PIC S9(03) COMP-3.
           05  AGENCIA-DUP                     PIC S9(04) COMP-3.
           05  NATU-DUP                        PIC 9(02).
           05  VALOR-DUP                       PIC S9(11) COMP-3.
           05  SALDO-DUP                       PIC S9(11) COMP-3.
           05  DT-PAG-DUP                      PIC S9(06) COMP-3.
           05  ANO-MES-PAG-DUP.
               10  ANO-PAG-DUP                 PIC 9(02).
               10  MES-PAG-DUP                 PIC 9(02).
           05  FILLER                          PIC X(08).

      *---------------------------------------------------------
       01  ARQDUP-TX.
C          05  U-DUP-TX                       PIC X(01).
C          05  FILLER VALUE ":CADDUP"          PIC X(07).
C          05  FILIAL-DUP-TX                  PIC 9(02).
C          05  FILLER VALUE ".TXT"             PIC X(04).

      *

       PROCEDURE DIVISION.
      *
       INICIO-010.
           DISPLAY (1, 1) ERASE.
       015-DATAS.
           DISPLAY (5, 22) "* conversao ARQ DUPLICATAS EM TXT *"

           DISPLAY (10, 10) "Informe o Drive dos arqs:"
           ACCEPT (, ) U-DUP-WS WITH PROMPT UPDATE
           ACCEPT ESCAPE-77 FROM ESCAPE KEY
           IF ESCAPE-77 NOT = ZEROS STOP RUN.
           MOVE U-DUP-WS TO U-DUP-TX.

           DISPLAY (11, 10) "Informe a Filial .......:"
           ACCEPT (, ) FILIAL-DUP-WS WITH PROMPT UPDATE
           IF ESCAPE-77 NOT = ZEROS GO TO INICIO-010.
           MOVE FILIAL-DUP-WS   TO FILIAL-DUP-TX.

           DISPLAY (14, 10) "LIDOS:      GRAVADOS:".

       020-ABRE-ARQ.

           OPEN OUTPUT ARQ-TX.

           MOVE 999 TO ERRO-WS CAN-WS
           MOVE ABRE-WS TO B-FUNC-WS

           MOVE -1 TO KEY-NUM-WS
           MOVE 999 TO ERRO-WS CAN-WS
           PERFORM MOVE-DADOS-DUP
           CALL "BTVCAL" USING DADOS-WS

           IF  B-STATUS-WS = 12
               MOVE CADDUP-WS TO ARQBT-WS
               MOVE U-DUP-WS TO LETRA1BT-WS 
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
           MOVE ZEROS TO REGDUP-TX.
           MOVE REGISTRO-WS TO REG-DUP.
           PERFORM MOVE-INFO

           WRITE REGDUP-TX

           ADD 1 TO GRAVADOS-77
           DISPLAY (14, 32) GRAVADOS-77
           MOVE 09 TO ERRO-WS
           MOVE 0 TO KEY-NUM-WS
           MOVE LER-PROX-WS TO B-FUNC-WS
           CALL "BTVCAL" USING DADOS-WS
           GO TO LEITURA-020.
      *
      *     -------------------------->  "DADOGRUP.COB"
       MOVE-DADOS-DUP.
      *
           MOVE POS-DUP-WS TO POS-WS
           MOVE CADDUP-WS TO NOME-ARQ-WS
           MOVE TAM-DUP-WS TO TAMANHO-WS
           MOVE REG-DUP TO REGISTRO-WS.
      *
       VOLTA-DADOS-DUP.
           MOVE POS-WS TO POS-DUP-WS
           MOVE ZERO TO ERRO-WS
           MOVE REGISTRO-WS TO REG-DUP.
      *
       MOVE-INFO.
           MOVE  FILIAL-DUP       TO  FILIAL-TX     
           MOVE  CPF-CGC-DUP      TO  CPF-CGC-TX   
           MOVE  CODIGO-DUP       TO  CODIGO-TX    
           MOVE  IND-PAGA-DUP     TO  IND-PAGA-TX  
           MOVE  IND-NPAGA-DUP    TO  IND-NPAGA-TX 
           MOVE  STATUS-DUP       TO  STATUS-TX    
           MOVE  VEND-DUP         TO  VEND-TX      
           MOVE  DT-EMIS-DUP      TO  DT-EMIS-TX   
           MOVE  DT-VENC-DUP      TO  DT-VENC-TX   
           MOVE  DT-BORDERO-DUP   TO  DT-BORDERO-TX
           MOVE  REGIAO-DUP       TO  REGIAO-TX    
           MOVE  BANCO-DUP        TO  BANCO-TX     
           MOVE  AGENCIA-DUP      TO  AGENCIA-TX   
           MOVE  NATU-DUP         TO  NATU-TX      
           MOVE  VALOR-DUP        TO  VALOR-TX     
           MOVE  SALDO-DUP        TO  SALDO-TX     
           MOVE  DT-PAG-DUP       TO  DT-PAG-TX    
           MOVE  ANO-PAG-DUP      TO  ANO-PAG-TX   
           MOVE  MES-PAG-DUP      TO  MES-PAG-TX      
           
           
           
           
           
           
           
           


           
           
           























