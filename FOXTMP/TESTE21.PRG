LNemp = 1
LNorcamento = 100
LNvendedor = 200

set procedure to rotinas.spr
do upambientaliza
set procedure to orcament.spr
set step on
=ORadorcament(LNemp,LNorcamento)
LNkey = lastkey()

set step on
