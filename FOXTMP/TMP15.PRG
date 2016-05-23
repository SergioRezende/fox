		IF orcament.prazomedio = 0 OR orcament.tp_pgto <> 3
			LSsit = "AE"
		ELSE
			** JA HOUVE LIBERACAO EMCERTAS CONDICOES ***
			IF (orcament.prazomedio <= orcament.lim_prazo ;
				AND orcament.valor <= orcament.lim_libera ;
				AND	(orcament.lim_forma = 0 ;
				OR orcament.lim_forma = orcament.forma_pgto))
				LSsit = "AE"
			ELSE
				IF (orcament.lim_libera > 0)   && JA houve liberacao
					LSsit = "AH"		&& AGUARDA LIBERACAO DE CREDITO
				ELSE
					LSsit = "AD"		&& AGUARDA LIBERACAO DE CREDITO
				ENDIF

				*---------------------------------------------------------*
				*  Vendas em cartao para matriz sao liberadas sem verifica
				* cao
				*---------------------------------------------------------*
				IF 	  (orcament.empresa = 1 ;
				         AND (   orcament.forma_pgto = 5 ;
				    	         OR orcament.forma_pgto = 6 ;
				    	         OR orcament.forma_pgto = 7 ;
				    	         OR orcament.forma_pgto = 8 ;
				    	     );
				       ) ;
					OR ;
					 ORVer_credito(clienc.cliente,;
							orcament.valor - orcament.vlr_ent,0,0) = 0
						
					LDdt_libera  = wp_dtoper
					LNlim_libera = orcament.valor - orcament.vlr_ent
					LNlim_forma  = 0
					LNlim_prazo  = orcament.prazomedio
					LNusr_libera = 0	&& liberado pelo SISTEMA
					LSsit = "AE"
				ENDIF
			ENDIF
		ENDIF
