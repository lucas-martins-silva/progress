/******************************************************************************** 
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
/******************************************************************************
**
** Include: af0513.i - Defini‡äes das Temp table elimina‡Æo dos ¡ndices
**
*******************************************************************************/

/******************************Defini‡Æo de Temp Table ****************************/

    DEF TEMP-TABLE tt-param
        FIELD destino              AS INTEGER
        FIELD arquivo              AS CHAR
        FIELD usuario              AS CHAR FORMAT "x(12)"
        FIELD data-exec            AS DATE
        FIELD hora-exec            AS INTEGER
        FIELD c-estabelecimento-ini LIKE af-contr-indice.cod-estabel
        FIELD c-estabelecimento-fim LIKE af-contr-indice.cod-estabel
        FIELD i-fornecedor-ini     LIKE af-contr-indice.cod-emitente
        FIELD i-fornecedor-fim     LIKE af-contr-indice.cod-emitente
        FIELD i-ano-ini            AS INTEGER        
        FIELD i-ano-fim            AS INTEGER        
        FIELD i-periodo-ini        AS INTEGER
        FIELD c-periodo-ini        AS CHAR FORMAT "x(20)"
        FIELD i-periodo-fim        AS INTEGER
        FIELD c-periodo-fim        AS CHAR FORMAT "x(20)"
        FIELD c-item-ini           LIKE af-contr-indice.it-codigo
        FIELD c-item-fim           LIKE af-contr-indice.it-codigo
        FIELD i-nr-controle-ini    LIKE af-contr-indice.nr-controle
        FIELD i-nr-controle-fim    LIKE af-contr-indice.nr-controle                     
        FIELD l-somente-fechado    AS LOGICAL
        FIELD l-simula-eliminacao  AS LOGICAL.

    DEF TEMP-TABLE tt-digita
        FIELD nr-controle               LIKE af-item-contr-form.nr-controle
        FIELD descricao                 LIKE af-controle.descricao
        FIELD percentual                LIKE af-item-contr-form.percentual.
        
    def temp-table tt-raw-digita
       field raw-digita      as raw.
    
/* Fim da include */

