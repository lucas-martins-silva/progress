/**********************************************************************************
**
**   Arquivo....: BC0206.I
**
**   Finalidade.: Definiá∆o da Temp-Table de parÉmetros para impress∆o do LayOut
**                etiquetas.
**
**   Vers∆o.....: 01.00.00 - Criaá∆o - Luciano
**
**   Observaá∆o.: 
**
**********************************************************************************/

define temp-table tt-param
    field ep-codigo         like empresa.ep-codigo
    field destino           as inte
    field usuario           as char
    field arquivo           as char
    field data-exec         as date
    field hora-exec         as integer
    field transacao-ini     like bc-trans.cd-trans
    field transacao-fim     like bc-trans.cd-trans
    field nr-trans-ini      as decimal
    field nr-trans-fim      as decimal
    field da-ini            as date
    field da-fim            as date
    field hr-ini            as char
    field hr-fim            as char
    field est-nova          as logical
    field est-atualizada    as logical
    field est-erro          as logical
    field est-processo      as logical
    field est-cancelado     as logical
    field imp-erros         as logical.
