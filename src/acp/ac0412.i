/*************************************************************************
* Include : acp/ac0412.i tt-param 
*  Autor  : DATASUL S.A.
**************************************************************************/

define temp-table tt-param
    field destino              as integer
    field arquivo              as char
    field arq-destino          as char
    field arq-entrada          as char
    field usuario              as char format "x(12)"
    field data-exec            as date
    field hora-exec            as integer
    field cod-estab-ini        like cotas.cod-estabel
    field cod-estab-fim        like cotas.cod-estabel
    field cod-canal-venda-ini  like cotas.cod-canal-venda
    field cod-canal-venda-fim  like cotas.cod-canal-venda
    field cod-gr-cli-ini       like cotas.cod-gr-cli
    field nome-ab-reg-ini      like cotas.nome-ab-reg
    field nome-ab-reg-fim      like cotas.nome-ab-reg
    field cod-gr-cli-fim       like cotas.cod-gr-cli
    field cod-rep-ini          like cotas.cod-rep
    field cod-rep-fim          like cotas.cod-rep
    field dt-inicial           like cotas.dt-inicial
    field dt-final             like cotas.dt-final
    field texto                as character format "x(2000)"
    field imprime              as logical.

/* Fim include ac0401.i */
