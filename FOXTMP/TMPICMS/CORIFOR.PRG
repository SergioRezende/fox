close all
use q:\scgc\central\fornece
go top

SET ESCAPE ON
SET TALK ON
SET PROCEDURE TO ROTINAS.SPR
MENS = ""
SET STEP ON

DO WHILE !EOF()

	=RLOCK()
	LSinsc			= CHRTRAN(inscricao," ","")
	LSinsc			= CHRTRAN(LSinsc,".","")
	LSinsc			= CHRTRAN(LSinsc,"/","")
	LSinsc			= CHRTRAN(LSinsc,"-","")
	LSinsc			= LEFT(LSinsc+space(14),14)
	REPLACE inscricao WITH LSinsc

*	IF 	estado = "MT" ;
*			AND  !("ISENTO" $ INSCRICAO) ;
*			AND  LEN(ALLTRIM(INSCRICAO)) < 11 ;
*			AND  !UPInscricao(estado,inscricao,1,0,0,Mens)  
*				REPLACE INSCRICAO WITH ;
*					REPL("0", 11-LEN(ALLTRIM(INSCRICAO)))+LTRIM(INSCRICAO) 
*	ENDIF
	SKIP
ENDDO
