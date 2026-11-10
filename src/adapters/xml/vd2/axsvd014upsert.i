PROCEDURE PITransUpsert:

/*PARAMETERS - BEGIN*/
DEFINE INPUT  PARAM cEvent      AS CHARACTER INITIAL ? NO-UNDO.
DEFINE INPUT  PARAM cTranAction AS CHARACTER INITIAL ? NO-UNDO.
DEFINE INPUT  PARAM rw-emitente AS ROWID               NO-UNDO.
DEFINE OUTPUT PARAM TABLE FOR tt_log_erro.
/*PARAMETERS - END*/

/*LOCAL VARIABLES - BEGIN*/

/*LOCAL VARIABLES - END*/

/* ******************************************* */
/* *************** BODY - BEGIN ************** */
/* ******************************************* */

EMPTY TEMP-TABLE ttCustomerEvaluationEnv.
EMPTY TEMP-TABLE tt_log_erro.

CREATE ttCustomerEvaluationEnv.

FOR FIRST emitente 
    WHERE ROWID(emitente) = rw-emitente NO-LOCK:

    ASSIGN ttCustomerEvaluationEnv.cgc           = emitente.cgc
           ttCustomerEvaluationEnv.cgcCob        = emitente.cgc-cob
           ttCustomerEvaluationEnv.codigo        = emitente.cod-emitente
           ttCustomerEvaluationEnv.dtImplantacao = emitente.data-implant
           ttCustomerEvaluationEnv.grupoCli      = emitente.cod-gr-cli
           ttCustomerEvaluationEnv.IE            = emitente.ins-estadual
           ttCustomerEvaluationEnv.IECob         = emitente.ins-est-cob
           ttCustomerEvaluationEnv.IM            = emitente.ins-municipal
           ttCustomerEvaluationEnv.INSS          = &IF "{&bf_dis_versao_ems}" >= "2.05" &THEN emitente.cod-inscr-inss &ELSE emitente.char-2 &ENDIF
           ttCustomerEvaluationEnv.matriz        = emitente.nome-matriz
           ttCustomerEvaluationEnv.nomeAbrev     = emitente.nome-abrev
           ttCustomerEvaluationEnv.ramoAtividade = emitente.atividade
           ttCustomerEvaluationEnv.razaoSocial   = emitente.nome-emit
           ttCustomerEvaluationEnv.endereco      = emitente.endereco
           ttCustomerEvaluationEnv.natureza      = emitente.natureza.

END.

RUN PIUpsert(INPUT cEvent,
             INPUT cTranAction,
             INPUT ROWID(emitente),
             INPUT  TABLE ttCustomerEvaluationEnv,
             OUTPUT TABLE tt_log_erro).

/* ******************************************* */
/* *************** BODY - END   ************** */
/* ******************************************* */

END PROCEDURE.



