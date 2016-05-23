      *
       IDENTIFICATION DIVISION.
      *
       PROGRAM-ID. CONVFIXO.
       AUTHOR. LUIS AUGUSTO.
      *
      *    DATA DA ALTERACAO: 11/95
      *
      *    ESTE PROGRAMA GERA ARQ. TXT DE ARQ FIXO DO ESTOQUE
      *    ARQUIVO DE ARQFIXO
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
           VALUE     OF FILE-ID   ARQFIXO-TX
           DATA      RECORD       REGFIXO-TX.
       01  REGFIXO-TX.
           05  CHAVE-PRIM-TX.
001            10  CODIGO-NUM-TX               PIC 9(07).
               10  CODIGO-TX REDEFINES CODIGO-NUM-TX.
                   15  PARTE1-COD-TX           PIC 9(02).
                   15  PARTE2-COD-TX           PIC 9(01).
                   15  PARTE3-COD-TX           PIC 9(03).
                   15  PARTE4-COD-TX           PIC 9(01).
008        05  DESCRICAO-TX                    PIC X(25).
           05  CHAVE-SEC-TX.
033            10  GRUPO-TX                    PIC 9(02).
035            10  SUBGRUPO-TX                 PIC 9(03).
038            10  CLASS-TX                    PIC 9(03).
041            10  SEQ-TX                      PIC 9(03).
044            10  MARCA-TX                    PIC 9(01).
045        05  GRUPO-SAI-TX                    PIC 9(02).
      *        GRUPO   0=01   1=02  2=03  3=06  4=04  5=05
      *        SUB-GR 91=07  92=08  93=09
047        05  GRUPO-ENT-TX                    PIC 9(02).
      *        GRUPO 0=01  1=02  2=03  3=09  4=04  5=05  6=06  7=07
      *              8=08  9.091=7      9.092=8      9.093=9
049        05  UNIDADE-TX                      PIC X(02).
051        05  FORNECEDOR-TX                   PIC 9(03).
053        05  VALOR-TAB-TX                    PIC 9(11).
           05  PESO-TX                         PIC 9(04)V9(03).
           05  STATUS-TX                       PIC X(01).
           05  PROT-TX                         PIC X(01).
           05  EMITE-TAB-TX.
               10  NUM-EMI-TX OCCURS 10 TIMES  PIC X(01).
           05  EXISTE-ALX-TX.
               10  OCC-ALX-TX OCCURS 10 TIMES  PIC X(01).
           05  EMITE-PED-TX                    PIC X(01).
      *        'S' -->  EMITE PEDIDO
      *        'N' -->  NAO EMITE PEDIDO
           05  ORIGEM-TX                       PIC 9(01).
           05  TIPO-IMPOSTO-TX                 PIC 9(01).

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

      * ARQUIVO DA PARTE FIXA DO ESTOQUE <REGFIXO.COB>
      *
       01  DADOS-FIXO-WS.
           05  POS-FIXO-WS                      PIC X(128).
           05  TAM-FIXO-WS                      PIC 99 COMP-0 VALUE 212.
      *         tamanho da parte fixa --> 87 bytes.
      *         tamanho da pagina     --> 512 (5 registros)
      *         parte variavel        --> 125 bytes.
       01  ARQFIXO-WS.
           05  U-FIXO-WS                       PIC X(01).
           05  FILLER VALUE ":ARQFIXO.EST"     PIC X(13).
       01  REGFIXO-WS.
           05  CHAVE-PRIM-WS.
001            10  CODIGO-NUM-WS               PIC 9(07).
               10  CODIGO-WS REDEFINES CODIGO-NUM-WS.
                   15  PARTE1-COD-WS           PIC 9(02).
                   15  PARTE2-COD-WS           PIC 9(01).
                   15  PARTE3-COD-WS           PIC 9(03).
                   15  PARTE4-COD-WS           PIC 9(01).
008        05  DESCRICAO-WS                    PIC X(25).
           05  CHAVE-SEC-WS.
