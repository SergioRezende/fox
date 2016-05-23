	SELECT gr.codigo, ;
	     ULvlr(1,m.dt_ref, GR.CODIGO) AS EstGyn ;
	     FROM grupo gr ;
         where       wl_tmp $ gr.empresas  ;
				 AND gr.cdg_tipo = 4   ;
				 AND STR(gr.tp_control,1) $ LScontroles ;
				 AND GR.classifica <> m.clasfim
	SELECT gr.codigo ;
	     FROM grupo gr ;
         where       wl_tmp $ gr.empresas  ;
				 AND gr.cdg_tipo = 4   ;
				 AND STR(gr.tp_control,1) $ LScontroles ;
				 AND GR.classifica <> m.clasfim

