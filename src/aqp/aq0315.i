/***************************************************************************
**                                                                        **
**    AQ0315.I - Confirma‡Æo preco final produtores                       **
**                                                                        **
**    DEFINIÇÂO DAS TEMP-TABLES                                           **
**                                                                        **  
****************************************************************************/
 
DEFINE TEMP-TABLE tt-filtro
    FIELD cod-period                 LIKE fechto-produt-period.cod-period
    FIELD it-codigo                  LIKE fechto-produt-period.it-codigo
    FIELD cod-estabel-ini            LIKE fechto-produt-period.cod-estabel
    FIELD cod-estabel-fim            LIKE fechto-produt-period.cod-estabel
    FIELD cod-regiao-ini             LIKE fechto-produt-period.cod-regiao 
    FIELD cod-regiao-fim             LIKE fechto-produt-period.cod-regiao
    FIELD cod-rota-ini               LIKE fechto-produt-period.cod-rota
    FIELD cod-rota-fim               LIKE fechto-produt-period.cod-rota
    FIELD cdn-grp-produt-ini         LIKE grp-produt.cdn-grp-produt 
    FIELD cdn-grp-produt-fim         LIKE grp-produt.cdn-grp-produt 
    FIELD cdn-produt-rural-ini       LIKE fechto-produt-period.cdn-produt-rural
    FIELD cdn-produt-rural-fim       LIKE fechto-produt-period.cdn-produt-rural
    FIELD cod-propried-ini           LIKE fechto-produt-period.cod-propried
    FIELD cod-propried-fim           LIKE fechto-produt-period.cod-propried
    FIELD tg-sit-todos               AS LOGICAL
    FIELD tg-sit-pendente            AS LOGICAL
    FIELD tg-sit-confirmada          AS LOGICAL
    FIELD tg-sit-nf-gerada           AS LOGICAL
    FIELD ordenacao                  AS CHARACTER.

DEFINE TEMP-TABLE tt-variavel NO-UNDO
    FIELD cod-var-oper   AS CHAR FORMAT "x(16)"
    FIELD valor-variavel AS CHAR FORMAT "x(60)".

DEFINE TEMP-TABLE tt-retorno NO-UNDO
    FIELD valor-retorno AS CHAR FORMAT "x(60)"
    FIELD campo-retorno AS CHAR FORMAT "x(60)"
    FIELD perc-rateio   AS DECIMAL FORMAT ">>9,99".
