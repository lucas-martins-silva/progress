BLOCK-LEVEL ON ERROR UNDO, THROW.

USING PROGRESS.json.*.
USING PROGRESS.json.ObjectModel.*.
USING com.totvs.framework.api.*.
USING com.totvs.po.*.

/*
    API com Regras de negocio - quotationProcess (solicit-cotac)
    Data: 13/10/2022
*/

{include/i-prgvrs.i quotationProcess 2.00.00.004 } /*** "010004" 09/07/2024 12:03:15 ***/
{include/i-license-manager.i quotationProcess ccp}

{include/i-dynqry-doc.i 
           &tables="solicit-cotac":U
           &fields=" solicit-cotac.cdd-solicit solicit-cotac.cod-usuar-solic solicit-cotac.cod-usuar-criac solicit-cotac.dtm-criac solicit-cotac.dtm-expirac solicit-cotac.dtm-liber solicit-cotac.des-solicit solicit-cotac.log-responde-via-web solicit-cotac.log-planilha-envda solicit-cotac.log-confir-entreg solicit-cotac.log-confir-recebto":U
           &indexes="solicit-cotac.slctctc_id2":U}

{method/dbotterr.i}
{inbo/boin01028.i QuotationProcessPersistent}
{inbo/boin01030.i QuotationProcessVendorPersistent}
{cdp/utils.i}
{rep/utils/errorUtil.i}

{ccp/rules/quotationProcessV1.i QuotationProcess}
{ccp/rules/quotationProcessVendorV1.i QuotationProcessVendor}
{ccp/rules/quotationsV1.i VendorQuotationsByProcess}
{fch/fchmat/fchmatenterquotations.i}      /* ttQuotations */
{fch/fchmat/fchmatlastpurchaseofitem.i ttNumLastPurchaseOfItem}

DEFINE VARIABLE boHandler AS HANDLE NO-UNDO.

DEFINE TEMP-TABLE ttLastPurchaseOfItem LIKE ttNumLastPurchaseOfItem
    FIELD currencyCode AS INTEGER.
    
DEFINE TEMP-TABLE ttLastPurchaseOfItemVendor LIKE ttLastPurchaseOfItem
    FIELD typeLastPurchase AS CHARACTER.

/*:T--- FUNCTIONS ---*/

FUNCTION fn-get-id-from-path RETURNS CHARACTER (
    INPUT oRequest AS JsonAPIRequestParser,
    INPUT iPosition AS INTEGER
):
    RETURN oRequest:getPathParams():GetCharacter(iPosition).
END FUNCTION.  

FUNCTION fn-has-row-errors RETURNS LOGICAL ():

    FOR EACH RowErrors 
        WHERE UPPER(RowErrors.ErrorType) = 'INTERNAL':U:
        DELETE RowErrors. 
    END.

    RETURN CAN-FIND(FIRST RowErrors 
        WHERE UPPER(RowErrors.ErrorSubType) = 'ERROR':U).
    
END FUNCTION.

FUNCTION isToReturnTheField RETURNS LOGICAL (
    INPUT cField AS CHAR,
    INPUT cExcept AS CHAR
):
    RETURN cExcept = "":U OR lookup(cField, cExcept) = 0.
END FUNCTION.

/*:T--- DOMAIN PROCEDURES V1 ---*/
/*:T--- QUERY PROCEDURES V1 ---*/

