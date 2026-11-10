/*************************************************************************
* Include : acp\ac0407.i tt-param 
*  Autor  : DATASUL S.A.
**************************************************************************/

define temp-table tt-param
    field destino              as integer
    field arquivo              as char
    field usuario              as char format "x(12)"
    field data-exec            as date
    field hora-exec            as integer
    field classifica           as integer
    field desc-classifica      as char format "x(40)"
    field cliente-ini          like cotas.nome-abrev
    field cliente-fim          like cotas.nome-abrev
    field dt-inicial           like ped-venda.dt-emissao
    field dt-Final             like ped-venda.dt-emissao
    field perc-amostra         as decimal format ">>9.99".

/* Fim include ac0407.i */
