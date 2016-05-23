SELE TIPOOPER
SET ORDE TO TIPO
    
SELE orcament
SET ORDER TO TAG data_fat
SET RELATION TO "S"+orcament.tipo INTO tipooper

SET NEAR ON
SEEK STR(m.empresa,3)+DTOS(m.dt_inicio)+STR(1,7)
SET NEAR OFF
IF EOF() OR orcament.dt_fat > m.dt_fim	
	WAIT WINDOW "Nao Existem Dados Com Parametros Informados. <ENTER> "
	RETURN
ENDIF

********************>  GERANDO ARQTMP CAPA_ORC **********************

wl_arqtmp = ""
LNtmp     = 65		&& TABELA ASCII A = 65
IF !UPabretmp("iie")
	wp_flgfecha = .t.
ENDIF
IF wp_flgfecha
	UNLOCK
	RETURN
ENDIF		
************************************************************
LStmp = "&wp_dirtmp"+"&wl_arqtmp"

WAIT WINDOW "AGUARDE. Gerando Arq. Temporario." NOWAIT

SELE orcament
	
    COPY TO &LStmp  ;
    	FOR 	tipooper.ch_opera = "1" ;
    		AND orcament.tp_transp = 1  ;
			AND LEFT(orcament.situacao,1) = "O" ;
		WHILE m.empresa = orcament.empresa ;
			AND orcament.dt_fat <= m.dt_fim WITH CDX
	
	*----- O alias  ARQTMP serve para referencia fixa no relatorio *-----
	*----- a atribuicao a wl_arqtmp e para manter o padrao
	
	SELE 0 
	USE &LStmp  alias capa_orc exclu 
	INDEX ON orcamento TAG capa_orc ADDITIVE
	SET ORDER TO TAG capa_orc
	
	********************>  GERANDO ARQTMP ITENS_ORC **********************
	wl_arqtmp = ""
	LNtmp     = 65		&& TABELA ASCII A = 65
	IF !UPabretmp("iie")
		wp_flgfecha = .t.
	ENDIF
	IF wp_flgfecha
		UNLOCK
 		RETURN
 	ENDIF		
	************************************************************
	
	LStmp = "&wp_dirtmp"+"&wl_arqtmp"
	WAIT WINDOW "AGUARDE. Gerando Arq. Temporario." NOWAIT
	
*	SELE orcatmp
*	SET ORDER TO TAG data_fat
*	SET NEAR ON
*	SEEK STR(m.empresa,3)+DTOS(m.dt_inicio)
*	SET NEAR OFF
*	IF EOF() OR m.empresa <> orcatmp.empresa  OR orcatmp.dtfat > m.dt_fim	
*		WAIT WINDOW "Nao Existem Dados Com Parametros Informados. <ENTER> "
*		SELE capa_orc
*		USE
*		SELE itens_orc
*		USE
*		RETURN
*	ENDIF
******** INICIO

	 
	SELE GRUPO
	SET ORDE TO codigo
	
	SELE ORCATMP
	SET ORDE TO chv_emporc
	SET RELATION TO codigo							INTO grupo   ADDIT
	
	SELE orcament 
	SET ORDER TO TAG data_fat 
	SET RELATION TO str(empresa,3)+str(orcamento,6) INTO orcatmp ADDIT
	SET SKIP TO orcatmp
	
	SELE orcament
	SET NEAR ON
	SEEK STR(m.empresa,3)+DTOS(m.dt_inicio)+STR(1,7)
	SET NEAR OFF
	
********** FIM
	
    COPY TO &LStmp  ;
    	FIELD orcatmp.EMPRESA,orcatmp.ORCAMENTO,orcatmp.IMP_VIA,;
		      orcatmp.SITUACAO,orcatmp.DESCONTO,orcatmp.DESC_ALT,;
		      orcatmp.USR_DALT,orcatmp.ORDEM,orcatmp.CODIGO,;
		      orcatmp.UNIDADE,orcatmp.DESCRICAO,orcatmp.TP_MERCAD,;
		      orcatmp.PESO,orcatmp.IVA,orcatmp.CLAS_CMS,orcatmp.CFO,;
		      orcatmp.ORIGEM,orcatmp.CST,orcatmp.BASE_ISS,orcatmp.ALIQ_ISS,;
		      orcatmp.VLR_ISS,orcatmp.BASE_CALC,orcatmp.ALIQ_ICMS,;
		      orcatmp.VLR_ICMS,orcatmp.BASE_SBBRT,orcatmp.BASE_SUBS,;
		      orcatmp.ICMS_SUBS,orcatmp.BASE_ISENT,orcatmp.BASE_OUTR,;
		      orcatmp.BASE_ISIPI,orcatmp.BASE_IPI,orcatmp.ALIQ_IPI,;
		      orcatmp.VLRIPI,orcatmp.PRECO,orcatmp.DESC_ADICI,;
		      orcatmp.PRECOFINAL,orcatmp.QTDE,orcatmp.VLRVENDA,;
		      orcatmp.QTDERES,orcatmp.DTREGIS,orcatmp.HREGIS,;
		      orcatmp.USRREGIS,orcatmp.DELETADO,tipooper.ch_opera,;
		      grupo.classifica ;
    	FOR tipooper.ch_opera = "1" ;
    		AND orcament.empresa=m.empresa ;
		WHILE ;
		    orcament.empresa  = m.empresa  ;
			AND orcament.dt_fat <= m.dt_fim

	*----- a atribuicao a wl_arqtmp e para manter o padrao
	
	SELE 0 
	USE &LStmp  alias itens_orc exclu 
    INDEX ON orcamento TAG itens_orc ADDITIVE
	SET ORDER TO TAG itens_orc
	
