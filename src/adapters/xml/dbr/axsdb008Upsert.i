PROCEDURE PITransUpsert:

    /* PARAMETERS*/
    DEFINE INPUT  PARAM pTranAction           AS CHARACTER INITIAL ? NO-UNDO.
    DEFINE INPUT  PARAM pProgName             AS CHARACTER INITIAL ? NO-UNDO.
    DEFINE INPUT  PARAM pProgVersion          AS CHARACTER INITIAL ? NO-UNDO.
    DEFINE INPUT  PARAM TABLE FOR tt-turno-grp-dbr.
    DEFINE INPUT  PARAM de-val-refer-atualiz  AS DECIMAL   INITIAL ? NO-UNDO.
    DEFINE OUTPUT PARAM TABLE FOR tt-erro.

    /* LOCAL VARIABLES */
    DEFINE VAR iId AS INTEGER INITIAL 1 NO-UNDO.

    /* ******************************************* */
    /* *************** BODY - BEGIN ************** */
    /* ******************************************* */
    
    EMPTY TEMP-TABLE tt-erro               NO-ERROR.
    EMPTY TEMP-TABLE ttShiftOfMachineGroup NO-ERROR.

    IF  NOT CAN-FIND (FIRST tt-turno-grp-dbr) THEN DO: 

        /* Registro Turnos Grupo de M quina nao encontrado */
        {utp/ut-liter.i Turnos_do_Grupo_de_M quina_para_Integracao_EAI *}
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

    FOR EACH tt-turno-grp-dbr:

        CREATE ttShiftOfMachineGroup.
        ASSIGN ttShiftOfMachineGroup.MachineGroupCode        = tt-turno-grp-dbr.gm-codigo
               ttShiftOfMachineGroup.StartDate               = tt-turno-grp-dbr.dt-inicio
               ttShiftOfMachineGroup.EndDate                 = tt-turno-grp-dbr.dt-termino
               ttShiftOfMachineGroup.ShiftModelCode          = tt-turno-grp-dbr.cod-model-turno
               ttShiftOfMachineGroup.ttShiftOfMachineGroupId = iId
               iId                                           = iId + 1.
    END.

    /* Envia informa‡äes p/ cria‡Æo do XML no adapter principal  */
    RUN PIUpsert (INPUT pTranAction,
                  INPUT pProgName,
                  INPUT pProgVersion,
                  INPUT TABLE ttShiftOfMachineGroup,
                  INPUT de-val-refer-atualiz,
                  OUTPUT TABLE tt-erro).

    /* ******************************************* */
    /* *************** BODY - END   ************** */
    /* ******************************************* */


END PROCEDURE.



