/*********************************************************************************
***
*** app/ap0817rp.i - Retorna-Tabela-Simula‡Æo
***
*********************************************************************************/
def var c-ini-refer      as character format "x(3)" no-undo.
def var c-fim-refer      as character format "x(3)" init "zzz" no-undo.
def var c-ini-espec      as character format "x(3)" no-undo.
def var c-fim-espec      as character format "x(3)" init "zzz" no-undo.
def var c-ini-estab-aux  as char      format "x(3)" init ""    no-undo. 
def var c-fim-estab-aux  as char      format "x(3)" init "zzz" no-undo.

{app/ap8100.i3 "no"
               "if avail param-fasb and param-fasb.moeda-fasb <> 0 then no else yes"
               "if avail param-fasb and param-fasb.moeda-cmi  <> 0 then no else yes"
               "no"
               "c-ini-estab-aux"
               "c-fim-estab-aux"
               "c-ini-refer"
               "c-fim-refer"
               "c-ini-espec"
               "c-fim-espec"               
               "tt-param.dt-ini-period"
               "tt-param.dt-fim-period"
               "i3"
               "app/ap0817rp.p"
               "0"
               "0"}
/* Fim de Include */