PROCEDURE pi-get-v1:
    DEFINE INPUT  PARAM oInput  AS JsonObject NO-UNDO.
    DEFINE OUTPUT PARAM oOutput AS JsonObject NO-UNDO.
    DEFINE OUTPUT PARAM TABLE FOR RowErrors.

    DEFINE VARIABLE oRequest     AS JsonAPIRequestParser NO-UNDO.
    DEFINE VARIABLE cExcept      AS CHARACTER            NO-UNDO.
    DEFINE VARIABLE aExpandables AS JsonArray            NO-UNDO.
    
    DEFINE VARIABLE key_cdd-solicit AS DECIMAL NO-UNDO.

    ASSIGN oRequest = NEW JsonAPIRequestParser(oInput).

    ASSIGN key_cdd-solicit = DECIMAL(fn-get-id-from-path(oRequest,1)).

    ASSIGN cExcept = JsonAPIUtils:getTableExceptFieldsBySerializedFields(
        TEMP-TABLE QuotationProcess:HANDLE, oRequest:getFields()
    ).

    FOR FIRST solicit-cotac FIELDS (
         cdd-solicit cod-usuar-solic cod-usuar-criac dtm-criac dtm-expirac dtm-liber des-solicit log-responde-via-web log-planilha-envda log-confir-entreg log-confir-recebto
    ) NO-LOCK 
        WHERE solicit-cotac.cdd-solicit = key_cdd-solicit:
        
        CREATE QuotationProcess.
        TEMP-TABLE QuotationProcess:HANDLE:DEFAULT-BUFFER-HANDLE:BUFFER-COPY(
            BUFFER solicit-cotac:HANDLE, cExcept
        ).
        RUN findExtraFields (INPUT cExcept).
        RUN findExpandables (INPUT oRequest:getExpandChar()).

        ASSIGN oOutput = JsonAPIUtils:convertTempTableFirstItemToJsonObject(
            TEMP-TABLE QuotationProcess:HANDLE, (LENGTH(TRIM(cExcept)) > 0)
        ).
        RUN informationExpandables (INPUT oRequest:getExpandChar(),
                                    OUTPUT aExpandables).
        IF aExpandables:LENGTH > 0 THEN oOutput:add("_expandables":U, aExpandables).
    END.
    
    CATCH eSysError AS Progress.Lang.SysError:
        RUN piCreateTechnicalError (eSysError:getMessage(1)).
    END.
    FINALLY: 
        DELETE OBJECT oRequest NO-ERROR.
        IF fn-has-row-errors() THEN DO:
            UNDO, RETURN 'NOK':U.
        END.
    END FINALLY.

END PROCEDURE.

