      *
       IDENTIFICATION DIVISION.
      *
       PROGRAM-ID. CONVCLIE.
       AUTHOR. LUIS AUGUSTO.
      *
      *    DATA DA ALTERACAO: 11/95
      *
      *    ESTE PROGRAMA GERA ARQ. TXT DE ARQ CLI DO ESTOQUE
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
           VALUE     OF FILE-ID   ARQCLI-TX
           DATA      RECORD       REGCLI-TX.
C      01  REGCLI-TX.
           05  TIPO-TX                        PIC 9(01).
               88  PESSOA-FISICA VALUE 0.
               88  PESSOA-JURIDICA VALUE 1.
           05  CHAVE-TX.
               10  FILIAL-TX                  PIC 9(02).
               10  CPF-CGC-TX                 PIC 9(14).
           05  PESSOA-FISICA-TX.
               10  NOMER-TX                   PIC X(39).
               10  ENDR-TX                    PIC X(30).
               10  MUNR-TX                    PIC X(20).
               10  BAIRROR-TX                 PIC X(14).
               10  UFR-TX                     PIC X(02).
               10  CEPR-TX                    PIC 9(05).
               10  TELR-TX                    PIC 9(07).
               10  DT-NASC-TX                 PIC 9(06).
               10  SEXO-TX                    PIC X(01).
           05  PESSOA-JURIDICA-TX.
               10  NOMEC-TX                   PIC X(39).
               10  ENDC-TX                    PIC X(30).
               10  MUNC-TX                    PIC X(20).
               10  BAIRROC-TX                 PIC X(14).
               10  UFC-TX                     PIC X(02).
               10  CEPC-TX                    PIC 9(05).
               10  TELC-TX                    PIC 9(07).
               10  INSC-ESTADUAL-TX           PIC 9(13).
           05  REGIAO-TX                      PIC 9(03).
           05  COBRANCA-TX                    PIC 9(01).
               88  RESIDENCIAL-TX VALUE 0.
               88  COMERCIAL-TX   VALUE 1.
           05  LIMITE-CRED-TX                 PIC 9(07).
           05  MEDIAS-DIAS-TX                 PIC 9(03).
           05  STATUS-TX                      PIC 9(01).
               88  CLIENTE-NORMAL VALUE 0.
               88  CLIENTE-NEGATIVO VALUE 1.
           05  NATU-TX                        PIC 9(01).
               88  PODER-PUBLICO  VALUE 1.
               88  OUTROS-PODERES VALUE 0.
           05  DATA-TX                        PIC 9(06).
           05  TIPO-REG-TX                    PIC X(01).
           05  MAIOR-ATRASO-TX                PIC 9(03).
           05  VENDEDOR-TX                    PIC 9(03).
           05  DATA-CAD-TX                    PIC 9(06).
           05  CEP2R-TX                       PIC 9(03).
           05  CEP2C-TX                       PIC 9(03).
           05  OBSERVACAO-TX                  PIC X(25).
           05  MAIS-DADOS-TX                  PIC X(01).

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

      * REGISTRO DO CADASTRO DE CLIENTES <REGCLI.COB>
       01  DADOS-CLI-WS.
           05  POS-CLI-WS                      PIC X(128).
           05  TAM-CLI-WS                      PIC 99 COMP-0 VALUE 331.
      *         tamanho da pagina --> 1024 (3 registros)
       01  ARQCLI-WS.
           05  U-CLI-WS                        PIC X(01).
           05  FILLER VALUE ":ARQCLI"          PIC X(07).
           05  FILIAL-CLI-WS                   PIC 9(02).
           05  FILLER VALUE ".FAT"             PIC X(04).
       01  ARQCLI-REG.
           05  TIPO-CLI                        PIC 9(01).
               88  PESSOA-FISICA VALUE 0.
               88  PESSOA-JURIDICA VALUE 1.
           05  CHAVE-CLI.
               10  FILIAL-CLI                  PIC 9(02).
               10  CPF-CGC-CLI                 PIC 9(14).
           05  PESSOA-FISICA-CLI.
               10  NOMER-CLI                   PIC X(39).
               10  ENDR-CLI                    PIC X(30).
               10  MUNR-CLI                    PIC X(20).
               10  BAIRROR-CLI                 PIC X(14).
               10  UFR-CLI                     PIC X(02).
               10  CEPR-CLI                    PIC 9(05)  COMP-3.
               10  TELR-CLI                    PIC 9(07)  COMP-3.
               10  DT-NASC-CLI                 PIC 9(06)  COMP-3.
               10  SEXO-CLI                    PIC X(01).
           05  PESSOA-JURIDICA-CLI.
               10  NOMEC-CLI                   PIC X(39).
               10  ENDC-CLI                    PIC X(30).
               10  MUNC-CLI                    PIC X(20).
               10  BAIRROC-CLI                 PIC X(14).
               10  UFC-CLI                     PIC X(02).
               10  CEPC-CLI                    PIC 9(05)  COMP-3.
               10  TELC-CLI                    PIC 9(07)  COMP-3.
               10  INSC-ESTADUAL-CLI           PIC 9(13)  COMP-3.
           05  REGIAO-CLI                      PIC 9(03)  COMP-3.
           05  COBRANCA-CLI                    PIC 9(01).
               88  RESIDENCIAL-CLI VALUE 0.
               88  COMERCIAL-CLI   VALUE 1.
           05  LIMITE-CRED-CLI                 PIC S9(07) COMP-3.
           05  MEDIAS-DIAS-CLI                 PIC S9(03) COMP-3.
           05  STATUS-CLI                      PIC 9(01).
               88  CLIENTE-NORMAL VALUE 0.
               88  CLIENTE-NEGATIVO VALUE 1.
           05  NATU-CLI                        PIC 9(01).
               88  PODER-PUBLICO  VALUE 1.
               88  OUTROS-PODERES VALUE 0.
           05  DATA-CLI                        PIC 9(06)  COMP-3.
           05  TIPO-REG-CLI                    PIC X(01).
           05  MAIOR-ATRASO-CLI                PIC S9(03) COMP-3.
           05  VENDEDOR-CLI                    PIC S9(03) COMP-3.
           05  DATA-CAD-CLI                    PIC 9(06).
           05  CEP2R-CLI                       PIC 9(03).
           05  CEP2C-CLI                       PIC 9(03).
           05  OBSERVACAO-CLI                  PIC X(25).
           05  MAIS-DADOS-CLI                  PIC X(01).
           05  FILLER                          PIC X(20).
      *---------------------------------------------------------
       01  ARQCLI-TX.
