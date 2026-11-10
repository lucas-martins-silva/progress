PROCEDURE PITransDelete:

/*PARAMETERS - BEGIN*/
DEFINE INPUT PARAMETER pCityRowID AS ROWID NO-UNDO.
DEFINE OUTPUT PARAM TABLE FOR tt_log_erro.
/*PARAMETERS - END*/


/*LOCAL VARIABLES - BEGIN*/
/*LOCAL VARIABLES - END*/


/* ******************************************* */
/* *************** BODY - BEGIN ************** */
/* ******************************************* */

FIND FIRST cidade
    WHERE ROWID(cidade) = pCityRowID NO-LOCK NO-ERROR.
IF AVAIL cidade THEN DO:

    FIND FIRST pais
        WHERE pais.nome-pais = bfcidade.pais NO-LOCK NO-ERROR.
    
    RUN PIDelete ( INPUT "del":U,
                   INPUT cidade.cidade,
                   INPUT cidade.pais,  
                   INPUT IF AVAIL pais THEN substr(pais.cod-pais-siscomex,1,3) ELSE " ",
                   INPUT IF AVAIL pais THEN substr(pais.cod-pais-siscomex,4,1) ELSE " ",
                   INPUT cidade.estado,
                   OUTPUT TABLE tt_log_erro ).
END.

/* ******************************************* */
/* *************** BODY - END   ************** */
/* ******************************************* */

END PROCEDURE.



