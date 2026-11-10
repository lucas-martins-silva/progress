/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/

DEFINE TEMP-TABLE tt-impostos-despesa NO-UNDO
    FIELD cod-tax      LIKE tipo-tax.cod-tax 
    FIELD descricao    LIKE tipo-tax.descricao 
    FIELD tax-perc     LIKE tipo-tax.tax-perc FORMAT ">>>9.9999"
    FIELD vl-base      LIKE impto-item-docto.val-base
    FIELD vl-imposto   LIKE impto-item-docto.val-impto
    FIELD vl-base-me      LIKE impto-item-docto.val-base-me
    FIELD vl-imposto-me   LIKE impto-item-docto.val-impto-me
    FIELD l-automatico AS LOGICAL
    INDEX id cod-tax.
