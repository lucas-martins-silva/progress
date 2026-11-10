/***********************************************************************
**
** ap0010.i - Verifica a existˆncia dos parƒmetros globais e do m¢dulo
**
***********************************************************************/

FIND FIRST param-global NO-LOCK NO-ERROR.
IF NOT AVAIL param-global THEN DO:
    RUN utp/ut-msgs.p (input "show":U,
                       input 16,
                       input  "").
    APPLY "CLOSE":U TO THIS-PROCEDURE.
    RETURN.
END.

IF {&param-ap} = yes THEN DO:
    FIND param-ap NO-LOCK
        WHERE param-ap.ep-codigo = i-ep-codigo-usuario
        NO-ERROR.
    IF  NOT AVAIL param-ap THEN DO:
        RUN utp/ut-msgs.p (input "show":U,
                           input 28,
                           input  "").
        APPLY "CLOSE":U TO THIS-PROCEDURE.
        RETURN.
    END.
END.

/* fim */
