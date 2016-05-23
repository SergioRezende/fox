	SELECT   notaite.classifica,notaite.descricao, notaite.data, notaite.ch_opera,;
			 notaite.ch_desti,;
			 notaite.nota,notaite.tipo,notaite.codforn,notaite.tp_mercad,;
			 notaite.iva , ;
			 notaite.operacao , notaite.vlrvenda, notaite.vlripi, ;
			 notaite.aliq_icms, ;
			 ULNFEicmsRetido_item(17,tp_mercad,vlrvenda,vlripi,;
			 			aliq_icms,iva) AS ICMRETIDO,;
			 ULNFEicmsnormal_item(tp_mercad,vlrvenda,aliq_icms) ;
			 						   AS ICMNORMAL, ;
			 ULNFEicmstransint_item(tp_mercad, vlrvenda,;
									aliq_icms,iva,ch_desti,;
									ch_opera, classifica) ;
									 AS ICMTRANSF ;
	    		 FROM &LSarq1 ;
				 WHERE (notaite.data	>= m.dt_inicio AND ;
   				 	    notaite.data	<= m.dt_fim AND ;
						notaite.empresa = m.empresa AND ;
   				 	    notaite.ch_opera $ "12" AND ;
   				 	    notaite.ch_condi $ "23" AND ;
   				 	    LEFT(notaite.operacao,1) = "E") ;
				 INTO CURSOR &wl_arqtmp ;
				 ORDER BY 	 nota,classifica
				 