  ^   !                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                              .t.                            cfo                            !empresa.sigla+" - " +empresa.nome                               "UNIDADE :"                    	"FOLHA :"                      "VALOR "                       
"CONTABIL"                     "OUTRAS"                       
cfo_contab                     "99,999,999.99"                J                              cfo                            
cfo_bsicms                     "99,999,999.99"                J                              cfo_icms                       "99,999,999.99"                J                              
cfo_bsisen                     "99,999,999.99"                J                              
cfo_bsoutr                     "99,999,999.99"                J                              
cfo_bssubs                     "99,999,999.99"                J                              
cfo_icmsub                     "99,999,999.99"                J                              
tot_contab                     "99,999,999.99"                J                              
tot_bsicms                     "99,999,999.99"                J                              tot_icms                       "99,999,999.99"                J                              
tot_bsisen                     "99,999,999.99"                J                              
tot_bsoutr                     "99,999,999.99"                J                              
tot_bssubs                     "99,999,999.99"                J                              
tot_icmsub                     "99,999,999.99"                J                              "BASE-CALCULO"                 	"ISENTAS"                      "BASE RETIDO"                  "RETIDO"                       	UPtermo()                      chr(15)                        chr(18)+chr(20)                e"R E S U M O    D E   R E G I S T R O S   P O R   C O D I G O   D E   O P E R A C A O - S A I D A S "                             AIIF(_pageno+LNpagina < 500, _pageno+LNpagina, _pageno+LNpagina+2)                                "9999"                         J                              "de"                           	LDper_ini                      "a"                            	LDper_fim                      	"MES/ANO"                      >ALLTRIM(wp_meses(month(LDper_ini)))+"/"+STR(YEAR(LDper_ini),4)                                   "IMP-DEBITADO"                 	"TOTAL  "                      "CFOP"                         "-*"                           "*-OPER COM DEB. DO IMPOSTO"                                    	cfo_bsipi                      "99,999,999.99"                J                              cfo_ipi                        "99,999,999.99"                J                              	tot_bsIPI                      "99,999,999.99"                J                              tot_IPI                        "99,999,999.99"                J                              8"*---------- OPERACOES SEM DEBITO  DO IMPOSTO --------*"        "*--- IPI - VALORES  ------*"                                   �"------------------------------------------------------------------------------------------------------------------------------------"                             �"------------------------------------------------------------------------------------------------------------------------------------"                             
"BASE IPI"                     "IPI"                          
CFO_CONTAB                     
total_nota                     0                              
CFO_BSICMS                     	base_icms                      0                              CFO_ICMS                       VLR_ICMS                       0                              
CFO_BSISEN                     
base_isent                     0                              
CFO_BSOUTR                     base_outr + base_iss           0                              
CFO_BSSUBS                     	base_subs                      0                              
CFO_ICMSUB                     	icms_subs                      0                              	CFO_BSIPI                      base_ipi                       0                              CFO_IPI                        VLR_IPI                        0                              
TOT_CONTAB                     
total_nota                     0                              
TOT_BSICMS                     	base_icms                      0                              TOT_ICMS                       VLR_ICMS                       0                              
TOT_BSISEN                     
base_isent                     0                              
TOT_BSOUTR                     base_outr+base_iss             0                              
TOT_BSSUBS                     	base_subs                      0                              
TOT_ICMSUB                     	icms_subs                      0                              	TOT_BSIPI                      BASE_IPI                       0                              TOT_IPI                        VLR_IPI                        0                              PAGINA                         1                              lnpagina                       .t.                            cfo                            !empresa.sigla+" - " +empresa.nome                               "UNIDADE :"                    	"FOLHA :"                      "VALOR "                       
"CONTABIL"                     "OUTRAS"                       
cfo_contab                     J                              "99,999,999.99"                cfo                            
cfo_bsicms                     J                              "99,999,999.99"                cfo_icms                       J                              "99,999,999.99"                
cfo_bsisen                     J                              "99,999,999.99"                
cfo_bsoutr                     J                              "99,999,999.99"                
cfo_bssubs                     J                              "99,999,999.99"                
cfo_icmsub                     J                              "99,999,999.99"                
tot_contab                     J                              "99,999,999.99"                
tot_bsicms                     J                              "99,999,999.99"                tot_icms                       J                              "99,999,999.99"                
tot_bsisen                     J                              "99,999,999.99"                
tot_bsoutr                     J                              "99,999,999.99"                
tot_bssubs                     J                              "99,999,999.99"                
tot_icmsub                     J                              "99,999,999.99"                "BASE-CALCULO"                 	"ISENTAS"                      "BASE RETIDO"                  "RETIDO"                       	UPtermo()                      chr(15)                        chr(18)+chr(20)                e"R E S U M O    D E   R E G I S T R O S   P O R   C O D I G O   D E   O P E R A C A O - S A I D A S "                             AIIF(_pageno+LNpagina < 500, _pageno+LNpagina, _pageno+LNpagina+2)                                J                              "9999"                         "de"                           	LDper_ini                      "a"                            	LDper_fim                      	"MES/ANO"                      >ALLTRIM(wp_meses(month(LDper_ini)))+"/"+STR(YEAR(LDper_ini),4)                                   "IMP-DEBITADO"                 	"TOTAL  "                      "CFOP"                         "-*"                           "*-OPER COM DEB. DO IMPOSTO"                                    	cfo_bsipi                      J                              "99,999,999.99"                cfo_ipi                        J                              "99,999,999.99"                	tot_bsIPI                      J                              "99,999,999.99"                tot_IPI                        J                              "99,999,999.99"                8"*---------- OPERACOES SEM DEBITO  DO IMPOSTO --------*"        "*--- IPI - VALORES  ------*"                                   �"------------------------------------------------------------------------------------------------------------------------------------"                             �"------------------------------------------------------------------------------------------------------------------------------------"                             
"BASE IPI"                     "IPI"                          
CFO_CONTAB                     
total_nota                     0                              
CFO_BSICMS                     	base_icms                      0                              CFO_ICMS                       VLR_ICMS                       0                              
CFO_BSISEN                     
base_isent                     0                              
CFO_BSOUTR                     base_outr + base_iss           0                              
CFO_BSSUBS                     	base_subs                      0                              
CFO_ICMSUB                     	icms_subs                      0                              	CFO_BSIPI                      base_ipi                       0                              CFO_IPI                        VLR_IPI                        0                              
TOT_CONTAB                     
total_nota                     0                              
TOT_BSICMS                     	base_icms                      0                              TOT_ICMS                       VLR_ICMS                       0                              
TOT_BSISEN                     
base_isent                     0                              
TOT_BSOUTR                     base_outr+base_iss             0                              
TOT_BSSUBS                     	base_subs                      0                              
TOT_ICMSUB                     	icms_subs                      0                              	TOT_BSIPI                      BASE_IPI                       0                              TOT_IPI                        VLR_IPI                        0                              PAGINA                         1                              lnpagina