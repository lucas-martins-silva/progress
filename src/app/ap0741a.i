/******************************************************************************
***                         
*** app/ap0741a.i - Executa Programa Miniflexibiliza‡Æo CMCAC - AP.
***                     
******************************************************************************/

def var l-cmcac as logical initial no no-undo.

&IF DEFINED(BF_FIN_ABERT_CMCAC_AP) &THEN
    assign l-cmcac = yes.
&ELSE
    if can-find(first funcao where 
                      funcao.cd-funcao = "spp-abt_cmcac_ap" and
                      funcao.ativo     = yes) then
       assign l-cmcac = yes.
&ENDIF
