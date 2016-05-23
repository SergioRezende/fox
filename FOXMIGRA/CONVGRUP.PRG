
SET EXCLUSIVE ON
SELE 0
USE GRUPO
ZAP
PACK

SELE 0
USE PRECO
ZAP
PACK

*----------------- ITENS
SELE 0
USE ESTQIMPO
ZAP 
PACK
APPEND FROM U:\EST\ARQFIXO.TXT TYPE SDF
GO TOP
*----------------- GRUPOS
SELE 0
USE GRUPIMPO
ZAP 
PACK
APPEND FROM U:\EST\ARQGRUPO.TXT TYPE SDF
GO TOP
*----------------- SUB-GRUPOS
SELE 0
USE SUBGIMPO
ZAP 
PACK
APPEND FROM U:\EST\ARQSUBGR.TXT TYPE SDF
GO TOP
*----------------- CLASSES
SELE 0
USE CLASIMPO
ZAP 
PACK
APPEND FROM U:\EST\ARQCLASS.TXT TYPE SDF
GO TOP

******>> PREENCHIMENTO DOS CAMPOS
 m.status	=   1

*>>>>>>>>>>>>>>  CONVERCAO DOS GRUPOS
SELE GRUPIMPO
DO WHILE !EOF()
	m.codigo 	 =	SPACE(15)
	m.classifica =  grupimpo.codigo
 	m.descricao  = 	grupimpo.descricao
	m.cdg_tipo	=	1
	SELE GRUPO
	APPEND BLANK
	GATHER MEMVAR MEMO
	SELE grupimpo
	SKIP
ENDDO
*>>>>>>>>>>>>>>  CONVERCAO DOS SUB-GRUPOS
SELE SUBGIMPO
DO WHILE !EOF()
	m.codigo 	 =	SPACE(15)
	m.classifica =  subgimpo.codigo
 	m.descricao  = 	subgimpo.descricao
	m.cdg_tipo	=	2
	SELE GRUPO
	APPEND BLANK
	GATHER MEMVAR MEMO
	SELE subgimpo
	SKIP
ENDDO
*>>>>>>>>>>>>>>  CONVERCAO DaS CLASSES    
SELE CLASIMPO
DO WHILE !EOF()
	m.codigo 	 =	SPACE(15)
	m.classifica =  clasimpo.codigo
 	m.descricao  = 	clasimpo.descricao
	m.cdg_tipo	=	3
	SELE GRUPO
	APPEND BLANK
	GATHER MEMVAR MEMO
	SELE clasimpo
	SKIP
ENDDO

*-*-*-*-*-*-*--*-*-*-   CONVERCAO DOS ITENS
m.ordem  = 0
SELE ESTQIMPO
DO WHILE !EOF()
	m.codigo 	=	LEFT(estqimpo.codigo,7)
	m.codigo	=   ALLTRIM(m.codigo)+UPCALCDIG(m.codigo)
	m.classifica =  estqimpo.grp+estqimpo.sub+estqimpo.clas+;
					estqimpo.seq+estqimpo.marca
 	m.descricao  = 	estqimpo.descricao
	m.cdg_tipo	=	4
    m.marca     =   int(val(estqimpo.marca))
    m.peso      =   estqimpo.peso / 100
    m.unidade   =   estqimpo.unidade
    m.origem    =   estqimpo.origem
    m.tp_mercad =   estqimpo.tipo_impo
	IF m.origem > 0 AND     m.tp_mercad =   2
	    m.tp_mercad =   8
	ENDIF	
    m.status	=   1
	m.fadricante=   estqimpo.forn
	I = 0
	m.empresas = ""
	m.tab_preco = ""
	FOR I = 1 TO 10
		IF SUBS(estqimpo.EXISTE_ALX,I,1) = "S" 
 	       m.empresas = m.empresas + STRTRAN(STR(I,3)," ","0") +"/"
        ENDIF
		IF SUBS(estqimpo.EMIT_TAB,I,1) = "S" 
 	       m.tab_preco = m.tab_preco + STRTRAN(STR(I,3)," ","0") +"/"
        ENDIF
	ENDFOR
	SELE GRUPO
	APPEND BLANK
	GATHER MEMVAR MEMO

	m.empresa   = 1
	m.tabpreco  = 1 
	m.serie     = "A"
    m.preco     =   estqimpo.valor / 100

	SELE PRECO
	APPEND BLANK
	GATHER MEMVAR MEMO


	SELE estqimpo
	SKIP
ENDDO

