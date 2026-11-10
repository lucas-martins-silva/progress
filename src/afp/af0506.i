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
** Include: af0506.i - Defini‡äes das Temp table para 
                        Listagem de Item Avalia‡Æo Fornecedores
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
        FIELD c-item-ini           LIKE af-item-contr.it-codigo
        FIELD c-item-fim           LIKE af-item-contr.it-codigo
        FIELD c-desc-item-ini      LIKE item.desc-item
        FIELD c-desc-item-fim      LIKE item.desc-item
        FIELD c-familia-ini        LIKE af-familia-contr.fm-codigo
        FIELD c-familia-fim        LIKE af-familia-contr.fm-codigo
        FIELD i-fornecedor-ini     LIKE af-familia-contr.cod-emitente
        FIELD i-fornecedor-fim     LIKE af-familia-contr.cod-emitente        
        FIELD c-nom-abrev-ini      LIKE emitente.nome-abrev
        FIELD c-nom-abrev-fim      LIKE emitente.nome-abrev                
        FIELD l-relacionamento     AS   LOGICAL
        FIELD l-formula            AS   LOGICAL
        FIELD i-versao             AS   INTEGER
        FIELD c-versao             AS   CHARACTER FORMAT "x(20)":U.
        

    DEF TEMP-TABLE tt-digita
        FIELD nr-controle               LIKE af-item-contr-form.nr-controle
        FIELD descricao                 LIKE af-controle.descricao
        FIELD percentual                LIKE af-item-contr-form.percentual.
        
        
    def temp-table tt-raw-digita
       field raw-digita      as raw.
    
/* Fim da include */

