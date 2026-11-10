/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
/********************************************************************************
** anepd015.i - Os erros retornados dos BO's s∆o gravados na tt-erro-neogrid.
** {1} Nome da table-table de erros (RowErros, RowErrosItem, RowErrosPedRepre, etc.)
********************************************************************************/

for each {1} NO-LOCK:
    create tt-erro-neogrid.
    assign tt-erro-neogrid.c-doc-origem  = c-docidentifier
           tt-erro-neogrid.c-cod-estabel = tt-ped-venda.cod-estabel
           tt-erro-neogrid.i-cod-erro    = {1}.ErrorNumber
           tt-erro-neogrid.c-desc-erro   = {1}.ErrorDescription.
end.