PROCEDURE pi-query-v1:
    DEFINE INPUT  PARAM oInput        AS JsonObject NO-UNDO.
    DEFINE OUTPUT PARAM aOutput       AS JsonArray  NO-UNDO.
    DEFINE OUTPUT PARAM lHasNext      AS LOGICAL    NO-UNDO INITIAL FALSE.
    DEFINE OUTPUT PARAM aExpandables  AS JsonArray  NO-UNDO.
    DEFINE OUTPUT PARAM TABLE FOR RowErrors.

    EMPTY TEMP-TABLE RowErrors.
    EMPTY TEMP-TABLE QuotationProcess.

    DEFINE VARIABLE oRequest   AS JsonAPIRequestParser  NO-UNDO.
    DEFINE VARIABLE iCount     AS INTEGER INITIAL 0     NO-UNDO.

    DEFINE VARIABLE cExcept    AS CHARACTER             NO-UNDO.
    DEFINE VARIABLE cQuery     AS CHARACTER             NO-UNDO.
    DEFINE VARIABLE cQueryName AS CHARACTER             NO-UNDO.
    DEFINE VARIABLE cBy        AS CHARACTER             NO-UNDO.
    DEFINE VARIABLE cMatches   AS CHARACTER             NO-UNDO.

    ASSIGN oRequest = NEW JsonAPIRequestParser(oInput).

    ASSIGN cExcept = JsonAPIUtils:getTableExceptFieldsBySerializedFields(
        TEMP-TABLE QuotationProcess:HANDLE, oRequest:getFields()
    ).
    
    ASSIGN cQuery = 'FOR EACH solicit-cotac NO-LOCK':U.

    IF oRequest:getQueryParams():has("search":U) OR (oRequest:getQueryParams():has("filter":U) AND oRequest:getQueryParams():GetJsonArray("filter":U):getCharacter(1) <> "":U) THEN DO:
        ASSIGN cMatches = IF oRequest:getQueryParams():has("search":U) THEN 
                              oRequest:getQueryParams():GetJsonArray('search':U):getCharacter(1) 
                          ELSE  
                              oRequest:getQueryParams():GetJsonArray('filter':U):getCharacter(1).


        ASSIGN cQuery = cQuery + IF (INDEX(cQuery, "WHERE":U) > 0) THEN ' AND (':U ELSE ' WHERE (':U 
                               + ' STRING(solicit-cotac.cdd-solicit) MATCHES("*' + cMatches + '*") ':U
                               + ') ':U .
    END. 
    ELSE DO:
        ASSIGN cQuery   = buildWhereLogMatches(TEMP-TABLE QuotationProcess:HANDLE, oRequest:getQueryParams(), "":U, cQuery, FALSE)                                 // FUNCTION buildWhereLogMatches NA INCLUDE CDP/UTILS.I
               cBy      = buildByWithOnlyMainTableFields(TEMP-TABLE QuotationProcess:HANDLE, TEMP-TABLE QuotationProcessPersistent:HANDLE, oRequest:getOrder()). // FUNCTION buildByWithOnlyMainTableFields    NA INCLUDE CDP/UTILS.I

    END.

    ASSIGN cQuery = cQuery + cBy.

    DEFINE QUERY findQuery FOR solicit-cotac 
        FIELDS( cdd-solicit cod-usuar-solic cod-usuar-criac dtm-criac dtm-expirac dtm-liber des-solicit log-responde-via-web log-planilha-envda log-confir-entreg log-confir-recebto)
    SCROLLING.

    QUERY findQuery:QUERY-PREPARE(cQuery).
    QUERY findQuery:QUERY-OPEN().
    QUERY findQuery:REPOSITION-TO-ROW(oRequest:getStartRow()).

    REPEAT:

        GET NEXT findQuery.
        IF QUERY findQuery:QUERY-OFF-END THEN LEAVE.

        IF oRequest:getPageSize() EQ iCount THEN DO:
            ASSIGN lHasNext = TRUE.
            LEAVE.
        END.

        CREATE QuotationProcess.
        TEMP-TABLE QuotationProcess:HANDLE:DEFAULT-BUFFER-HANDLE:BUFFER-COPY(
            BUFFER solicit-cotac:HANDLE, cExcept
        ).

        RUN findExtraFields (INPUT cExcept).
        RUN findExpandables (INPUT oRequest:getExpandChar()).

        ASSIGN iCount = iCount + 1.
    END.
    QUERY findQuery:QUERY-CLOSE().

    ASSIGN aOutput = JsonAPIUtils:convertTempTableToJsonArray(
        TEMP-TABLE QuotationProcess:HANDLE, (LENGTH(TRIM(cExcept)) > 0)
    ).
    RUN informationExpandables (INPUT oRequest:getExpandChar(),
                                OUTPUT aExpandables).

    CATCH eSysError AS Progress.Lang.SysError:
        RUN piCreateTechnicalError (eSysError:getMessage(1)).
    END.
    FINALLY: 
        DELETE OBJECT oRequest NO-ERROR.
        DELETE OBJECT (QUERY findQuery:HANDLE) NO-ERROR.
        IF fn-has-row-errors() THEN DO:
            UNDO, RETURN 'NOK':U.
        END.
    END FINALLY.

END PROCEDURE.

/*:T--- PRIVATE PROCEDURES ---*/

/**
* Busca os campos extras que nao pertencem a entidade principal
*/
PROCEDURE findExtraFields PRIVATE:
    DEFINE INPUT  PARAM cExcept  AS CHAR    NO-UNDO.

    IF NOT AVAIL solicit-cotac OR NOT AVAIL QuotationProcess THEN 
        RETURN "NOK":U.

    IF isToReturnTheField("name-do-campo-extra-field":U, cExcept) THEN DO:
        // logica para buscar o campo extra
    END.

    RETURN "OK":U.
END PROCEDURE.

