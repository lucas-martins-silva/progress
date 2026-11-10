/**********************************************************************************
**
**    Include ap0501.i
**    Data: 15/05/2000
**
**    Objetivo: Verificar se a provis∆o est† dispon°vel para este cliente ou
**              vers∆o.
**
***********************************************************************************/

def var l-provisao as logical initial no no-undo.

&IF DEFINED(BF_FIN_PROVISAO) &THEN
    assign l-provisao = yes.
&ELSE
    &IF DEFINED(BF_FIN_PROVISAO203) &THEN
        if  can-find(first funcao where
                           funcao.cd-funcao = "spp-provisao" and
                           funcao.ativo     = yes) then
            assign l-provisao = yes.
    &ENDIF.
&ENDIF.
