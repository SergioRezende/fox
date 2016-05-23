set date german
SET CENTU ON

use q:\scgc\central\nota
SET ORDER TO TAG DATA OF Q:\SCGC\CENTRAL\NOTA.CDX
seek STR(10,3)+DTOS({01.01.2005})
replace ch_produ with "1" ;
     for empresa=10 and tipo $ "VLP/VFW" ;
         AND DATA > {01.01.2005} ;
         AND RLOCK() ;
     WHILE EMPRESA = 10

USE Q:\SCGC\central\itemmov
SET ORDER TO TAG DT_MOV OF Q:\SCGC\CENTRAL\ITEMMOV.CDX
seek STR(10,3)+DTOS({01.01.2005})
replace ch_produ with "1" ;
     for empresa=10 and tipo $ "VLP/VFW" ;
         AND DATA > {01.01.2005} ;
         AND RLOCK() ;
     WHILE EMPRESA = 10
