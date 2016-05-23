SET DELE ON
SET DATE GERMAN
SET CENTU ON


SELECT 0
use q:\scgc\central\duplicat
SET ORDER TO TAG DOC 


SELECT 0
use x:\scgc\cgb\duplicat alias cgb


set relation to STR(EMPRESA,3)+STR(DUPLICATA,9) into duplicat


brows fields A=cgb.vlr_pgto - duplicat.vlr_pgto
