	SET DELE ON
	SET DATE GERMAN
	SET CENTU ON

	=U_SLD()
RETURN

FUNCTION U_SLD

	select ;
	 sld.empresa,;
	 sld.codigo,;
	 MAX(;
	      IIF(sld.sld_atu = 0, ;
	         sld.vlr_atu, ;
	         sld.vlr_atu/sld.sld_atu;
	         );
	     ) as custo_med ;
	FROM ;
	     Q:\SCGC\COMUM\GRUPO GR,;
	         Q:\SCGC\CENTRAL\SALDO SLD;
	    WHERE ;
	        	gr.cdg_tipo = 4;
	     	AND SLD.CODIGO = GR.CODIGO ;
	        AND (gr.tp_control = 1 or gr.tp_control = 4);
	        AND (;
	                 SLD.EMPRESA = 1 ;
	             OR  SLD.EMPRESA = 5 ;
	             OR  SLD.EMPRESA = 7 ;
	             OR  SLD.EMPRESA = 9 ;
    	         OR  SLD.EMPRESA = 11 ;
	             OR  SLD.EMPRESA = 14 ;
	            );
	GROUP BY ;
	 sld.empresa,;
	 sld.codigo ;
	ORDER BY  ;
	 sld.empresa,;
	 sld.codigo;
	into table x:\tmp\CST1
	
	select ;
	 sld.empresa,;
	 sld.codigo,;
	 MAX(;
	      IIF(sld.sld_atu = 0, ;
	         sld.vlr_atu, ;
	         sld.vlr_atu/sld.sld_atu;
	         );
	     ) as custo_med ;
	FROM ;
	     Q:\SCGC\COMUM\GRUPO GR,;
	         O:\SCGC2013\CENTRAL\SALDO SLD;
	    WHERE ;
	        	gr.cdg_tipo = 4;
	     	AND SLD.CODIGO = GR.CODIGO ;
	        AND (gr.tp_control = 1 or gr.tp_control = 4);
	        AND (;
	                 SLD.EMPRESA = 1 ;
	             OR  SLD.EMPRESA = 5 ;
	             OR  SLD.EMPRESA = 7 ;
	             OR  SLD.EMPRESA = 9 ;
    	         OR  SLD.EMPRESA = 11 ;
	             OR  SLD.EMPRESA = 14 ;
	            );
	GROUP BY ;
	 sld.empresa,;
	 sld.codigo ;
	ORDER BY  ;
	 sld.empresa,;
	 sld.codigo;
	into table x:\tmp\CST2




    SELECT ;
	 sld.empresa,;
	 sld.codigo,;
	 sld.CUSTO_MED ;
    FROM ;
     x:\tmp\CST1 SLD ;
    UNION ;
    SELECT ;
	 sld.empresa,;
	 sld.codigo, ;
	 sld.CUSTO_MED ;
    FROM ;
     x:\tmp\CST2 SLD ;
    INTO TABLE  x:\tmp\CST3    
    


    
    SELECT ;
	 sld.empresa,;
	 sld.codigo,;
	 MAX(custo_med) AS CUSTO_MED ;
    FROM ;
     x:\tmp\CST3 SLD   ;
	GROUP BY ;
	 sld.empresa,;
	 sld.codigo ;
	ORDER BY  ;
	 sld.empresa,;
	 sld.codigo;
    INTO TABLE  x:\tmp\custo
        
      




	
 
RETURN
 
