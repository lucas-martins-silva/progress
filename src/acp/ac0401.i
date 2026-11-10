/*************************************************************************
* Include : acp/ac0401.i tt-param 
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
    field cod-estab-ini        like cotas.cod-estabel
    field cod-estab-fim        like cotas.cod-estabel
    field cod-canal-venda-ini  like cotas.cod-canal-venda
    field cod-canal-venda-fim  like cotas.cod-canal-venda
    field cod-gr-cli-ini       like cotas.cod-gr-cli
    field cod-gr-cli-fim       like cotas.cod-gr-cli
    field nome-abrev-ini       like cotas.nome-abrev
    field nome-abrev-fim       like cotas.nome-abrev
    field nome-ab-reg-ini      like cotas.nome-ab-reg
    field nome-ab-reg-fim      like cotas.nome-ab-reg
    field nome-mic-reg-ini     like cotas.nome-mic-reg
    field nome-mic-reg-fim     like cotas.nome-mic-reg
    field cod-rep-ini          like cotas.cod-rep
    field cod-rep-fim          like cotas.cod-rep
    field cd-produto-ini       like cotas.cd-produto
    field cd-produto-fim       like cotas.cd-produto
    field dt-inicial           like cotas.dt-inicial
    field dt-final             like cotas.dt-inicial
    field considera            as logical
    field rs-quantidade        as integer
    field desc-quantidade      as char format "x(40)".

/* Fim include ac0401.i */
