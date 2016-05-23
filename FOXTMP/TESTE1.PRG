USE Q:\SCGC\CENTRAL\ITEMMOV
SET ORDER TO TAG DT_MOV OF Q:\SCGC\CENTRAL\ITEMMOV.CDX

set near on
seek STR(8,3)+DTOS({01.02.2003})
set date german
set centu on
seek STR(8,3)+DTOS({27.02.2003})
do while empresa= 8
  replace base_isent with (vlrvenda+icms_subs+vlripi) - ;
                          (base_CALC+VLRIPI+base_outr+base_iss+icms_subs)
  skip
enddo
