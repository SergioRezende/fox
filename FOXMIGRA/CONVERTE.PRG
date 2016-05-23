use grupo exclu
go top
SET TALK ON
CLEAR
*---->monta codigo
REPLACE ALL CODIGO WITH LEFT(TXT,2)+SUBS(TXT,7,1)+SUBS(TXT,12,3)+SUBS(TXT,19,1)

*---->monta descricao
REPLACE ALL DESCRICAO WITH SUBS(TXT,24,25)

*---> monta classificacao (pre)
REPLACE ALL grupo     with subs(txt,53,1) 
REPLACE ALL subgrupo  with subs(txt,58,3) 
REPLACE ALL classe    with subs(txt,65,3)
REPLACE ALL sequencia with subs(txt,72,3)  
REPLACE ALL marcatxt  with subs(txt,79,1)  
*---> monta outros
REPLACE ALL aro    with int(val(subs(txt,66,2)))
REPLACE ALL marca  with int(val(subs(txt,79,1)))

*---> acerta
REPLACE ALL CODIGO WITH CHRTRAN(LEFT(CODIGO,7)," ","0")

*-------->  CLASSIFICA  99.99.999.999.999  para PNEUS

REPLACE ALL CLASSIFICA WITH "0404004013"+CHRTRAN(SEQUENCIA," ","0") ;
											 FOR    GRUPO    = "0";
												AND SUBGRUPO = " 49";
												AND CLASSE   = " 13"
REPLACE ALL CLASSIFICA WITH "0404004014"+CHRTRAN(SEQUENCIA," ","0") ;
											 FOR    GRUPO    = "0";
												AND SUBGRUPO = " 49";
												AND CLASSE   = " 14"
REPLACE ALL CLASSIFICA WITH "0404004015"+CHRTRAN(SEQUENCIA," ","0") ;
											 FOR    GRUPO    = "0";
												AND SUBGRUPO = " 49";
												AND CLASSE   = " 15"
REPLACE ALL CLASSIFICA WITH "0404004021"+CHRTRAN(SEQUENCIA," ","0") ;
											 FOR    GRUPO    = "0";
												AND SUBGRUPO = " 49";
												AND CLASSE   = " 21"
REPLACE ALL CLASSIFICA WITH "0404008013"+CHRTRAN(SEQUENCIA," ","0") ;
											 FOR    GRUPO    = "0";
												AND SUBGRUPO = "149";
												AND CLASSE   = " 13"
REPLACE ALL CLASSIFICA WITH "0404008014"+CHRTRAN(SEQUENCIA," ","0") ;
											 FOR    GRUPO    = "0";
												AND SUBGRUPO = "149";
												AND CLASSE   = " 14"
REPLACE ALL CLASSIFICA WITH "0404008015"+CHRTRAN(SEQUENCIA," ","0") ;
											 FOR    GRUPO    = "0";
												AND SUBGRUPO = "149";
												AND CLASSE   = " 15"
REPLACE ALL CLASSIFICA WITH "0408004015"+CHRTRAN(SEQUENCIA," ","0") ;
											 FOR    GRUPO    = "0";
												AND SUBGRUPO = "249";
												AND CLASSE   = " 15"
REPLACE ALL CLASSIFICA WITH "0408004016"+CHRTRAN(SEQUENCIA," ","0") ;
											 FOR    GRUPO    = "0";
												AND SUBGRUPO = "249";
												AND CLASSE   = " 16"
REPLACE ALL CLASSIFICA WITH "0408008015"+CHRTRAN(SEQUENCIA," ","0") ;
											 FOR    GRUPO    = "0";
												AND SUBGRUPO = "299";
												AND CLASSE   = " 15"
REPLACE ALL CLASSIFICA WITH "0408008016"+CHRTRAN(SEQUENCIA," ","0") ;
											 FOR    GRUPO    = "0";
												AND SUBGRUPO = "299";
												AND CLASSE   = " 16"
REPLACE ALL CLASSIFICA WITH "0408008017"+CHRTRAN(SEQUENCIA," ","0") ;
											 FOR    GRUPO    = "0";
												AND SUBGRUPO = "299";
												AND CLASSE   = " 17"
REPLACE ALL CLASSIFICA WITH "0416004020"+CHRTRAN(SEQUENCIA," ","0") ;
											 FOR    GRUPO    = "0";
												AND SUBGRUPO = "449";
												AND CLASSE   = " 20"
REPLACE ALL CLASSIFICA WITH "0416004022"+CHRTRAN(SEQUENCIA," ","0") ;
											 FOR    GRUPO    = "0";
												AND SUBGRUPO = "449";
												AND CLASSE   = " 22"
REPLACE ALL CLASSIFICA WITH "0416012020"+CHRTRAN(SEQUENCIA," ","0") ;
											 FOR    GRUPO    = "0";
												AND SUBGRUPO = "499";
												AND CLASSE   = " 20"
REPLACE ALL CLASSIFICA WITH "0416012022"+CHRTRAN(SEQUENCIA," ","0") ;
											 FOR    GRUPO    = "0";
												AND SUBGRUPO = "499";
												AND CLASSE   = " 22"
REPLACE ALL CLASSIFICA WITH "0416008020"+CHRTRAN(SEQUENCIA," ","0") ;
											 FOR    GRUPO    = "0";
												AND SUBGRUPO = "549";
												AND CLASSE   = " 20"
