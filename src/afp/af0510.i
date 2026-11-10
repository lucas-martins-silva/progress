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
** Include: af0510.i - Defini‡äes das Temp table execu‡Æo
**    de atualiza‡Æo: Ativa/Desativa Relacionamento
                       
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
        FIELD l-familia-fornecedor AS LOGICAL
        FIELD l-item-fornecedor    AS LOGICAL
        FIELD l-item-estabelecimento AS LOGICAL
        FIELD l-grupo              AS LOGICAL
        FIELD l-ativa-desativa     AS LOGICAL
        FIELD r-ativa-desativa     AS LOGICAL.
        

    DEF TEMP-TABLE tt-digita
        FIELD nr-controle               LIKE af-item-contr-form.nr-controle
        FIELD descricao                 LIKE af-controle.descricao
        FIELD percentual                LIKE af-item-contr-form.percentual.
        
        
    def temp-table tt-raw-digita
       field raw-digita      as raw.
    
/* Fim da include */

