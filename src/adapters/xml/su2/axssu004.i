IF l-integra-portal THEN DO:
    IF ttPurchaseOrder.CompanyCode <> ? THEN
    DO: /*Test LOGIC*/
        RUN addNode IN hGenXml (getStack(), "Company":U, "", OUTPUT iId).
        addStack(iId).
             RUN addNode IN hGenXml (getStack(), "CompanyCode":U, ttPurchaseOrder.CompanyCode, OUTPUT iId).
             RUN addNode IN hGenXml (getStack(), "TaxID":U, ttPurchaseOrder.TaxId, OUTPUT iId).
        delStack().
    END. /*Test LOGIC*/
    /*Maylon*/
END.