REPLACE ALL CLASSIFICA WITH "0416008022"+CHRTRAN(SEQUENCIA," ","0") ;
											 FOR    GRUPO    = "0";
												AND SUBGRUPO = "549";
												AND CLASSE   = " 22"
REPLACE ALL CLASSIFICA WITH "0420020018"+CHRTRAN(SEQUENCIA," ","0") ;
											 FOR    GRUPO    = "0";
												AND SUBGRUPO = "649";
												AND CLASSE   = " 18"
REPLACE ALL CLASSIFICA WITH "0420020020"+CHRTRAN(SEQUENCIA," ","0") ;
											 FOR    GRUPO    = "0";
												AND SUBGRUPO = "649";
												AND CLASSE   = " 20"
REPLACE ALL CLASSIFICA WITH "0420024024"+CHRTRAN(SEQUENCIA," ","0") ;
											 FOR    GRUPO    = "0";
												AND SUBGRUPO = "699";
												AND CLASSE   = " 24"
REPLACE ALL CLASSIFICA WITH "0420024026"+CHRTRAN(SEQUENCIA," ","0") ;
											 FOR    GRUPO    = "0";
												AND SUBGRUPO = "699";
												AND CLASSE   = " 26"
REPLACE ALL CLASSIFICA WITH "0420024028"+CHRTRAN(SEQUENCIA," ","0") ;
											 FOR    GRUPO    = "0";
												AND SUBGRUPO = "699";
												AND CLASSE   = " 28"
REPLACE ALL CLASSIFICA WITH "0420024030"+CHRTRAN(SEQUENCIA," ","0") ;
											 FOR    GRUPO    = "0";
												AND SUBGRUPO = "699";
												AND CLASSE   = " 30"
REPLACE ALL CLASSIFICA WITH "0420024034"+CHRTRAN(SEQUENCIA," ","0") ;
											 FOR    GRUPO    = "0";
												AND SUBGRUPO = "699";
												AND CLASSE   = " 34"
REPLACE ALL CLASSIFICA WITH "0420024038"+CHRTRAN(SEQUENCIA," ","0") ;
											 FOR    GRUPO    = "0";
												AND SUBGRUPO = "699";
												AND CLASSE   = " 38"
REPLACE ALL CLASSIFICA WITH "0424028024"+CHRTRAN(SEQUENCIA," ","0") ;
											 FOR    GRUPO    = "0";
												AND SUBGRUPO = "749";
												AND CLASSE   = " 24"
REPLACE ALL CLASSIFICA WITH "0424028025"+CHRTRAN(SEQUENCIA," ","0") ;
											 FOR    GRUPO    = "0";
												AND SUBGRUPO = "749";
												AND CLASSE   = " 25"
REPLACE ALL CLASSIFICA WITH "0428032010"+CHRTRAN(SEQUENCIA," ","0") ;
											 FOR    GRUPO    = "0";
												AND SUBGRUPO = "799";
												AND CLASSE   = " 10"
REPLACE ALL CLASSIFICA WITH "0428032012"+CHRTRAN(SEQUENCIA," ","0") ;
											 FOR    GRUPO    = "0";
												AND SUBGRUPO = "799";
												AND CLASSE   = " 12"
REPLACE ALL CLASSIFICA WITH "0428032015"+CHRTRAN(SEQUENCIA," ","0") ;
											 FOR    GRUPO    = "0";
												AND SUBGRUPO = "799";
												AND CLASSE   = " 15"
												
												
*-------->  CLASSIFICA  99.99.999.999.999  para CAMARAS
												
																								
REPLACE ALL CLASSIFICA WITH "0804004013"+CHRTRAN(SEQUENCIA," ","0") ;
											 FOR    GRUPO    = "1";
												AND SUBGRUPO = " 49";
												AND CLASSE   = " 13"
REPLACE ALL CLASSIFICA WITH "0804004014"+CHRTRAN(SEQUENCIA," ","0") ;
											 FOR    GRUPO    = "1";
												AND SUBGRUPO = " 49";
												AND CLASSE   = " 14"
REPLACE ALL CLASSIFICA WITH "0804004015"+CHRTRAN(SEQUENCIA," ","0") ;
											 FOR    GRUPO    = "1";
												AND SUBGRUPO = " 49";
												AND CLASSE   = " 15"
REPLACE ALL CLASSIFICA WITH "0808012016"+CHRTRAN(SEQUENCIA," ","0") ;
											 FOR    GRUPO    = "1";
												AND SUBGRUPO = "249";
												AND CLASSE   = " 16"
REPLACE ALL CLASSIFICA WITH "0816018020"+CHRTRAN(SEQUENCIA," ","0") ;
											 FOR    GRUPO    = "1";
												AND SUBGRUPO = "449";
												AND CLASSE   = " 20"
REPLACE ALL CLASSIFICA WITH "0816018022"+CHRTRAN(SEQUENCIA," ","0") ;
											 FOR    GRUPO    = "1";
												AND SUBGRUPO = "449";
												AND CLASSE   = " 22"
REPLACE ALL CLASSIFICA WITH "0820020016"+CHRTRAN(SEQUENCIA," ","0") ;
											 FOR    GRUPO    = "1";
												AND SUBGRUPO = "649";
												AND CLASSE   = " 16"
