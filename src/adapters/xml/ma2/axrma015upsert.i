if not valid-handle(h-boin839) then
    run inbo/boin839.p persistent set h-boin839.

run openQueryStatic in h-boin839 (input "Main":U) no-error.
                                
run emptyRowErrors in h-boin839.

run gotoKey IN h-boin839 (input tt-fab-medic.cdn-fabrican).
run setRecord in h-boin839 (input table tt-fab-medic).

IF (cTranAction = "add") THEN
    run createRecord in h-boin839.
ELSE IF (cTranAction = "upd") THEN
    run UpdateRecord in h-boin839.

run getRowErrors in h-boin839(output table RowErrors).

FOR EACH RowErrors where RowErrors.ErrorType = "INTERNAL":U:
    DELETE RowErrors.
END.

IF VALID-HANDLE(h-boin839) THEN
    DELETE PROCEDURE h-boin839.



