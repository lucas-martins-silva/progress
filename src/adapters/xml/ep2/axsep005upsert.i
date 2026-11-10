PROCEDURE PITransUpsert:
    
    /*PARAMETERS - BEGIN*/
    DEFINE INPUT  PARAM pTranAction   AS   CHARACTER NO-UNDO . /* UPD */
    DEFINE INPUT  PARAM pEvent        AS   CHARACTER NO-UNDO . /* UpdateDocument/UndoUpdateDocument */
    DEFINE INPUT  PARAM pcod-estabel  LIKE nota-fiscal.cod-estabel  NO-UNDO.
    DEFINE INPUT  PARAM pserie        LIKE nota-fiscal.serie        NO-UNDO.
    DEFINE INPUT  PARAM pnr-nota-fis  LIKE nota-fiscal.nr-nota-fis  NO-UNDO.
    DEFINE INPUT  PARAM pdt-cancela   LIKE nota-fiscal.dt-cancela   NO-UNDO.
    DEFINE INPUT  PARAM pdesc-cancela LIKE nota-fiscal.desc-cancela NO-UNDO.
    DEFINE OUTPUT PARAM TABLE FOR tt_log_erro.
    /*PARAMETERS - END*/
    
/* ******************************************* */
/* *************** BODY - BEGIN ************** */
/* ******************************************* */

    EMPTY TEMP-TABLE tt_log_erro      NO-ERROR.
    EMPTY TEMP-TABLE tt-nota-fiscal NO-ERROR.

    CREATE tt-nota-fiscal.
    ASSIGN tt-nota-fiscal.cod-estabel  = pcod-estabel 
           tt-nota-fiscal.serie        = pserie       
           tt-nota-fiscal.nr-nota-fis  = pnr-nota-fis 
           tt-nota-fiscal.dt-cancela   = pdt-cancela  
           tt-nota-fiscal.desc-cancela = pdesc-cancela.

    RUN PIUpsert (INPUT pTranAction,
                  INPUT pEvent,
                  INPUT  TABLE tt-nota-fiscal,
                  OUTPUT TABLE tt_log_erro ).

/* ******************************************* */
/* *************** BODY - END   ************** */
/* ******************************************* */

END PROCEDURE.

