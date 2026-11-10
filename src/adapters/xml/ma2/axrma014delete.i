if not valid-handle(h-boin840) then
    run inbo/boin840.p persistent set h-boin840.

run emptyRowErrors in h-boin840.
run openQueryStatic in h-boin840 (input "Main":U) no-error.

run goToKey        in h-boin840 (input ItemCode,
                                 INPUT Manufacturer_00).
if return-value <> "NOK" then do:

    RUN deleteRecord   IN h-boin840.
    if return-value <> "ok" then do:
    
        run getRowErrors in h-boin840(output table RowErrors).
    
        FOR EACH RowErrors where RowErrors.ErrorType = "INTERNAL":U:
            DELETE RowErrors.
        END.
    
    END.

END.

IF VALID-HANDLE(h-boin840) THEN
    DELETE PROCEDURE h-boin840.