/****************************************************************************** 
** Include:   AF0502.i -  Defini‡Æo da tt-param                              **
** Programas: AF0502.w                                                       **
**            AF0502rp.p                                                     **
******************************************************************************/

define temp-table tt-param no-undo
    field destino          as INTEGER 
    FIELD c-destino        AS CHAR
    field arquivo          as char format "x(35)"
    field usuario          as char format "x(12)"
    field data-exec        as date
    field hora-exec        as integer
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
    field i-compara-fornecedores      as int 
    field c-compara-fornecedores      as char format "x(30)" label "Tipo Listagem"
    field l-email                     as logical FORMAT "Sim/NÆo" LABEL "Envia e-mail para o fornecedor"
    field l-informa-email             as logical FORMAT "Sim/NÆo" LABEL "Informa e-mail"
    field c-para                      as CHAR FORMAT "x(100)" LABEL "Envia e-mail para"
    field c-cc                        as CHAR FORMAT "x(100)" LABEL "Envia e-mail com c¢pia"
    field c-assunto                   as CHAR FORMAT "x(100)" LABEL "Assunto"
    field c-mensagem                  as CHAR FORMAT "x(100)" LABEL "Mensagem"
    field l-anexar                    as log label "Anexar"
    field c-cod-grp-aval-ini LIKE af-item-contr-estab.cod-grp-avaliacao                                                          
    field c-cod-grp-aval-fim LIKE af-item-contr-estab.cod-grp-avaliacao
    field c-cod-grp-resp-ini LIKE af-item-contr-estab-form.cod-grp-resp                                                          
    field c-cod-grp-resp-fim LIKE af-item-contr-estab-form.cod-grp-resp.                                                                       

