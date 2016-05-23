SET EXCL OFF
set date german
use q:\scgc\CENTRAL\itemmov
SET ORDER TO TAG NOTA
set near on
seek STR(2,3)+"S"+STR(79669,7)
brows fields CFO,empresa,nota,bsbr_icms,base_calc,vlr_icms,cst,base_isent,base_outr,a=bsbr_icms-base_calc,VLRVENDA
