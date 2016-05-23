set escape on
on key

 LSid_chamada = ("DADO PRECO FINAL (PRECOFINAL)") 
   m.precofinal = m.precofinal + m.difere


	=W_DEFPROC("ORCAMENT.SPR")
	=ORcalc_vlres(m.preco,(m.qtde),m.DESCONTO,m.desc_adici,;
			(orcament.taxa),m.precofinal,m.vlrvenda,LSid_chamada)
	*----------------------------------------------------------*
	STORE 0 TO m.base_iss,m.vlr_iss,m.base_calc,;
				m.vlr_icms,m.base_isent,m.base_sbbrt,m.base_subs,;
				m.icms_subs,m.base_outr,m.base_ipi,m.vlripi,m.base_isipi,;
				m.bsbr_icms
	*----------------------------------------------------------*
    *    O Numero maximo de parametros passados a uma UDF e 24 
    * o vTParam aplia essa condicao (mas por questoes de facilidade o 
    * vetor so e utilizado para completar os parametros excedentes)
	*----------------------------------------------------------*
	dimension vTParam[ 4 ]
	vTParam[01] = m.base_ipi
	vTParam[02] = m.vlripi
	vTParam[03] = m.base_isipi
	vTParam[04] = m.bsbr_icms

	=W_DEFPROC("TRIBUTAR.SPR")
	=TRcalc_tribu((orcament.empresa),(orcament.tipo),;
				(m.cst),(m.vlrvenda),;
				(m.tp_mercad), (m.aliq_iss),;
				(m.aliq_icms), (m.aliq_ipi),(m.aliq_rdu),;
				(m.iva),(orcament.data),;
				(clienc.estado),(m.qtde),;
				(m.codigo),m.base_iss,m.vlr_iss,m.base_calc,;
				m.vlr_icms,m.base_isent,m.base_sbbrt,m.base_subs,;
				m.icms_subs,m.base_outr,vTParam)

	m.base_ipi   = vTParam[01]
	m.vlripi     = vTParam[02] 
	m.base_isipi = vTParam[03]
	m.bsbr_icms  = vTParam[04]


	m.untcpm=round((m.vlrvenda-m.vlripi)/m.qtde,2)
	m.totcalc = (m.untcpm*m.qtde)+m.vlripi
	m.difere  = m.totcalc-m.vlrvenda
	
