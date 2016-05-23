PROCEDURE UAatrmotivos
STORE SPACE(15)   TO VTLmotivo
DO CASE
	CASE m.natu_oper = 1
		VTLmotivo(1) = "Normal         "
		VTLmotivo(2) = "Reclamada      "
		VTLmotivo(3) = "Complemento    "
		VTLmotivo(4) = "Entrega Futura "
		VTLmotivo(5) = "Imobilizado    "
		VTLmotivo(6) = "Carcacas       "
		VTLmotivo(7) = "Sucatas        "
		VTLmotivo(8) = "Outras         "
	CASE m.natu_oper = 2
		VTLmotivo(1) = "Mercadoria Comercial  "
		VTLmotivo(2) = "Bens Imobilizados     "
		VTLmotivo(3) = "Mat. de Uso em Servico"
		VTLmotivo(4) = "Material de Consumo   "
		VTLmotivo(5) = "Outros                "
		VTLmotivo(6) = "                      "
		VTLmotivo(7) = "                      "
		VTLmotivo(8) = "                      "
	CASE m.natu_oper = 3
		VTLmotivo(1) = "Consignacao    "
		VTLmotivo(2) = "Demonstracao   "
		VTLmotivo(3) = "Reclamacao     "
		VTLmotivo(4) = "Entrega Futura "
		VTLmotivo(5) = "Conserto       "
		VTLmotivo(6) = "Outras         "
		VTLmotivo(7) = "               "
		VTLmotivo(8) = "               "
	CASE m.natu_oper = 4
		VTLmotivo(1) = "Mercadoria Comercial   "
		VTLmotivo(2) = "Remessa em Consignacao "
		VTLmotivo(3) = "Remessa em Demonstracao"
		VTLmotivo(4) = "Mat. Uso Servico       "
		VTLmotivo(5) = "Mat. Consumo           "
		VTLmotivo(6) = "Compra de Imobilizado  "
		VTLmotivo(7) = "ICMS p/ Reembolso      "
		VTLmotivo(8) = "Outros                 "
	CASE m.natu_oper = 5
		VTLmotivo(1) = "Mercadoria Danificada  "
		VTLmotivo(2) = "Reserva P/Fat.Futuro   "
		VTLmotivo(3) = "                       "
		VTLmotivo(4) = "                       "
		VTLmotivo(5) = "                       "
		VTLmotivo(6) = "                       "
		VTLmotivo(7) = "                       "
		VTLmotivo(8) = "                       "
ENDCASE
RETURN

