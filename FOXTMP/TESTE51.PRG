SET DATE GERMAN
SET CENTU ON

	


m.aliq_frete=0
m.aliq_pis = 0
m.aliq_cofins= 0

SELECT 	;
	NE.EMPRESA,;
	NE.NOTA,;
	NE.SERIE,;
	NE.DATA,;
	NE.PEDIDO,;
	NE.TIPO,;
	IT.CODIGO,;
    IT.DESCRICAO,;
	IT.QTDE,;
	(IT.VLRVENDA/IT.QTDE) AS VLR_FAT,;
    TF.preco_tab,;
    TF.desc_t,;
    TF.aliq_ipi,;
    TF.aliq_icmr,;
    TF.IVA, ;
    TF.aliq_icmc,;
    TF.avindice,;
    TF.margem_liq;
 FROM  					q:\scgc\loja\notaent NE,;
    					q:\scgc\loja\itemmov IT,;
    					q:\scgc\comum\tabforn TF;
WHERE ;
		NE.EMPRESA 	= IT.EMPRESA AND;
		NE.CODFORN 	= IT.CODFORN AND;
		NE.NOTA    	= IT.NOTA    AND;
		NE.SERIE   	= IT.SERIE   AND;
		NE.TIPO    	= IT.TIPO	AND;
	    NE.pedido > 0 AND; 
	    NE.DATA >= {01.01.2002} AND ;
	    NE.DATA < {01.03.2002} AND;
  		IT.ch_opera = "1" 		AND;
		LEFT(IT.operacao,1) = "E" AND ;
		IT.CODFORN 	= TF.CODFORN AND;
		IT.CODIGO   = TF.CODIGO;
INTO TABLE C:\TMP\QUERY

m.aliq_frete=2.5
m.aliq_pis = 0.65
m.aliq_cofins= 3.00

SELECT ;
	EMPRESA,;
	NOTA,;
	SERIE,;
	DATA,;
	PEDIDO,;
	TIPO,;
	CODIGO,;
    DESCRICAO,;
	QTDE,;
	VLR_FAT,;
	ROUND(UPfcalcusto(1,preco_tab,desc_t,aliq_ipi,;
				m.aliq_frete,;
				aliq_icmr,IVA, aliq_icmc,;
				avindice,;
				0,0,0,0,0,0,0,0,;
			    m.aliq_pis,m.aliq_cofins,;
			    margem_liq,;
			    0,0),2) AS VLR_PEDIDO;
 FROM C:\TMP\QUERY ;
 ORDER BY 	EMPRESA,;
			DATA,;
			NOTA