REPLACE ALL CLASSIFICA WITH "0820020018"+CHRTRAN(SEQUENCIA," ","0") ;
											 FOR    GRUPO    = "1";
												AND SUBGRUPO = "649";
												AND CLASSE   = " 18"
REPLACE ALL CLASSIFICA WITH "0820024024"+CHRTRAN(SEQUENCIA," ","0") ;
											 FOR    GRUPO    = "1";
												AND SUBGRUPO = "699";
												AND CLASSE   = " 24"
REPLACE ALL CLASSIFICA WITH "0820024026"+CHRTRAN(SEQUENCIA," ","0") ;
											 FOR    GRUPO    = "1";
												AND SUBGRUPO = "699";
												AND CLASSE   = " 26"
REPLACE ALL CLASSIFICA WITH "0820024028"+CHRTRAN(SEQUENCIA," ","0") ;
											 FOR    GRUPO    = "1";
												AND SUBGRUPO = "699";
												AND CLASSE   = " 28"
REPLACE ALL CLASSIFICA WITH "0820024030"+CHRTRAN(SEQUENCIA," ","0") ;
											 FOR    GRUPO    = "1";
												AND SUBGRUPO = "699";
												AND CLASSE   = " 30"
REPLACE ALL CLASSIFICA WITH "0820024038"+CHRTRAN(SEQUENCIA," ","0") ;
											 FOR    GRUPO    = "1";
												AND SUBGRUPO = "699";
												AND CLASSE   = " 38"
REPLACE ALL CLASSIFICA WITH "0824028024"+CHRTRAN(SEQUENCIA," ","0") ;
											 FOR    GRUPO    = "1";
												AND SUBGRUPO = "749";
												AND CLASSE   = " 24"
REPLACE ALL CLASSIFICA WITH "0824028025"+CHRTRAN(SEQUENCIA," ","0") ;
											 FOR    GRUPO    = "1";
												AND SUBGRUPO = "749";
												AND CLASSE   = " 25"
REPLACE ALL CLASSIFICA WITH "0828032010"+CHRTRAN(SEQUENCIA," ","0") ;
											 FOR    GRUPO    = "1";
												AND SUBGRUPO = "799";
												AND CLASSE   = "998";
												AND LEFT(CODIGO,2)= "10"
REPLACE ALL CLASSIFICA WITH "0828032012"+CHRTRAN(SEQUENCIA," ","0") ;
											 FOR    GRUPO    = "1";
												AND SUBGRUPO = "799";
												AND CLASSE   = "998";
												AND LEFT(CODIGO,2)= "12"
REPLACE ALL CLASSIFICA WITH "0828032015"+CHRTRAN(SEQUENCIA," ","0") ;
											 FOR    GRUPO    = "1";
												AND SUBGRUPO = "799";
												AND CLASSE   = "998";
												AND LEFT(CODIGO,2)= "15"
												
*------------>>>>  PARA PROTETORES														

REPLACE ALL CLASSIFICA WITH "1216"+CHRTRAN(SEQUENCIA," ","0") ;
											 FOR    GRUPO    = "4";
												AND SUBGRUPO = " 42";
												AND CLASSE   = " 19"
REPLACE ALL CLASSIFICA WITH "1220"+CHRTRAN(SEQUENCIA," ","0") ;
											 FOR    GRUPO    = "4";
												AND SUBGRUPO = " 42";
												AND CLASSE   = "199"
REPLACE ALL CLASSIFICA WITH "1222"+CHRTRAN(SEQUENCIA," ","0") ;
											 FOR    GRUPO    = "4";
												AND SUBGRUPO = " 42";
												AND CLASSE   = "299"
REPLACE ALL CLASSIFICA WITH "1224"+CHRTRAN(SEQUENCIA," ","0") ;
											 FOR    GRUPO    = "4";
												AND SUBGRUPO = " 42";
												AND CLASSE   = "399"
REPLACE ALL CLASSIFICA WITH "1225"+CHRTRAN(SEQUENCIA," ","0") ;
											 FOR    GRUPO    = "4";
												AND SUBGRUPO = " 42";
												AND CLASSE   = "499"


*------->>>>> PARA RODAS

REPLACE ALL CLASSIFICA WITH "1604004013"+CHRTRAN(SEQUENCIA," ","0") ;
											 FOR    GRUPO    = "2";
												AND SUBGRUPO = " 99";
												AND CLASSE   = " 13"
REPLACE ALL CLASSIFICA WITH "1604004014"+CHRTRAN(SEQUENCIA," ","0") ;
											 FOR    GRUPO    = "2";
												AND SUBGRUPO = " 99";
												AND CLASSE   = " 14"
REPLACE ALL CLASSIFICA WITH "1604004015"+CHRTRAN(SEQUENCIA," ","0") ;
											 FOR    GRUPO    = "2";
												AND SUBGRUPO = " 99";
												AND CLASSE   = " 15"
REPLACE ALL CLASSIFICA WITH "1604008013"+CHRTRAN(SEQUENCIA," ","0") ;
											 FOR    GRUPO    = "2";
												AND SUBGRUPO = "399";
												AND CLASSE   = " 13"
