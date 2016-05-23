RETURN

*----------------------------------------------------------------*
* objetivo : verifica mensagem de erro para funcao NetUse()      *
*----------------------------------------------------------------*
PROCEDURE  NetErr
   nErro = Error()
   IF nErro = 3  AND !LFmodo 
		return
 		* nao se carac. erro pois nao solicitou exclusividade	
		*    cMsgm = "Arquivo "+cArq+".dbf  esta em Uso"
   ENDIF
   do case
      case nErro = 3
		   cMsgm = "Arquivo "+cArq+".dbf  esta em Uso"
      case nErro = 6
           cMsgm = "Muitos Arquivos Abertos"
      case nErro = 15
           cMsgm = cArq+".dbf  Nao e um Arquivo DBF"
      case nErro = 19
           cMsgm = "Arquivo de Indice  "+cArq+".cdx Imperfeito"
      case nErro = 23
           cMsgm = "Expressao do Indice muito longa"
      case nErro = 24
           cMsgm = "Alias sendo utilizado por outro arquivo"
      case nErro = 26
           cMsgm = "Arquivo "+cArq+".dbf  nao Ordenado"
      case nErro = 43
           cMsgm = "Memoria Insuficiente"
      case nErro = 91
           cMsgm = "Arquivo "+cArq+".dbf  nao Carregado"
      case nErro = 108
           cMsgm = "Arquivo "+cArq+".dbf  esta em uso por outro usuario"
      case nErro = 114
           cMsgm = "Recrie o Indice "+cArq+".CDX"
      case nErro = 1012
           cMsgm = "Erro de Memoria do SO"
      case nErro = 1101
           cMsgm = "Nao consigo abrir arquivo "+cArq+".dbf "
      case nErro = 1111
           cMsgm = "Descritor de arquivo invalido p/"+cArq+".dbf "
      case nErro = 1117
           cMsgm = "Chave p/"+cArq+".dbf  com comprimento errado"
      case nErro = 1124
           cMsgm = "Chave muito longa p/"+cArq+".dbf "
      case nErro = 1462
           cMsgm = "Erro de consistencia interna no arquivo "+cArq+".dbf "
      case nErro = 1683
           cMsgm = "Marca (Tag) de indice nao encontrada em  "+cArq+".cdx"
      case nErro = 1684
           cMsgm = ;
      		"Marca (Tag) de indice deve ser especificada p/ "+cArq+".cdx"
      case nErro = 1705
           cMsgm = "Acesso ao arquivo "+cArq+".dbf  negado"
      case nErro = 1708
           cMsgm = ;
           		"Arquivo "+cArq+".dbf  esta aberto em outra area de trabalho"
      case nErro = 1718
           cMsgm = "Arquivo "+cArq+".dbf  aberto somente para leitura"
      case nErro = 1721
           cMsgm = "Todas areas de trabalho em uso"
      OtherWise
           cMsgm = "Erro indefinido " + STR(nErro,4)
   EndCase
   store .f. to LFOpen
   wait cMsgm + " <Enter> " window
return

