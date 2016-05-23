      *
       IDENTIFICATION DIVISION.
      *
       PROGRAM-ID. CONVSALD.
       AUTHOR. LUIS AUGUSTO.
      *
      *    DATA DA ALTERACAO: 11/95
      *
      *    ESTE PROGRAMA GERA ARQ. TXT DE ARQ ALX DO ESTOQUE
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
           VALUE     OF FILE-ID   ARQALX-TX
           DATA      RECORD       REGALX-TX.
C      01  REGALX-TX.
C          05  CHAVE-TX.
C              10  COD-FILIAL-TX              PIC 9(02).
C              10  CODIGO-TX                  PIC 9(07).
C          05  CHAVE-SEC-TX.
C              10  GRUPO-TX                   PIC 9(02).
C              10  SUBGRUPO-TX                PIC 9(03).
C              10  CLASS-TX                   PIC 9(03).
C              10  SEQ-TX                     PIC 9(03).
C              10  MARCA-TX                   PIC 9(01).
C          05  LOCACAO-TX                     PIC X(05).
C          05  QTD-EST-TX                     PIC 9(05).
C          05  VALOR-EST-TX                   PIC 9(11).
C          05  DT-ULT-ENT-TX                  PIC 9(06).
C          05  DT-ULT-SAI-TX                  PIC 9(06).
C          05  ULT-CUSTO-TX                   PIC 9(11).
C          05  PENDENTE-TX                    PIC X(01).
C          05  STATUS-TX                      PIC 9(01).
C          05  ACUM-TX.
C              10  EST-ANT-TX                 PIC 9(05).
C              10  QTD-COMPRAS-TX             PIC 9(05).
C              10  VAL-COMPRAS-TX             PIC 9(11).
C              10  QTD-VENDAS-TX              PIC 9(05).
C              10  VAL-VENDAS-TX              PIC 9(11).
C              10  QTD-TRANSF-ENT-TX          PIC 9(05).
C              10  VAL-TRANSF-ENT-TX          PIC 9(11).
C              10  QTD-OUTRAS-ENT-TX          PIC 9(05).
C              10  VAL-OUTRAS-ENT-TX          PIC 9(11).
C              10  QTD-TRANSF-SAI-TX          PIC 9(05).
C              10  VAL-TRANSF-SAI-TX          PIC 9(11).
C              10  QTD-OUTRAS-SAI-TX          PIC 9(05).
C              10  VAL-OUTRAS-SAI-TX          PIC 9(11).
C              10  VALOR-TAB-TX               PIC 9(11).
C              10  VALOR-MEDIO-TX             PIC 9(11).
C          05  NTF-TX                         PIC 9(06).
C          05  CUSTO-MEDIO-TX                 PIC 9(11).
C          05  QTD-ULT-ENT-TX                 PIC 9(05).
C          05  VAL-VEND-LIQ-TX                PIC 9(11).
C          05  VAL-ANT-TX                     PIC 9(11).
C          05  VAL-ENC-TX                     PIC 9(11).
C          05  CUSTO-VAREJO-TX                PIC 9(11).

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

