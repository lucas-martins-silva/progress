if not valid-handle(h-boin840) then
    run inbo/boin840.p persistent set h-boin840.

run openQueryStatic in h-boin840 (input "Main":U) no-error.
                                
run emptyRowErrors in h-boin840.
run setRecord in h-boin840 (input table tt-fab-medic-item).
IF (cTranAction = "add") THEN
    run createRecord in h-boin840.
ELSE IF (cTranAction = "mod") THEN
    run UpdateRecord in h-boin840.

run getRowErrors in h-boin840(output table RowErrors).

FOR EACH RowErrors where RowErrors.ErrorType = "INTERNAL":U:
    DELETE RowErrors.
END.

IF CAN-FIND(FIRST RowErrors) THEN DO:
    FOR EACH RowErrors:
        RUN setError IN hMessageHandler (INPUT RowErrors.ErrorNumber, 
                                         INPUT "business_error":U, 
                                         INPUT RowErrors.ErrorDescription).
    END.
END.

IF VALID-HANDLE(h-boin840) THEN
    DELETE PROCEDURE h-boin840.

