/**********************************************************************************
**
**  apapi008.i
**
**  Defini‡Æo das temp-tableïs.
**
***********************************************************************************/

def temp-table tt-saldo no-undo
   field i-ep-codigo      like tit-ap.ep-codigo
   field i-portador       like tit-ap.portador
   field i-modalidade     like tit-ap.modalidade
   field cod-versao-integ as int
   field c-esp-ini        like tit-ap.cod-esp
   field c-esp-fim        like tit-ap.cod-esp
   field da-data-ini      like tit-ap.dt-transacao
   field da-data-fim      like tit-ap.dt-transacao
   field da-ven-ini       like tit-ap.dt-vencimen
   field da-ven-fim       like tit-ap.dt-vencimen
   field de-tot-anterior  as dec format "->>>,>>>,>>>,>>9.99"
   field de-tot-aberto    as dec format "->>>,>>>,>>>,>>9.99"
   field l-aberto         as log
   field l-vid-rel        as log.
                 
/* apapi008.i */                 
