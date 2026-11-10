/*******************************************************************************
***
*** app/ap0777c.i - Defini‡Æo temp-tableïs utilizadas ap0777.w e ap0777c.p
***
*******************************************************************************/

DEF TEMP-TABLE tt-tit-ap NO-UNDO LIKE tit-ap
    FIELD cod-gr-forn LIKE emitente.cod-gr-forn
    FIELD ind-erro    AS CHAR FORMAT "x(03)" LABEL "Sit" INIT "OK"
    FIELD ind-orig    AS CHAR FORMAT "x(13)" LABEL "Origem"
    FIELD natureza    AS CHAR FORMAT "x(15)" LABEL "Narureza"
    FIELD rw-tit      AS ROWID
    INDEX codigo ep-codigo
                 cod-estabel
                 cod-fornec
                 cod-esp
                 serie
                 nr-docto
                 parcela
    INDEX link rw-tit
    INDEX erro ind-erro
    INDEX docto nr-docto.

DEF TEMP-TABLE tt-espec-ap NO-UNDO LIKE espec-ap
    FIELD log-sel  AS LOG     FORMAT "Sim/NÆo" LABEL "Selecionado"
    FIELD ind-tipo AS CHAR    FORMAT "x(20)" LABEL "Tipo Esp‚cie".

DEF TEMP-TABLE tt-log-erros NO-UNDO
    FIELD rw-tit AS ROWID
    FIELD ind-tipo-erro AS CHAR FORMAT "x(15)" LABEL "Tipo Erro"
    FIELD num-erro      AS INT  FORMAT ">>>>>9" LABEL "C¢d Erro"
    FIELD desc-erro     AS CHAR
    INDEX codigo rw-tit.

DEF TEMP-TABLE tt-tit-ap-sel NO-UNDO
    FIELD row-tit-ap AS ROWID
    INDEX codigo row-tit-ap.

/* Fim de Include */



