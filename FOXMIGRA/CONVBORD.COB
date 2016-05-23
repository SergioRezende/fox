      *
       IDENTIFICATION DIVISION.
      *
       PROGRAM-ID. CONVBORD.
       AUTHOR. LUIS AUGUSTO.
      *
      *    DATA DA ALTERACAO: 11/95
      *
      *    ESTE PROGRAMA GERA ARQ. TXT DE BORDERO
      *  
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
           VALUE     OF FILE-ID   CADBORD-TX
           DATA      RECORD       CADBORD-REG-TX.
       01  CADBORD-REG-TX.
           05  CHAVE-TX.
               10  FILIAL-TX                 PIC 9(02).
               10  DUPL-TX                   PIC 9(08).
           05  DATA-TX                       PIC 9(06).
           05  BANCO-TX                      PIC 9(03).
           05  NOME-CLI-TX                   PIC X(40).
           05  AGENCIA-TX                    PIC 9(04).
           05  CPF-TX                        PIC 9(14).
           05  DT-EMISS-TX                   PIC 9(06).
           05  DT-VENC-TX                    PIC 9(06).
           05  VALOR-TX                      PIC 9(11).

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

      *
      *                  -------->>   "REGBORD.COB"
      *    06/92 - ALTERACAO CAMPO DE VALOR
      *            VALOR-BORD   PIC 9(09) P/ PIC 9(11)
      *            FILLER       PIC X(02) P/ PIC X(01)
      *
       01  DADOS-BORD-WS.
           05  POS-BORD-WS                     PIC X(128).
           05  TAM-BORD-WS                     PIC 99 COMP-0 VALUE 84.
      *         tamanho da pagina --> 512 (6 registros)
       01  CADBORD-WS.
           05  U-BORD-WS                       PIC X(01).
           05  FILLER VALUE ":BD"              PIC X(03).
           05  DATA-BD-WS                      PIC 9(04).
           05  FILIAL-BORD-WS                  PIC 9(02).
           05  FILLER VALUE ".CRC"             PIC X(04).
       01  CADBORD-REG-WS.
           05  CHAVE-BORD.
               10  FILIAL-BORD                 PIC 9(02).
               10  DUPL-BORD                   PIC 9(08).
           05  DATA-BORD                       PIC 9(06).
           05  BANCO-BORD                      PIC 9(03) COMP-3.
           05  NOME-CLI-BORD                   PIC X(40).
           05  AGENCIA-BORD                    PIC 9(04) COMP-3.
           05  CPF-BORD                        PIC 9(14) COMP-3.
           05  DT-EMISS-BORD                   PIC 9(06) COMP-3.
           05  DT-VENC-BORD                    PIC 9(06) COMP-3.
           05  VALOR-BORD                      PIC S9(11) COMP-3.
           05  FILLER                          PIC X(01).
      *---------------------------------------------------------
      *
       01  CADBORD-TX.
           05  U-BORD-TX                       PIC X(01).
           05  FILLER VALUE ":BD"              PIC X(03).
           05  DATA-BD-TX                      PIC 9(04).
           05  FILIAL-BORD-TX                  PIC 9(02).
           05  FILLER VALUE ".BRD"             PIC X(04).
      *

       PROCEDURE DIVISION.
      *
       INICIO-010.
           DISPLAY (1, 1) ERASE.
       015-DATAS.
           DISPLAY (5, 22) "* conversao BORDERO EM TXT *"

           DISPLAY (10, 10) "Informe o Drive dos arqs:"
           ACCEPT (, ) U-BORD-WS WITH PROMPT UPDATE
           ACCEPT ESCAPE-77 FROM ESCAPE KEY
           IF ESCAPE-77 NOT = ZEROS STOP RUN.
           MOVE U-BORD-WS TO U-BORD-TX.

           DISPLAY (11, 10) "Informe a Filial .......:"
           ACCEPT (, ) FILIAL-BORD-WS WITH PROMPT UPDATE
           IF ESCAPE-77 NOT = ZEROS GO TO INICIO-010.
           MOVE FILIAL-BORD-WS   TO FILIAL-BORD-TX.

           DISPLAY (12, 10) "Data Inicial (dd/mm)....:"
           ACCEPT (, ) DD-MM-77 WITH PROMPT UPDATE
           IF ESCAPE-77 NOT = ZEROS GO TO INICIO-010.
           MOVE DD-MM-77 TO INICIAL-WS FINAL-WS

           IF DIA-INI-WS = ZEROS GO TO INICIO-010.
           DISPLAY (13, 10) "Data Final   (dd/mm)....:" DD-MM-77
           ACCEPT (13, 35) DIA-FIM-WS WITH PROMPT UPDATE
           IF ESCAPE-77 NOT = ZEROS GO TO INICIO-010.

           DISPLAY (14, 10) "LIDOS:      GRAVADOS:".
           MOVE FILIAL-BORD-WS   TO FILIAL-BORD-TX.
           SUBTRACT 1 FROM DIA-INI-WS.

       020-ABRE-ARQ.

           ADD 1 TO DIA-INI-WS
           IF DIA-INI-WS > DIA-FIM-WS
              GO TO 015-DATAS.
           MOVE INICIAL-WS TO DATA-BD-WS DATA-BD-TX 

           OPEN OUTPUT ARQ-TX.

           MOVE 999 TO ERRO-WS CAN-WS
           MOVE ABRE-WS TO B-FUNC-WS

           MOVE -1 TO KEY-NUM-WS
           MOVE 999 TO ERRO-WS CAN-WS
           PERFORM MOVE-DADOS-BORD
           CALL "BTVCAL" USING DADOS-WS

           IF  B-STATUS-WS NOT = ZEROS
               MOVE RESET-WS TO B-FUNC-WS
               CALL "BTVCAL" USING DADOS-WS
               CLOSE ARQ-TX
               GO 020-ABRE-ARQ.

           MOVE 0 TO KEY-NUM-WS LIDOS-77 GRAVADOS-77 GRAVADOS2-77
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

           MOVE REGISTRO-WS TO CADBORD-REG-WS.
           PERFORM MOVE-INFO

	   IF  DUPL-BORD > 0   
               WRITE CADBORD-REG-TX.

           ADD 1 TO GRAVADOS-77
           DISPLAY (14, 32) GRAVADOS-77
           MOVE 09 TO ERRO-WS
           MOVE 0 TO KEY-NUM-WS
           MOVE LER-PROX-WS TO B-FUNC-WS
           CALL "BTVCAL" USING DADOS-WS
           GO TO LEITURA-020.
      *
      *     -------------------------->  "DADONTFS.COB"
       MOVE-DADOS-BORD.
      *
           MOVE POS-BORD-WS TO POS-WS
           MOVE CADBORD-WS TO NOME-ARQ-WS
           MOVE TAM-BORD-WS TO TAMANHO-WS
           MOVE CADBORD-REG-WS TO REGISTRO-WS.
      *
       VOLTA-DADOS-BORD.
           MOVE POS-WS TO POS-BORD-WS
           MOVE ZERO TO ERRO-WS
           MOVE REGISTRO-WS TO CADBORD-REG-WS.
      *
       MOVE-INFO.
           MOVE  FILIAL-BORD         TO  FILIAL-TX    
           MOVE  DUPL-BORD           TO  DUPL-TX               
           MOVE  DATA-BORD           TO  DATA-TX               
           MOVE  BANCO-BORD          TO  BANCO-TX              
           MOVE  NOME-CLI-BORD       TO  NOME-CLI-TX           
           MOVE  AGENCIA-BORD        TO  AGENCIA-TX            
           MOVE  CPF-BORD            TO  CPF-TX                
           MOVE  DT-EMISS-BORD       TO  DT-EMISS-TX           
           MOVE  DT-VENC-BORD        TO  DT-VENC-TX            
           MOVE  VALOR-BORD          TO  VALOR-TX              


	             
                     
                     
                     
                     
                     
                     
                     
                     
         