REPLACE ALL CLASSIFICA WITH "1604008015"+CHRTRAN(SEQUENCIA," ","0") ;
											 FOR    GRUPO    = "2";
												AND SUBGRUPO = "399";
												AND CLASSE   = " 15"
REPLACE ALL CLASSIFICA WITH "1608012015"+CHRTRAN(SEQUENCIA," ","0") ;
											 FOR    GRUPO    = "2";
												AND SUBGRUPO = "499";
												AND CLASSE   = " 15"
REPLACE ALL CLASSIFICA WITH "1608012016"+CHRTRAN(SEQUENCIA," ","0") ;
											 FOR    GRUPO    = "2";
												AND SUBGRUPO = "499";
												AND CLASSE   = " 16"
REPLACE ALL CLASSIFICA WITH "1608004015"+CHRTRAN(SEQUENCIA," ","0") ;
											 FOR    GRUPO    = "2";
												AND SUBGRUPO = "599";
												AND CLASSE   = " 15"
REPLACE ALL CLASSIFICA WITH "1608004016"+CHRTRAN(SEQUENCIA," ","0") ;
											 FOR    GRUPO    = "2";
												AND SUBGRUPO = "599";
												AND CLASSE   = " 16"
												
*-------->>>>> PARA PECAS DE SUSPENSAO
REPLACE ALL CLASSIFICA WITH "2404"+CHRTRAN(SEQUENCIA," ","0") ;
											 FOR    GRUPO    = "4";
												AND SUBGRUPO = " 45";
												AND CLASSE   = " 99"
REPLACE ALL CLASSIFICA WITH "2408"+CHRTRAN(SEQUENCIA," ","0") ;
											 FOR    GRUPO    = "4";
												AND SUBGRUPO = " 45";
												AND CLASSE   = "199"
REPLACE ALL CLASSIFICA WITH "2412"+CHRTRAN(SEQUENCIA," ","0") ;
											 FOR    GRUPO    = "4";
												AND SUBGRUPO = " 45";
												AND CLASSE   = "299"
REPLACE ALL CLASSIFICA WITH "2416"+CHRTRAN(SEQUENCIA," ","0") ;
											 FOR    GRUPO    = "4";
												AND SUBGRUPO = " 45";
												AND CLASSE   = "399"
REPLACE ALL CLASSIFICA WITH "2424"+CHRTRAN(SEQUENCIA," ","0") ;
											 FOR    GRUPO    = "4";
												AND SUBGRUPO = " 45";
												AND CLASSE   = "449"
REPLACE ALL CLASSIFICA WITH "2420"+CHRTRAN(SEQUENCIA," ","0") ;
											 FOR    GRUPO    = "4";
												AND SUBGRUPO = " 45";
												AND CLASSE   = "499"
REPLACE ALL CLASSIFICA WITH "2428"+CHRTRAN(SEQUENCIA," ","0") ;
											 FOR    GRUPO    = "4";
												AND SUBGRUPO = " 45";
												AND CLASSE   = "549"
REPLACE ALL CLASSIFICA WITH "2432"+CHRTRAN(SEQUENCIA," ","0") ;
											 FOR    GRUPO    = "4";
												AND SUBGRUPO = " 45";
												AND CLASSE   = "599"
REPLACE ALL CLASSIFICA WITH "2416"+CHRTRAN(SEQUENCIA," ","0") ;
											 FOR    GRUPO    = "4";
												AND SUBGRUPO = " 45";
												AND CLASSE   = "699"
REPLACE ALL CLASSIFICA WITH "2432"+CHRTRAN(SEQUENCIA," ","0") ;
											 FOR    GRUPO    = "4";
												AND SUBGRUPO = " 45";
												AND CLASSE   = "749"
*-----------PARA PECAS DE FREIO
REPLACE ALL CLASSIFICA WITH "2804"+CHRTRAN(SEQUENCIA," ","0") ;
											 FOR    GRUPO    = "4";
												AND SUBGRUPO = " 47";
												AND CLASSE   = " 99"
REPLACE ALL CLASSIFICA WITH "2808"+CHRTRAN(SEQUENCIA," ","0") ;
											 FOR    GRUPO    = "4";
												AND SUBGRUPO = " 47";
												AND CLASSE   = "299"
REPLACE ALL CLASSIFICA WITH "2812"+CHRTRAN(SEQUENCIA," ","0") ;
											 FOR    GRUPO    = "4";
												AND SUBGRUPO = " 47";
												AND CLASSE   = "699"
REPLACE ALL CLASSIFICA WITH "2816"+CHRTRAN(SEQUENCIA," ","0") ;
											 FOR    GRUPO    = "4";
												AND SUBGRUPO = " 47";
												AND CLASSE   = "749"
REPLACE ALL CLASSIFICA WITH "2820"+CHRTRAN(SEQUENCIA," ","0") ;
											 FOR    GRUPO    = "4";
												AND SUBGRUPO = " 47";
												AND CLASSE   = "799"
REPLACE ALL CLASSIFICA WITH "2824"+CHRTRAN(SEQUENCIA," ","0") ;
											 FOR    GRUPO    = "4";
												AND SUBGRUPO = " 47";
												AND CLASSE   = "849"
