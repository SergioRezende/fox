
select ;
    nf.data,;
    nf.ch_opera,;
    nf.tp_parcela,;
    ULMOD_DOC(nf.nota)   as MOD_DOC,;
;
    ULNRO_DOC(nf.nota)   as NRO_DOC,;
    nf.nota              ,;
    nf.status,;
    nf.total_nota        as VLR_DOC,;
    nf.icms_subs,;
    nf.vlr_issrtd,;
    NF.FAVORECIDO,;
    NF.NOME;
from ;
   q:\scgc\loja\nota nf;
where ;
   nf.data = {02.01.2013};
and nf.empresa = 1 ;
ORDER BY ;
    nf.ch_opera,;
    nf.tp_parcela,;
    nf.data,;
    MOD_DOC , ;
    NRO_DOC 
 




RETURN

FUNCTION ULMOD_DOC
PARAMETERS PrmNota

private RtnMOD_DOC


    RtnMOD_DOC   =   ""
	DO CASE

		CASE PrmNota > 1000000 AND PrmNota < 2000000
		    RtnMOD_DOC    =   "2D"  && CUPOM

		CASE PrmNota > 2000000 AND PrmNota < 3000000
		    RtnMOD_DOC    =   "03"  && NF SERVICO

		CASE PrmNota > 3000000 AND PrmNota < 4000000
		    RtnMOD_DOC    =   "55"  && NFe


		CASE PrmNota > 4000000 AND PrmNota < 5000000
		    RtnMOD_DOC    =   "03"  && NFSe
		
*		OTHERWISE			
*			=W_DEFPROC("TIPOOPER.SPR")
*			LFieldTmp    = ;
*				TPGetFieldValue("S",  PrmTipo ,"Cod_Mod_Rf")
*		    RtnMOD_DOC    = LFieldTmp
*
	ENDCASE
	

RETURN(RtnMOD_DOC)


FUNCTION ULNRO_DOC
PARAMETERS PrmNota

private RtnNro_Doc


    RtnNro_Doc    =   PrmNota
	DO CASE

		CASE PrmNota > 1000000 AND PrmNota < 2000000
		    RtnNro_Doc    =   PrmNota - 1000000

		CASE PrmNota > 2000000 AND PrmNota < 3000000
		    RtnNro_Doc    =   PrmNota - 2000000

		CASE PrmNota > 3000000 AND PrmNota < 4000000
		    RtnNro_Doc    =   PrmNota - 3000000


		CASE PrmNota > 4000000 AND PrmNota < 5000000
		    RtnNro_Doc    =   PrmNota - 4000000

	ENDCASE
	

RETURN(RtnNro_Doc)