C     * REGISTRO DOS ARQUIVOS DE ALMOXARIFADO <REGALX.COB>
C     *
C      01  DADOS-ALX-WS.
C          05  POS-ALX-WS                      PIC X(128).
C          05  TAM-ALX-WS                      PIC 99 COMP-0 VALUE 245.
C     *         tamanho da pagina --> 1024 (5 registros)
C      01  ARQALX-WS.
C          05  U-ALX-WS                        PIC X(01).
C          05  FILLER VALUE ":ARQALX"          PIC X(07).
C          05  FILIAL-ALX-WS                   PIC 9(02).
C          05  FILLER VALUE ".EST"             PIC X(04).
C      01  ARQALX-REG.
C          05  CHAVE-ALX.
C              10  COD-FILIAL-ALX              PIC 9(02).
C              10  CODIGO-ALX                  PIC 9(07).
C          05  CHAVE-SEC-ALX.
C              10  GRUPO-ALX                   PIC 9(02).
C              10  SUBGRUPO-ALX                PIC 9(03).
C              10  CLASS-ALX                   PIC 9(03).
C              10  SEQ-ALX                     PIC 9(03).
C              10  MARCA-ALX                   PIC 9(01).
C          05  LOCACAO-ALX                     PIC X(05).
C          05  QTD-EST-ALX                     PIC S9(05) COMP-3.
C          05  VALOR-EST-ALX                   PIC S9(11) COMP-3.
C          05  DT-ULT-ENT-ALX                  PIC 9(06)  COMP-3.
C          05  DT-ULT-SAI-ALX                  PIC 9(06)  COMP-3.
C          05  ULT-CUSTO-ALX                   PIC S9(11) COMP-3.
C          05  SAIDAS-ANT-ALX.
C              10  SAI-ANT-ALX OCCURS 6        PIC S9(05) COMP-3.
C          05  PENDENTE-ALX                    PIC X(01).
C     *        TEM PENDENTES     = 'S'
C     *        NAO TEM PENDENTES = 'N'
C          05  STATUS-ALX                      PIC 9(01).
C              88  ABAIXO-MINIMO VALUE 1.
C              88  PONTO-DE-PEDIDO VALUE 2.
C              88  ACIMA-MAXIMO VALUE 3.
C              88  NORMAL VALUE 4.
C          05  ACUM-ALX.
C              10  EST-ANT-ALX                 PIC S9(05) COMP-3.
C              10  QTD-COMPRAS-ALX             PIC S9(05) COMP-3.
C              10  VAL-COMPRAS-ALX             PIC S9(11) COMP-3.
C              10  QTD-VENDAS-ALX              PIC S9(05) COMP-3.
C              10  VAL-VENDAS-ALX              PIC S9(11) COMP-3.
C              10  QTD-TRANSF-ENT-ALX          PIC S9(05) COMP-3.
C              10  VAL-TRANSF-ENT-ALX          PIC S9(11) COMP-3.
C              10  QTD-OUTRAS-ENT-ALX          PIC S9(05) COMP-3.
C              10  VAL-OUTRAS-ENT-ALX          PIC S9(11) COMP-3.
C              10  QTD-TRANSF-SAI-ALX          PIC S9(05) COMP-3.
C              10  VAL-TRANSF-SAI-ALX          PIC S9(11) COMP-3.
C              10  QTD-OUTRAS-SAI-ALX          PIC S9(05) COMP-3.
C              10  VAL-OUTRAS-SAI-ALX          PIC S9(11) COMP-3.
C              10  VALOR-TAB-ALX               PIC S9(11) COMP-3.
C              10  VALOR-MEDIO-ALX             PIC S9(11) COMP-3.
C          05  RESERVA-ALX OCCURS 5 TIMES.
C              10  VEND-ALX                    PIC S9(03) COMP-3.
C              10  QTD-RES-ALX                 PIC S9(05) COMP-3.
C              10  POS-VEND-ALX                PIC 9(02).
C          05  NTF-ALX                         PIC S9(06) COMP-3.
C          05  CUSTO-MEDIO-ALX                 PIC S9(11) COMP-3.
C          05  QTD-ULT-ENT-ALX                 PIC S9(05) COMP-3.
C          05  VAL-VEND-LIQ-ALX                PIC S9(11) COMP-3.
C          05  VAL-ANT-ALX                     PIC S9(11) COMP-3.
C          05  VAL-ENC-ALX                     PIC S9(11) COMP-3.
C          05  CUSTO-VAREJO-ALX                PIC S9(11) COMP-3.
C          05  FILLER                          PIC X(35).
C     *
      *---------------------------------------------------------
C      01  ARQALX-TX.
C          05  U-ALX-TX                        PIC X(01).
C          05  FILLER VALUE ":ARQALX"          PIC X(07).
C          05  FILIAL-ALX-TX                   PIC 9(02).
C          05  FILLER VALUE ".TXT"             PIC X(04).
      *

       PROCEDURE DIVISION.
      *
       INICIO-010.
           DISPLAY (1, 1) ERASE.
       015-DATAS.
           DISPLAY (5, 22) "* conversao ARQ ALMOXERIFADO EM TXT *"

           DISPLAY (10, 10) "Informe o Drive dos arqs:"
           ACCEPT (, ) U-ALX-WS WITH PROMPT UPDATE
           ACCEPT ESCAPE-77 FROM ESCAPE KEY
           IF ESCAPE-77 NOT = ZEROS STOP RUN.
           MOVE U-ALX-WS TO U-ALX-TX.

           DISPLAY (11, 10) "Informe a Filial .......:"
           ACCEPT (, ) FILIAL-ALX-WS WITH PROMPT UPDATE
           IF ESCAPE-77 NOT = ZEROS GO TO INICIO-010.
           MOVE FILIAL-ALX-WS   TO FILIAL-ALX-TX.

           DISPLAY (14, 10) "LIDOS:      GRAVADOS:".

       020-ABRE-ARQ.

           OPEN OUTPUT ARQ-TX.

           MOVE 999 TO ERRO-WS CAN-WS
           MOVE ABRE-WS TO B-FUNC-WS

           MOVE -1 TO KEY-NUM-WS
           MOVE 999 TO ERRO-WS CAN-WS
           PERFORM MOVE-DADOS-ALX
           CALL "BTVCAL" USING DADOS-WS

           IF  B-STATUS-WS = 12
               MOVE ARQALX-WS TO ARQBT-WS
               MOVE U-ALX-WS TO LETRA1BT-WS 
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
           MOVE ZEROS TO REGALX-TX.
           MOVE REGISTRO-WS TO ARQALX-REG.
           PERFORM MOVE-INFO

           WRITE REGALX-TX

           ADD 1 TO GRAVADOS-77
           DISPLAY (14, 32) GRAVADOS-77
           MOVE 09 TO ERRO-WS
           MOVE 0 TO KEY-NUM-WS
           MOVE LER-PROX-WS TO B-FUNC-WS
           CALL "BTVCAL" USING DADOS-WS
           GO TO LEITURA-020.
      *
      *     -------------------------->  "DADOGRUP.COB"
       MOVE-DADOS-ALX.
      *
           MOVE POS-ALX-WS TO POS-WS
           MOVE ARQALX-WS TO NOME-ARQ-WS
           MOVE TAM-ALX-WS TO TAMANHO-WS
           MOVE ARQALX-REG TO REGISTRO-WS.
      *
       VOLTA-DADOS-ALX.
           MOVE POS-WS TO POS-ALX-WS
           MOVE ZERO TO ERRO-WS
           MOVE REGISTRO-WS TO ARQALX-REG.
      *
       MOVE-INFO.