REPLACE ALL CLASSIFICA WITH "2828"+CHRTRAN(SEQUENCIA," ","0") ;
											 FOR    GRUPO    = "4";
												AND SUBGRUPO = " 47";
												AND CLASSE   = "899"
REPLACE ALL CLASSIFICA WITH "2832"+CHRTRAN(SEQUENCIA," ","0") ;
											 FOR    GRUPO    = "4";
												AND SUBGRUPO = " 47";
												AND CLASSE   = "949"
REPLACE ALL CLASSIFICA WITH "2836"+CHRTRAN(SEQUENCIA," ","0") ;
											 FOR    GRUPO    = "4";
												AND SUBGRUPO = " 48";
												AND CLASSE   = " 99"
REPLACE ALL CLASSIFICA WITH "2840"+CHRTRAN(SEQUENCIA," ","0") ;
											 FOR    GRUPO    = "4";
												AND SUBGRUPO = " 48";
												AND CLASSE   = "199"
*------->>> PARA ENCERADOS
REPLACE ALL CLASSIFICA WITH "3204"+CHRTRAN(SEQUENCIA," ","0") ;
											 FOR    GRUPO    = "4";
												AND SUBGRUPO = " 41";
												AND CLASSE   = " 99"
REPLACE ALL CLASSIFICA WITH "3208"+CHRTRAN(SEQUENCIA," ","0") ;
											 FOR    GRUPO    = "4";
												AND SUBGRUPO = " 41";
												AND CLASSE   = "199"
REPLACE ALL CLASSIFICA WITH "3212"+CHRTRAN(SEQUENCIA," ","0") ;
											 FOR    GRUPO    = "4";
												AND SUBGRUPO = " 41";
												AND CLASSE   = "299"
REPLACE ALL CLASSIFICA WITH "3216"+CHRTRAN(SEQUENCIA," ","0") ;
											 FOR    GRUPO    = "4";
												AND SUBGRUPO = " 41";
												AND CLASSE   = "299";
									AND SEQUENCIA $ "251/252/253/254"
REPLACE ALL CLASSIFICA WITH "3220"+CHRTRAN(SEQUENCIA," ","0") ;
											 FOR    GRUPO    = "4";
												AND SUBGRUPO = " 41";
												AND CLASSE   = "399"
*-----> PARA MATERIA DE BORRACHARIA
REPLACE ALL CLASSIFICA WITH "3604"+CHRTRAN(SEQUENCIA," ","0") ;
											 FOR    GRUPO    = "5";
												AND SUBGRUPO = " 50";
												AND CLASSE   = "799"
REPLACE ALL CLASSIFICA WITH "3608"+CHRTRAN(SEQUENCIA," ","0") ;
											 FOR    GRUPO    = "5";
												AND SUBGRUPO = " 50";
												AND CLASSE   = "999"
REPLACE ALL CLASSIFICA WITH "3612"+CHRTRAN(SEQUENCIA," ","0") ;
											 FOR    GRUPO    = "5";
												AND SUBGRUPO = " 51";
												AND CLASSE   = "119"
REPLACE ALL CLASSIFICA WITH "3616"+CHRTRAN(SEQUENCIA," ","0") ;
											 FOR    GRUPO    = "5";
												AND SUBGRUPO = " 52";
												AND CLASSE   = " 69"
REPLACE ALL CLASSIFICA WITH "3620"+CHRTRAN(SEQUENCIA," ","0") ;
											 FOR    GRUPO    = "5";
												AND SUBGRUPO = " 52";
												AND CLASSE   = "599"
REPLACE ALL CLASSIFICA WITH "3624"+CHRTRAN(SEQUENCIA," ","0") ;
											 FOR    GRUPO    = "5";
												AND SUBGRUPO = " 58";
												AND CLASSE   = "519"
*----> PARA ACESSORIOS E PECAS
REPLACE ALL CLASSIFICA WITH "4004"+CHRTRAN(SEQUENCIA," ","0") ;
											 FOR    GRUPO    = "4";
												AND SUBGRUPO = " 40";
												AND CLASSE   = "299"
REPLACE ALL CLASSIFICA WITH "4008"+CHRTRAN(SEQUENCIA," ","0") ;
											 FOR    GRUPO    = "4";
												AND SUBGRUPO = " 40";
												AND CLASSE   = "399"
*-------> PARA MATERIA PRIMA
REPLACE ALL CLASSIFICA WITH "4404"+CHRTRAN(SEQUENCIA," ","0") ;
											 FOR    GRUPO    = "6";
												AND SUBGRUPO = " 60";
												AND CLASSE   = "999"
REPLACE ALL CLASSIFICA WITH "4408"+CHRTRAN(SEQUENCIA," ","0") ;
											 FOR    GRUPO    = "6";
												AND SUBGRUPO = " 61";
												AND CLASSE   = "999"
*--------> PARA MATERIA SECUNDARIA

REPLACE ALL CLASSIFICA WITH "4804"+CHRTRAN(SEQUENCIA," ","0") ;
											 FOR    GRUPO    = "7";
												AND SUBGRUPO = " 70";
												AND CLASSE   = " 99"
REPLACE ALL CLASSIFICA WITH "4808"+CHRTRAN(SEQUENCIA," ","0") ;
											 FOR    GRUPO    = "7";
												AND SUBGRUPO = " 70";
												AND CLASSE   = "199"
