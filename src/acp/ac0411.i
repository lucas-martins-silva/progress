/*************************************************************************
* Include : acp/ac0412.i tt-param 
*  Autor  : DATASUL S.A.
**************************************************************************/

/************************************************************ 
*  Pr‚-Processador para o m¢dulo de Administra‡Æo de Cotas
************************************************************/
 
&if defined (bf_dis_adm_cotas) &then
    define temp-table tt-param
        field destino          as integer
        field arquivo          as char
        field usuario          as char format "x(12)"
        field data-exec        as date
        field hora-exec        as integer
        field periodo-ini      like cotas.dt-inicial
        field periodo-fim      like cotas.dt-inicial
        field cod-sit-com      as integer
        field desc-sit-com     as char format "x(40)"
        field cod-estabel-ini  like cotas.cod-estabel
        field cod-estabel-fim  like cotas.cod-estabel
        field nr-pedido-ini    like ped-venda.nr-pedcli
        field nr-pedido-fim    like ped-venda.nr-pedcli
        field nome-abrev-ini   like ped-venda.nome-abrev
        field nome-abrev-fim   like ped-venda.nome-abrev
        field dt-ini           like ped-venda.dt-emissao
        field dt-fim           like ped-venda.dt-emissao
        field cod-canal-venda-ini like ped-venda.cod-canal-venda
        field cod-canal-venda-fim like ped-venda.cod-canal-venda.
&else
    define temp-table tt-param
        field destino          as integer
        field arquivo          as char
        field usuario          as char format "x(12)"
        field data-exec        as date
        field hora-exec        as integer
        field periodo-ini      like cotas.dt-inicial
        field periodo-fim      like cotas.dt-inicial
        field cod-sit-com      as integer
        field desc-sit-com     as char format "x(40)"
        field cod-estabel-ini  like cotas.cod-estabel
        field cod-estabel-fim  like cotas.cod-estabel
        field nr-pedido-ini    like ped-venda.nr-pedcli
        field nr-pedido-fim    like ped-venda.nr-pedcli
        field nome-abrev-ini   like ped-venda.nome-abrev
        field nome-abrev-fim   like ped-venda.nome-abrev
        field dt-ini           like ped-venda.dt-emissao
        field dt-fim           like ped-venda.dt-emissao.
&endif

/* Fim include ac0401.i */
