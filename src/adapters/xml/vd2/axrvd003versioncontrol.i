     /* ********* EXECUÇÃO DAS PI - BEGIN ********* */
     IF (cTranAction = "add":U) OR (cTranAction = "upd":U) THEN 
          RUN PIUpsert.
     IF (cTranAction = "del":U) THEN 
          RUN PIDelete.
     IF (cTranAction = "qry":U) THEN 
          RUN PIQuery (OUTPUT hQueryReturnContent). /* consulta */

     IF CAN-FIND (FIRST RowErrors) THEN /* Erros ocorridos durante efetiva‡Æo do registro */
        FOR EACH RowErrors WHERE RowErrors.ErrorType <> "INTERNAL":U : 

            /********************************************************************************************************  
            **  Altera‡Æo efetuada durante implanta‡Æo na RioPol:
            **  Causa.......: NÆo estava retornando o help da mensagem de erro. Em determinadas situa‡äes, como
            **                no aviso de pedido nÆo aprovado, o help ‚ indispensavel para contextualizar o usu rio.
            **  Solu‡Æo.....: Implementada a concatena‡Æo do help da mensagem com a descri‡Æo do erro.
            **  Respons vel.: M rcio Lohmann
            **  Data........: 25/02/2005 
            ********************************************************************************************************/   
            IF RowErrors.ErrorSubType = "ERROR":U THEN
               RUN setError IN hMessageHandler (INPUT RowErrors.ErrorNumber,
                                                INPUT "business_error":U,
                                                INPUT RowErrors.ErrorDescription + " - " + RowErrors.ErrorHelp).

            ELSE IF RowErrors.ErrorSubType = "WARNING":U THEN
                 RUN setError IN hMessageHandler (INPUT RowErrors.ErrorNumber,
                                                  INPUT "business_warning":U,
                                                  INPUT RowErrors.ErrorDescription + " - " + RowErrors.ErrorHelp).

            ELSE IF RowErrors.ErrorSubType = "INFORMATION":U THEN
                 RUN setError IN hMessageHandler (INPUT RowErrors.ErrorNumber,
                                                  INPUT "business_information":U,
                                                  INPUT RowErrors.ErrorDescription + " - " + RowErrors.ErrorHelp).

        END.

        IF hMessageHandler:GET-SIGNATURE("setExtraInformation":U) <> "":U THEN DO:

           FOR EACH ReturnOrderValues NO-LOCK:
               RUN setExtraInformation IN hMessageHandler (ReturnOrderValues.XMLElementName,
                                                           ReturnOrderValues.FieldValue).
               IF ReturnOrderValues.XMLElementName = "OrderNumber":U THEN
                  ASSIGN i-nr-pedido = integer(ReturnOrderValues.FieldValue).
           END.
           FOR EACH ReturnItemValues NO-LOCK:
               RUN setExtraInformation IN hMessageHandler (string(ReturnItemValues.OrderLine) + '-':U + ReturnItemValues.ItemCode + '-':U + ReturnItemValues.XMLElementName,
                                                           string(ReturnItemValues.FieldValue)).
           END.
        END.
   
    IF (cTranAction = "qry":U) THEN /* inclui os registros encontrados durante a consulta na mensagem de retorno */
        RUN setQueryReturnContent IN hMessageHandler (INPUT hQueryReturnContent).

    /* Obt‚m mensagem de retorno (erro ou confirma‡Æo) */
    RUN getReturnMessage IN hMessageHandler (OUTPUT hOUTPUTXML). 
       
    /* Envia mensagam de notifica‡Æo :: integra‡Æo ass¡ncrona */
    RUN getReturnStatus IN hMessageHandler (OUTPUT pSendSuccess, OUTPUT pTotalErrors).
    
    /*--- NÆo retirar esta l¢gica. Procedimento necess rio para a integra‡Æo SGT --*/
    IF  CAN-FIND(FIRST funcao
                 WHERE funcao.cd-funcao = 'spp-sgt':U
                 AND   funcao.ativo     = TRUE) THEN DO:
        ASSIGN pSendSuccess = TRUE
               pTotalErrors = 0.
        FOR EACH RowErrors: DELETE RowErrors. END.
    END.
    /*- NÆo retirar a l¢gica acima. Procedimento necess rio para a integra‡Æo SGT -*/

    /*--- NÆo retirar esta l¢gica. Procedimento necess rio para a integra‡Æo com Neogrid --*/
    IF  CAN-FIND(FIRST funcao
                 WHERE funcao.cd-funcao = 'spp-neogrid':U
                 AND   funcao.ativo     = TRUE) THEN DO:
        ASSIGN pSendSuccess = TRUE.
    END.
    /*- NÆo retirar a l¢gica acima. Procedimento necess rio para a integra‡Æo com Neogrid -*/


    IF  pSendSuccess AND cTranAction <> "qry":U 
    AND NOT CAN-FIND (FIRST RowErrors
                      WHERE RowErrors.ErrorSubType = "ERROR":U) THEN DO: 

        IF  SEARCH("adapters/xml/vd2/axnvd003.r":U) <> ? OR
            SEARCH("adapters/xml/vd2/axnvd003.p":U) <> ? THEN DO:
        
           FOR FIRST ped-venda WHERE ped-venda.nr-pedido = i-nr-pedido NO-LOCK: END.
            IF AVAIL ped-venda THEN
               RUN adapters/xml/vd2/axnvd003.p ( INPUT ROWID(ped-venda),   /* registro atualizado */
                                                 INPUT TABLE tt-ped-venda, /* registro lido do XML */
                                                 OUTPUT TABLE RowErrors ).

            IF CAN-FIND (FIRST RowErrors) THEN 
              FOR EACH RowErrors WHERE RowErrors.ErrorType <> "INTERNAL":U : 
                  RUN setError IN hMessageHandler (INPUT RowErrors.ErrorNumber,
                                                   INPUT "enviroment_error":U,
                                                   INPUT RowErrors.ErrorDescription + " - " + RowErrors.ErrorHelp).
              END.
        END.
    END.
