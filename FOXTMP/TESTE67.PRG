SET EXCL OFF
SET TALK ON
SET ESCAPE ON

set date german
SET CENTU ON

use q:\scgc\LOJA\notaite
SET ORDER TO TAG DATA OF Q:\SCGC\LOJA\NOTAITE.CDX
seek STR(10,3)+DTOS({01.01.2005})
replace codforn with 907 ;
     for empresa=10 and tipo = "RAE" ;
         AND DATA > {01.01.2005} ;
         AND CODFORN = 999 ;
         AND RLOCK() ;
     WHILE EMPRESA = 10

USE Q:\SCGC\LOJA\notaent
SET ORDER TO TAG RLDTENTR OF Q:\SCGC\LOJA\NOTAENT.CDX
seek STR(10,3)+DTOS({01.01.2005})
replace codforn with 907 ;
     for empresa=10 and tipo = "RAE" ;
         AND DATA > {01.01.2005} ;
         AND CODFORN = 999 ;
         AND RLOCK() ;
     WHILE EMPRESA = 10



set date german
SET CENTU ON

use q:\scgc\LOJA\nota
SET ORDER TO TAG DATA OF Q:\SCGC\LOJA\NOTA.CDX
seek STR(10,3)+DTOS({01.01.2005})
replace ch_produ with "1" ;
     for empresa=10 and tipo $ "VLP/VFW" ;
         AND DATA > {01.01.2005} ;
         AND RLOCK() ;
     WHILE EMPRESA = 10

USE Q:\SCGC\LOJA\itemmov
SET ORDER TO TAG DT_MOV OF Q:\SCGC\LOJA\ITEMMOV.CDX
seek STR(10,3)+DTOS({01.01.2005})
replace ch_produ with "1" ;
     for empresa=10 and tipo $ "VLP/VFW" ;
         AND DATA > {01.01.2005} ;
         AND RLOCK() ;
     WHILE EMPRESA = 10
