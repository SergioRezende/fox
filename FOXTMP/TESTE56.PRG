USE Q:\SCGC\loja\ITEMMOV
SET ORDER TO TAG MOVIMENTO OF Q:\SCGC\loja\ITEMMOV.CDX
GO TOP

set near on

seek STR(5,3)

SCATTER MEMVAR
SKIP

DO WHILE empresa = 5

   IF     itemmov.empresa = m.empresa ;
      and itemmov.codigo  = m.codigo ;
      and itemmov.data    = m.data ;
      and itemmov.hora    = m.hora ;
      and itemmov.tipo    = m.tipo ;
      and itemmov.nota    = m.nota ;
      and itemmov.ordem   = m.ordem
      =rlock()
      delete
   else
      SCATTER MEMVAR
   endif

   skip
ENDDO