C          MOVE  COD-FILIAL-ALX          TO  COD-FILIAL-TX      
C          MOVE  CODIGO-ALX              TO  CODIGO-TX          
C          MOVE  GRUPO-ALX               TO  GRUPO-TX           
C          MOVE  SUBGRUPO-ALX            TO  SUBGRUPO-TX        
C          MOVE  CLASS-ALX               TO  CLASS-TX           
C          MOVE  SEQ-ALX                 TO  SEQ-TX             
C          MOVE  MARCA-ALX               TO  MARCA-TX           
C          MOVE  LOCACAO-ALX             TO  LOCACAO-TX         
C          MOVE  QTD-EST-ALX             TO  QTD-EST-TX         
C          MOVE  VALOR-EST-ALX           TO  VALOR-EST-TX       
C          MOVE  DT-ULT-ENT-ALX          TO  DT-ULT-ENT-TX      
C          MOVE  DT-ULT-SAI-ALX          TO  DT-ULT-SAI-TX      
C          MOVE  ULT-CUSTO-ALX           TO  ULT-CUSTO-TX       
C          MOVE  PENDENTE-ALX            TO  PENDENTE-TX        
C          MOVE  STATUS-ALX              TO  STATUS-TX          
C          MOVE  EST-ANT-ALX             TO  EST-ANT-TX         
C          MOVE  QTD-COMPRAS-ALX         TO  QTD-COMPRAS-TX     
C          MOVE  VAL-COMPRAS-ALX         TO  VAL-COMPRAS-TX     
C          MOVE  QTD-VENDAS-ALX          TO  QTD-VENDAS-TX      
C          MOVE  VAL-VENDAS-ALX          TO  VAL-VENDAS-TX      
C          MOVE  QTD-TRANSF-ENT-ALX      TO  QTD-TRANSF-ENT-TX  
C          MOVE  VAL-TRANSF-ENT-ALX      TO  VAL-TRANSF-ENT-TX  
C          MOVE  QTD-OUTRAS-ENT-ALX      TO  QTD-OUTRAS-ENT-TX  
C          MOVE  VAL-OUTRAS-ENT-ALX      TO  VAL-OUTRAS-ENT-TX  
C          MOVE  QTD-TRANSF-SAI-ALX      TO  QTD-TRANSF-SAI-TX  
C          MOVE  VAL-TRANSF-SAI-ALX      TO  VAL-TRANSF-SAI-TX  
C          MOVE  QTD-OUTRAS-SAI-ALX      TO  QTD-OUTRAS-SAI-TX  
C          MOVE  VAL-OUTRAS-SAI-ALX      TO  VAL-OUTRAS-SAI-TX  
C          MOVE  VALOR-TAB-ALX           TO  VALOR-TAB-TX       
C          MOVE  VALOR-MEDIO-ALX         TO  VALOR-MEDIO-TX     
C          MOVE  NTF-ALX                 TO  NTF-TX             
C          MOVE  CUSTO-MEDIO-ALX         TO  CUSTO-MEDIO-TX     
C          MOVE  QTD-ULT-ENT-ALX         TO  QTD-ULT-ENT-TX     
C          MOVE  VAL-VEND-LIQ-ALX        TO  VAL-VEND-LIQ-TX    
C          MOVE  VAL-ANT-ALX             TO  VAL-ANT-TX         
C          MOVE  VAL-ENC-ALX             TO  VAL-ENC-TX         
C          MOVE  CUSTO-VAREJO-ALX        TO  CUSTO-VAREJO-TX    
           
     
                
                
                
                
                
                
                
                
                
                
                
     
     
                
                
                
     
     
     
     
     
     
     
     
     
     
     
     
     
     
     
     
     
     
     
     