PROCEDURE PITransUpsert:

/*PARAMETERS - BEGIN*/
DEFINE INPUT PARAMETER pTranAction          AS CHARACTER  NO-UNDO.
DEFINE INPUT PARAMETER pMicroTerritoryRowID AS ROWID      NO-UNDO.
DEFINE OUTPUT PARAM TABLE FOR tt_log_erro.
/*PARAMETERS - END*/


/*LOCAL VARIABLES - BEGIN*/
DEFINE VARIABLE c-nome-estab         LIKE estabelec.nome     INITIAL "" NO-UNDO.
DEFINE VARIABLE c-nome-estab-reg     LIKE estabelec.nome     INITIAL "" NO-UNDO.
DEFINE VARIABLE c-nome-repres        LIKE repres.nome        INITIAL "" NO-UNDO.
DEFINE VARIABLE c-reg-cod-estabel    LIKE regiao.cod-estabel INITIAL "" NO-UNDO.
DEFINE VARIABLE c-reg-nome-ab-reg    LIKE regiao.nome-ab-reg INITIAL "" NO-UNDO.
DEFINE VARIABLE c-reg-localizacao    LIKE regiao.localizacao INITIAL "" NO-UNDO.
DEFINE VARIABLE c-reg-narrativa      LIKE regiao.narrativa   INITIAL "" NO-UNDO.
DEFINE VARIABLE c-reg-nome-regiao    LIKE regiao.nome-regiao INITIAL "" NO-UNDO.
DEFINE VARIABLE c-reg-pais           LIKE regiao.pais        INITIAL "" NO-UNDO.

/*LOCAL VARIABLES - END*/


EMPTY TEMP-TABLE tt_log_erro.

/* ******************************************* */
/* *************** BODY - BEGIN ************** */
/* *********************** ******************** */
FIND FIRST micro-reg WHERE ROWID(micro-reg) = pMicroTerritoryRowID NO-LOCK NO-ERROR.

IF AVAIL micro-reg THEN DO:

    FOR FIRST estabelec FIELDS(nome) NO-LOCK 
        WHERE estabelec.cod-estabel = micro-reg.cod-estabel:
        ASSIGN c-nome-estab = estabelec.nome.
    END.

    FOR FIRST repres FIELDS(nome) NO-LOCK 
        WHERE repres.cod-rep = micro-reg.cod-rep:
        ASSIGN c-nome-repres = repres.nome.
    END.

    FOR FIRST regiao FIELDS(cod-estabel nome-ab-reg localizacao narrativa nome-regiao pais) NO-LOCK
        WHERE regiao.nome-ab-reg = micro-reg.nome-ab-reg:
        ASSIGN c-reg-cod-estabel = regiao.cod-estabel
               c-reg-nome-ab-reg = regiao.nome-ab-reg
               c-reg-localizacao = regiao.localizacao
               c-reg-narrativa   = regiao.narrativa
               c-reg-nome-regiao = regiao.nome-regiao
               c-reg-pais        = regiao.pais.

        FOR FIRST estabelec FIELDS(nome) NO-LOCK 
            WHERE estabelec.cod-estabel = regiao.cod-estabel:
            ASSIGN c-nome-estab-reg = estabelec.nome.
        END.
    END.

    RUN PIUpsert ( pTranAction,                                           
                   c-reg-cod-estabel,                                        
                   c-nome-estab-reg,                                         
                   micro-reg.cod-localiz,                                     
                   micro-reg.cod-rep,                                         
                   c-nome-repres,                                               
                   micro-reg.desc-mic-reg,                                    
                   micro-reg.narrativa,                                       
                   c-reg-nome-ab-reg,                                        
                   micro-reg.nome-mic-reg,                                    
                   c-reg-localizacao,                                        
                   c-reg-narrativa,                                          
                   c-reg-nome-regiao,                                        
                   c-reg-pais,                                               
                   micro-reg.cod-estabel,                                     
                   c-nome-estab,                                      
                   OUTPUT TABLE tt_log_erro ).

END.
/* ******************************************* */
/* *************** BODY - END   ************** */
/* ******************************************* */

END PROCEDURE.



