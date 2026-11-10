/*---------------------------------------------------
@api: taxReports
@visibility: internal
@summary: <RESUMO-OBJETIVO>
@description: <DESCRIÇÃO-OBJETIVO>
---------------------------------------------------*/

USING Progress.Lang.Error.
USING com.totvs.framework.api.JsonApiResponseBuilder.

{utp/ut-api.i}
{utp/ut-api-utils.i}

{utp/ut-api-action.i pi-print-icms-helper-report PUT /printIcmsHelperReport/~* }

{utp/ut-api-notfound.i}

DEFINE VARIABLE apiHandler AS HANDLE NO-UNDO.
DEFINE VARIABLE apiHandlerImpr AS HANDLE NO-UNDO.

/*:T--- PROCEDURES V1 ---*/

PROCEDURE pi-print-icms-helper-report:
    DEFINE INPUT  PARAM oInput  AS JsonObject NO-UNDO.
    DEFINE OUTPUT PARAM oOutput AS JsonObject NO-UNDO.
    
	IF NOT VALID-HANDLE(apiHandlerImpr) THEN DO:
        RUN fisapi/apiTaxReports.p PERSISTENT SET apiHandlerImpr.
    END.

    RUN pi-print-icms-helper-report-v1 IN apiHandlerImpr (INPUT  oInput,
										                  OUTPUT oOutput,
										                  OUTPUT TABLE RowErrors).

    IF CAN-FIND(FIRST RowErrors WHERE UPPER(RowErrors.ErrorSubType) = 'ERROR':U) THEN DO:
        ASSIGN oOutput = JsonApiResponseBuilder:asError(TEMP-TABLE RowErrors:HANDLE).
    END.

    CATCH oE AS Error: 
        ASSIGN oOutput = JsonApiResponseBuilder:asError(oE,500). 
    END CATCH. 

    FINALLY: 
		IF VALID-HANDLE(apiHandlerImpr) THEN DO:
			DELETE PROCEDURE apiHandlerImpr NO-ERROR. 
		END.
    END FINALLY.
	
END PROCEDURE.
