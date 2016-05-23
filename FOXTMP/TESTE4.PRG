SET DATE GERMAN
SET CENTU ON

LDDT_INI = {01.07.2002}
LDDT_FIM = {31.07.2002}

SELECT SUM(nfs.TOTAL_NOTA);
   FROM Q:\SCGC\CENTRAL\NOTA NFS;
   WHERE     NFS.ch_opera = "1" ;
         AND NFS.operacao = "S" ;
         AND NFS.ch_produ <> "2";
         AND !(NFS.tipo $ "CPM/ENT") ;
         AND  NFS.status <> 2  ;
		 AND NFS.DATA >= LDdt_ini ;
		 AND NFS.DATA <= LDdt_fim
