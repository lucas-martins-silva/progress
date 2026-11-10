/**********************************************************************************
***
***   BH0102AA.i - Defini‡Æo tt-chave-tit-ap
***
**********************************************************************************/

def temp-table tt-chave-tit-ap no-undo
    field ep-codigo   like hisadm.tit-ap.ep-codigo
    field cod-estabel like hisadm.tit-ap.cod-estabel
    field cod-fornec  like hisadm.tit-ap.cod-fornec  
    field cod-esp     like hisadm.tit-ap.cod-esp
    field serie       like hisadm.tit-ap.serie
    field nr-docto    like hisadm.tit-ap.nr-docto
    field parcela     like hisadm.tit-ap.parcela
    INDEX chave IS PRIMARY 
          ep-codigo
          cod-estabel
          cod-fornec
          cod-esp
          serie
          nr-docto
          parcela.
          
          
def temp-table tt-chave-transfere like tt-chave-tit-ap.
/*--- BH0102AA.I ---*/
