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
** Include: af0509.i - Defini‡äes das Temp table para Elimina‡Æo de Versäes das tabelas
                        af-familia-contr
                        af-item-contr
                        af-item-contr-estab
                        af-grp-avaliacao
                        af-faixa-demerito
                        af-formula
                       
**
*******************************************************************************/

/******************************Defini‡Æo de Temp Table ****************************/

    DEF TEMP-TABLE tt-param
        FIELD destino              AS INTEGER
        FIELD arquivo              AS CHAR
        FIELD usuario              AS CHAR FORMAT "x(12)"
        FIELD data-exec            AS DATE
        FIELD hora-exec            AS INTEGER
        FIELD i-nr-versao-ini      LIKE af-versao-avaliacao.nr-versao
        FIELD i-nr-versao-fim      LIKE af-versao-avaliacao.nr-versao
        FIELD c-descricao-ini      LIKE af-versao-avaliacao.desc-versao
        FIELD c-descricao-fim      LIKE af-versao-avaliacao.desc-versao
        FIELD c-familia-ini        LIKE af-familia-contr.fm-codigo
        FIELD c-familia-fim        LIKE af-familia-contr.fm-codigo
        FIELD c-item-ini           LIKE af-item-contr.it-codigo
        FIELD c-item-fim           LIKE af-item-contr.it-codigo
        FIELD c-estabelecimento-ini LIKE af-item-contr-estab.cod-estabel
        FIELD c-estabelecimento-fim LIKE af-item-contr-estab.cod-estabel        
        FIELD i-fornecedor-ini     LIKE af-familia-contr.cod-emitente
        FIELD i-fornecedor-fim     LIKE af-familia-contr.cod-emitente        
        FIELD c-grp-avaliacao-ini  LIKE af-familia-contr.cod-grp-avaliacao
        FIELD c-grp-avaliacao-fim  LIKE af-familia-contr.cod-grp-avaliacao
        FIELD i-nr-controle-ini    LIKE af-faixa-demerito.nr-controle
        FIELD i-nr-controle-fim    LIKE af-faixa-demerito.nr-controle
        FIELD i-cod-formula-ini    LIKE af-formula.cod-formula
        FIELD i-cod-formula-fim    LIKE af-formula.cod-formula
        FIELD c-desc-form-ini      LIKE af-formula.descricao
        FIELD c-desc-form-fim      LIKE af-formula.descricao
        FIELD l-familia-fornecedor AS LOGICAL
        FIELD l-item-fornecedor    AS LOGICAL
        FIELD l-item-estabelecimento AS LOGICAL
        FIELD l-grupo              AS LOGICAL
        FIELD l-simula-eliminacao  AS LOGICAL
        FIELD l-faixa-demerito     AS LOGICAL
        FIELD l-faixa-calculo      AS LOGICAL.
        

    DEF TEMP-TABLE tt-digita
        FIELD nr-controle               LIKE af-item-contr-form.nr-controle
        FIELD descricao                 LIKE af-controle.descricao
        FIELD percentual                LIKE af-item-contr-form.percentual.
        
        
    def temp-table tt-raw-digita
       field raw-digita      as raw.
    
/* Fim da include */

