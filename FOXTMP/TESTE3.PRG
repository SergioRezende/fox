SET DATE GERMAN
SET CENTU ON

DT_INI = {01.07.2002}
DT_FIM = {31.07.2002}

SELECT COUNT(*) ;
        FROM ;
             Q:\SCGC\COMUM\TIPOOPER TP, ;
	       	 Q:\SCGC\LOJA\ORCAMENT  OR ;
		WHERE ;
    		    OR.tp_transp = 1  ;
			AND LEFT(OR.situacao,1) = "O" ;
	        AND OR.empresa   = 1         ;
		    AND OR.dt_fat   >= m.dt_ini   ;
		    AND OR.dt_fat   <= m.dt_fim   ;
	        AND TP.processo  = "S" ;
	        AND TP.ch_opera  = "1" ;
	        AND TP.tipo      = OR.tipo   



    SELECT    OR.EMPRESA,OR.ORCAMENTO, OR.DATA,OR.dt_fat,OR.hora,OR.hora_fat,;
			  OR.VEICULO,TP.ch_opera;
        FROM ;
             &ArqTipooper  TP, ;
	       	 &ArqOrcament  OR ;
		WHERE ;
    		    OR.tp_transp = 1  ;
			AND LEFT(OR.situacao,1) = "O" ;
	        AND OR.empresa   = m.empresa  ;
		    AND OR.dt_fat   >= m.dt_inicio  ;
		    AND OR.dt_fat   <= m.dt_fim   ;
	        AND TP.processo  = "S" ;
	        AND TP.ch_opera  = "1" ;
	        AND TP.tipo      = OR.tipo   ;
    ORDER BY OR.ORCAMENTO;
    INTO CURSOR  CURS_A


    SELECT    OR.*,;
              TM.IMP_VIA,;
		      TM.SITUACAO,TM.DESCONTO,TM.DESC_ALT,;
		      TM.USR_DALT,TM.ORDEM,TM.CODIGO,;
		      TM.UNIDADE,TM.DESCRICAO,TM.TP_MERCAD,;
		      TM.PESO,TM.IVA,TM.CLAS_CMS,TM.CFO,;
		      TM.ORIGEM,TM.CST,TM.BASE_ISS,TM.ALIQ_ISS,;
		      TM.VLR_ISS,TM.BASE_CALC,TM.ALIQ_ICMS,;
		      TM.VLR_ICMS,TM.BASE_SBBRT,TM.BASE_SUBS,;
		      TM.ICMS_SUBS,TM.BASE_ISENT,TM.BASE_OUTR,;
		      TM.BASE_ISIPI,TM.BASE_IPI,TM.ALIQ_IPI,;
		      TM.VLRIPI,TM.PRECO,TM.DESC_ADICI,;
		      TM.PRECOFINAL,TM.QTDE,TM.VLRVENDA,;
		      TM.QTDERES,TM.DTREGIS,TM.HREGIS,;
		      TM.USRREGIS,TM.DELETADO,;
		      GR.classifica ;
        FROM ;
	       	 CURS_A        OR, ;
	       	 &ArqOrTmp     TM, ;
             &ArqGrupo     GR  ;
		WHERE ;
			    OR.empresa   = TM.empresa ;
			AND OR.orcamento = TM.orcamento;
            AND TM.codigo = GR.codigo      ;
    ORDER BY OR.ORCAMENTO;
    INTO CURSOR  CRS_ORCA
	
