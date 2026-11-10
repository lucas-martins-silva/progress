/*******************************************************************************
***
*** app/ap0506b.i - Defini‡Æo Temp-Tables.
***
*******************************************************************************/

define temp-table tt-param
    field i-ep-codigo      like empresa.ep-codigo
    field cod-fornec       like mov-ap.cod-fornec
    field cod-estabel      like mov-ap.cod-estabel
    field cod-esp          like mov-ap.cod-esp
    field serie            like mov-ap.serie
    field nr-docto         like mov-ap.nr-docto
    field parcela          like mov-ap.parcela
    field portador         like mov-ap.portador
    field modalidade       like mov-ap.modalidade
    field nr-cheque        like mov-ap.nr-cheque
    field dt-transacao     like mov-ap.dt-transacao
    field valor-mov        like mov-ap.valor-mov
    field esp-ant          like mov-ap.cod-esp
    field serie-ant        like mov-ap.serie-ant
    field docto-ant        like mov-ap.docto-ant
    field parc-ant         like mov-ap.parc-ant
    field fornec-ant       like mov-ap.fornec-ant
    field usa-antec         as  logical
    field retorna-portador  as  logical
    field l-video           as  log init no
    field data-exec         as  date
    field hora-exec         as  integer
    field destino           as  integer
    field arquivo           as  char
    field usuario           as  char.

/* Fim de Include */
