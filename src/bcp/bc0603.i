/**********************************************************************************
**
**   Arquivo....: BC0603.i
**
**   Finalidade.: Definiá∆o da Temp-Table de parÉmetros para impress∆o do Relat¢rio
**                de Extens∆o Item Emitente.
**
**   Vers∆o.....: 01.00.00 - Criaá∆o - Vanessa
**
**   Observaá∆o.: 
**
**********************************************************************************/

define temp-table tt-param NO-UNDO
    field ep-codigo        like empresa.ep-codigo
    field destino          as inte
    field usuario          as char
    field arquivo          as char
    field data-exec        as date
    field hora-exec        as integer
    field item-ini         like bc-ext-item-emit.it-codigo
    field item-fim         like bc-ext-item-emit.it-codigo
    field nome-abrev-ini   like bc-ext-item-emit.nome-abrev
    field nome-abrev-fim   like bc-ext-item-emit.nome-abrev
    field i-classificacao  as integer.
