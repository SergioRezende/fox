CLOSE ALL
SET DATE GERMAN
USE CLIENTES
SET ORDER TO TAG CLIENTE
SELE 0
USE CLIEIMPO
ZAP
PACK
APPEND FROM Q:\SCGC01\ARQCLI01.TXT TYPE SDF



******>> PREENCHIMENTO DOS CAMPOS
SELE clieimpo
go top
DO WHILE !eof()
	m.empresa 		= clieimpo.filial
	m.tp_pessoa		= clieimpo.tp_pessoa + 1
	m.cliente 		= clieimpo.cgc
	SELE clientes
	SEEK m.cliente
	IF FOUND()
		SELE clieimpo
		SKIP
	ENDIF
	m.empresa 		= clieimpo.filial
	m.nome			= clieimpo.nome	
	m.inscricao		= clieimpo.insc
	m.regiao		= clieimpo.regiao
	m.status		= clieimpo.status + 1
	m.natureza		= clieimpo.natu	+ 1
	m.vendedor		= clieimpo.vendedor + (m.EMPRESA * 1000)
	m.dtcad			= CTOD(SUBS(clieimpo.data_cad,1,2)+"."+ ;
						   SUBS(clieimpo.data_cad,3,2)+"."+ ;
						   SUBS(clieimpo.data_cad,5,2))
	m.ult_atend		= CTOD(SUBS(clieimpo.data,1,2)+"."+ ;
						   SUBS(clieimpo.data,3,2)+"."+ ;
						   SUBS(clieimpo.data,5,2))
	m.dt_nasc		= CTOD(SUBS(clieimpo.dt_nasc,1,2)+"."+ ;
						   SUBS(clieimpo.dt_nasc,3,2)+"."+ ;
						   SUBS(clieimpo.dt_nasc,5,2))
    m.obs = ""
	IF !EMPTY(ALLTRIM(clieimpo.obs))
		m.obs			= clieimpo.obs
	ENDIF
******************************
	IF m.tp_pessoa	= 1 && FISICAS
		m.nome		= clieimpo.nome
		m.endereco	= clieimpo.endr
		m.bairro	= clieimpo.bairror
		m.cidade	= clieimpo.munr
		m.estado	= clieimpo.ufr
		m.cep		= clieimpo.cepr+clieimpo.cep2r
		m.fone		= "(   )-"+LEFT(clieimpo.telr,3)+"-"+;
						SUBS(clieimpo.telr,4,4)
		m.sexo			= clieimpo.sexo
	**** COBRANCA
		m.CBnome		= clieimpo.nomec
		m.CBendereco	= clieimpo.endc
		m.CBbairro	= clieimpo.bairroc
		m.CBcidade	= clieimpo.munc
		m.CBestado	= clieimpo.ufc
		m.CBcep		= clieimpo.cepc+clieimpo.cep2c
		m.CBfone		= "(   )-"+LEFT(clieimpo.telc,3)+"-"+;
						SUBS(clieimpo.telc,4,4)

	ELSE
		m.nome		= clieimpo.nomec
		m.endereco	= clieimpo.endc
		m.bairro	= clieimpo.bairroc
		m.cidade	= clieimpo.munc
		m.estado	= clieimpo.ufc
		m.cep		= clieimpo.cepc+clieimpo.cep2c
		m.fone		= "(   )-"+LEFT(clieimpo.telc,3)+"-"+;
						SUBS(clieimpo.telc,4,4)
		m.sexo			= " "
	**** COBRANCA
		m.CBnome		= clieimpo.nome
		IF EMPTY(ALLTRIM(m.nome))
			m.nome		= clieimpo.nome
			m.CBnome	= ""
		ENDIF
		m.CBendereco	= clieimpo.endr
		m.CBbairro	= clieimpo.bairror
		m.CBcidade	= clieimpo.munr
		m.CBestado	= clieimpo.ufr
		m.CBcep		= clieimpo.cepr+clieimpo.cep2r
		m.CBfone		= "(   )-"+LEFT(clieimpo.telr,3)+"-"+;
						SUBS(clieimpo.telr,4,4)
	ENDIF
	
	m.tp_inscr		= 1
	m.insctmp = CHRTRAN(m.inscricao,"0"," ")
    IF EMPTY(ALLTRIM(m.insctmp))
		m.tp_inscr		= 4
		m.inscricao		= ""
	ENDIF
	SELE CLIENTES
	APPEND BLANK
	GATHER MEMVAR MEMO
	SELE clieimpo
	SKIP
	

   *
ENDDO
