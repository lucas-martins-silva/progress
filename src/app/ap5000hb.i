/******************************************************************************
***       
*** app/ap5000hb.i - C lculo Resumo.
***                             
******************************************************************************/

    ASSIGN i-tot-empresa    = 0   
           i-tot-portador   = 0
           i-dias-corridos  = 0
           i-dias-uteis     = 0
           i-qtde-periodo   = 0
           da-data-ini      = ?
           da-data-fim      = ?.

    FIND FIRST {1} NO-LOCK NO-ERROR.
    IF  AVAIL {1} THEN DO:
        IF  {1}.da-inicio <> ? AND {1}.da-fim <> ? THEN DO:
            DO  da-data = {1}.da-inicio TO {1}.da-fim:
                IF  WEEKDAY(da-data) <> 1 AND
                    WEEKDAY(da-data) <> 7 THEN
                    ASSIGN i-dias-uteis = i-dias-uteis + 1.
    
            END.

            ASSIGN da-data-ini = {1}.da-inicio
                   da-data-fim = {1}.da-fim.

        END.

        IF  {1}.da-fim = {1}.da-inicio THEN
            ASSIGN i-dias-corridos = 1
                   i-dias-uteis    = 1.
        ELSE
            ASSIGN i-dias-corridos = {1}.da-fim - {1}.da-inicio.

    END.
    
    FOR EACH {1} NO-LOCK
        WHERE {1}.MODULO = "{2}"
        BREAK BY {1}.ep-codigo:
        IF  LAST-OF({1}.ep-codigo) THEN
            ASSIGN i-tot-empresa = i-tot-empresa + 1.

        ASSIGN i-qtde-periodo = i-qtde-periodo + {1}.qtde-dia.

    END.

    FOR EACH {1} NO-LOCK
        WHERE {1}.MODULO = "{2}"
        BREAK BY {1}.portador:
        IF  LAST-OF({1}.portador) THEN
            ASSIGN i-tot-portador = i-tot-portador + 1.
    END.
    
    IF  i-dias-corridos = ? THEN
        ASSIGN i-dias-corridos = 0.

    IF  i-dias-uteis = ? THEN
        ASSIGN i-dias-uteis = 0.

/* Fim Include */

