PROCEDURE PITransUpsert:

    /*PARAMETERS - BEGIN*/
    DEFINE INPUT  PARAMETER pTranAction     AS CHARACTER  NO-UNDO.
    DEFINE INPUT  PARAMETER pTranEvent      AS CHARACTER  NO-UNDO.
    DEFINE INPUT  PARAMETER TABLE FOR ttMonitorFaixa_ENV.
    DEFINE OUTPUT PARAMETER TABLE FOR tt_log_erro.
    /*PARAMETERS - END*/


    /*LOCAL VARIABLES - BEGIN*/
    /*LOCAL VARIABLES - END*/
    
    
    /* ******************************************* */
    /* *************** BODY - BEGIN ************** */
    /* ******************************************* */

    FOR FIRST ttMonitorFaixa_ENV: END.

    RUN PIUpsert ( INPUT  pTranAction         , /* add / upd */
                   INPUT  pTranEvent          , /* Evento    */
                   INPUT  TABLE ttMonitorFaixa_ENV,
                   OUTPUT TABLE tt_log_erro).


    /* ******************************************* */
    /* *************** BODY - END   ************** */
    /* ******************************************* */

END PROCEDURE.



