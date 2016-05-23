       IDENTIFICATION DIVISION.
       PROGRAM-ID. CONVDIR.
       ENVIRONMENT DIVISION.
       CONFIGURATION SECTION.
       SPECIAL-NAMES. DECIMAL-POINT IS COMMA.
       INPUT-OUTPUT SECTION.
       FILE-CONTROL.
      *
           SELECT      ARQ-DIARIO     ASSIGN     TO   DISK
           ORGANIZATION IS SEQUENTIAL
           ACCESS MODE IS SEQUENTIAL
           FILE STATUS IS ESTADO.

           SELECT SAIDA ASSIGN TO "DIARCV.SEQ"
           ORGANIZATION IS LINE SEQUENTIAL
	   FILE STATUS IS ESTADO.
      *
       DATA DIVISION.
       FILE SECTION.
      *
       FD  ARQ-DIARIO
           LABEL     RECORD       STANDARD
           VALUE     OF FILE-ID   DIARIO-WS
           DATA      RECORD       REG-DIARIO.
       01  REG-DIARIO.
           02 D-CONTA             PIC 9(11) COMP-3.
           02 D-CHEC              PIC 9.
           02 D-DATA-L            PIC 9(6) COMP-3.
           02 D-NUM               PIC 9(5) COMP-3.
           02 D-CH                PIC 99.
           02 D-HIST              PIC X(30).
            02 FILLER REDEFINES D-HIST.
               05 HIST-PART1    PIC X(20).
               05 HIST-PART2    PIC X(09).
	       05 FILLER REDEFINES HIST-PART2.
	          10  FILLER    PIC X(02).
		  10  MMAA-HIST PIC X(05).
	       05  FILLER REDEFINES HIST-PART2.
	          10  FILLER    PIC X(01).
		  10  DDMMAA-HIST  PIC X(08).
            02 FILLER REDEFINES D-HIST.
               05 HIST-PART11   PIC X(15).
               05 HIST-PART22   PIC X(15).
           02 D-TIPOHIST          PIC X(01).
           02 D-DOCTO             PIC 9(8) COMP-3.
           02 D-DATA-D            PIC 9(6) COMP-3.
           02 D-CUSTO             PIC 999  COMP-3.
           02 D-ARQ               PIC 9(5) COMP-3.
           02 D-VALOR             PIC 9(12)V99 COMP-3.
           02 D-DC                PIC X.
           02 D-SANT              PIC S9(11)V99 COMP-3.
      *
         FD SAIDA
            LABEL RECORD IS STANDARD.
         01  SAIDA-REG                          PIC X(600).
       WORKING-STORAGE SECTION.
       77 CONTREG               PIC 9(5) VALUE ZERO.
       77 ESTADO                PIC X(02).
       77 TIPOC-77              PIC X(01).
       77 I                     PIC 9(02).
       77 DESCR-77              PIC X(560).
       77 DESCR1-77             PIC X(30).
       77 DESCR2-77             PIC X(30).
       77 LER-77 VALUE ZERO     PIC 9(01).
       01  DESCR-WS             PIC X(30).
       01  FILLER REDEFINES DESCR-WS.
           05  FILLER           PIC X(15).
	   05  DESCR1-WS        PIC X(15).
       01  VALOR-L-WS           PIC 9(12)V9(02).
       01  VALOR-LR-WS REDEFINES VALOR-L-WS PIC 9(14).
       01  DIARIO-WS            PIC X(14).
       01  HISTORA-WS.
           05  FILLER           PIC X(94)
	       VALUE "24464923211327172822100940483345344443353604021539
      -              "30370338011207261611053129251408064241473200".
       01  FILLER REDEFINES HISTORA-WS.
           05  HISTA-WS OCCURS 47 TIMES    PIC 9(02).
       01  HISTORN-WS.
           05  FILLER           PIC X(141)
	       VALUE "22744347721219514225118126520811910438846231643932
      -              "14244103353400530341613732843540493690201380872461
      -              "76123068299270231157091072405392458301000".
       01  FILLER REDEFINES HISTORN-WS.
           05  HISTN-WS OCCURS 47 TIMES    PIC 9(03).
       01  DETALHE-C.
           02 DATA-C   PIC 999999.
           02 FILLER      PIC XXX      VALUE ',0,'.
           02 CONTA-C    PIC 9(08).
           02 FILLER      PIC X      VALUE ','.
           02 VALOR-C     PIC 999999999999.99.
           02 FILLER      PIC X      VALUE ','.
	   02 HIST-C      PIC 999.
           02 FILLER      PIC X      VALUE ','.
           02 DESCR-C     PIC X(559).
       01  DETALHE-D.
           02 DATA-D   PIC 999999.
           02 FILLER      PIC X      VALUE ','.
           02 CONTA-D    PIC 9(08).
           02 FILLER      PIC XXX      VALUE ',0,'.
           02 VALOR-D     PIC 999999999999.99.
           02 FILLER      PIC X      VALUE ','.
	   02 HIST-D      PIC 999.
           02 FILLER      PIC X      VALUE ','.
           02 DESCR-D     PIC X(559).
       PROCEDURE DIVISION.
       INICIO.
           CALL X"E4"
           DISPLAY (12, 10) "DIARIO:"
           ACCEPT (, ) DIARIO-WS WITH PROMPT
	   OPEN INPUT ARQ-DIARIO
	   IF  ESTADO NOT = ZEROS
	       DISPLAY (24, 10) "DIARIO COM ERRO"
	       STOP RUN.
           OPEN OUTPUT SAIDA
	   IF  ESTADO NOT = ZEROS
	       DISPLAY (24, 10) "ARQ-CONV COM ERRO"
	       CLOSE ARQ-DIARIO
	       STOP RUN.
           READ ARQ-DIARIO NEXT
	       AT END
	           DISPLAY (24, 10) "DIARIO VAZIO"
		   CLOSE ARQ-DIARIO SAIDA
		   STOP RUN.
       VOLTA.
           READ ARQ-DIARIO NEXT
               AT END
                      CLOSE ARQ-DIARIO SAIDA
    	              STOP RUN.
           ADD 1 TO CONTREG
	   DISPLAY (20, 20) CONTREG
	   MOVE SPACES TO DESCR-77 DESCR1-77 DESCR2-77

           IF  D-VALOR = ZEROS
               MOVE D-HIST TO DESCR1-77
               READ ARQ-DIARIO NEXT
               IF  D-VALOR = ZEROS
                   MOVE D-HIST TO DESCR2-77
                   READ ARQ-DIARIO NEXT.


           IF  D-CH = ZEROS
               IF  DESCR1-77 = SPACES
                   STRING '"' D-HIST '"'
  	              DELIMITED BY "  " INTO DESCR-77
	       ELSE
  	           STRING '"' DESCR1-77 DESCR2-77 D-HIST '"' 
	               DELIMITED BY "  " INTO DESCR-77
	       END-IF
	   ELSE
           IF  D-TIPOHIST = '6'
	       STRING '"' DDMMAA-HIST '"' DELIMITED BY " " INTO DESCR-77
	   ELSE
	   IF  D-TIPOHIST = '5'
	       STRING '"' MMAA-HIST '"' DELIMITED BY " " INTO DESCR-77
           ELSE
	   IF  D-TIPOHIST = '3' OR D-TIPOHIST = '2'
	       INSPECT HIST-PART2 REPLACING ALL " " BY "0"
	       STRING '"' HIST-PART2 '"' DELIMITED BY " " INTO DESCR-77
           ELSE
	   IF  D-TIPOHIST = '0'
	       MOVE '" "' TO DESCR-77
	   ELSE
	   IF  D-TIPOHIST = '4'
               IF  DESCR1-77 = SPACES
                   STRING '"' HIST-PART22 '"'
  	              DELIMITED BY "  " INTO DESCR-77
	       ELSE
	           MOVE DESCR1-77 TO DESCR-WS
                   STRING '"' DESCR1-WS DESCR2-77 D-HIST '"'
	              DELIMITED BY "  " INTO DESCR-77.
           MOVE D-DC TO TIPOC-77
           PERFORM VARYING I FROM 1 BY 1
	           UNTIL HISTA-WS (I) = D-CH
           END-PERFORM
           IF  D-DC = 'D'
	           MOVE D-DATA-L TO DATA-D
		   MOVE D-CONTA TO CONTA-D
		   MOVE D-VALOR TO VALOR-L-WS
		   MOVE VALOR-LR-WS TO VALOR-D
		   MOVE HISTN-WS (I) TO HIST-D
	           MOVE DESCR-77 TO DESCR-D
		   WRITE SAIDA-REG FROM DETALHE-D
           ELSE
	           MOVE D-DATA-L TO DATA-C
		   MOVE D-CONTA TO CONTA-C
		   MOVE D-VALOR TO VALOR-L-WS
		   MOVE VALOR-LR-WS TO VALOR-C
		   MOVE HISTN-WS (I) TO HIST-C
	           MOVE DESCR-77 TO DESCR-C
		   WRITE SAIDA-REG FROM DETALHE-C
           END-IF
           GO TO VOLTA.

