PROCEDURE PITransUpsert:

/*PARAMETERS - BEGIN*/
DEFINE INPUT  PARAM cTranAction AS CHARACTER INITIAL ? NO-UNDO.
DEFINE INPUT  PARAM p-nfe       AS CHARACTER           NO-UNDO.
DEFINE OUTPUT PARAM TABLE FOR tt_log_erro.
/*PARAMETERS - END*/

/* ******************************************* */
/* *************** BODY - BEGIN ************** */
/* ******************************************* */
EMPTY TEMP-TABLE tt_log_erro       NO-ERROR.

FOR FIRST estabelec FIELDS(cgc cod-estabel) NO-LOCK
    WHERE estabelec.cgc = substr(p-nfe,7,14),
    FIRST nota-fiscal FIELDS(cod-estabel serie nr-nota-fis
                             &if "{&bf_dis_versao_ems}" < "2.07" &THEN
                             char-2
                             &else
                             cod-chave-aces-nf-eletro
                             &endif) NO-LOCK             
    WHERE nota-fiscal.cod-estabel = estabelec.cod-estabel  AND
          nota-fiscal.serie       = substr(p-nfe,23,3)     AND
          nota-fiscal.nr-nota-fis = substr(p-nfe,26,9):    END.
IF  AVAIL nota-fiscal THEN DO:
    IF  CONNECTED("EAI") THEN
        RUN adapters/xml/ep2/axsep007writefilaeai.p IN h-filaeai.

    RUN PIUpsert (INPUT cTranAction,                
                  INPUT p-nfe,     
                  OUTPUT TABLE tt_log_erro ).

    IF  VALID-HANDLE(h-filaeai) THEN
        DELETE PROCEDURE h-filaeai.

END.

END PROCEDURE.