REPLACE ALL CLASSIFICA WITH "4812"+CHRTRAN(SEQUENCIA," ","0") ;
											 FOR    GRUPO    = "7";
												AND SUBGRUPO = " 70";
												AND CLASSE   = "299"
*-------> PARA MATERIA DE CONSUMO
REPLACE ALL CLASSIFICA WITH "5204004"+CHRTRAN(SEQUENCIA," ","0") ;
											 FOR    GRUPO    = "7";
												AND SUBGRUPO = " 75";
												AND CLASSE   = " 99"
REPLACE ALL CLASSIFICA WITH "5204008"+CHRTRAN(SEQUENCIA," ","0") ;
											 FOR    GRUPO    = "7";
												AND SUBGRUPO = " 75";
												AND CLASSE   = "199"
REPLACE ALL CLASSIFICA WITH "5204016"+CHRTRAN(SEQUENCIA," ","0") ;
											 FOR    GRUPO    = "7";
												AND SUBGRUPO = " 75";
												AND CLASSE   = "399"
REPLACE ALL CLASSIFICA WITH "5208020"+CHRTRAN(SEQUENCIA," ","0") ;
											 FOR    GRUPO    = "7";
												AND SUBGRUPO = " 75";
												AND CLASSE   = "599"
REPLACE ALL CLASSIFICA WITH "5208024"+CHRTRAN(SEQUENCIA," ","0") ;
											 FOR    GRUPO    = "7";
												AND SUBGRUPO = " 75";
												AND CLASSE   = "699"
REPLACE ALL CLASSIFICA WITH "5208028"+CHRTRAN(SEQUENCIA," ","0") ;
											 FOR    GRUPO    = "7";
												AND SUBGRUPO = " 75";
												AND CLASSE   = "799"
REPLACE ALL CLASSIFICA WITH "5208032"+CHRTRAN(SEQUENCIA," ","0") ;
											 FOR    GRUPO    = "7";
												AND SUBGRUPO = " 75";
												AND CLASSE   = "899"
REPLACE ALL CLASSIFICA WITH "5208036"+CHRTRAN(SEQUENCIA," ","0") ;
											 FOR    GRUPO    = "7";
												AND SUBGRUPO = " 75";
												AND CLASSE   = "999"
REPLACE ALL CLASSIFICA WITH "5212040"+CHRTRAN(SEQUENCIA," ","0") ;
											 FOR    GRUPO    = "7";
												AND SUBGRUPO = " 76";
												AND CLASSE   = " 49"
REPLACE ALL CLASSIFICA WITH "5212044"+CHRTRAN(SEQUENCIA," ","0") ;
											 FOR    GRUPO    = "7";
												AND SUBGRUPO = " 76";
												AND CLASSE   = " 99"
REPLACE ALL CLASSIFICA WITH "5212048"+CHRTRAN(SEQUENCIA," ","0") ;
											 FOR    GRUPO    = "7";
												AND SUBGRUPO = " 76";
												AND CLASSE   = "199"
REPLACE ALL CLASSIFICA WITH "5212048"+CHRTRAN(SEQUENCIA," ","0") ;
											 FOR    GRUPO    = "7";
												AND SUBGRUPO = " 76";
												AND CLASSE   = "299"
REPLACE ALL CLASSIFICA WITH "5212054"+CHRTRAN(SEQUENCIA," ","0") ;
											 FOR    GRUPO    = "7";
												AND SUBGRUPO = " 76";
												AND CLASSE   = "999"
REPLACE ALL CLASSIFICA WITH "5212056"+CHRTRAN(SEQUENCIA," ","0") ;
											 FOR    GRUPO    = "7";
												AND SUBGRUPO = " 77";
												AND CLASSE   = "199"
REPLACE ALL CLASSIFICA WITH "5216058"+CHRTRAN(SEQUENCIA," ","0") ;
											 FOR    GRUPO    = "7";
												AND SUBGRUPO = " 77";
												AND CLASSE   = "299"
*-----> PARA REFOMA DE PNEUS
REPLACE ALL CLASSIFICA WITH "6404008013"+CHRTRAN(SEQUENCIA," ","0") ;
											 FOR    GRUPO    = "3";
												AND SUBGRUPO = "149";
												AND CLASSE   = " 13"
REPLACE ALL CLASSIFICA WITH "6404008014"+CHRTRAN(SEQUENCIA," ","0") ;
											 FOR    GRUPO    = "3";
												AND SUBGRUPO = "149";
												AND CLASSE   = " 14"
REPLACE ALL CLASSIFICA WITH "6404008013"+CHRTRAN(SEQUENCIA," ","0") ;
											 FOR    GRUPO    = "3";
												AND SUBGRUPO = "199";
												AND CLASSE   = " 13"
REPLACE ALL CLASSIFICA WITH "6404008014"+CHRTRAN(SEQUENCIA," ","0") ;
											 FOR    GRUPO    = "3";
												AND SUBGRUPO = "199";
												AND CLASSE   = " 14"
REPLACE ALL CLASSIFICA WITH "6408004016"+CHRTRAN(SEQUENCIA," ","0") ;
											 FOR    GRUPO    = "3";
												AND SUBGRUPO = "249";
												AND CLASSE   = " 16"
