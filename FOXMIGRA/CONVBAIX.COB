      *
       IDENTIFICATION DIVISION.
      *
       PROGRAM-ID. CONVBAIX.
       AUTHOR. LUIS AUGUSTO.
      *
      *    DATA DA ALTERACAO: 11/95
      *
      *    ESTE PROGRAMA GERA ARQ. TXT DE BAIXA
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
           VALUE     OF FILE-ID   CADLANC-TX
           DATA      RECORD       REG-LANC-TX.
       01  REG-LANC-TX.
           05  TIPO-TX               	     PIC X(01).
           05  CORPO-TX                      PIC 9(07).
           05  DT-PAG-TX                     PIC 9(06).
           05  VALOR-PAG-TX                  PIC 9(13).
           05  DT-VENC-TX                    PIC 9(06).
           05  VALOR-JURO-TX                 PIC 9(11).
           05  VALOR-DESP-TX                 PIC 9(11).
           05  VALOR-DESC-TX                 PIC 9(11).
           05  REGIAO-TX                     PIC 9(03).
           05  BANCO-TX                      PIC 9(03).
           05  NATU-TX                       PIC 9(02).
           05  COD-OPER-TX                   PIC X(01).
      *        "1"   FATURAMENTO     
      *        "2"   BAIXA INTEGRAL
      *        "3"   BAIXA PARCELADA
      *        "4"   DEVOLUCAO
      *        "5"   INCOBRAVEL
           05  CHAVE-LOTE-TX                 PIC X(27).
           05  STATUS-TX                     PIC X(01).
           05  VERSAO-TX                     PIC X(01).

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

      *  --->> "REGLANC.COB"
      *
       01  DADOS-LANC-WS.
           05  POS-LANC-WS                     PIC X(128).
           05  TAM-LANC-WS                     PIC 99 COMP-0 VALUE 89.
      *         tamanho da pagina --> 512 (5 registros)
       01  CADLANC-WS.
           05  U-LANC-WS                       PIC X(01).
           05  FILLER VALUE ":BX"              PIC X(03).
           05  DATA-BX-WS                      PIC 9(04).
           05  FILIAL-LANC-WS                  PIC 9(02).
           05  FILLER VALUE ".CRC"             PIC X(04).
       01  REG-LANC-WS.
           05  CHAVE-LANC.
               10  CODIGO-LANC                 PIC 9(08).
               10  DUP-LANC REDEFINES CODIGO-LANC.
                   15  TIPO-LANC               PIC X(01).
                   15  CORPO-LANC              PIC 9(07).
               10  DT-PAG-LANC                 PIC 9(06).
               10  VALOR-PAG-LANC              PIC 9(13).
           05  DT-VENC-LANC                    PIC S9(06) COMP-3.
           05  VALOR-JURO-LANC                 PIC S9(11) COMP-3.
           05  VALOR-DESP-LANC                 PIC S9(11) COMP-3.
           05  VALOR-DESC-LANC                 PIC S9(11) COMP-3.
           05  REGIAO-LANC                     PIC S9(03) COMP-3.
           05  BANCO-LANC                      PIC S9(03) COMP-3.
           05  NATU-LANC                       PIC 9(02).
           05  COD-OPER-LANC                   PIC X(01).
      *        "1"   FATURAMENTO     
      *        "2"   BAIXA INTEGRAL
      *        "3"   BAIXA PARCELADA
      *        "4"   DEVOLUCAO
      *        "5"   INCOBRAVEL
           05  CHAVE-LOTE-LANC                 PIC X(27).
           05  STATUS-LANC                     PIC X(01).
           05  VERSAO-LANC                     PIC X(01).
           05  FILLER                          PIC X(16).
      *---------------------------------------------------------
      *
       01  CADLANC-TX.
           05  U-LANC-TX                       PIC X(01).
           05  FILLER VALUE ":BX"              PIC X(03).
           05  DATA-BX-TX                      PIC 9(04).
           05  FILIAL-LANC-TX                  PIC 9(02).
           05  FILLER VALUE ".BAX"             PIC X(04).
      *

       PROCEDURE DIVISION.
      *
       INICIO-010.
           DISPLAY (1, 1) ERASE.
       015-DATAS.
           DISPLAY (5, 22) "* conversao ARQ. BAIXAS DUP EM TXT *"

           DISPLAY (10, 10) "Informe o Drive dos arqs:"
           ACCEPT (, ) U-LANC-WS WITH PROMPT UPDATE
           ACCEPT ESCAPE-77 FROM ESCAPE KEY
           IF ESCAPE-77 NOT = ZEROS STOP RUN.
           MOVE U-LANC-WS TO U-LANC-TX.

           DISPLAY (11, 10) "Informe a Filial .......:"
           ACCEPT (, ) FILIAL-LANC-WS WITH PROMPT UPDATE
           IF ESCAPE-77 NOT = ZEROS GO TO INICIO-010.
           MOVE FILIAL-LANC-WS   TO FILIAL-LANC-TX.

           DISPLAY (12, 10) "Data Inicial (dd/mm)....:"
           ACCEPT (, ) DD-MM-77 WITH PROMPT UPDATE
           IF ESCAPE-77 NOT = ZEROS GO TO INICIO-010.
           MOVE DD-MM-77 TO INICIAL-WS FINAL-WS

           IF DIA-INI-WS = ZEROS GO TO INICIO-010.
           DISPLAY (13, 10) "Data Final   (dd/mm)....:" DD-MM-77
           ACCEPT (13, 35) DIA-FIM-WS WITH PROMPT UPDATE
           IF ESCAPE-77 NOT = ZEROS GO TO INICIO-010.

           DISPLAY (14, 10) "LIDOS:      GRAVADOS:".
           MOVE FILIAL-LANC-WS   TO FILIAL-LANC-TX.
           SUBTRACT 1 FROM DIA-INI-WS.

       020-ABRE-ARQ.

           ADD 1 TO DIA-INI-WS
           IF DIA-INI-WS > DIA-FIM-WS
              GO TO 015-DATAS.
           MOVE INICIAL-WS TO DATA-BX-WS DATA-BX-TX 

           OPEN OUTPUT ARQ-TX.

           MOVE 999 TO ERRO-WS CAN-WS
           MOVE ABRE-WS TO B-FUNC-WS

           MOVE -1 TO KEY-NUM-WS
           MOVE 999 TO ERRO-WS CAN-WS
           PERFORM MOVE-DADOS-LANC
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

           MOVE REGISTRO-WS TO REG-LANC-WS.
           PERFORM MOVE-INFO
	   IF CODIGO-LANC > 0
              WRITE REG-LANC-TX.
           ADD 1 TO GRAVADOS-77
           DISPLAY (14, 32) GRAVADOS-77
           MOVE 09 TO ERRO-WS
           MOVE 0 TO KEY-NUM-WS
           MOVE LER-PROX-WS TO B-FUNC-WS
           CALL "BTVCAL" USING DADOS-WS
           GO TO LEITURA-020.
      *
      *     -------------------------->  "DADONTFS.COB"
       MOVE-DADOS-LANC.
      *
           MOVE POS-LANC-WS TO POS-WS
           MOVE CADLANC-WS TO NOME-ARQ-WS
           MOVE TAM-LANC-WS TO TAMANHO-WS
           MOVE REG-LANC-WS TO REGISTRO-WS.
      *
       VOLTA-DADOS-LANC.
           MOVE POS-WS TO POS-LANC-WS
           MOVE ZERO TO ERRO-WS
           MOVE REGISTRO-WS TO REG-LANC-WS.
      *
       MOVE-INFO.
           MOVE  TIPO-LANC                TO  TIPO-TX          
           MOVE  CORPO-LANC               TO  CORPO-TX         
           MOVE  DT-PAG-LANC              TO  DT-PAG-TX        
           MOVE  VALOR-PAG-LANC           TO  VALOR-PAG-TX     
           MOVE  DT-VENC-LANC             TO  DT-VENC-TX       
           MOVE  VALOR-JURO-LANC          TO  VALOR-JURO-TX    
           MOVE  VALOR-DESP-LANC          TO  VALOR-DESP-TX    
           MOVE  VALOR-DESC-LANC          TO  VALOR-DESC-TX    
           MOVE  REGIAO-LANC              TO  REGIAO-TX        
           MOVE  BANCO-LANC               TO  BANCO-TX         
           MOVE  NATU-LANC                TO  NATU-TX          
           MOVE  COD-OPER-LANC            TO  COD-OPER-TX      
           MOVE  CHAVE-LOTE-LANC          TO  CHAVE-LOTE-TX    
           MOVE  STATUS-LANC              TO  STATUS-TX        
           MOVE  VERSAO-LANC              TO  VERSAO-TX        