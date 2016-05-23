PARAMETERS LSbaseDados
	*-------------------------------------------------------------*
	*  LISTAR CGC E NOME DOS FORNECEDORES QUE ESTAO COM INSCRICAO INVALIDO
	*-------------------------------------------------------------*
	ON ERROR
	set procedure to rotinas.spr

	DO CASE
		CASE LSbaseDados = "LOJA"
			use Q:\scgc\LOJA\fornece
		CASE LSbaseDados = "CENTRAL"
			use Q:\scgc\CENTRAL\fornece
		OTHERWISE
			WAIT WINDOW "INFORMA A BASE - LOJA ou CENTRAL"
			RETURN
	ENDCASE
	on error
	SET DELE ON
	SET DATE GERMAN
	set escape on
	set talk ON
	GO TOP

	DO CASE
		CASE LSbaseDados = "LOJA"
			COPY TO \FPD26\PROG\TMPICMS\FOR_LOJA WITH CDX;
					FOR !UPInscricao(fornece.ESTADO,fornece.INSCRICAO,1,0,0,'') 
		CASE LSbaseDados = "CENTRAL"
			COPY TO \FPD26\PROG\TMPICMS\FOR_CENTRAL WITH CDX;
					FOR !UPInscricao(fornece.ESTADO,fornece.INSCRICAO,1,0,0,'') 
	ENDCASE
	CLOSE ALL
RETURN
