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
** Include: af0512.i - Defini‡äes das Temp table para listagem das
**                   : Faixa de Dem‚rito                        
**
*******************************************************************************/

/******************************Defini‡Æo de Temp Table ****************************/

    DEF TEMP-TABLE tt-param
        FIELD destino              AS INTEGER
        FIELD arquivo              AS CHAR
        FIELD usuario              AS CHAR FORMAT "x(12)":U
        FIELD data-exec            AS DATE
        FIELD hora-exec            AS INTEGER
        FIELD classifica           AS INTEGER
        FIELD desc-classifica      AS CHAR FORMAT "x(40)":U
        FIELD modelo               AS CHAR
        FIELD l-habilitaRtf        AS LOG
        FIELD i-nr-versao-ini      LIKE af-versao-avaliacao.nr-versao
        FIELD i-nr-versao-fim      LIKE af-versao-avaliacao.nr-versao
        FIELD c-descricao-ini      LIKE af-versao-avaliacao.desc-versao
        FIELD c-descricao-fim      LIKE af-versao-avaliacao.desc-versao
        FIELD i-nr-controle-ini    LIKE af-controle.nr-controle
        FIELD i-nr-controle-fim    LIKE af-controle.nr-controle
        FIELD c-desc-controle-ini  LIKE af-controle.descricao
        FIELD c-desc-controle-fim  LIKE af-controle.descricao
        FIELD l-faixa-valor        AS LOGICAL
        FIELD l-faixa-percentual   AS LOGICAL
        FIELD l-limite-demerito    AS LOGICAL
        FIELD rsversoes            AS INTEGER
        FIELD rs-desc-versao       AS CHARACTER FORMAT "x(20)":U.
        

    DEF TEMP-TABLE tt-digita
        FIELD nr-controle               LIKE af-item-contr-form.nr-controle
        FIELD descricao                 LIKE af-controle.descricao
        FIELD percentual                LIKE af-item-contr-form.percentual.
        
        
    def temp-table tt-raw-digita
       field raw-digita      as raw.
    
/* Fim da include */


