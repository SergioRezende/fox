LFnatureza 	= NetArq("tab001") 
LFclientes 	= NetArq("clientes") 
LFduplicat	= NetArq("duplicat") 
IF (LFnatureza+LFClientes+LFduplicat) > 100000 && HOUVE FALHA DE ABERTURA
		=UP_fecha("TAB001" ,LFnatureza)
		=UP_fecha("clientes" ,LFclientes)
		=UP_fecha("duplicat" ,LFduplicat)
		RETURN(.F.)
ENDIF
	

M_DATA=DATE()
M_FIL=1

@ 08,10 SAY 'Filial..........:' GET M_FIL
@ 10,10 SAY 'Limite de Data..:' GET M_DATA
read
set talk on

select DISTINCT dupli.empresa, cli.cliente, cli.nome, cli.credito, nat.descricao; 
    from clientes cli, ;
         TAB001   nat, ;
         Duplicat dupli;
    where DUPLI.DT_EMI > M_DATA ;
          AND dupli.EMPRESA = M_FIL ;
          AND NAT.TABELA='NTZ' ;
          AND VAL(NAT.CODIGO)=CLI.NATUREZA;
          AND DUPLI.CLIENTE=CLI.CLIENTE;
    order by 5,3;
    into table ListCli
        
    set talk off
    use listcli


	=W_DEFPROC("rotinas.spr")
	PRIVATE LFinterrompe			&& Interrupcao de processos
	DO RELINIC.PRG          && INICIA VAR P/ TERMOMETRO

	GO TOP
	LNregistro 	= RECNO()
    COUNT TO LNimpressao 
    IF LNimpressao > 0
		LNimpressos = 0
		GO LNregistro
		*------------------------------------------------------------*
		*   (COMPLETADO PREPARACAO DO CONTROLE DE STATUS IMPRESSAO)
		*------------------------------------------------------------*
		LFsegue  	= .T.
		wp_arqname 	= ""
	    LSrel 		= "cliallfi"
		*------------------------------------------------------------*
		LSfiltro  = ""
		LSorienta = ""
		LSorienta 	= " For LFsegue "

		DO UPimpressao     

	    SET PRINTER TO SET('PRINTER',1)
		SET RELATION TO 
		SET POINT TO 
		SET SEPARATOR  TO 

	*report form cliallfi.frx to file .\teste.rel
	*SET SAFE ON
	*modif comm .\teste.rel
	
ENDIF

	*------------------------------------------------------------*
	DO RELFIM.PRG          && FIM VAR P/ TERMOMETRO
	*------------------------------------------------------------*
=UP_fecha("TAB001" ,LFnatureza)
=UP_fecha("clientes" ,LFclientes)
=UP_fecha("duplicat"  ,LFduplicat)
