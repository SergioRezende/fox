********************************************************************
*	SCGC800E => Processa o movimento de um produto solicitado para  *
*             determinar a quantidade vendida em um periodo 
*
*	CHAMADO por SCGC800 e OBJ_ROL1
*
********************************************************************
PARAMETERS LNempresa,LSclas,LScodigo,LDdtini,LDdtfim,LNemdias,LNqtvenda,LNqtacm,;
			 	LNqtentra,LNacmentra
	LNqtvenda   = 0

	*********************>>> REGISTRO DE SAIDAS <<<*********************
	*
	*   O saldo formado no so e considerado ate a 2/3 do 
	* do periodo devido a pouca influencia nas vendas do periodo
	* das entradas do 1/3 restante
	*
	********************************************************************
	LDdtfimsld = LDdtini 		 		&& data para referenciar saldo apuradao
	LNdiassld  = INT(LNemdias / 3)* 2  && para apurar o saldo formado 
							 			&& ate metade do periodo
	LNctrdias = 0
	DO WHILE LNctrdias <= LNdiassld
		IF DOW(LDdtfimsld) <> 1
			LNctrdias = LNctrdias +1
		ENDIF
		LDdtfimsld = LDdtfimsld + 1
	ENDDO
	*******************************************************************
	DO ULvdprd1 WITH LDdtini,LDdtfim, LNempresa, LScodigo,LDdtfimsld
	*******************************************************************
	SELE grupoanx
	SET ORDER TO TAG classifica
	SEEK LSclas
	IF FOUND()
		*******************************************************************
		DO ULvdprd1 WITH LDdtini,LDdtfim, LNempresa, LScodigo,LDdtfimsld
		*******************************************************************
	ENDIF	
RETURN

********************************************************************

PROCEDURE ULvdprd1 
	PARAMETERS  LDdtini,LDdtfim, LNempresa, LScodigo,LDdtfimsld

	SELE itemmov
	SET ORDER TO TAG movimento
	SET NEAR ON
	SEEK STR(LNempresa,3)+LScodigo+DTOS(LDdtini)
	SET NEAR OFF
	
	
	DO WHILE itemmov.data <= LDdtfim AND ;
			 itemmov.empresa = LNempresa AND ;
			 itemmov.codigo  = LScodigo

		IF LEFT(itemmov.operacao,1) = 'S' AND ;
				itemmov.ch_opera = "1" 	  
			 IF itemmov.movestq = "S"
				 	LNqtvenda  = LNqtvenda  + itemmov.qtde
				 	LNqtacm    = LNqtacm    + itemmov.qtde
			 ENDIF
		ENDIF
		IF LEFT(itemmov.operacao,1) = 'E' AND itemmov.ch_opera = "4" AND ;
			    itemmov.movestq = "S"
			IF (LNqtvenda  - itemmov.qtde) >=  0
			 	LNqtvenda  = LNqtvenda  - itemmov.qtde
			 	LNqtacm    = LNqtacm    - itemmov.qtde
			ENDIF
		ENDIF

		IF itemmov.data <= LDdtfimsld AND LEFT(itemmov.operacao,1) = 'E' ;
			AND itemmov.ch_opera <> "4" AND itemmov.movestq = "S"
			 	LNqtentra  = LNqtentra  + itemmov.qtde
				LNacmentra = LNacmentra + itemmov.qtde
		ENDIF

		***********************************************************
		*  CASO A MERCADORIA SAI POR TRANSFERENCIA OU POR MOV. QUE NAO 
		* SEJA VENDA ELA E DESCONSIDERADA
		* DAS ENTRADAS POIS NAO ESTA DESTINADA AO ESTOQUE DE VENDA
		***********************************************************

		IF LEFT(itemmov.operacao,1) = 'S' AND ;
				itemmov.ch_opera <> "1"	&& SAIDAS DEVERSAS DA VENDA
			 IF itemmov.movestq = "S"
				 	LNqtentra  = LNqtentra  - itemmov.qtde
					LNacmentra = LNacmentra - itemmov.qtde
			 ENDIF
			 IF LNqtentra < 0
			 	LNqtentra = 0 
			 ENDIF
		ENDIF
		SKIP
	ENDDO	
RETURN


