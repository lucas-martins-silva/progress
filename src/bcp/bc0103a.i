/**********************************************************************************
**
**   Arquivo....: BC0103a.I
**
**   Finalidade.: Definiá∆o da Temp-Table de parÉmetros para impress∆o do LayOut
**                etiquetas.
**
**   Vers∆o.....: 01.00.00 - Criaá∆o - Luciano
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
    field tp-etiq-ini      like tipo-etiqueta.tipo-etiq
    field tp-etiq-fim      like tipo-etiqueta.tipo-etiq.
