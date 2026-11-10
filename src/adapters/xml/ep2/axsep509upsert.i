PROCEDURE PITransUpsert:
    
    /*PARAMETERS - BEGIN*/
    DEFINE INPUT PARAM pTranAction       AS   CHARACTER NO-UNDO . /* UPD */
    DEFINE INPUT PARAM pTranEvent        AS   CHARACTER NO-UNDO . /* UpdateDocument/UndoUpdateDocument */
    DEFINE INPUT PARAM pnum-romaneio     LIKE roman-faturam.num-romaneio     NO-UNDO.
    DEFINE INPUT PARAM pcod-estabel      LIKE roman-faturam.cod-estabel      NO-UNDO.
    DEFINE INPUT PARAM pidi-sit-roman    LIKE roman-faturam.idi-sit-roman    NO-UNDO.
    DEFINE INPUT PARAM pdt-cancela       LIKE roman-faturam.dt-cancela       NO-UNDO.
    DEFINE INPUT PARAM pdsl-motiv-cancel LIKE roman-faturam.dsl-motiv-cancel NO-UNDO.
    DEFINE INPUT PARAM pcod-usuar-cancel LIKE roman-faturam.cod-usuar-cancel NO-UNDO.
    
    DEFINE OUTPUT PARAM TABLE FOR tt_log_erro.
    /*PARAMETERS - END*/
    
/* ******************************************* */
/* *************** BODY - BEGIN ************** */
/* ******************************************* */

    EMPTY TEMP-TABLE tt_log_erro      NO-ERROR.
    EMPTY TEMP-TABLE tt-roman-faturam NO-ERROR.

    CREATE tt-roman-faturam.
    ASSIGN tt-roman-faturam.num-romaneio     = pnum-romaneio    
           tt-roman-faturam.cod-estabel      = pcod-estabel     
           tt-roman-faturam.idi-sit-roman    = pidi-sit-roman   
           tt-roman-faturam.dt-cancela       = pdt-cancela      
           tt-roman-faturam.dsl-motiv-cancel = pdsl-motiv-cancel
           tt-roman-faturam.cod-usuar-cancel = pcod-usuar-cancel.

    RUN PIUpsert (INPUT pTranAction,
                  INPUT pTranEvent,
                  INPUT  TABLE tt-roman-faturam,
                  OUTPUT TABLE tt_log_erro ).

/* ******************************************* */
/* *************** BODY - END   ************** */
/* ******************************************* */

END PROCEDURE.
