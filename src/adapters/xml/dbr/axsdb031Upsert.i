PROCEDURE PITransUpsert:

    EMPTY TEMP-TABLE tt-erro NO-ERROR.

    /*PARAMETERS - BEGIN*/
    DEFINE INPUT  PARAM pTranAction          AS CHAR NO-UNDO.
    DEFINE INPUT  PARAM pProgName            AS CHAR NO-UNDO.
    DEFINE INPUT  PARAM pProgVersion         AS CHAR NO-UNDO.
    DEFINE INPUT  PARAM TABLE FOR tt-recur-sec-dbr.
    DEFINE INPUT  PARAM TABLE FOR tt-recur-sec-dispon-dbr.
    DEFINE INPUT  PARAM TABLE FOR tt-recur-sec-ctrab-dbr.
    DEFINE INPUT  PARAM de-val-refer-atualiz AS DEC NO-UNDO.
    DEFINE OUTPUT PARAM TABLE FOR tt-erro.
    /*PARAMETERS - END*/


    /* ******************************************* */
    /* *************** BODY - BEGIN ************** */
    /* ******************************************* */
    
    IF NOT CAN-FIND (FIRST tt-recur-sec-dbr) THEN DO:
        {utp/ut-liter.i Recurso_Secund rio_para_integra‡Æo_EAI * r}
        RUN utp/ut-msgs.p("msg":U,5561,TRIM(RETURN-VALUE)).
        CREATE tt-erro.
        ASSIGN iContErro        = iContErro + 1
               tt-erro.cd-erro  = 5561
               tt-erro.mensagem = RETURN-VALUE
               tt-erro.i-sequen = iContErro. 
        RETURN "NOK":U.
    END.

    /* Cria temp-table's do adapter com base nas temp-table's enviadas pelo EMS. 
       O adapter irá considerar valores branco e zero, pois o default dos campos já foi setado */
     FOR EACH tt-recur-sec-dbr NO-LOCK:
         
         CREATE ttSecondaryResource.  
         ASSIGN iCont01                                          = iCont01 + 1
                ttSecondaryResource.ttSecondaryResourceID        = iCont01 
                ttSecondaryResource.SecondaryResourceCode        = tt-recur-sec-dbr.cod-recurso
                ttSecondaryResource.SecondaryResourceDescription = tt-recur-sec-dbr.des-recurso
                ttSecondaryResource.Active                       = tt-recur-sec-dbr.log-ativo
                ttSecondaryResource.Application                  = tt-recur-sec-dbr.idi-aplic
                ttSecondaryResource.Type                         = tt-recur-sec-dbr.idi-tipo.

         FOR EACH tt-recur-sec-dispon-dbr NO-LOCK
            where tt-recur-sec-dispon-dbr.cod-recurso = tt-recur-sec-dbr.cod-recurso:
             
             CREATE ttAvailability.  
             ASSIGN iCont02                              = iCont02 + 1
                    ttAvailability.ttAvailabilityID      = iCont02
                    ttAvailability.ttSecondaryResourceID = iCont01
                    ttAvailability.InitialPeriod         = tt-recur-sec-dispon-dbr.dat-inic-period
                    ttAvailability.InitialSecs           = tt-recur-sec-dispon-dbr.qtd-segs-inic
                    ttAvailability.FinalPeriod           = tt-recur-sec-dispon-dbr.dat-fim-period
                    ttAvailability.FinalSecs             = tt-recur-sec-dispon-dbr.qtd-segs-fim
                    ttAvailability.QuantityAvailable     = tt-recur-sec-dispon-dbr.qtd-dispon.
         END.     

         FOR EACH tt-recur-sec-ctrab-dbr NO-LOCK
            where tt-recur-sec-ctrab-dbr.cod-recurso = tt-recur-sec-dbr.cod-recurso:
             
             CREATE ttWorkCenter.  
             ASSIGN iCont03                            = iCont03 + 1
                    ttWorkCenter.ttWorkCenterID        = iCont03
                    ttWorkCenter.ttSecondaryResourceID = iCont01
                    ttWorkCenter.WorkCenterCode        = tt-recur-sec-ctrab-dbr.cod-ctrab
                    ttWorkCenter.Active                = tt-recur-sec-ctrab-dbr.log-ativo
                    ttWorkCenter.AllocationOrders      = tt-recur-sec-ctrab-dbr.idi-aloc-ord
                    ttWorkCenter.QuantityConsumed      = tt-recur-sec-ctrab-dbr.qtd-consum.
         END.     
     END.     

    /* Envia informações p/ criação do XML no adapter principal  */
    RUN  PIUpsert (INPUT pTranAction,
                   INPUT pProgName,
                   INPUT pProgVersion,
                   INPUT TABLE ttSecondaryResource,
                   INPUT TABLE ttAvailability,
                   INPUT TABLE ttWorkCenter,
                   INPUT de-val-refer-atualiz,
                   OUTPUT TABLE tt-erro).
    
    /* ******************************************* */
    /* *************** BODY - END   ************** */
    /* ******************************************* */

END PROCEDURE.
