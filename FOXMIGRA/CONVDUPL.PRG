CLOSE ALL
SET EXCLUSIVE ON

SET DATE GERMAN
SELE 0
USE orcament
SET ORDER TO TAG orcamento

SELE 0
USE CLIENTES
SET ORDER TO TAG CLIENTE
SELE 0

USE DUPLICAT
SET ORDER TO TAG DOC
ZAP 
PACK

SELE 0
USE DUPLIMPO
ZAP
PACK
APPEND FROM Q:\TMP\CADDUP01.TXT TYPE SDF

******>> PREENCHIMENTO DOS CAMPOS
SELE duplimpo
go top
DO WHILE !eof()
	m.empresa 		= duplimpo.filial
	m.duplicata		= duplimpo.codigo
	m.banco			= duplimpo.banco
	m.portador		= duplimpo.banco
	m.agencia		= duplimpo.agencia

	m.cliente		= duplimpo.cpf_cgc
	SELE clientes
	SEEK m.cliente
    m.nome = "   "
	IF FOUND()
	   m.nome = clientes.nome
	ENDIF
	m.vlr_doc		= duplimpo.valor / 100
	m.vlr_pgto		= (duplimpo.valor - duplimpo.saldo) / 100
	m.dt_emi		= CTOD(SUBS(duplimpo.dt_emis,1,2)+"."+ ;
						   SUBS(duplimpo.dt_emis,3,2)+"."+ ;
						   SUBS(duplimpo.dt_emis,5,2))
	m.dt_venc		= CTOD(SUBS(duplimpo.dt_venc,1,2)+"."+ ;
						   SUBS(duplimpo.dt_venc,3,2)+"."+ ;
						   SUBS(duplimpo.dt_venc,5,2))
	m.dt_pgto   	= CTOD(SUBS(duplimpo.dt_pag,1,2)+"."+ ;
						   SUBS(duplimpo.dt_pag,3,2)+"."+ ;
						   SUBS(duplimpo.dt_pag,5,2))
	m.dt_baixa   	= m.dt_pgto
	m.dtocorrenc  	= m.dt_pgto
	TMPstring 		= STR(m.duplicata,8)
    m.nota          = SUBS(TMPstring,1,6)
    m.nota          = VAL(m.nota)
    m.orcamento     = m.nota

	IF m.banco = 0  AND m.dt_emi > CTOD("15.10.96") && ultimos registros
		SELE ORCAMENT
		STR(EMPRESA,3)+STR(ORCAMENTO,6)
		IF FOUND()
		   m.banco = orcament.banco
		ENDIF
	ENDIF

	m.tp_cobranc    = 1  && simples
	m.forma_pgto    = 4  && duplicatas

	m.vendedor		= duplimpo.vendedor + (m.EMPRESA * 1000)
	m.regiao		= duplimpo.regiao
    m.natu			= duplimpo.natu
	m.dt_bordero	= CTOD(SUBS(duplimpo.dt_bordero,1,2)+"."+ ;
						   SUBS(duplimpo.dt_bordero,3,2)+"."+ ;
						   SUBS(duplimpo.dt_bordero,5,2))
	m.ind_paga		= duplimpo.ind_paga
	m.ind_npaga		= duplimpo.ind_npaga
	m.status		= duplimpo.status

	SELE duplicat
	APPEND BLANK
	GATHER MEMVAR MEMO
	SELE duplimpo
	SKIP
   *
ENDDO
