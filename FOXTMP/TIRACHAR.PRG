
	SET TALK ON
	set excl off
	DO DUPLICATA WITH "Q:\SCGC\LOJA\"

*	DO DUPLICATA WITH "Q:\SCGC\CENTRAL\"
	
RETURN

PROCEDURE DUPLICATA
PARAMETERS PrmDir
	arq = PrmDir+"duplicat.dbf"
	use &arq alia arq


	SELE ARQ
	GO TOP
	DO WHILE !EOF()
		=RLOCK()
		IF ARQ.OBS ="ggATT// I D P // ROBERTO PEDIR PNEUS NA MATRIS LEVAR PARA O SR.JOC    "
			REPLACE ARQ.OBS WITH ""
		ELSE		
			REPLACE ARQ.OBS WITH CHRTRAN(ARQ.OBS,CHR(10),"")
			REPLACE ARQ.OBS WITH CHRTRAN(ARQ.OBS,CHR(13),"")
		ENDIF
		SKIP
	ENDDO
	use 

RETURN