PROCEDURE findExtraFieldsVendor PRIVATE:
    DEFINE INPUT  PARAM cExcept  AS CHAR    NO-UNDO.

    IF NOT AVAIL fornec-solicit-cotac OR NOT AVAIL QuotationProcessVendor THEN 
        RETURN "NOK":U.

    {cdp/findemitente.i fornec-solicit-cotac.cdn-fornec}
    IF AVAIL emitente THEN DO:
        IF isToReturnTheField("nome-abrev":U, cExcept) THEN 
            ASSIGN QuotationProcessVendor.nome-abrev = emitente.nome-abrev.
        
        IF isToReturnTheField("nome-emit":U, cExcept) THEN 
            ASSIGN QuotationProcessVendor.nome-emit = emitente.nome-emit.
       
        IF isToReturnTheField("cgc":U, cExcept) THEN DO:
            ASSIGN QuotationProcessVendor.cgc = emitente.cgc.
        END.
    END.
    
    RETURN "OK":U.
END PROCEDURE.

/**
* Busca as sub-listas (expand=ListaXyz) referentes a entidade principal
*/
PROCEDURE findExpandables PRIVATE:
    DEFINE INPUT  PARAM cExpand  AS CHAR    NO-UNDO.

    IF NOT AVAIL solicit-cotac OR NOT AVAIL QuotationProcess THEN 
        RETURN "NOK":U.

    IF LOOKUP("listaXYZ":U, cExpand) > 0 THEN DO: /* foi enviado parametro para expandir listaXYZ */
        // logica para expandir lista XYZ
    END.

    RETURN "OK":U.
END PROCEDURE.

/**
* Retorna para o chamador a quais sub-listas podem ser expandidas
*/
PROCEDURE informationExpandables PRIVATE:
    DEFINE INPUT  PARAM cExpand       AS CHAR       NO-UNDO.
    DEFINE OUTPUT PARAM aExpandables  AS JsonArray  NO-UNDO.

    aExpandables = NEW JsonArray().

    /* IF INDEX(cExpand, "listaXYZ":U) = 0 THEN
        aExpandables:ADD("listaXYZ":U). */

    RETURN "OK":U.
END PROCEDURE.

PROCEDURE pi-get-rtc-v1:
    DEFINE INPUT  PARAM oInput  AS JsonObject NO-UNDO.
    DEFINE OUTPUT PARAM aOutput AS JsonArray  NO-UNDO.
    DEFINE OUTPUT PARAM TABLE FOR RowErrors.

    DEFINE VARIABLE oRtc          AS JsonObject NO-UNDO.
    DEFINE VARIABLE l-nt2024002   AS LOGICAL    NO-UNDO.

    EMPTY TEMP-TABLE RowErrors.
    LOG-MANAGER:WRITE-MESSAGE(">>> RTC") NO-ERROR.
    ASSIGN l-nt2024002 = CAN-FIND(FIRST funcao NO-LOCK
        WHERE funcao.cd-funcao = "spp-nt2024002":U
          AND funcao.ativo
    ).
    LOG-MANAGER:WRITE-MESSAGE(">>> l-nt2024002: " + STRING(l-nt2024002)) NO-ERROR.
    

    ASSIGN aOutput = NEW JsonArray().
    ASSIGN oRtc = NEW JsonObject().

    oRtc:ADD("lRTC":U, l-nt2024002).
    aOutput:ADD(oRtc).

    FINALLY:
        DELETE OBJECT oRtc NO-ERROR.
    END FINALLY.
END PROCEDURE.

