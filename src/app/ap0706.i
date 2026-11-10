/****************************************************************************
***
*** app/ap0706.i - Defini‡Æo Temp-table.
***
****************************************************************************/

def temp-table tt-param
    field ep-codigo        as integer
    field destino          as integer
    field arquivo          as char
    field usuario          as char
    field data-exec        as date
    field hora-exec        as integer
    field classifica       as integer
    field text-classif     as char
    field estab-ini        like mov-ap.cod-estabel
    field estab-fim        like mov-ap.cod-estabel
    field espec-ini        like mov-ap.cod-esp
    field espec-fim        like mov-ap.cod-esp
    field grp-forn-ini     like emitente.cod-gr-forn
    field grp-forn-fim     like emitente.cod-gr-forn
    field fornec-ini       as integer format ">>>>>>>>9"
    field fornec-fim       as integer format ">>>>>>>>9"
    field matriz-ini       as integer format ">>>>>>>>9"
    field matriz-fim       as integer format ">>>>>>>>9"
    field dt-transac-ini   like mov-ap.dt-transacao
    field dt-transac-fim   like mov-ap.dt-transacao
    field moeda            like mov-ap.moeda
    field da-conversao     as date
    field cotacao-dia      like mov-ap.cotacao-dia
    field l-prev-perfil    as logical
    field l-prev-saldo     as logical
    field l-espec-ctbl     as logical
    field l-ficha          as logical
    field l-lista-antecip  as logical
    field atraso-medio     as integer
    field tp-moeda         as integer
    field tipo             as integer
    field l-lista-op       as logical
    field l-pula-linha     as logical.

def temp-table tt-digita
    field ordem            as integer   format ">>>>9"
    field exemplo          as character format "x(30)"
    index id is primary unique
        ordem.

def temp-table tt-raw-digita
    field raw-digita       as raw.
    
/* Fim de Include */
