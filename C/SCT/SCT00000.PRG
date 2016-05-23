****************************************************************
*		   <<<<  COLECAO DE OBJETOS DE USO COMERCIAL >>>>>>
*
*			  CM: Comercial ; G: Generico ; C: Colecao
*	
*			    Todas as PROCEDURES TEM ESTA FUNCAO
*
*	Esta Colecao possui modulos de relatorios e funcoes caracte-
*	risticas do sistema COMERCIAL que envolve VD,CO,CR,CP,PD.
*
****************************************************************

FUNCTION W_DEFPROC
	*------------------------------------------------------------*
	* CLASSIFICACAO:  [*****]   MODULO INDEPENDENTE				 *
	*------------------------------------------------------------*
	* OBJETIVO....: Redefine a Biblioteca de Funcoes 
	*------------------------------------------------------------*
	* COMENTARIO..: Utiliza em todo sistema para "SETAR" a biblio-
	*               teca que fornecera a funcoes para o sistema
	*------------------------------------------------------------*
	* OBS........ : 
	*------------------------------------------------------------*
	* TABELAS....: 
	*------------------------------------------------------------*
	* PARAMETROS..:
	*		LSnmprocedure..: Nome da BIBLIOTECA de PROCEDIMENTOS
	*------------------------------------------------------------*
	* RETORNO.....:       
	*------------------------------------------------------------*
	PARAMETERS LSnmprocedure
		SET PROCEDURE TO &LSnmprocedure
	RETURN(0)