PROCEDURE pi-get-vendors-v1:
    DEFINE INPUT  PARAM oInput        AS JsonObject NO-UNDO.
    DEFINE OUTPUT PARAM aOutput       AS JsonArray  NO-UNDO.
    DEFINE OUTPUT PARAM lHasNext      AS LOGICAL    NO-UNDO INITIAL FALSE.
    DEFINE OUTPUT PARAM aExpandables  AS JsonArray  NO-UNDO.
    DEFINE OUTPUT PARAM TABLE FOR RowErrors.

    EMPTY TEMP-TABLE RowErrors.
    
    DEFINE VARIABLE oRequest   AS JsonAPIRequestParser  NO-UNDO.
    DEFINE VARIABLE iCount     AS INTEGER INITIAL 0     NO-UNDO.

    DEFINE VARIABLE cExcept    AS CHARACTER             NO-UNDO.
    DEFINE VARIABLE cQuery     AS CHARACTER             NO-UNDO.
    DEFINE VARIABLE cBy        AS CHARACTER             NO-UNDO.

    DEFINE VARIABLE key_cdd-solicit AS DECIMAL          NO-UNDO.
    DEFINE VARIABLE key_cdn-fornec  AS INTEGER          NO-UNDO.

    ASSIGN oRequest = NEW JsonAPIRequestParser(oInput).

    ASSIGN key_cdd-solicit = DECIMAL(fn-get-id-from-path(oRequest,1)).
    RUN validateQuotationProcess (INPUT key_cdd-solicit).
    
    IF oRequest:getPathParams():LENGTH > 2 THEN DO:
        ASSIGN key_cdn-fornec  = INTEGER(fn-get-id-from-path(oRequest,3)).
        RUN validateVendorQuotationProcess (INPUT key_cdd-solicit, key_cdn-fornec).
    END.
    
    IF fn-has-row-errors() THEN DO:
        UNDO, RETURN 'NOK':U.
    END.
    
    ASSIGN cExcept = JsonAPIUtils:getTableExceptFieldsBySerializedFields(
        TEMP-TABLE QuotationProcessVendor:HANDLE, oRequest:getFields()
    ).
    
    ASSIGN cQuery = 'FOR EACH fornec-solicit-cotac NO-LOCK':U
                  + ' WHERE fornec-solicit-cotac.cdd-solicit = ':U + STRING(key_cdd-solicit).
    IF key_cdn-fornec > 0 THEN DO:
        ASSIGN cQuery = cQuery + ' AND fornec-solicit-cotac.cdn-fornec = ':U + STRING(key_cdn-fornec).
    END.

    
    ASSIGN cQuery   = buildWhereLogMatches(TEMP-TABLE QuotationProcessVendor:HANDLE, oRequest:getQueryParams(), "":U, cQuery, FALSE)                                 // FUNCTION buildWhereLogMatches NA INCLUDE CDP/UTILS.I
           cBy      = buildByWithOnlyMainTableFields(TEMP-TABLE QuotationProcessVendor:HANDLE, TEMP-TABLE QuotationProcessVendorPersistent:HANDLE, oRequest:getOrder()). // FUNCTION buildByWithOnlyMainTableFields    NA INCLUDE CDP/UTILS.I
 
    ASSIGN cQuery = cQuery + cBy.

    DEFINE QUERY findQuery FOR fornec-solicit-cotac SCROLLING.

    QUERY findQuery:QUERY-PREPARE(cQuery).
    QUERY findQuery:QUERY-OPEN().
    QUERY findQuery:REPOSITION-TO-ROW(oRequest:getStartRow()).

    REPEAT:

        GET NEXT findQuery.
        IF QUERY findQuery:QUERY-OFF-END THEN LEAVE.

        IF oRequest:getPageSize() EQ iCount THEN DO:
            ASSIGN lHasNext = TRUE.
            LEAVE.
        END.

        CREATE QuotationProcessVendor.
        TEMP-TABLE QuotationProcessVendor:HANDLE:DEFAULT-BUFFER-HANDLE:BUFFER-COPY(
            BUFFER fornec-solicit-cotac:HANDLE, cExcept
            ).
        ASSIGN QuotationProcessVendor.l-nt2024002 = CAN-FIND(FIRST funcao NO-LOCK
            WHERE funcao.cd-funcao = "spp-nt2024002":U
              AND funcao.ativo).

        RUN findExtraFieldsVendor (INPUT cExcept).

        ASSIGN iCount = iCount + 1.
    END.
    QUERY findQuery:QUERY-CLOSE().

    ASSIGN aOutput = JsonAPIUtils:convertTempTableToJsonArray(
        TEMP-TABLE QuotationProcessVendor:HANDLE, (LENGTH(TRIM(cExcept)) > 0)
    ).

    RUN informationExpandables (INPUT oRequest:getExpandChar(),
                                OUTPUT aExpandables).
        
    CATCH eSysError AS Progress.Lang.SysError:
        RUN piCreateTechnicalError (eSysError:getMessage(1)).
    END.
    FINALLY: 
        DELETE OBJECT oRequest NO-ERROR.
        DELETE OBJECT (QUERY findQuery:HANDLE) NO-ERROR.
        IF fn-has-row-errors() THEN DO:
            UNDO, RETURN 'NOK':U.
        END.
    END FINALLY.

