    close all
    set talk on
    set excl off
    
*    use Q:\scgc\CENTRAL\itemmov

    use X:\scgc\SIA\itemmov

	SET ORDER TO TAG movimento
	SET NEAR ON
	SEEK STR(2,3)+ALLTRIM("13012919")+"1"
	
*	SEEK STR(2,3)+ALLTRIM("14012430")+"1"

set filter to vlr_estq = 0

    brows fields ;
    	operacao,;
    	empresa,;
    	orcamento,;
    	codigo,;
    	vlr_estq,;
    	sld_estq,;
    	CM=IIF(sld_estq>0,VLR_ESTQ/sld_estq,0),;
    	qtde,;
    	VLRVENDA,;
    	tipo,;
    	ordem,;
    	hregis,;
    	dtregis,;
    	USRREGIS
    