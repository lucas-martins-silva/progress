/*************************************************************************
* Include : acp/ac0406.i tt-param 
*  Autor  : DATASUL S.A.
**************************************************************************/

define temp-table tt-param
    field destino              as integer
    field arquivo              as char
    field usuario              as char format "x(12)"
    field data-exec            as date
    field hora-exec            as integer
    field periodo-ini          like transfer.dt-transf
    field periodo-fim          like transfer.dt-transf
    field produto-ini          like cotas.cd-produto
    field produto-fim          like cotas.cd-produto
    field cod-estab-ini        like cotas.cod-estabel
    field cod-estab-fim        like cotas.cod-estabel
    field dt-inicial           like transfer.dt-inicial.

/* Fim include ac0406.i */
