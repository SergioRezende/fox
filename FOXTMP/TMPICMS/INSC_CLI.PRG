PARAMETERS LSbaseDados
	*-------------------------------------------------------------*
	*  LISTAR CGC E NOME DOS CLIENTES QUE ESTAO COM INSCRICAO INVALIDO
	*-------------------------------------------------------------*
	ON ERROR
	set procedure to rotinas.spr

	on error
	SET EXCL OFF
	SET DELE ON
	SET DATE GERMAN
	set escape on
	set talk ON

	DO CASE
		CASE LSbaseDados = "LOJA"
			use \scgc\LOJA\clientes
		CASE LSbaseDados = "CENTRAL"
			use \scgc\CENTRAL\clientes
		OTHERWISE
			WAIT WINDOW "INFORMA A BASE - LOJA ou CENTRAL"
			RETURN
	ENDCASE
	GO TOP

	DO CASE
		CASE LSbaseDados = "LOJA"
			COPY TO \FPD26\PROG\TMPICMS\CLI_LOJA WITH CDX;
					FOR !UPInscricao(clientes.ESTADO,clientes.INSCRICAO,1,0,0,'') ;
				       AND   ULT_ATEND > {01.01.1999} 
		CASE LSbaseDados = "CENTRAL"
			COPY TO \FPD26\PROG\TMPICMS\CLI_CENTRAL WITH CDX;
					FOR !UPInscricao(clientes.ESTADO,clientes.INSCRICAO,1,0,0,'') ;
				       AND   ULT_ATEND > {01.01.1999} 
	ENDCASE
	CLOSE ALL

RETURN
