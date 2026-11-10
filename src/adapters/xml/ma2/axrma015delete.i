if not valid-handle(h-boin839) then
    run inbo/boin839.p persistent set h-boin839.

run emptyRowErrors in h-boin839.
run openQueryStatic in h-boin839 (input "Main":U) no-error.

run goToKey        in h-boin839 (input Manufacturer_00).
if return-value <> "NOK" then do:

    RUN deleteRecord   IN h-boin839.
    if return-value <> "ok" then do:
    
        run getRowErrors in h-boin839(output table RowErrors).
    
        FOR EACH RowErrors where RowErrors.ErrorType = "INTERNAL":U:
            DELETE RowErrors.
        END.
    
    END.

END.

IF VALID-HANDLE(h-boin839) THEN
    DELETE PROCEDURE h-boin839.

