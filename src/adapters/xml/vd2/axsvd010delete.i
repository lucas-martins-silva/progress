PROCEDURE PITransDelete:

/*PARAMETERS - BEGIN*/
DEFINE INPUT PARAMETER pMicroTerritoryRowID AS ROWID NO-UNDO.
DEFINE OUTPUT PARAM TABLE FOR tt_log_erro.
/*PARAMETERS - END*/


/*LOCAL VARIABLES - BEGIN*/
DEFINE VARIABLE c-cod-estabel     LIKE estabelec.cod-estabel INITIAL "" NO-UNDO.
DEFINE VARIABLE c-estab-nome      LIKE estabelec.nome        INITIAL "" NO-UNDO.
DEFINE VARIABLE c-reg-localizacao LIKE regiao.localizacao    INITIAL "" NO-UNDO.
DEFINE VARIABLE c-reg-narrativa   LIKE regiao.narrativa      INITIAL "" NO-UNDO.
DEFINE VARIABLE c-reg-nome        LIKE regiao.nome-regiao    INITIAL "" NO-UNDO.
DEFINE VARIABLE c-reg-pais        LIKE regiao.pais           INITIAL "" NO-UNDO.
/*LOCAL VARIABLES - END*/

EMPTY TEMP-TABLE tt_log_erro.


/* ******************************************* */
/* *************** BODY - BEGIN ************** */
/* ******************************************* */

FOR FIRST micro-reg WHERE
    ROWID(micro-reg) = pMicroTerritoryRowID NO-LOCK:

    FOR FIRST regiao FIELDS(localizacao narrativa nome-regiao pais) NO-LOCK
        WHERE regiao.nome-ab-reg = micro-reg.nome-ab-reg:
        
        ASSIGN c-reg-localizacao = regiao.localizacao
               c-reg-narrativa   = regiao.narrativa
               c-reg-nome        = regiao.nome-regiao
               c-reg-pais        = regiao.pais.
    END.

    FOR FIRST estabelec FIELDS(cod-estabel nome) NO-LOCK
        WHERE estabelec.cod-estabel = micro-reg.cod-estabel:
    
        ASSIGN c-cod-estabel = estabelec.cod-estabel
               c-estab-nome  = estabelec.nome.
    END.

    RUN PIDelete ( INPUT "del":U,
                   INPUT c-cod-estabel,
                   INPUT c-estab-nome,
                   INPUT micro-reg.nome-ab-reg,
                   INPUT micro-reg.nome-mic-reg,
                   INPUT micro-reg.desc-mic-reg,
                   INPUT c-reg-localizacao,
                   INPUT c-reg-nome,
                   INPUT c-reg-pais,
                   INPUT c-reg-narrativa,
                   OUTPUT TABLE tt_log_erro ).

END.
/* ******************************************* */
/* *************** BODY - END   ************** */
/* ******************************************* */

END PROCEDURE.



