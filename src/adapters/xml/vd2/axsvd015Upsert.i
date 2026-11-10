PROCEDURE PITransUpsert:

/*PARAMETERS - BEGIN*/
DEFINE INPUT PARAMETER pTranAction AS CHAR  NO-UNDO.
DEFINE INPUT PARAMETER pCityRowID  AS ROWID NO-UNDO.
DEFINE OUTPUT PARAM TABLE FOR tt_log_erro.
/*PARAMETERS - END*/

/*LOCAL VARIABLES - BEGIN*/
/*LOCAL VARIABLES - END*/

/* ******************************************* */
/* *************** BODY - BEGIN ************** */
/* ******************************************* */

EMPTY TEMP-TABLE tt_log_erro NO-ERROR.

FIND FIRST bfcidade
    WHERE ROWID(bfcidade) = pCityRowID NO-LOCK NO-ERROR.
IF AVAIL bfcidade THEN DO:

    FIND FIRST pais
        WHERE pais.nome-pais = bfcidade.pais NO-LOCK NO-ERROR.

    RUN PIUpsert(INPUT pTranAction,
                 INPUT bfcidade.cidade,        
                 INPUT bfcidade.pais,  
                 INPUT IF AVAIL pais THEN substr(pais.cod-pais-siscomex,1,3) ELSE " ",
                 INPUT IF AVAIL pais THEN substr(pais.cod-pais-siscomex,4,1) ELSE " ",
                 INPUT bfcidade.cdn-domic-fisc,
                 INPUT bfcidade.cdn-munpio-ibge,          
                 INPUT bfcidade.nome-mic-reg,  
                 INPUT bfcidade.sigla,         
                 INPUT bfcidade.estado,        
                 INPUT bfcidade.nome-ab-reg,
                 OUTPUT TABLE tt_log_erro).

END.

/* ******************************************* */
/* *************** BODY - END   ************** */
/* ******************************************* */

END PROCEDURE.

