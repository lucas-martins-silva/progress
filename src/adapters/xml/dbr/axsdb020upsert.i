PROCEDURE PITransUpsert:
    
    EMPTY TEMP-TABLE tt-erro NO-ERROR.

    /*PARAMETERS - BEGIN*/
    DEFINE INPUT PARAM cTranAction                      AS CHAR INITIAL ? NO-UNDO.
    DEFINE INPUT PARAM cProgName                        AS CHAR INITIAL ? NO-UNDO.
    DEFINE INPUT PARAM cProgVersion                     AS CHAR INITIAL ? NO-UNDO.
    define input param table for tt-param-carga.
    define input param de-val-refer-atualiz             as dec            no-undo.
    DEFINE OUTPUT PARAM TABLE FOR tt-erro.
    /*PARAMETERS - END*/

/* ******************************************* */
/* *************** BODY - BEGIN ************** */
/* ******************************************* */

    IF NOT CAN-FIND (FIRST tt-param-carga) THEN DO: 
        {utp/ut-liter.i Parƒmetros_para_Confirma‡Æo_Encerramento_Atualiza‡Æo_da_integra‡Æo_EAI * r}
        RUN utp/ut-msgs.p("msg":U,5561,trim(RETURN-VALUE)).
        CREATE tt-erro.
        ASSIGN iContErro        = iContErro + 1
               tt-erro.cd-erro  = 5561
               tt-erro.mensagem = RETURN-VALUE
               tt-erro.i-sequen = iContErro. 
        RETURN "NOK":U.
    END.

    /* Cria temp-table's do adapter com base nas temp-table's enviadas pelo EMS. 
       O adapter ir  considerar valores branco e zero, pois o default dos campos j  foi setado */
    find first tt-param-carga no-lock no-error.
    assign EndDateEstruct                   = tt-param-carga.da-corte-estrut
           EndDateOperation                 = tt-param-carga.da-corte-oper
           IsConfiguredItemConsidered       = tt-param-carga.l-item-conf
           IsCustomerOrderConsidered        = tt-param-carga.l-pedido
           IsDirectDebitItemConsidered      = tt-param-carga.l-item-dd
           IsEstructConsidered              = tt-param-carga.l-estrut
           IsGenericScheduleConsidered      = tt-param-carga.l-calend
           IsOffSiteBalanceConsidered       = tt-param-carga.l-saldo-terc
           IsOnHandBalanceConsidered        = tt-param-carga.l-saldo-estoque
           IsOnlyAprovCustomerOrderConsi_00 = tt-param-carga.l-ped-aprov
           IsOperationConsidered            = tt-param-carga.l-operacao
           IsOrderAlocBalanceConsidered     = tt-param-carga.l-aloca-prod
           IsProductionOrderConsidered      = tt-param-carga.l-ord-prod
           IsProductionToolConsidered       = tt-param-carga.l-ferr
           IsPurchaseAlocBalanceConsidered  = tt-param-carga.l-aloca-ped
           IsPurchaseOrderConsidered        = tt-param-carga.l-ord-compra
           IsStandardOpConsidered           = tt-param-carga.l-oper-pad
           IsWorkCenterConsidered           = tt-param-carga.l-grupo
           IsXML                            = tt-param-carga.l-xml
           
           IsWareHouseConsidered            =   tt-param-carga.l-depositos
           IsVendorConsidered               =   tt-param-carga.l-fornecedor
           
           OrderReferenceDate               = tt-param-carga.da-refer-ord
           IsItemSiteConsidered             = tt-param-carga.l-item-estab.
        
    /* Envia informa‡äes p/ cria‡Æo do XML no adapter principal  */
    RUN  PIUpsert (INPUT cTranAction,
                   INPUT cProgName,
                   INPUT cProgVersion,
                   INPUT EndDateEstruct,                  
                   INPUT EndDateOperation,
                   INPUT IsConfiguredItemConsidered,
                   INPUT IsCustomerOrderConsidered,
                   INPUT IsDirectDebitItemConsidered,
                   INPUT IsEstructConsidered,
                   INPUT IsGenericScheduleConsidered,
                   INPUT IsOffSiteBalanceConsidered,
                   INPUT IsOnHandBalanceConsidered,
                   INPUT IsOnlyAprovCustomerOrderConsi_00,
                   INPUT IsOperationConsidered,
                   INPUT IsOrderAlocBalanceConsidered,
                   INPUT IsProductionOrderConsidered,
                   INPUT IsProductionToolConsidered,
                   INPUT IsPurchaseAlocBalanceConsidered,
                   INPUT IsPurchaseOrderConsidered,
                   INPUT IsStandardOpConsidered,
                   INPUT IsWorkCenterConsidered,
                   INPUT IsXML,
                   INPUT IsWareHouseConsidered,
                   INPUT IsVendorConsidered , 
                   INPUT OrderReferenceDate,
                   INPUT IsItemSiteConsidered,
                   INPUT de-val-refer-atualiz,
                   OUTPUT TABLE tt-erro).

/* ******************************************* */
/* *************** BODY - END   ************** */
/* ******************************************* */

END PROCEDURE.