END PROCEDURE.

PROCEDURE pi-get-vendor-quotations-v1:
    DEFINE INPUT  PARAM oInput        AS JsonObject NO-UNDO.
    DEFINE OUTPUT PARAM aOutput       AS JsonArray  NO-UNDO.
    DEFINE OUTPUT PARAM lHasNext      AS LOGICAL    NO-UNDO INITIAL FALSE.
    DEFINE OUTPUT PARAM aExpandables  AS JsonArray  NO-UNDO.
    DEFINE OUTPUT PARAM TABLE FOR RowErrors.

    EMPTY TEMP-TABLE RowErrors.
    
    DEFINE VARIABLE oRequest                       AS JsonAPIRequestParser NO-UNDO.
    DEFINE VARIABLE cExcept                        AS CHARACTER            NO-UNDO.
    DEFINE VARIABLE cSearch                        AS CHARACTER            NO-UNDO.  
    DEFINE VARIABLE iVisualizarOrdens              AS INTEGER              NO-UNDO.
    DEFINE VARIABLE key_cdn-fornec                 AS INTEGER              NO-UNDO.
    DEFINE VARIABLE key_cdd-solicit                AS DECIMAL              NO-UNDO. 
    DEFINE VARIABLE h-fchmatenterpackagequotations AS HANDLE               NO-UNDO.

    ASSIGN oRequest = NEW JsonAPIRequestParser(oInput).

    ASSIGN key_cdd-solicit = DECIMAL(fn-get-id-from-path(oRequest,1)).
    RUN validateQuotationProcess (INPUT key_cdd-solicit).
    
    IF oRequest:getPathParams():LENGTH > 2 THEN DO:
        ASSIGN key_cdn-fornec  = INTEGER(fn-get-id-from-path(oRequest,3)).
        RUN validateVendorQuotationProcess (INPUT key_cdd-solicit, key_cdn-fornec).
    END.
        
    IF fn-has-row-errors() THEN DO:
        UNDO, RETURN 'NOK':U.
    END.
    
    ASSIGN cExcept = JsonAPIUtils:getTableExceptFieldsBySerializedFields(
        TEMP-TABLE VendorQuotationsByProcess:HANDLE, oRequest:getFields()
    ).
    
    ASSIGN iVisualizarOrdens = 2.
    IF oRequest:getQueryParams():has("onlyWithoutQuotation":U) AND 
       oRequest:getQueryParams():GetJsonArray("onlyWithoutQuotation":U):GetCharacter(1) = 'true' THEN 
       ASSIGN iVisualizarOrdens = 1.
       
    IF oRequest:getQueryParams():has("search":U) OR (oRequest:getQueryParams():has("filter":U) AND oRequest:getQueryParams():GetJsonArray("filter":U):getCharacter(1) <> "":U) THEN DO:
        ASSIGN cSearch = IF oRequest:getQueryParams():has("search":U) THEN 
                            oRequest:getQueryParams():GetJsonArray('search':U):getCharacter(1) 
                         ELSE  
                            oRequest:getQueryParams():GetJsonArray('filter':U):getCharacter(1).
    END.
       
    RUN fch/fchmat/fchmatenterpackagequotations.p PERSISTENT SET h-fchmatenterpackagequotations.
    RUN getQuotationsByQuotationProcess IN h-fchmatenterpackagequotations (INPUT key_cdd-solicit,
                                                                           INPUT key_cdn-fornec,
                                                                           INPUT iVisualizarOrdens,
                                                                           INPUT cSearch,
                                                                           OUTPUT TABLE ttQuotations).
                                                                             
    FOR EACH ttQuotations NO-LOCK:
        CREATE VendorQuotationsByProcess.
        BUFFER-COPY ttQuotations TO VendorQuotationsByProcess NO-ERROR.
        FOR FIRST ITEM fields(inform-compl) NO-LOCK WHERE ITEM.it-codigo = ttQuotations.it-codigo:
            ASSIGN VendorQuotationsByProcess.inform-compl = ITEM.inform-compl.
        END.
    END.

    ASSIGN aOutput = JsonAPIUtils:convertTempTableToJsonArray(
        TEMP-TABLE VendorQuotationsByProcess:HANDLE, (LENGTH(TRIM(cExcept)) > 0)
    ).

    RUN informationExpandables (INPUT oRequest:getExpandChar(),
                                OUTPUT aExpandables).
        
    CATCH eSysError AS Progress.Lang.SysError:
        RUN piCreateTechnicalError (eSysError:getMessage(1)).
    END.
    FINALLY: 
        DELETE OBJECT oRequest NO-ERROR.
        DELETE PROCEDURE h-fchmatenterpackagequotations NO-ERROR.
        IF fn-has-row-errors() THEN DO:
            UNDO, RETURN 'NOK':U.
        END.
    END FINALLY.

