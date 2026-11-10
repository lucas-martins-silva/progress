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
** Include: af0514.i - Listagem de Inconsitˆncia de versäes
**                       
**
*******************************************************************************/

/******************************Defini‡Æo de Temp Table ****************************/
    DEF TEMP-TABLE tt-param
        FIELD destino               AS INTEGER
        FIELD arquivo               AS CHAR
        FIELD usuario               AS CHAR FORMAT "x(12)"
        FIELD data-exec             AS DATE
        FIELD hora-exec             AS INTEGER
        FIELD c-item-ini            LIKE af-item-contr.it-codigo
        FIELD c-item-fim            LIKE af-item-contr.it-codigo
        FIELD c-descricao-ini       LIKE ITEM.desc-item
        FIELD c-descricao-fim       LIKE ITEM.desc-item
        FIELD c-familia-ini         LIKE ITEM.fm-codigo
        FIELD c-familia-fim         LIKE ITEM.fm-codigo        
        FIELD c-estabelecimento-ini LIKE af-item-contr-estab.cod-estabel
        FIELD c-estabelecimento-fim LIKE af-item-contr-estab.cod-estabel        
        FIELD i-fornecedor-ini      LIKE af-item-contr.cod-emitente
        FIELD i-fornecedor-fim      LIKE af-item-contr.cod-emitente        
        FIELD c-nom-abrev-ini       LIKE emitente.nome-abrev
        FIELD c-nom-abrev-fim       LIKE emitente.nome-abrev
        FIELD c-grp-avaliacao-ini   LIKE af-grp-avaliacao.cod-grp-avaliacao
        FIELD c-grp-avaliacao-fim   LIKE af-grp-avaliacao.cod-grp-avaliacao
        FIELD c-des-grp-aval-ini    LIKE af-grp-avaliacao.des-grp-avaliacao
        FIELD c-des-grp-aval-fim    LIKE af-grp-avaliacao.des-grp-avaliacao
        FIELD i-nr-controle-ini     LIKE af-faixa-demerito.nr-controle
        FIELD i-nr-controle-fim     LIKE af-faixa-demerito.nr-controle
        FIELD c-nr-contr-desc-ini   LIKE af-controle.descricao
        FIELD c-nr-contr-desc-fim   LIKE af-controle.descricao
        FIELD i-cod-formula-ini     LIKE af-formula.cod-formula
        FIELD i-cod-formula-fim     LIKE af-formula.cod-formula
        FIELD c-desc-form-ini       LIKE af-formula.descricao
        FIELD c-desc-form-fim       LIKE af-formula.descricao
        FIELD l-familia-fornecedor  AS LOGICAL
        FIELD l-item-fornecedor     AS LOGICAL
        FIELD l-item-estabelecimento AS LOGICAL
        FIELD l-grupo               AS LOGICAL
        FIELD l-faixa-demerito      AS LOGICAL
        FIELD l-faixa-calculo       AS LOGICAL.
        

    DEF TEMP-TABLE tt-digita
        FIELD nr-controle               LIKE af-item-contr-form.nr-controle
        FIELD descricao                 LIKE af-controle.descricao
        FIELD percentual                LIKE af-item-contr-form.percentual.
        
        
    def temp-table tt-raw-digita
       field raw-digita      as raw.
    
/* Fim da include */

