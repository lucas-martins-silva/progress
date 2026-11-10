/****************************************************************************** 
** Include:   AF0501.i -  Defini‡Æo da tt-param                              **
** Programas: AF0501.w                                                       **
**            AF0501rp.p                                                     **
******************************************************************************/

define temp-table tt-param no-undo
    field destino          as INTEGER 
    FIELD c-destino        AS CHAR
    field arquivo          as char format "x(35)"
    field usuario          as char format "x(12)"
    field data-exec        as date
    field hora-exec        as integer
    field classifica       as integer extent 5
    field desc-classifica  as char    extent 5 format "x(20)"
    field c-est-ini        like af-contr-indice.cod-estabel 
    field c-est-fim        like af-contr-indice.cod-estabel 
    field i-emi-ini        like af-contr-indice.cod-emitente 
    field i-emi-fim        like af-contr-indice.cod-emitente 
    field c-it-ini         like af-contr-indice.it-codigo 
    field c-it-fim         like af-contr-indice.it-codigo 
    field i-nr-ini         like af-contr-indice.nr-controle 
    field i-nr-fim         like af-contr-indice.nr-controle 
    FIELD i-ano-ini        LIKE af-periodo-aval.ano-avaliacao
    FIELD c-des-per-ini    LIKE af-periodo-aval.des-periodo-aval[1] COLUMN-LABEL "Per¡odo Ini"
    FIELD i-ano-fim        LIKE af-periodo-aval.ano-avaliacao
    FIELD c-des-per-fim    LIKE af-periodo-aval.des-periodo-aval[1] COLUMN-LABEL "Per¡odo Fim"
    field i-cod-gr-forn-ini like emitente.cod-gr-forn label "Grupo Fornecedor"
    field i-cod-gr-forn-fim like emitente.cod-gr-forn label "Grupo Fornecedor"
    field i-ge-codigo-ini  like item.ge-codigo
    field i-ge-codigo-fim  like item.ge-codigo
    field c-fm-codigo-ini  like item.fm-codigo
    field c-fm-codigo-fim  like item.fm-codigo
    field c-cod-grp-aval-ini LIKE af-item-contr-estab.cod-grp-avaliacao                                                          
    field c-cod-grp-aval-fim LIKE af-item-contr-estab.cod-grp-avaliacao
    field c-cod-grp-resp-ini LIKE af-item-contr-estab-form.cod-grp-resp
    field c-cod-grp-resp-fim LIKE af-item-contr-estab-form.cod-grp-resp
    field i-situacao       as int
    field c-situacao       as char format "x(20)" label "Situa‡Æo"
    field l-narrativa      as logical  FORMAT "Sim/NÆo"      LABEL "Narrativa Öndice"
    field l-indice-zerado  as logical  FORMAT "Sim/NÆo"      LABEL "Öndice digitado com valor zero"
    field l-descricao-item as logical  FORMAT "Sim/NÆo"      LABEL "Descri‡Æo Item"
    field l-detalha-itens  as logical  FORMAT "Sim/NÆo"      LABEL "Öndice detalhado por item"
    field l-pula-linha     as logical  FORMAT "Sim/NÆo"      LABEL "Linha em branco"
    FIELD l-email          AS LOGICAL  FORMAT "Sim/NÆo"
    FIELD i-mensagem       AS INTEGER.                                                                                 .