REPLACE ALL CLASSIFICA WITH "6408008016"+CHRTRAN(SEQUENCIA," ","0") ;
											 FOR    GRUPO    = "3";
												AND SUBGRUPO = "299";
												AND CLASSE   = " 16"
REPLACE ALL CLASSIFICA WITH "6408008017"+CHRTRAN(SEQUENCIA," ","0") ;
											 FOR    GRUPO    = "3";
												AND SUBGRUPO = "299";
												AND CLASSE   = " 17"
REPLACE ALL CLASSIFICA WITH "6416004020"+CHRTRAN(SEQUENCIA," ","0") ;
											 FOR    GRUPO    = "3";
												AND SUBGRUPO = "449";
												AND CLASSE   = " 20"
REPLACE ALL CLASSIFICA WITH "6416004022"+CHRTRAN(SEQUENCIA," ","0") ;
											 FOR    GRUPO    = "3";
												AND SUBGRUPO = "449";
												AND CLASSE   = " 22"
REPLACE ALL CLASSIFICA WITH "6416008020"+CHRTRAN(SEQUENCIA," ","0") ;
											 FOR    GRUPO    = "3";
												AND SUBGRUPO = "549";
												AND CLASSE   = " 20"
REPLACE ALL CLASSIFICA WITH "6416008022"+CHRTRAN(SEQUENCIA," ","0") ;
											 FOR    GRUPO    = "3";
												AND SUBGRUPO = "549";
												AND CLASSE   = " 22"
REPLACE ALL CLASSIFICA WITH "6416008023"+CHRTRAN(SEQUENCIA," ","0") ;
											 FOR    GRUPO    = "3";
												AND SUBGRUPO = "559";
												AND CLASSE   = " 22"
REPLACE ALL CLASSIFICA WITH "6420020016"+CHRTRAN(SEQUENCIA," ","0") ;
											 FOR    GRUPO    = "3";
												AND SUBGRUPO = "649";
												AND CLASSE   = " 16"
REPLACE ALL CLASSIFICA WITH "6420020018"+CHRTRAN(SEQUENCIA," ","0") ;
											 FOR    GRUPO    = "3";
												AND SUBGRUPO = "649";
												AND CLASSE   = " 18"
REPLACE ALL CLASSIFICA WITH "6420024024"+CHRTRAN(SEQUENCIA," ","0") ;
											 FOR    GRUPO    = "3";
												AND SUBGRUPO = "699";
												AND CLASSE   = " 24"
REPLACE ALL CLASSIFICA WITH "6420024026"+CHRTRAN(SEQUENCIA," ","0") ;
											 FOR    GRUPO    = "3";
												AND SUBGRUPO = "699";
												AND CLASSE   = " 26"
REPLACE ALL CLASSIFICA WITH "6420024028"+CHRTRAN(SEQUENCIA," ","0") ;
											 FOR    GRUPO    = "3";
												AND SUBGRUPO = "699";
												AND CLASSE   = " 28"
REPLACE ALL CLASSIFICA WITH "6420024030"+CHRTRAN(SEQUENCIA," ","0") ;
											 FOR    GRUPO    = "3";
												AND SUBGRUPO = "699";
												AND CLASSE   = " 30"
REPLACE ALL CLASSIFICA WITH "6420024034"+CHRTRAN(SEQUENCIA," ","0") ;
											 FOR    GRUPO    = "3";
												AND SUBGRUPO = "699";
												AND CLASSE   = " 34"
REPLACE ALL CLASSIFICA WITH "6424036024"+CHRTRAN(SEQUENCIA," ","0") ;
											 FOR    GRUPO    = "3";
												AND SUBGRUPO = "749";
												AND CLASSE   = " 24"
REPLACE ALL CLASSIFICA WITH "6424036025"+CHRTRAN(SEQUENCIA," ","0") ;
											 FOR    GRUPO    = "3";
												AND SUBGRUPO = "749";
												AND CLASSE   = " 25"
*------->> PARA SERVICOS
REPLACE ALL CLASSIFICA WITH "6004004"+CHRTRAN(SEQUENCIA," ","0") ;
											 FOR    GRUPO    = "9";
												AND SUBGRUPO = " 91";
												AND CLASSE   = " 99"
REPLACE ALL CLASSIFICA WITH "6008008"+CHRTRAN(SEQUENCIA," ","0") ;
											 FOR    GRUPO    = "9";
												AND SUBGRUPO = " 92";
												AND CLASSE   = " 99"
REPLACE ALL CLASSIFICA WITH "6008012"+CHRTRAN(SEQUENCIA," ","0") ;
											 FOR    GRUPO    = "9";
												AND SUBGRUPO = " 92";
												AND CLASSE   = "199"
REPLACE ALL CLASSIFICA WITH "6012016"+CHRTRAN(SEQUENCIA," ","0") ;
											 FOR    GRUPO    = "9";
												AND SUBGRUPO = " 93";
												AND CLASSE   = " 99"
REPLACE ALL CLASSIFICA WITH "6012020"+CHRTRAN(SEQUENCIA," ","0") ;
											 FOR    GRUPO    = "9";
												AND SUBGRUPO = " 93";
												AND CLASSE   = "199"
