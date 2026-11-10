/******************************************************************************
***  Include: AP0512.I
***  Objetivo: Imprimir listagem de consistencia
***
******************************************************************************/

create tt-log-erro.
assign tt-log-erro.ep-codigo  = {1}tit-ap.ep-codigo
       tt-log-erro.cod-fornec = {1}tit-ap.cod-forn
       tt-log-erro.cod-est    = {1}tit-ap.cod-est
       tt-log-erro.serie      = {1}tit-ap.serie
       tt-log-erro.cod-esp    = {1}tit-ap.cod-esp
       tt-log-erro.nr-docto   = {1}tit-ap.nr-docto
       tt-log-erro.parcela    = {1}tit-ap.parcela
       tt-log-erro.erro       = trim(return-value).

/* Fim de Include */
