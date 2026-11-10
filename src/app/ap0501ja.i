/******************************************************************************************************
**
** AP0501JA.I - Valor m¡nimo
******************************************************************************************************/
    assign l-consis-vl-min = no.
    &IF DEFINED(BF_FIN_VL_MIN) &THEN
        assign l-consis-vl-min = yes.
    &ELSE
        if can-find(first funcao where 
                          funcao.cd-funcao = "spp-vl_min_imp" and
                          funcao.ativo     = yes) then
           assign l-consis-vl-min = yes.
    &ENDIF
/* fim da include */
