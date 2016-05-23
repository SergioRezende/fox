
return
*---------------------------------------------------------------*
*------------------------ < ROT. APOIO >------------------------*
*---------------------------------------------------------------*
*  rotina alterada para tratar IVA AJUSTADA
*---------------------------------------------------------------*


FUNCTION TR_ICM49IVAjustada
PARAMETERS LNiva
	*------------------------------------------------------------*
	* IVA AJUSTADA
	*------------------------------------------------------------*
    *      Verifica aplicacao da regra de iva ajustada:
    *   => PECAS
    *      => MT e DF
	*------------------------------------------------------------*

		LFajustaIVA = .f.

        *------------------------------------------------------*
        * 1a - VERIFICACAO DE ENQUADRAMENTO - UF e DATA
        *------------------------------------------------------*
		DO CASE

			CASE (PrmUFOrigem $ "DF") ;
			    	and PrmUFOrigem <> PrmUFDestino ;
		    	and PrmData >= {01.06.2008} 
				*---------------------------------------------------*
				* PROTOCOLO ICMS 49 -8 DE MAI DE 2008 IVA AJUSTAS DF/MT
				*-----------------------------------------------------*
				LFajustaIVA = LFajustaIVA 
							&& SO PARA JUSTIFICAR IF AFIRMATIVO

			CASE (PrmUFOrigem $ "MT");
			    	and PrmUFOrigem <> PrmUFDestino ;
			    	and PrmData >= {01.06.2008} ;
			    	and PrmData <  {01.09.2012} 
				*------------------------------------------------*
				* PROTOCOLO ICMS 49 -8 DE MAI DE 2008 IVA AJUSTAS DF/MT
				*----------------------------------------------------*
				LFajustaIVA = LFajustaIVA 
							&& SO PARA JUSTIFICAR IF AFIRMATIVO
			OTHWERWISE
				RETURN(LNIva)
		ENDDO

        *------------------------------------------------------*
        * 2a - VERIFICACAO DE ENQUADRAMENTO - PRODUTOS
        *------------------------------------------------------*

	 	DO CASE
			*--------------------------------------------*
			* PECAS E ACESSORIOS
			*--------------------------------------------*
	 		CASE LEFT( &Als_Grupo .classifica,2) = "04" 
	 		   IF LEFT( &Als_Grupo .classifica,5)  $ "04041/04042/04043"
				  LFajustaIVA = .f.  && Nao aplica IVA AJUSTADA
	 		   ELSE
				  LFajustaIVA = .T.  && Aplica IVA AJUSTADA
	 		   ENDIF

			*--------------------------------------------*
			* PESOS
			*--------------------------------------------*
	 		CASE LEFT( &Als_Grupo .classifica,5) = "07075" 
	 		   IF SUBS( &Als_Grupo .classifica,6,3)  $ "599/699/799/899/999"
				  LFajustaIVA = .T.  && Aplica IVA AJUSTADA
	 		   ENDIF
			*--------------------------------------------*
			* MATERIAL BORRACHARIA
			*--------------------------------------------*
	 		CASE LEFT( &Als_Grupo .classifica,2) = "05" 
			  LFajustaIVA = .T.  && Aplica IVA AJUSTADA
 	
	 	ENDCASE

		IF LFajustaIVA = .T.
			LNalq_externaUForg = TRAlqIcmOuUF(PrmUFOrigem)
			LNalq_internaUFDst = TRAlqIcmInUF(PrmUFDestino)


			do case
				case LNiva = 1.265				     
					do case
						case LNalq_externaUForg	= 7
	
							do case
								case LNalq_internaUFDst = 17
									LNiva = 1.417				     
								case LNalq_internaUFDst = 18
									LNiva = 1.435				     
								case LNalq_internaUFDst = 19
									LNiva = 1.452			     
        		         	endcase

					     case LNalq_externaUForg	= 12
        		            do case
								case LNalq_internaUFDst = 17
									LNiva = 1.341				     
								case LNalq_internaUFDst = 18
									LNiva = 1.358			     
								case LNalq_internaUFDst = 19
									LNiva = 1.374			     
		                    endcase
					endcase
				case LNiva = 1.400				     
					do case
						case LNalq_externaUForg	= 7
	
							do case
								case LNalq_internaUFDst = 17
									LNiva = 1.569				     
								case LNalq_internaUFDst = 18
									LNiva = 1.588				     
								case LNalq_internaUFDst = 19
									LNiva = 1.607				     
        		         	endcase

					     case LNalq_externaUForg	= 12
        		            do case
								case LNalq_internaUFDst = 17
									LNiva = 1.484				     
								case LNalq_internaUFDst = 18
									LNiva = 1.502				     
								case LNalq_internaUFDst = 19
									LNiva = 1.521			     
		                    endcase
					endcase
			endcase
		ENDIF
    

RETURN(LNIva)
