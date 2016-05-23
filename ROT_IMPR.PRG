
FUNCTION UPextenso
	PARAMETER LNvalor
		wp_ext1 = "hgsdhjgsdfhgsfldhgfhfsdhfjhafkhgfk"
		wp_ext2 = "jhljkghjsdhjkljkdlsk"
RETURN (LNvalor)

FUNCTION UPstatchq    && para programa SCGC301 (altera status chqpag)
*** STATUS => CHQPAG
	=REGLOCK()
	REPLACE status WITH "NI"
RETURN (" ")