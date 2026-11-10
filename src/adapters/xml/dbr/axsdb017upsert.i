PROCEDURE PITransUpsert:

    EMPTY TEMP-TABLE tt-erro              NO-ERROR.
    EMPTY TEMP-TABLE ttRoutingOfFactoring NO-ERROR.

    /*PARAMETERS - BEGIN*/
    DEFINE INPUT  PARAM pTranAction          AS CHAR NO-UNDO.
    DEFINE INPUT  PARAM pProgName            AS CHAR NO-UNDO.
    DEFINE INPUT  PARAM pProgVersion         AS CHAR NO-UNDO.
    DEFINE INPUT  PARAM TABLE FOR tt-rot-fab-dbr.
    DEFINE INPUT  PARAM TABLE FOR tt-operac-rot.
    DEFINE INPUT  PARAM TABLE FOR tt-op-ferr-dbr.
    DEFINE INPUT  PARAM TABLE FOR tt-ctrab-op-dbr.
    DEFINE INPUT  PARAM de-val-refer-atualiz AS DEC NO-UNDO.
    DEFINE OUTPUT PARAM TABLE FOR tt-erro.
    /*PARAMETERS - END*/

    
    /* ******************************************* */
    /* *************** BODY - BEGIN ************** */
    /* ******************************************* */

    IF NOT CAN-FIND (FIRST tt-rot-fab-dbr) THEN DO: 

        /* nÆo ‚ obrigat¢rio existir o cadastro de roteiros
        {utp/ut-liter.i Roteiro_de_Fabrica‡Æo_para_integra‡Æo_EAI * r}
        RUN utp/ut-msgs.p("msg":U,5561,trim(RETURN-VALUE)).
        CREATE tt-erro.
        ASSIGN iContErro        = iContErro + 1
               tt-erro.cd-erro  = 5561
               tt-erro.mensagem = RETURN-VALUE
               tt-erro.i-sequen = iContErro. 
       */
       /* como nÆo ‚ obrigatorio retorna OK */
       RETURN "OK":U.
    END.

    /* Cria temp-table's do adapter com base nas temp-table's enviadas pelo EMS. 
       O adapter ir  considerar valores branco e zero, pois o default dos campos j  foi setado */
        
     FOR EACH tt-rot-fab-dbr NO-LOCK:
    

         CREATE ttRoutingOfFactoring.
         ASSIGN iContRot                                           = iContRot + 1
                ttRoutingOfFactoring.ttRoutingOfFactoringID        = iContRot
                ttRoutingOfFactoring.AuthorityCode                 = tt-rot-fab-dbr.cod-respons
                ttRoutingOfFactoring.RoutingOfFactoringCode        = tt-rot-fab-dbr.cod-roteiro
                ttRoutingOfFactoring.RoutingOfFactoringDescription = tt-rot-fab-dbr.descricao 
                ttRoutingOfFactoring.RouteStatus                   = IF tt-rot-fab-dbr.idi-sit-rotei >= 1 AND tt-rot-fab-dbr.idi-sit-rotei <= 3 THEN tt-rot-fab-dbr.idi-sit-rotei
                                                                     ELSE 1 /* consiste campo de acordo com a include {dbinc/i01db032.i} */ .
                
         FOR EACH  tt-operac-rot WHERE tt-operac-rot.cod-roteiro = tt-rot-fab-dbr.cod-roteiro NO-LOCK: 

             CREATE ttOperationInformation.
             ASSIGN iContOper                                           = iContOper + 1
                    ttOperationInformation.ttOperationInformationID     = iContOper
                    ttOperationInformation.ttRoutingOfFactoringID       = ttRoutingOfFactoring.ttRoutingOfFactoringID
                    ttOperationInformation.FinishlDate                  = tt-operac-rot.data-termino
                    ttOperationInformation.InitialDate                  = tt-operac-rot.data-inicio 
                    ttOperationInformation.IsSignificantTime            = IF tt-operac-rot.tempo-sig THEN "yes":U ELSE "no":U
                    ttOperationInformation.ItemCode                     = tt-operac-rot.it-codigo
                    ttOperationInformation.MachineHours                 = tt-operac-rot.tempo-maquin
                    ttOperationInformation.ManHours                     = tt-operac-rot.tempo-homem
                    ttOperationInformation.OperationCode                = tt-operac-rot.op-codigo
                    ttOperationInformation.OperationDescription         = tt-operac-rot.descricao
                    ttOperationInformation.OperationId                  = tt-operac-rot.num-id-operacao
                    ttOperationInformation.OperationType                = IF tt-operac-rot.tipo-oper <> 1 AND tt-operac-rot.tipo-oper <> 2 THEN 1 
                                                                          ELSE tt-operac-rot.tipo-oper /* consiste campo de acordo com a include {ininc/i01in263.i} */ 
                    ttOperationInformation.SetupTime                    = tt-operac-rot.tempo-prepar
                    ttOperationInformation.StandardOperationCode        = tt-operac-rot.nr-oper-pad
                    ttOperationInformation.Units                        = tt-operac-rot.nr-unidades
                    ttOperationInformation.WorkCenterCode               = tt-operac-rot.gm-codigo
                    ttOperationInformation.SetupReductionCode           = tt-operac-rot.cod-reduc-prepar.
                    
             FOR EACH  tt-op-ferr-dbr WHERE tt-op-ferr-dbr.num-id-operacao =  tt-operac-rot.num-id-operac NO-LOCK:
                
                 CREATE ttToolsPerOperationInform_00.
                 ASSIGN iContOperFerr                                               = iContOperFerr + 1
                        ttToolsPerOperationInform_00.ttToolsPerOperationInform_00ID = iContOperFerr
                        ttToolsPerOperationInform_00.ttOperationInformationID       = ttOperationInformation.ttOperationInformationID
                        ttOperationInformation.ttRoutingOfFactoringID               = ttRoutingOfFactoring.ttRoutingOfFactoringID
                        ttToolsPerOperationInform_00.AlternativeOperationCode       = tt-op-ferr-dbr.op-altern
                        ttToolsPerOperationInform_00.SequenceCode                   = tt-op-ferr-dbr.sequencia
                        ttToolsPerOperationInform_00.ToolCode                       = tt-op-ferr-dbr.ferramenta.
             END.

             FOR EACH  tt-ctrab-op-dbr WHERE tt-ctrab-op-dbr.num-id-operacao =  tt-operac-rot.num-id-operac NO-LOCK:
                
                 CREATE ttOperationWorkCenterInform.
                 ASSIGN iContOperFerr                                        = iContOperFerr + 1
                        ttOperationWorkCenterInform.ttOperationInformationID = iContOperFerr
                        ttOperationWorkCenterInform.AlternativeOperationCode = tt-ctrab-op-dbr.op-altern
                        ttOperationWorkCenterInform.WorkCenterCode           = tt-ctrab-op-dbr.cod-ctrab
                        ttOperationWorkCenterInform.Priority                 = tt-ctrab-op-dbr.prioridade
                        ttOperationWorkCenterInform.Performance              = tt-ctrab-op-dbr.val-perform.
             END.

         END. /* ttOperationInformation */
     END.     /* ttRoutingOfFactoring  */

    /* Envia informa‡äes p/ cria‡Æo do XML no adapter principal  */
    RUN  PIUpsert (INPUT pTranAction,
                   INPUT pProgName,
                   INPUT pProgVersion,
                   INPUT TABLE ttRoutingOfFactoring,
                   INPUT TABLE ttOperationInformation,
                   INPUT TABLE ttToolsPerOperationInform_00,
                   INPUT TABLE ttOperationWorkCenterInform,
                   INPUT de-val-refer-atualiz,
                   OUTPUT TABLE tt-erro).

    /* ******************************************* */
    /* *************** BODY - END   ************** */
    /* ******************************************* */
END PROCEDURE.



