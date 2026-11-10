/****************************************************************************** 
** Include:   AF0303.i -  Definiá∆o da tt-param                              **
** Programas: AF0303.w                                                       **
**            AF0303rp.p                                                     **
******************************************************************************/

define temp-table tt-param no-undo
    field destino             as INTEGER 
    FIELD c-destino           AS CHAR
    field arquivo             as char format "x(35)"
    field usuario             as char format "x(12)"
    field data-exec           as date
    field hora-exec           as integer
    field c-est-ini           like af-contr-indice.cod-estabel 
    field c-est-fim           like af-contr-indice.cod-estabel 
    field i-emi-ini           like af-contr-indice.cod-emitente 
    field i-emi-fim           like af-contr-indice.cod-emitente 
    field c-it-ini            like af-contr-indice.it-codigo 
    field c-it-fim            like af-contr-indice.it-codigo 
    FIELD i-ano-ini           LIKE af-periodo-aval.ano-avaliacao
    FIELD c-des-per-ini       LIKE af-periodo-aval.des-periodo-aval[1] COLUMN-LABEL "Per°odo Ini"
    FIELD i-ano-fim           LIKE af-periodo-aval.ano-avaliacao
    FIELD c-des-per-fim       LIKE af-periodo-aval.des-periodo-aval[1] COLUMN-LABEL "Per°odo Fim"
    field i-cod-gr-forn-ini   like emitente.cod-gr-forn label "Grupo Fornecedor"
    field i-cod-gr-forn-fim   like emitente.cod-gr-forn label "Grupo Fornecedor"
    field i-ge-codigo-ini     like item.ge-codigo
    field i-ge-codigo-fim     like item.ge-codigo
    field c-fm-codigo-ini     like item.fm-codigo
    field c-fm-codigo-fim     like item.fm-codigo
    FIELD l-qualidade         AS LOG LABEL "Qualidade" FORMAT "Sim/N∆o"
    FIELD l-quantidade        AS LOG LABEL "Quantidade" FORMAT "Sim/N∆o"
    FIELD l-preco             AS LOG LABEL "Preáo" FORMAT "Sim/N∆o"
    FIELD l-data-entrega      AS LOG LABEL "Data Entrega" FORMAT "Sim/N∆o"
    field l-padrao            as log label "Pradr∆o" format "Sim/N∆o"
    field l-especifico        as log label "Espec°ficos" format "Sim/N∆o"
    field i-nr-controle-ini   like af-controle.nr-controle
    field i-nr-controle-fim   like af-controle.nr-controle
    field l-utiliza-formula   LIKE af-controle.log-formula
    field c-grp-avaliacao-ini LIKE af-item-contr-estab.cod-grp-avaliacao                                                       
    field c-grp-avaliacao-fim LIKE af-item-contr-estab.cod-grp-avaliacao.

 

