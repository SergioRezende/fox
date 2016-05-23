	set date german
	set centu on

	set excl off

	SET STEP ON
    SET NEAR ON


	CLOSE ALL
	SET NEAR ON

	DO ESPECIFICA WITH 5,{03/06/2015}

*	DO ESPECIFICA WITH 3,{08/06/2015}

*	DO ESPECIFICA WITH 10,{08/06/2015}

return

PROCEDURE GERAL

	SELE 0
	USE Q:\SCGC\CENTRAL\EMPRESA
	SET ORDER TO TAG EMPRESA
	

	SELE 0
	USE Q:\SCGC\CENTRAL\RETORNMV
	SET ORDER TO TAG DTPROCESSO 


	SET DATE GERMAN
	SET CENTU ON
	SET TALK ON
	SET ESCAPE ON

	LDTinicio = {01/06/2015}



	SELE EMPRESA
	
	GO TOP
	DO WHILE !EOF()
	
		SELE RETORNMV

		LDTinicio = {01/06/2015}
	
		for x = 0 to 5 step 1

			LDTinicio = LDTinicio + x
			SEEK STR(empresa.empresa,3)+DTOS(LDTinicio)
		
			DO WHILE !EOF() AND retornmv.empresa = empresa.empresa ;
			 				AND retornmv.dtprocesso = LDTinicio
	
				REPLACE STATUS WITH "PR"
				SKIP
			ENDDO
		
		ENDFOR	
		SELE EMPRESA 
		SKIP
	
	ENDDO
	
RETURN

PROCEDURE ESPECIFICA
PARAMETER PrmEmp,PrmData
	SELE 0
	USE Q:\SCGC\CENTRAL\EMPRESA
	SET ORDER TO TAG EMPRESA
	SEEK  PrmEmp
	

	SELE 0
	USE Q:\SCGC\CENTRAL\RETORNMV
	SET ORDER TO TAG DTPROCESSO 


	SET DATE GERMAN
	SET CENTU ON
	SET TALK ON
	SET ESCAPE ON

	LDTinicio = PrmData



	SELE EMPRESA
	
	DO WHILE empresa = prmemp
	
		SELE RETORNMV

		LDTinicio = PrmData
	
		for x = 0 to 10 step 1

			LDTinicio = LDTinicio + x
			SEEK STR(empresa.empresa,3)+DTOS(LDTinicio)
		
			DO WHILE !EOF() AND retornmv.empresa = empresa.empresa ;
			 				AND retornmv.dtprocesso = LDTinicio
	
				REPLACE STATUS WITH "PR"
				SKIP
			ENDDO
		
		ENDFOR	
		SELE EMPRESA 
		SKIP
	
	ENDDO
	
RETURN
	