END PROCEDURE.

PROCEDURE validateQuotationProcess:
    DEFINE INPUT  PARAMETER pCddSolicit AS DECIMAL NO-UNDO.
    
    DEFINE VARIABLE h-boin01028 AS HANDLE NO-UNDO.
    
    RUN inbo/boin01028.p PERSISTENT SET h-boin01028.
    RUN emptyRowErrors IN h-boin01028.
    RUN findByKey IN h-boin01028 (INPUT pCddSolicit).
    IF RETURN-VALUE = "NOK":U THEN
        RUN getRowErrors IN h-boin01028(OUTPUT TABLE RowErrors APPEND).
    
    DELETE PROCEDURE h-boin01028.
    ASSIGN h-boin01028 = ?.
    
    RETURN "OK":U.
END PROCEDURE.

PROCEDURE validateVendorQuotationProcess:
    DEFINE INPUT  PARAMETER pCddSolicit AS DECIMAL NO-UNDO.
    DEFINE INPUT  PARAMETER pCdnFornec  AS INTEGER NO-UNDO.
    
    DEFINE VARIABLE h-boin01030 AS HANDLE NO-UNDO.
    
    RUN inbo/boin01030.p PERSISTENT SET h-boin01030.
    RUN emptyRowErrors IN h-boin01030.
    RUN findByKey IN h-boin01030 (INPUT pCddSolicit,
                                  INPUT pCdnFornec).
    IF RETURN-VALUE = "NOK":U THEN
        RUN getRowErrors IN h-boin01030 (OUTPUT TABLE RowErrors APPEND).
       
    DELETE PROCEDURE h-boin01030.
    ASSIGN h-boin01030 = ?.
    
    RETURN "OK":U.
END PROCEDURE.