C          05  U-CLI-TX                       PIC X(01).
C          05  FILLER VALUE ":ARQCLI"          PIC X(07).
C          05  FILIAL-CLI-TX                  PIC 9(02).
C          05  FILLER VALUE ".TXT"             PIC X(04).

      *

       PROCEDURE DIVISION.
      *
       INICIO-010.
           DISPLAY (1, 1) ERASE.
       015-DATAS.
           DISPLAY (5, 22) "* conversao ARQ CLIENTES EM TXT *"

           DISPLAY (10, 10) "Informe o Drive dos arqs:"
           ACCEPT (, ) U-CLI-WS WITH PROMPT UPDATE
           ACCEPT ESCAPE-77 FROM ESCAPE KEY
           IF ESCAPE-77 NOT = ZEROS STOP RUN.
           MOVE U-CLI-WS TO U-CLI-TX.

           DISPLAY (11, 10) "Informe a Filial .......:"
           ACCEPT (, ) FILIAL-CLI-WS WITH PROMPT UPDATE
           IF ESCAPE-77 NOT = ZEROS GO TO INICIO-010.
           MOVE FILIAL-CLI-WS   TO FILIAL-CLI-TX.

           DISPLAY (14, 10) "LIDOS:      GRAVADOS:".

       020-ABRE-ARQ.

           OPEN OUTPUT ARQ-TX.

           MOVE 999 TO ERRO-WS CAN-WS
           MOVE ABRE-WS TO B-FUNC-WS

           MOVE -1 TO KEY-NUM-WS
           MOVE 999 TO ERRO-WS CAN-WS
           PERFORM MOVE-DADOS-CLI
           CALL "BTVCAL" USING DADOS-WS

           IF  B-STATUS-WS = 12
               MOVE ARQCLI-WS TO ARQBT-WS
               MOVE U-CLI-WS TO LETRA1BT-WS 
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
           MOVE ZEROS TO REGCLI-TX.
           MOVE REGISTRO-WS TO ARQCLI-REG.
           PERFORM MOVE-INFO

           WRITE REGCLI-TX

           ADD 1 TO GRAVADOS-77
           DISPLAY (14, 32) GRAVADOS-77
           MOVE 09 TO ERRO-WS
           MOVE 0 TO KEY-NUM-WS
           MOVE LER-PROX-WS TO B-FUNC-WS
           CALL "BTVCAL" USING DADOS-WS
           GO TO LEITURA-020.
      *
      *     -------------------------->  "DADOGRUP.COB"
       MOVE-DADOS-CLI.
      *
           MOVE POS-CLI-WS TO POS-WS
           MOVE ARQCLI-WS TO NOME-ARQ-WS
           MOVE TAM-CLI-WS TO TAMANHO-WS
           MOVE ARQCLI-REG TO REGISTRO-WS.
      *
       VOLTA-DADOS-CLI.
           MOVE POS-WS TO POS-CLI-WS
           MOVE ZERO TO ERRO-WS
           MOVE REGISTRO-WS TO ARQCLI-REG.
      *
       MOVE-INFO.
           MOVE  TIPO-CLI           TO  TIPO-TX                
           MOVE  FILIAL-CLI         TO  FILIAL-TX              
           MOVE  CPF-CGC-CLI        TO  CPF-CGC-TX             
           MOVE  NOMER-CLI          TO  NOMER-TX               
           MOVE  ENDR-CLI           TO  ENDR-TX                
           MOVE  MUNR-CLI           TO  MUNR-TX                
           MOVE  BAIRROR-CLI        TO  BAIRROR-TX             
           MOVE  UFR-CLI            TO  UFR-TX                 
           MOVE  CEPR-CLI           TO  CEPR-TX                
           MOVE  TELR-CLI           TO  TELR-TX                
           MOVE  DT-NASC-CLI        TO  DT-NASC-TX             
           MOVE  SEXO-CLI           TO  SEXO-TX                
           MOVE  NOMEC-CLI          TO  NOMEC-TX               
           MOVE  ENDC-CLI           TO  ENDC-TX                
           MOVE  MUNC-CLI           TO  MUNC-TX                
           MOVE  BAIRROC-CLI        TO  BAIRROC-TX             
           MOVE  UFC-CLI            TO  UFC-TX                 
           MOVE  CEPC-CLI           TO  CEPC-TX                
           MOVE  TELC-CLI           TO  TELC-TX                
           MOVE  INSC-ESTADUAL-CLI  TO  INSC-ESTADUAL-TX       
           MOVE  REGIAO-CLI         TO  REGIAO-TX              
           MOVE  COBRANCA-CLI       TO  COBRANCA-TX            
           MOVE  LIMITE-CRED-CLI    TO  LIMITE-CRED-TX         
           MOVE  MEDIAS-DIAS-CLI    TO  MEDIAS-DIAS-TX         
           MOVE  STATUS-CLI         TO  STATUS-TX              
           MOVE  NATU-CLI           TO  NATU-TX                
           MOVE  DATA-CLI           TO  DATA-TX                
           MOVE  TIPO-REG-CLI       TO  TIPO-REG-TX            
           MOVE  MAIOR-ATRASO-CLI   TO  MAIOR-ATRASO-TX        
           MOVE  VENDEDOR-CLI       TO  VENDEDOR-TX            
           MOVE  DATA-CAD-CLI       TO  DATA-CAD-TX            
           MOVE  CEP2R-CLI          TO  CEP2R-TX               
           MOVE  CEP2C-CLI          TO  CEP2C-TX               
           MOVE  OBSERVACAO-CLI     TO  OBSERVACAO-TX          
           MOVE  MAIS-DADOS-CLI     TO  MAIS-DADOS-TX          
           
           
           
           
           
           
           
           
           
           


           
           
           























