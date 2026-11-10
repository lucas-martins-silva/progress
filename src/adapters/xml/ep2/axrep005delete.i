    FIND FIRST tt-docto-adapter NO-ERROR.

    FOR FIRST estabelec NO-LOCK
        WHERE estabelec.cod-estabel = tt-docto-adapter.cod-estabel:
    END.
    IF  NOT AVAIL estabelec THEN
        FOR FIRST estabelec NO-LOCK
            WHERE estabelec.cgc = tt-docto-adapter.estab-cgc:

            ASSIGN tt-docto-adapter.cod-estabel = estabelec.cod-estabel.
        END.
        IF  NOT AVAIL estabelec THEN DO:

            /* Inicio -- Projeto Internacional */
            {utp/ut-liter.i "Estabelecimento" *}
            RUN utp/ut-msgs.p (INPUT "msg":U, 
                               INPUT 2, 
                               INPUT RETURN-VALUE).

            CREATE RowErrors.
            ASSIGN RowErrors.ErrorSubType     = "ERROR":U
                   RowErrors.ErrorNumber      = 2
                   RowErrors.ErrorDescription = RETURN-VALUE.
            RETURN "OK":U.
        END.

    /*PROCESSO DE ELIMINAÄ«O OU CANCELAMENTO DE NOTAS FISCAIS*/
    CASE cTransactionType:
        WHEN "ELIMINAR":U THEN DO:

            RUN ftp/ftapi500a.p PERSISTENT SET h-ftapi500a.

            RUN pi-elimina-nota-fiscal IN h-ftapi500a (INPUT tt-docto-adapter.cod-estabel,
                                                       INPUT tt-docto-adapter.serie,
                                                       INPUT tt-docto-adapter.nr-nota-fis,
                                                       OUTPUT TABLE RowErrors).

            IF  VALID-HANDLE (h-ftapi500a) THEN DO:
                DELETE PROCEDURE h-ftapi500a.
                ASSIGN h-ftapi500a = ?.
            END.

        END.
        WHEN "CANCELAR":U THEN DO:

            RUN ftp/ftapi500a.p PERSISTENT SET h-ftapi500a.

            RUN pi-cancela-nota-fiscal IN h-ftapi500a (INPUT tt-docto-adapter.cod-estabel,
                                                       INPUT tt-docto-adapter.serie,
                                                       INPUT tt-docto-adapter.nr-nota-fis,
                                                       OUTPUT TABLE RowErrors).

            IF  VALID-HANDLE (h-ftapi500a) THEN DO:
                DELETE PROCEDURE h-ftapi500a.
                ASSIGN h-ftapi500a = ?.
            END.

        END.
        OTHERWISE
            RETURN "OK":U. /*Se o conte£do da tag TransactionType vier branco, ou seja, nem ELIMINAR nem CANCELAR, n∆o fazer nada e retornar*/
    END CASE.

    IF  CAN-FIND (FIRST RowErrors) THEN DO:
        FOR EACH RowErrors 
            WHERE RowErrors.errorNumber = 19531:
            DELETE RowErrors.
        END.

        FOR EACH RowErrors:
            RUN setError IN hMessageHandler (INPUT RowErrors.errorNumber,
                                             INPUT "enviroment_error":U,
                                             INPUT RowErrors.errorDescription).
        END.
    END.
