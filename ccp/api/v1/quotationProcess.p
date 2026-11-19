/*---------------------------------------------------
@api: quotationProcess
@visibility: internal
@summary: <RESUMO-OBJETIVO>
@description: <DESCRIÇÃO-OBJETIVO>
---------------------------------------------------*/

USING Progress.Lang.Error.
USING com.totvs.framework.api.JsonApiResponseBuilder.

{utp/ut-api.i}
{utp/ut-api-utils.i}

{include/i-prgvrs.i quotationProcess 2.00.00.005 } /*** "010005" 24/08/2026 14:25:47 ***/
{include/i-license-manager.i quotationProcess MCC}

{utp/ut-api-action.i pi-get-vendor-quotations  GET /~*/vendors/~*/quotations/~*}
{utp/ut-api-action.i pi-get-vendors            GET /~*/vendors/~*}
{utp/ut-api-action.i pi-get-last-purchases     GET /lastpurchases/~*}
{utp/ut-api-action.i pi-get                    GET /~*/}
{utp/ut-api-action.i pi-query                  GET /~*}
{utp/ut-api-action.i pi-get-rtc                GET /rtc/~*}

{utp/ut-api-notfound.i}

DEFINE VARIABLE apiHandler AS HANDLE     NO-UNDO.
DEFINE VARIABLE objRoot    AS JsonObject NO-UNDO.

/*:T--- PROCEDURES V1 ---*/

PROCEDURE pi-get:
    DEFINE INPUT  PARAM oInput  AS JsonObject NO-UNDO.
    DEFINE OUTPUT PARAM oOutput AS JsonObject NO-UNDO.
    
    IF NOT VALID-HANDLE(apiHandler) THEN DO:
        RUN ccp/rules/quotationProcessRules.p PERSISTENT SET apiHandler.
    END.

    RUN pi-get-v1 IN apiHandler (
        INPUT oInput,
        OUTPUT oOutput,
        OUTPUT TABLE RowErrors
    ).

    IF CAN-FIND(FIRST RowErrors WHERE UPPER(RowErrors.ErrorSubType) = 'ERROR':U) THEN DO:
        ASSIGN oOutput = JsonApiResponseBuilder:asError(TEMP-TABLE RowErrors:HANDLE).
    END.
    ELSE DO:
        IF oOutput EQ ? THEN DO:
            ASSIGN oOutput = JsonApiResponseBuilder:empty(404).
        END.
        ELSE DO:
            /* realiza a chamada da UPC Progress */
            {include/i-epcrest.i  &endpoint=findById &event=findById &jsonVar=oOutput}
            
            ASSIGN oOutput = JsonApiResponseBuilder:ok(oOutput).
        END.
    END.

    CATCH oE AS Error:
        ASSIGN oOutput = JsonApiResponseBuilder:asError(oE).
    END CATCH.

    FINALLY: DELETE PROCEDURE apiHandler NO-ERROR. END FINALLY.

END PROCEDURE.

PROCEDURE pi-query:
    DEFINE INPUT  PARAM oInput    AS JsonObject NO-UNDO.
    DEFINE OUTPUT PARAM oOutput   AS JsonObject NO-UNDO.

    DEFINE VARIABLE lHasNext      AS LOGICAL   NO-UNDO.
    DEFINE VARIABLE aResult       AS JsonArray NO-UNDO.
    DEFINE VARIABLE aExpandables  AS JsonArray NO-UNDO.

    IF NOT VALID-HANDLE(apiHandler) THEN DO:
        RUN ccp/rules/quotationProcessRules.p PERSISTENT SET apiHandler.
    END.

    RUN pi-query-v1 IN apiHandler  (
        INPUT  oInput,
        OUTPUT aResult,
        OUTPUT lHasNext,
        OUTPUT aExpandables,
        OUTPUT TABLE RowErrors
    ).

    IF CAN-FIND(FIRST RowErrors WHERE UPPER(RowErrors.ErrorSubType) = 'ERROR':U) THEN DO:
        ASSIGN oOutput = JsonApiResponseBuilder:asError(TEMP-TABLE RowErrors:HANDLE).
    END.
    ELSE DO:
        /* realiza a chamada da UPC Progress */
        objRoot = NEW JsonObject().
        objRoot:ADD("root":U, aResult).

        {include/i-epcrest.i &endpoint=findAll &event=findAll &jsonVar=objRoot}

        aResult = objRoot:getJsonArray("root":U).
        /* fim chamada UPC */
        
        ASSIGN oOutput = JsonApiResponseBuilder:ok(aResult, lHasNext).

        IF aExpandables:LENGTH > 0 THEN 
            oOutput:getJsonObject("payload":U):add("_expandables":U, aExpandables).
    END.
    
    CATCH oE AS ERROR:
        ASSIGN oOutput = JsonApiResponseBuilder:asError(oE).
    END CATCH.
    
    FINALLY: 
        DELETE PROCEDURE apiHandler NO-ERROR. 
        DELETE OBJECT objRoot NO-ERROR.
    END FINALLY.

