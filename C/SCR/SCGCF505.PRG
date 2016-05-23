
******
***  REGISTRA O FATURAMENTO EM RETONBC PARA SAIR NO DIARIO 
****        CHAMADO PELO PROG. DE IMPORTACAO 003A
******
	LNctrreg	= 0			&& TOTAL DE REGISTROS DE INSTRUCAO 
	LNacmvlr	= 0			&& VALOR TOTAL DOS DOCUMENTOS
	LNacmpgt	= 0			&& VALOR TOTAL DOS PAGAMENTOS

	SELE empresa
	SET ORDER TO TAG empresa
	SEEK m.empresa


	SELE retornbc
	SET ORDER TO TAG aviso
 	m.cod_empres = m.empresa
	m.aviso 	 = INT(VAL((DTOS(m.dt_inicio))))
	m.banco      = 990   && CODIGO DO FATURAMENTO 

	m.nome_emp	 = empresa.nome
	m.dtaviso  	 = dt_inicio
	m.dtprocesso = dt_inicio
	m.status 		= "PR"    && AGUARDANDO PROCESSAMENTO

	IF SEEK(STR(m.empresa,3)+STR(m.banco,3)+STR(m.aviso,8))
		RETURN
	ENDIF
	=edithand('SAVE')
	=REGLOCK(.T.)

	SELE retornmv
	SET ORDER TO TAG lancamento
	SELE duplicat
	SET ORDER TO TAG emissao
	SET NEAR ON
	SEEK STR(m.empresa,3)+DTOS(m.dtaviso)
	SET NEAR OFF
	DO WHILE !EOF() AND m.empresa = duplicat.empresa ;
					AND m.dtaviso  = duplicat.dt_emi

		m.duplicata	= duplicat.duplicata
		m.ocorrencia= 02	&&  REGISTRO CONFIRMADO
		m.efeito	= 1		&&  FATURAMENTO
		m.motivos   = ""
		m.vlr_dup	= duplicat.vlr_doc
		m.vlr_pgto  = 0
		LNctrreg	= LNctrreg + 1
		LNacmvlr	= LNacmvlr + m.vlr_dup
		LNacmpgt	= LNacmpgt + m.vlr_pgto

		SELE retornmv
		IF SEEK(STR(m.empresa,3)+STR(m.banco,3)+STR(m.aviso,8)+;
		 		STR(m.duplicata,9)+STR(m.ocorrencia,2))
			SELE duplicat
			SKIP
			LOOP
		ENDIF
		m.num_no_bco= " "
		m.vencimento= duplicat.dt_venc
		m.banco_cobr= duplicat.banco
		m.agenc_cobr= duplicat.agencia
		m.dsp_cobr  = 0
		m.out_desp  = 0
		m.juros     = 0
		m.iof       = 0
		m.abatimento= 0
		m.desconto  = 0
		m.mora      = 0
		m.out_credt = 0
		m.form_pgto = 0
		m.trf_cart  = " "
		m.dtocorrenc= m.dtaviso
		=edithand('SAVE')
		SELE duplicat
		SKIP
		LOOP
	ENDDO   
	SELE retornbc
	m.reg_total = LNctrreg
	m.reg_proces= 0
	m.reg_descar= 0
	m.tot_doc   = LNacmvlr
	m.tot_pgto  = LNacmpgt
	=edithand('REGRAVA')
	UNLOCK
RETURN
