/*************************************************************************
* Include : acp/ac1002.i tt-param 
*  Autor  : DATASUL S.A.
**************************************************************************/
    
define temp-table tt-param
    field destino          as integer
    field arquivo          as char
    field usuario          as char format "x(12)"
    field data-exec        as date
    field hora-exec        as integer
    field cod-sit-com      as integer
    field cod-estabel-ini  like cotas.cod-estabel
    field cod-estabel-fim  like cotas.cod-estabel
    field nr-pedido-ini    like ped-venda.nr-pedcli
    field nr-pedido-fim    like ped-venda.nr-pedcli
    field nome-abrev-ini   like ped-venda.nome-abrev
    field nome-abrev-fim   like ped-venda.nome-abrev
    field dt-ini           like ped-venda.dt-emissao
    field dt-fim           like ped-venda.dt-emissao
    field dt-implant-ini   like ped-venda.dt-implant
    field dt-implant-fim   like ped-venda.dt-implant
    field cotas-nao-aval   as log.


/* Fim include ac1002.i */
