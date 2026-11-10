PROCEDURE PITransUpsert:

    /* PARAMETERS*/
    DEFINE INPUT  PARAM pTranAction           AS CHARACTER INITIAL ? NO-UNDO.
    DEFINE INPUT  PARAM pProgName             AS CHARACTER INITIAL ? NO-UNDO.
    DEFINE INPUT  PARAM pProgVersion          AS CHARACTER INITIAL ? NO-UNDO.
    DEFINE INPUT  PARAM TABLE FOR tt-gm-dbr.
    DEFINE INPUT  PARAM de-val-refer-atualiz  AS DECIMAL   INITIAL ? NO-UNDO.
    DEFINE OUTPUT PARAM TABLE FOR tt-erro.


    /* LOCAL VARIABLES */
    DEFINE VAR iId AS INTEGER INITIAL 1 NO-UNDO.

    /* ******************************************* */
    /* *************** BODY - BEGIN ************** */
    /* ******************************************* */
    
    EMPTY TEMP-TABLE tt-erro        NO-ERROR.
    EMPTY TEMP-TABLE ttMachineGroup NO-ERROR.

    IF  NOT CAN-FIND (FIRST tt-gm-dbr) THEN DO: 
         /* Registro Grupo de  Maquina nao encontrado */
        {utp/ut-liter.i Grupo_de_M quina_para_Integracao_EAI *}
        RUN utp/ut-msgs.p("msg":U,
                          5561,
                          RETURN-VALUE).
        CREATE tt-erro.
        ASSIGN tt-erro.i-sequen = iSeqErro
               tt-erro.cd-erro  = 5561
               tt-erro.mensagem = RETURN-VALUE
               iSeqErro         = iSeqErro + 1.
        RETURN "NOK":U.
    END.

    /* Cria temp-tables do adapter com base nas temp-tables enviadas pelo EMS               */
    /* O adapter ir  considerar valores branco/zero pois o default dos campos j  foi setado */

    FOR EACH tt-gm-dbr:

        CREATE ttMachineGroup.
        ASSIGN ttMachineGroup.MachineGroupCode        = tt-gm-dbr.gm-codigo
               ttMachineGroup.MachineGroupDescription = tt-gm-dbr.descricao
               ttMachineGroup.CalendarCode            = tt-gm-dbr.cod-calend
               ttMachineGroup.NumberOfProcessors      = tt-gm-dbr.num-maquina
               ttMachineGroup.ProductionAreaCode      = tt-gm-dbr.cod-area-produc
               ttMachineGroup.ttMachineGroupId        = iId
               iId                                    = iId + 1.

    END.

    /* Envia informa‡äes p/ cria‡Æo do XML no adapter principal  */
    RUN PIUpsert (INPUT pTranAction,
                  INPUT pProgName,
                  INPUT pProgVersion,
                  INPUT TABLE ttMachineGroup,
                  INPUT de-val-refer-atualiz,
                  OUTPUT TABLE tt-erro).

    /* ******************************************* */
    /* *************** BODY - END   ************** */
    /* ******************************************* */

END PROCEDURE.



