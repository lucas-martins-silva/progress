PROCEDURE PITransUpsert:

/*PARAMETERS - BEGIN*/
DEFINE INPUT  PARAM cTranAction AS CHARACTER INITIAL ? NO-UNDO.
DEFINE INPUT  PARAM p-motivo    AS CHARACTER           NO-UNDO.
DEFINE INPUT  PARAM p-row-table AS ROWID               NO-UNDO. 
DEFINE OUTPUT PARAM p-tipo-transacao AS INTEGER             NO-UNDO.
DEFINE OUTPUT PARAM TABLE FOR tt_log_erro.
DEFINE OUTPUT PARAM TABLE FOR tt_nfe_erro.
/*PARAMETERS - END*/

/* ******************************************* */
/* *************** BODY - BEGIN ************** */
/* ******************************************* */
EMPTY TEMP-TABLE tt_log_erro NO-ERROR.
EMPTY TEMP-TABLE tt_nfe_erro NO-ERROR.

FOR FIRST nota-fiscal FIELDS(cod-estabel serie nr-nota-fis
                             &IF"{&bf_dis_versao_ems}" < "2.07" &THEN
                                char-2 char-1
                             &ELSE
                                cod-chave-aces-nf-eletro cod-protoc
                             &ENDIF) NO-LOCK
        WHERE ROWID(nota-fiscal) = p-row-table: END.

IF AVAIL nota-fiscal THEN DO:

  EMPTY TEMP-TABLE tt_nfe_erro.

  RUN PIUpsert (INPUT cTranAction,                
                INPUT p-motivo,
                INPUT p-row-table,
                OUTPUT p-tipo-transacao,
                OUTPUT TABLE tt_log_erro).

END.

END PROCEDURE.