END PROCEDURE.

PROCEDURE pi-get-vendors:
    DEFINE INPUT  PARAM oInput  AS JsonObject NO-UNDO.
    DEFINE OUTPUT PARAM oOutput AS JsonObject NO-UNDO.
    
    DEFINE VARIABLE lHasNext      AS LOGICAL   NO-UNDO.
    DEFINE VARIABLE aResult       AS JsonArray NO-UNDO.
    DEFINE VARIABLE aExpandables  AS JsonArray NO-UNDO.
    
    IF NOT VALID-HANDLE(apiHandler) THEN DO:
        RUN ccp/rules/quotationProcessRules.p PERSISTENT SET apiHandler.
    END.

    RUN pi-get-vendors-v1 IN apiHandler (
        INPUT oInput,
        OUTPUT aResult,
        OUTPUT lHasNext,
        OUTPUT aExpandables,
        OUTPUT TABLE RowErrors
    ).

    IF CAN-FIND(FIRST RowErrors WHERE UPPER(RowErrors.ErrorSubType) = 'ERROR':U) THEN DO:
        ASSIGN oOutput = JsonApiResponseBuilder:asError(TEMP-TABLE RowErrors:HANDLE).
    END.
    ELSE DO:
        /* realiza a chamada da UPC Progress */
        objRoot = NEW JsonObject().
        objRoot:ADD("root":U, aResult).

        {include/i-epcrest.i &endpoint=findAllVendors &event=findAllVendors &jsonVar=objRoot}

        aResult = objRoot:getJsonArray("root":U).
        /* fim chamada UPC */
        
        ASSIGN oOutput = JsonApiResponseBuilder:ok(aResult, lHasNext).

        IF aExpandables:LENGTH > 0 THEN 
            oOutput:getJsonObject("payload":U):add("_expandables":U, aExpandables).
    END.
    
    CATCH oE AS ERROR:
        ASSIGN oOutput = JsonApiResponseBuilder:asError(oE).
    END CATCH.
    
    FINALLY: 
        DELETE PROCEDURE apiHandler NO-ERROR.
        DELETE OBJECT objRoot NO-ERROR.
    END FINALLY.

END PROCEDURE.

PROCEDURE pi-get-vendor-quotations:
    DEFINE INPUT  PARAM oInput  AS JsonObject NO-UNDO.
    DEFINE OUTPUT PARAM oOutput AS JsonObject NO-UNDO.
    
    DEFINE VARIABLE lHasNext      AS LOGICAL   NO-UNDO.
    DEFINE VARIABLE aResult       AS JsonArray NO-UNDO.
    DEFINE VARIABLE aExpandables  AS JsonArray NO-UNDO.
    
    IF NOT VALID-HANDLE(apiHandler) THEN DO:
        RUN ccp/rules/quotationProcessRules.p PERSISTENT SET apiHandler.
    END.

    RUN pi-get-vendor-quotations-v1 IN apiHandler (
        INPUT oInput,
        OUTPUT aResult,
        OUTPUT lHasNext,
        OUTPUT aExpandables,
        OUTPUT TABLE RowErrors
    ).

    IF CAN-FIND(FIRST RowErrors WHERE UPPER(RowErrors.ErrorSubType) = 'ERROR':U) THEN DO:
        ASSIGN oOutput = JsonApiResponseBuilder:asError(TEMP-TABLE RowErrors:HANDLE).
    END.
    ELSE DO:
        /* realiza a chamada da UPC Progress */
        objRoot = NEW JsonObject().
        objRoot:ADD("root":U, aResult).

        {include/i-epcrest.i &endpoint=findAllVendorQuotations &event=findAllVendorQuotations &jsonVar=objRoot}

        aResult = objRoot:getJsonArray("root":U).
        /* fim chamada UPC */
        
        ASSIGN oOutput = JsonApiResponseBuilder:ok(aResult, lHasNext).

        IF aExpandables:LENGTH > 0 THEN 
            oOutput:getJsonObject("payload":U):add("_expandables":U, aExpandables).
    END.
    
    CATCH oE AS ERROR:
        ASSIGN oOutput = JsonApiResponseBuilder:asError(oE).
    END CATCH.
    
    FINALLY:
        DELETE PROCEDURE apiHandler NO-ERROR.
        DELETE OBJECT objRoot NO-ERROR.
    END FINALLY.

