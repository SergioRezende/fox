SET EXCL OFF

SET TALK ON
CLOSE ALL

use Q:\scgc\central\retornmv alias cent
SET ORDER TO TAG LANCAMENTO OF Q:\SCGC\CENTRAL\RETORNMV.CDX


SELECT 2
use x:\scgc\cgb\retornmv alias cgb
SET ORDER TO TAG LANCAMENTO OF X:\SCGC\CGB\RETORNMV.CDX


SELECT 1
set relation to STR(EMPRESA,3)+STR(BANCO,3)+CARTEIRA+VARIACAO+STR(AVISO,8)+STR(DUPLICATA,9)+STR(OCORRENCIA,2) into cgb


SELECT ;
		cent.empresa      AS AMP,;
		cent.BANCO        AS BANCO,;
		cent.AVISO        AS AVISO,;
		cent.dtprocesso   AS DATA,;
		cent.duplicata    AS DUPL,;
		cent.OCORRENCIA   AS OCORRENCIA,;
		cent.vlr_pgto     AS CNTVLR_PGTO,;
		cent.juros        AS CNTJUROS,;
		cent.mora         AS MORA,;
		cent.efeito       AS CENTEFEITO,;
		cent.status       AS CDNTSTATUS,;
		cgb.vlr_pgto      AS CGBVLR_PGTO,;
		cgb.juros         AS CGBJUROS,;
		cgb.mora          AS CGBMORA, ;
		cgb.efeito        AS CGBEFEITO,;
		cgb.status        AS CGBTATUS,;
		((cent.vlr_pgto+cent.juros+cent.mora) ;
		- ;
		(CGB.vlr_pgto+CGB.juros+CGB.mora) ) AS DIF ;
	FROM ;
	    CENT, ;
	    CGB ;
	WHERE ;
		CENT.EMPRESA = 6;
		AND ;
		CENT.EMPRESA = CGB.EMPRESA;
		AND ;
		CENT.BANCO   = CGB.BANCO;
		AND;
		CENT.CARTEIRA = CGB.CARTEIRA;
		AND;
		CENT.VARIACAO = CGB.VARIACAO;
		AND;
		CENT.AVISO    = CGB.AVISO;
		AND;
		CENT.DUPLICATA = CGB.DUPLICATA;
		AND ;
		CENT.OCORRENCIA = CGB.OCORRENCIA ;
		AND;
		( ;
		 CENT.efeito <> CGB.EFEITO ;
		 OR;
		 CENT.status <> CGB.STATUS ;
		) ;
		AND ;
		( ;
		 CENT.VLR_PGTO <> 0;
		 OR;
		 CGB.VLR_PGTO <> 0;
		) ;
	ORDER BY ;
		cent.empresa,;
		cent.dtprocesso,;
		cent.BANCO,;
		cent.AVISO
	

	
		

*		
*		((cent.vlr_pgto+cent.juros+cent.mora) ;
*		- ;
*		(CGB.vlr_pgto+CGB.juros+CGB.mora) ) <> 0 ;
*		

		

	
		