REPLACE ALL CLASSIFICA WITH "6012024"+CHRTRAN(SEQUENCIA," ","0") ;
											 FOR    GRUPO    = "9";
												AND SUBGRUPO = " 93";
												AND CLASSE   = "299"
REPLACE ALL CLASSIFICA WITH "6012028"+CHRTRAN(SEQUENCIA," ","0") ;
											 FOR    GRUPO    = "9";
												AND SUBGRUPO = " 93";
												AND CLASSE   = "399"
REPLACE ALL CLASSIFICA WITH "6012032"+CHRTRAN(SEQUENCIA," ","0") ;
											 FOR    GRUPO    = "9";
												AND SUBGRUPO = " 93";
												AND CLASSE   = "499"
REPLACE ALL CLASSIFICA WITH "6012036"+CHRTRAN(SEQUENCIA," ","0") ;
											 FOR    GRUPO    = "9";
												AND SUBGRUPO = " 93";
												AND CLASSE   = "599"
REPLACE ALL CLASSIFICA WITH "6012040"+CHRTRAN(SEQUENCIA," ","0") ;
											 FOR    GRUPO    = "9";
												AND SUBGRUPO = " 93";
												AND CLASSE   = "699"
REPLACE ALL CLASSIFICA WITH "6012044"+CHRTRAN(SEQUENCIA," ","0") ;
											 FOR    GRUPO    = "9";
												AND SUBGRUPO = " 93";
												AND CLASSE   = "799"
REPLACE ALL CLASSIFICA WITH "6012048"+CHRTRAN(SEQUENCIA," ","0") ;
											 FOR    GRUPO    = "9";
												AND SUBGRUPO = " 93";
												AND CLASSE   = "999"
REPLACE ALL CLASSIFICA WITH "6016052"+CHRTRAN(SEQUENCIA," ","0") ;
											 FOR    GRUPO    = "9";
												AND SUBGRUPO = " 94";
												AND CLASSE   = " 99"
**----> PARA AMORTECEDORES
REPLACE ALL CLASSIFICA WITH "2004004"+CHRTRAN(SEQUENCIA," ","0") ;
											 FOR    GRUPO    = "4";
												AND SUBGRUPO = " 44";
												AND CLASSE   = " 49"
REPLACE ALL CLASSIFICA WITH "2004008"+CHRTRAN(SEQUENCIA," ","0") ;
											 FOR    GRUPO    = "4";
												AND SUBGRUPO = " 44";
												AND CLASSE   = " 99"
REPLACE ALL CLASSIFICA WITH "2008004"+CHRTRAN(SEQUENCIA," ","0") ;
											 FOR    GRUPO    = "4";
												AND SUBGRUPO = " 44";
												AND CLASSE   = "149"
REPLACE ALL CLASSIFICA WITH "2008008"+CHRTRAN(SEQUENCIA," ","0") ;
											 FOR    GRUPO    = "4";
												AND SUBGRUPO = " 44";
												AND CLASSE   = "199"
REPLACE ALL CLASSIFICA WITH "2016012"+CHRTRAN(SEQUENCIA," ","0") ;
											 FOR    GRUPO    = "4";
												AND SUBGRUPO = " 44";
												AND CLASSE   = "299"
REPLACE ALL CLASSIFICA WITH "2020016"+CHRTRAN(SEQUENCIA," ","0") ;
											 FOR    GRUPO    = "4";
												AND SUBGRUPO = " 44";
												AND CLASSE   = "399"
REPLACE ALL CLASSIFICA WITH "2004020"+CHRTRAN(SEQUENCIA," ","0") ;
											 FOR    GRUPO    = "4";
												AND SUBGRUPO = " 44";
												AND CLASSE   = "549"
REPLACE ALL CLASSIFICA WITH "2004024"+CHRTRAN(SEQUENCIA," ","0") ;
											 FOR    GRUPO    = "4";
												AND SUBGRUPO = " 44";
												AND CLASSE   = "649"
REPLACE ALL CLASSIFICA WITH "2012024"+CHRTRAN(SEQUENCIA," ","0") ;
											 FOR    GRUPO    = "4";
												AND SUBGRUPO = " 44";
												AND CLASSE   = "699"
REPLACE ALL CLASSIFICA WITH "2008024"+CHRTRAN(SEQUENCIA," ","0") ;
											 FOR    GRUPO    = "4";
												AND SUBGRUPO = " 44";
												AND CLASSE   = "749"
REPLACE ALL CLASSIFICA WITH "2004028"+CHRTRAN(SEQUENCIA," ","0") ;
											 FOR    GRUPO    = "4";
												AND SUBGRUPO = " 44";
												AND CLASSE   = "849"

******-----> CLASSIFICACAO FISCAL DA MERCADORIA

REPLACE ALL TP_MERCAD WITH 1 FOR LEFT(CLASSIFICA,2) $ "16/20/24/28/32/36/40/"
REPLACE ALL TP_MERCAD WITH 2 FOR LEFT(CLASSIFICA,2) $ "04/08/12"
REPLACE ALL TP_MERCAD WITH 4 FOR LEFT(CLASSIFICA,2) $ "56"
REPLACE ALL TP_MERCAD WITH 7 FOR LEFT(CLASSIFICA,2) $ "60"
REPLACE ALL TP_MERCAD WITH 3 FOR LEFT(CLASSIFICA,4) $ "3604/3608/3612"
