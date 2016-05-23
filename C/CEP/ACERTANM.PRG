close all
SELECT 0
USE X:\FPD26\CEP\CEP_MUNI.DBF alias cep
SET ORDER TO TAG MUNI_CEP OF X:\FPD26\CEP\CEP_MUNI.CDX


SELECT 0
use X:\FPD26\CEP\cep_enc3 alia enc

set relation to cep into cep
brows fields enc.cep,cep.muni_cep,enc.cidade,enc.cidade_ok 
*replace all enc.cidade_ok with cep.municipio for !empty(cep.muni_cep)
*replace all enc.uf_ok with cep.uf for !empty(cep.muni_cep)

brows fields enc.cep,cep.muni_cep,enc.cidade,enc.cidade_ok for empty(cep.muni_cep)