END PROCEDURE.

PROCEDURE pi-get-last-purchases:
    DEFINE INPUT  PARAM oInput  AS JsonObject NO-UNDO.
    DEFINE OUTPUT PARAM oOutput AS JsonObject NO-UNDO.
    
    DEFINE VARIABLE aResult       AS JsonArray NO-UNDO.
    
    IF NOT VALID-HANDLE(apiHandler) THEN DO:
        RUN ccp/rules/quotationProcessRules.p PERSISTENT SET apiHandler.
    END.

    RUN pi-get-last-purchases-v1 IN apiHandler (
        INPUT oInput,
        OUTPUT aResult,
        OUTPUT TABLE RowErrors
    ).

    IF CAN-FIND(FIRST RowErrors WHERE UPPER(RowErrors.ErrorSubType) = 'ERROR':U) THEN DO:
        ASSIGN oOutput = JsonApiResponseBuilder:asError(TEMP-TABLE RowErrors:HANDLE).
    END.
    ELSE DO:
        /* realiza a chamada da UPC Progress */
        objRoot = NEW JsonObject().
        objRoot:ADD("root":U, aResult).

        {include/i-epcrest.i &endpoint=findAllVendorQuotations &event=findAllVendorQuotations &jsonVar=objRoot}

        aResult = objRoot:getJsonArray("root":U).
        /* fim chamada UPC */
        
        ASSIGN oOutput = JsonApiResponseBuilder:ok(aResult, FALSE).

    END.
    
    CATCH oE AS ERROR:
        ASSIGN oOutput = JsonApiResponseBuilder:asError(oE).
    END CATCH.
    
    FINALLY:
        DELETE PROCEDURE apiHandler NO-ERROR.
        DELETE OBJECT objRoot NO-ERROR.
    END FINALLY.

END PROCEDURE.

PROCEDURE pi-get-rtc:
    DEFINE INPUT  PARAM oInput  AS JsonObject NO-UNDO.
    DEFINE OUTPUT PARAM oOutput AS JsonObject NO-UNDO.

    DEFINE VARIABLE aResult AS JsonArray NO-UNDO.

    IF NOT VALID-HANDLE(apiHandler) THEN DO:
        RUN ccp/rules/quotationProcessRules.p PERSISTENT SET apiHandler.
    END.
    LOG-MANAGER:WRITE-MESSAGE(">>> RTC camada") NO-ERROR.
    RUN pi-get-rtc-v1 IN apiHandler (
        INPUT  oInput,
        OUTPUT aResult,
        OUTPUT TABLE RowErrors
    ).

    IF CAN-FIND(FIRST RowErrors WHERE UPPER(RowErrors.ErrorSubType) = 'ERROR':U) THEN DO:
        ASSIGN oOutput = JsonApiResponseBuilder:asError(TEMP-TABLE RowErrors:HANDLE).
    END.
    ELSE DO:
        ASSIGN oOutput = JsonApiResponseBuilder:ok(aResult, FALSE).
    END.

    CATCH oE AS Error:
        ASSIGN oOutput = JsonApiResponseBuilder:asError(oE).
    END CATCH.

    FINALLY:
        DELETE PROCEDURE apiHandler NO-ERROR.
    END FINALLY.
END PROCEDURE.
