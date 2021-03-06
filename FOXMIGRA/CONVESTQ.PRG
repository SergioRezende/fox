**  DEFINIR CAMPO TXT  COM TAMANHO 180


USE GRUPO
ZAP
APPEND FROM Q:\FPD26\BASE\LST\GRUPO.TXT FIELDS TXT TYPE SDF
APPEND FROM Q:\FPD26\BASE\LST\SUBGR.TXT FIELDS TXT TYPE SDF
APPEND FROM Q:\FPD26\BASE\LST\CLASSE.TXT FIELDS TXT TYPE SDF
APPEND FROM Q:\FPD26\BASE\LST\ESTOQUE.TXT FIELDS TXT TYPE SDF

DELETE ALL FOR SUBS(TXT,8,3) <> " | " AND SUBS(TXT,3,3) <> " | "
DELETE ALL FOR LEFT(TXT,4)    = "    "


PACK
******>> PREENCHIMENTO DOS CAMPOS

*-*-*-*-*-*-*--*-*-*-   CONVERCAO DOS ITENS

REPLACE ALL ;
   	CLASSIFICA  WITH SUBS(TXT,39,2)+SUBS(TXT,44,3)+SUBS(TXT,50,3)+;
				   SUBS(TXT,56,3)+SUBS(TXT,62,1) , ;
	CODIGO 		WITH SUBS(TXT,1,7), ;
	CDG_TIPO    WITH 4,; 
	DESCRICAO	WITH SUBS(TXT,11,25),;
	MARCA 		WITH INT(VAL(SUBS(TXT,62,1))),;
	UNIDADE     WITH SUBS(TXT,76,2),;
	PESO   		WITH INT(VAL(SUBS(TXT,102,6)))/1000,;
	ORIGEM      WITH INT(VAL(SUBS(TXT,149,1))),;
	TP_MERCAD	WITH INT(VAL(SUBS(TXT,153,1))) ;
     FOR SUBS(TXT,8,3) = " | "
REPLACE ALL ;
 	EMPRESAS	WITH "001/" FOR SUBS(TXT,119,1) = "S" ;
 			AND SUBS(TXT,8,3) = " | "
REPLACE ALL ;
 	EMPRESAS	WITH ALLTRIM(EMPRESAS)+"002/" FOR SUBS(TXT,120,1) = "S";
	 		AND SUBS(TXT,8,3) = " | "
REPLACE ALL ;
 	EMPRESAS	WITH ALLTRIM(EMPRESAS)+"003/" FOR SUBS(TXT,121,1) = "S" ;
		 	AND SUBS(TXT,8,3) = " | "
REPLACE ALL ;
 	EMPRESAS	WITH ALLTRIM(EMPRESAS)+"004/" FOR SUBS(TXT,122,1) = "S";
		 	AND SUBS(TXT,8,3) = " | "
REPLACE ALL ;
 	EMPRESAS	WITH ALLTRIM(EMPRESAS)+"005/" FOR SUBS(TXT,123,1) = "S"; 
		 	AND SUBS(TXT,8,3) = " | "
REPLACE ALL ;
 	EMPRESAS	WITH ALLTRIM(EMPRESAS)+"006/" FOR SUBS(TXT,124,1) = "S";
	 		AND SUBS(TXT,8,3) = " | "
REPLACE ALL ;
 	EMPRESAS	WITH ALLTRIM(EMPRESAS)+"007/" FOR SUBS(TXT,125,1) = "S";
 			AND SUBS(TXT,8,3) = " | "
REPLACE ALL ;
 	EMPRESAS	WITH ALLTRIM(EMPRESAS)+"008/" FOR SUBS(TXT,126,1) = "S";
		 	AND SUBS(TXT,8,3) = " | "
REPLACE ALL ;
 	EMPRESAS	WITH ALLTRIM(EMPRESAS)+"009/" FOR SUBS(TXT,127,1) = "S";
 			AND SUBS(TXT,8,3) = " | "
REPLACE ALL ;
 	EMPRESAS	WITH ALLTRIM(EMPRESAS)+"010/" FOR SUBS(TXT,128,1) = "S";
 			AND SUBS(TXT,8,3) = " | "

*-*-*-*-*-*-*--*-*-*-   CONVERCAO DOS GRUPOS
REPLACE ALL ;
   	CLASSIFICA  WITH SUBS(TXT,1,2), ;
	CDG_TIPO    WITH 1,; 
	DESCRICAO	WITH SUBS(TXT,6,35);
     FOR SUBS(TXT,3,3) = " | " AND ;
		 SUBS(TXT,9,3) <> " | " AND;
		 SUBS(TXT,15,3) <> " | " AND;
		 SUBS(TXT,8,3) <> " | " 
		 
*-*-*-*-*-*-*--*-*-*-   CONVERCAO DOS SUB-GRUPOS
REPLACE ALL ;
   	CLASSIFICA  WITH SUBS(TXT,1,2)+SUBS(TXT,6,3), ;
	CDG_TIPO    WITH 2,; 
	DESCRICAO	WITH SUBS(TXT,12,25);
     FOR SUBS(TXT,3,3) = " | " AND ;
		 SUBS(TXT,9,3) = " | " AND;
		 SUBS(TXT,15,3) <> " | " AND;
		 SUBS(TXT,8,3) <> " | " 
*-*-*-*-*-*-*--*-*-*-   CONVERCAO DOS CLASSES
REPLACE ALL ;
   	CLASSIFICA  WITH SUBS(TXT,1,2)+SUBS(TXT,6,3)+SUBS(TXT,12,3), ;
	CDG_TIPO    WITH 3,; 
	DESCRICAO	WITH SUBS(TXT,17,30);
     FOR SUBS(TXT,3,3) = " | " AND ;
		 SUBS(TXT,9,3) = " | " AND;
		 SUBS(TXT,15,3) = " | " AND;
		 SUBS(TXT,8,3) <> " | " 
REPLACE ALL STATUS WITH 1