PROCEDURE pi-get-last-purchases-v1:
    DEFINE INPUT  PARAM oInput        AS JsonObject NO-UNDO.
    DEFINE OUTPUT PARAM aOutput       AS JsonArray  NO-UNDO.
    DEFINE OUTPUT PARAM TABLE FOR RowErrors.

    EMPTY TEMP-TABLE RowErrors.
    
    DEFINE VARIABLE oRequest                AS JsonAPIRequestParser        NO-UNDO.
    DEFINE VARIABLE cExcept                 AS CHARACTER                   NO-UNDO.
    DEFINE VARIABLE key_it-codigo           LIKE ITEM.it-codigo            NO-UNDO.
    DEFINE VARIABLE key_numero-ordem        LIKE ordem-compra.numero-ordem NO-UNDO.
    DEFINE VARIABLE key_un                  AS CHARACTER                   NO-UNDO.
    DEFINE VARIABLE key_cdn-fornec          AS INTEGER                     NO-UNDO.
    DEFINE VARIABLE cCodEstabel             AS CHARACTER                   NO-UNDO.
    DEFINE VARIABLE h-boin082fx             AS HANDLE                      NO-UNDO.
    
    ASSIGN oRequest = NEW JsonAPIRequestParser(oInput).

    ASSIGN key_it-codigo    = fn-get-id-from-path(oRequest,2).
    ASSIGN key_numero-ordem = integer(fn-get-id-from-path(oRequest,3)).
    ASSIGN key_un           = fn-get-id-from-path(oRequest,4).
    ASSIGN key_cdn-fornec   = integer(fn-get-id-from-path(oRequest,5)).
    
    //Busca estabelec
    FOR FIRST ordem-compra FIELDS(cod-estabel) NO-LOCK WHERE ordem-compra.numero-ordem = key_numero-ordem:
        ASSIGN cCodEstabel = ordem-compra.cod-estabel.
    END.
    
    ASSIGN cExcept = JsonAPIUtils:getTableExceptFieldsBySerializedFields(
        TEMP-TABLE VendorQuotationsByProcess:HANDLE, oRequest:getFields()
    ).
    
    //Ultimas compras fornec
    IF NOT VALID-HANDLE(h-boin082fx) THEN
        RUN inbo/boin082fx.p PERSISTENT SET h-boin082fx.

    RUN getNumLastPurchaseOfItemVendor IN h-boin082fx (INPUT key_numero-ordem,
                                                       INPUT key_it-codigo,
                                                       INPUT key_un,
                                                       INPUT key_cdn-fornec,
                                                       OUTPUT TABLE ttNumLastPurchaseOfItem,
                                                       OUTPUT TABLE RowErrors).
                                                       
    FOR EACH ttNumLastPurchaseOfItem NO-LOCK:
        CREATE ttLastPurchaseOfItemVendor.
        BUFFER-COPY ttNumLastPurchaseOfItem TO ttLastPurchaseOfItemVendor NO-ERROR.
        ASSIGN ttLastPurchaseOfItemVendor.typeLastPurchase = "vendor".
    END.
    
    //Ultimas compras item
    RUN getNumLastPurchaseOfItem IN h-boin082fx (INPUT key_numero-ordem,
                                                 INPUT cCodEstabel,
                                                 INPUT key_it-codigo,
                                                 OUTPUT TABLE ttLastPurchaseOfItem,
                                                 OUTPUT TABLE RowErrors).
                                                 
    FOR EACH ttLastPurchaseOfItem NO-LOCK:
        CREATE ttLastPurchaseOfItemVendor.
        BUFFER-COPY ttLastPurchaseOfItem TO ttLastPurchaseOfItemVendor NO-ERROR.
        ASSIGN ttLastPurchaseOfItemVendor.typeLastPurchase = "item".
    END.
    
    ASSIGN aOutput = JsonAPIUtils:convertTempTableToJsonArray(
        TEMP-TABLE ttLastPurchaseOfItemVendor:HANDLE, (LENGTH(TRIM(cExcept)) > 0)
    ).
    
    CATCH eSysError AS Progress.Lang.SysError:
        RUN piCreateTechnicalError (eSysError:getMessage(1)).
    END.
    FINALLY: 
        DELETE OBJECT oRequest NO-ERROR.
        IF VALID-HANDLE(h-boin082fx) THEN DO:
            DELETE PROCEDURE h-boin082fx.
            ASSIGN h-boin082fx = ?.
        END.
        IF fn-has-row-errors() THEN DO:
            UNDO, RETURN 'NOK':U.
        END.
    END FINALLY.

END PROCEDURE.
