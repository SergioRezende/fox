close data
set date german
set centu on
set dele on


select ;
  dp.empresa,;
  dp.orcamento,;
  dp.nota,;
  dp.dt_emi,;
  or.valor,;
  or.tp_parcela,;
  CRqtd_parcelas(or.prazo)  as parc_prv,;
  count(1) as nro_parc, ;
  sum(dp.vlr_doc) as soma ;
from ;
  q:\scgc\loja\orcamento or ;
 ,q:\scgc\loja\duplicat dp ;
where ;
  or.tp_parcela = 4 ;
  and dp.dt_emi > {01.11.2014} ;
  and or.empresa = dp.empresa and or.orcamento = dp.orcamento;
group by ;
  dp.empresa,;
  dp.orcamento,;
  dp.nota,;
  dp.dt_emi,;
  or.valor,;
  or.tp_parcela;
into table x:\tmp\tmp_erro 


select ;
  * ;
from ;
  x:\tmp\tmp_erro  ;
where   ;
  parc_prv >  nro_parc ;
into table x:\tmp\tmp_dup2


GO TOP

DO WHILE !EOF()
 	=W_DEFPROC("DUPLICAT.spr")
     PrmTrataBoleto = "SEM BOLETO"  
	 DO  CRgeraDE01JUL12 WITH ;
				    (tmp_dup2.empresa),;
				    (tmp_dup2.orcamento),;
				    PrmTrataBoleto


  SELE TMP_DUP2
  SKIP
ENDDO



  
RETURN

FUNCTION CRqtd_parcelas
PARAMETERS LSPrazo



			LNocorrenc 	= 1		&& 1�,2�,3�... Ocorrencia do Char "/"
		    LNposic    	= 0     && Qual Posi��o da Str Oocorre "/" 3,7,...
		    LNnumpgt   	= 0		&& Quantidade de Parcelas Fora Entrada
			LNdias	   	= 0		&& Dias de Prazo da Parcela 
			LNproximodias	= 0  && Permite Diferenciar o 
							 && Pgto com Entrada (000/031/000/000)
							 && do Pgto Conta Apresent��o 
							 && (000/000/000/...). No Primeiro Caso Quando
							 && LNdias = 0 (ou ser� a Entrada ou Invalido)
							 && e  n�o ser� gerada Duplicatas. J� no
							 && Segundo Caso deve Ser Gerada Uma Dupl.
							 && Conta Apresenta��o
		    LNinicio   	= 1
			*-----------------------------------------------------------*



			DO WHILE .t.
		        LNinicio   	 = LNposic + 1
			    LNdias       = INT(VAL(SUBS(LSprazo,LNinicio,3)))
				LNproximodias= INT(VAL(SUBS(LSprazo,LNinicio+4,3)))

	    		LNposic 	 = AT("/",LSprazo, LNocorrenc) 
				*-----------------------------------------------*
	  			IF LNposic = 0 OR (LNocorrenc > 1 AND LNdias = 0)
					EXIT
				ENDIF
				*-----------------------------------------------*
				*-----------------------------------------------*
				* LNdias = 0 AND LNproximodias => Conta Apresenta��o
				*-----------------------------------------------*
				* 000/000/000/...  Conta Apresenta��o
				*				LNnumpgt = 1
				*-----------------------------------------------*
				*-----------------------------------------------*
				IF LNdias = 0 AND LNproximodias > 0 && Descarte da
													&&  Entrada
					LNocorrenc 	= LNocorrenc + 1
				ELSE
					LNocorrenc 	= LNocorrenc + 1
			       	LNnumpgt   	= LNnumpgt + 1
				ENDIF
			ENDDO
RETURN(LNnumpgt)
  

  
  

