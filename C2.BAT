@echo off
path \COB;\COBMS;P:\COBOL;P:\public;Y:\UTIL
set lib=\cobMS
set cobdir=\cobMS

IF  NOT "%1" == "SIFT1R" GOTO EXTFH
COPY COBOL.FAT COBOL.DIR
COBOL %1,,;
COPY COBOL.NOR COBOL.DIR
ECHO ON
LINK @%1.LNK+@SIFT011.LNK
GOTO EXEP
:EXTFH
if exist %1.exe del %1.exe
COBOL %1,,;
LINK %1;
:if exist %1.exe del %1.lst
:EXEP
EXEPACK %1.EXE %1.PCK
COPY %1.PCK K:%1.EXE
IF  "%1" == "SIFT1R" COPY %1.I?? K:
echo %1.exe >> progalt.doc
DEL %1.EXE
IF  "%2" == "" DEL %1.OBJ
DEL %1.PCK 
PROMPT $D$"...$T$_$P$G