033            10  GRUPO-WS                    PIC 9(02).
035            10  SUBGRUPO-WS                 PIC 9(03).
038            10  CLASS-WS                    PIC 9(03).
041            10  SEQ-WS                      PIC 9(03).
044            10  MARCA-WS                    PIC 9(01).
045        05  GRUPO-SAI-WS                    PIC 9(02).
047        05  GRUPO-ENT-WS                    PIC 9(02).
049        05  UNIDADE-WS                      PIC X(02).
051        05  FORNECEDOR-WS                   PIC 9(03)  COMP-3.
053        05  VALOR-TAB-WS                   PIC S9(11) COMP-3.
           05  PESO-WS                         PIC 9(04)V9(03) COMP-3.
           05  STATUS-WS                       PIC X(01).
           05  PROT-WS                         PIC X(01).
           05  EMITE-TAB-WS.
               10  NUM-EMI-WS OCCURS 10 TIMES  PIC X(01).
           05  EXISTE-ALX-WS.
               10  OCC-ALX-WS OCCURS 10 TIMES  PIC X(01).
           05  EMITE-PED-WS                    PIC X(01).
      *        'S' -->  EMITE PEDIDO
      *        'N' -->  NAO EMITE PEDIDO
           05  ORIGEM-WS                       PIC 9(01).
           05  TIPO-IMPOSTO-WS                 PIC 9(01).
           05  TAB-AUX-WS.
               10  DESCR-SEC-WS OCCURS 05      PIC X(25).
      *---------------------------------------------------------
       01  ARQFIXO-TX.
           05  U-FIXO-TX                       PIC X(01).
           05  FILLER VALUE ":ARQFIXO.TXT"     PIC X(13).
      *

       PROCEDURE DIVISION.
      *
       INICIO-010.
           DISPLAY (1, 1) ERASE.
       015-DATAS.
           DISPLAY (5, 22) "* conversao ARQ FIXO EM TXT *"

           DISPLAY (10, 10) "Informe o Drive dos arqs:"
           ACCEPT (, ) U-FIXO-WS WITH PROMPT UPDATE
           ACCEPT ESCAPE-77 FROM ESCAPE KEY
           IF ESCAPE-77 NOT = ZEROS STOP RUN.
           MOVE U-FIXO-WS TO U-FIXO-TX.


           DISPLAY (14, 10) "LIDOS:      GRAVADOS:".

       020-ABRE-ARQ.

           OPEN OUTPUT ARQ-TX.

           MOVE 999 TO ERRO-WS CAN-WS
           MOVE ABRE-WS TO B-FUNC-WS

           MOVE -1 TO KEY-NUM-WS
           MOVE 999 TO ERRO-WS CAN-WS
           PERFORM MOVE-DADOS-FIXO
           CALL "BTVCAL" USING DADOS-WS

           IF  B-STATUS-WS = 12
               MOVE ARQFIXO-WS TO ARQBT-WS
               MOVE U-FIXO-WS TO LETRA1BT-WS 
               MOVE "P" TO LETRA2BT-WS
               MOVE "CRIFIXO.BTV" TO DEFBT-WS
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
           MOVE ZEROS TO REGFIXO-TX.
           MOVE REGISTRO-WS TO REGFIXO-WS.
           PERFORM MOVE-INFO
           move 1 to i
           PERFORM VARYING I FROM 1 BY 1 UNTIL I > 10
             DISPLAY (15, 32) I
             MOVE NUM-EMI-WS (I) TO NUM-EMI-TX (I) 
             MOVE OCC-ALX-WS (I) TO OCC-ALX-TX (I)
           END-PERFORM
           move 1 to i

           WRITE REGFIXO-TX

           ADD 1 TO GRAVADOS-77
           DISPLAY (14, 32) GRAVADOS-77
           MOVE 09 TO ERRO-WS
           MOVE 0 TO KEY-NUM-WS
           MOVE LER-PROX-WS TO B-FUNC-WS
           CALL "BTVCAL" USING DADOS-WS
           GO TO LEITURA-020.
      *
      *     -------------------------->  "DADOFIXO.COB"
       MOVE-DADOS-FIXO.
      *
           MOVE POS-FIXO-WS TO POS-WS
           MOVE ARQFIXO-WS TO NOME-ARQ-WS
           MOVE TAM-FIXO-WS TO TAMANHO-WS
           MOVE REGFIXO-WS TO REGISTRO-WS.
      *
       VOLTA-DADOS-FIXO.
           MOVE POS-WS TO POS-FIXO-WS
           MOVE ZERO TO ERRO-WS
           MOVE REGISTRO-WS TO REGFIXO-WS.
      *
       MOVE-INFO.
           MOVE  CODIGO-NUM-WS              TO  CODIGO-NUM-TX              
           MOVE  DESCRICAO-WS               TO  DESCRICAO-TX               
           MOVE  GRUPO-WS                   TO  GRUPO-TX                   
           MOVE  SUBGRUPO-WS                TO  SUBGRUPO-TX                
           MOVE  CLASS-WS                   TO  CLASS-TX                   
           MOVE  SEQ-WS                     TO  SEQ-TX                     
           MOVE  MARCA-WS                   TO  MARCA-TX                   
           MOVE  GRUPO-SAI-WS               TO  GRUPO-SAI-TX               
           MOVE  GRUPO-ENT-WS               TO  GRUPO-ENT-TX               
           MOVE  UNIDADE-WS                 TO  UNIDADE-TX                 
           MOVE  FORNECEDOR-WS              TO  FORNECEDOR-TX              
           MOVE  VALOR-TAB-WS               TO  VALOR-TAB-TX               
           MOVE  PESO-WS                    TO  PESO-TX                    
           MOVE  STATUS-WS                  TO  STATUS-TX                  
      *     MOVE  PROT-WS                    TO  PROT-TX                    
           MOVE  ORIGEM-WS                  TO  ORIGEM-TX                  
           MOVE  TIPO-IMPOSTO-WS            TO  TIPO-IMPOSTO-TX            



           
           
           
           
           
           
           
           
           
           
           
           
           
           
           


           
           
           
