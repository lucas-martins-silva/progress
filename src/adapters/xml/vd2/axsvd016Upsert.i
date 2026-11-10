PROCEDURE PITransUpsert:

/*PARAMETERS - BEGIN*/
DEFINE INPUT PARAMETER pTranAction   AS CHAR  NO-UNDO.
DEFINE INPUT PARAMETER pEmbalagRowID AS ROWID NO-UNDO.
DEFINE OUTPUT PARAM TABLE FOR tt_log_erro.
/*PARAMETERS - END*/

/*LOCAL VARIABLES - BEGIN*/
/*LOCAL VARIABLES - END*/

/* ******************************************* */
/* *************** BODY - BEGIN ************** */
/* ******************************************* */

EMPTY TEMP-TABLE tt_log_erro NO-ERROR.

FIND FIRST bfembalag
     WHERE rowid(bfembalag) = pEmbalagRowID NO-LOCK NO-ERROR.
IF AVAIL bfembalag THEN DO:

RUN PIUpsert(INPUT pTranAction,
             INPUT bfembalag.sigla-emb,         /* Short,                */
             INPUT bfembalag.altura,            /* Height,               */
             INPUT bfembalag.log-embal-oculta,  /* IsHiddenPackaging,    */
             INPUT bfembalag.emite-roman,       /* IsPrintedLabel,       */
             INPUT bfembalag.it-codigo,         /* ItemCode,             */
             INPUT bfembalag.comprim,           /* Length,               */
             INPUT bfembalag.narrativa,         /* Narrative,            */
             INPUT bfembalag.embalagem,         /* PackagingCode,        */
             INPUT bfembalag.descricao,         /* PackagingDescription, */
             INPUT bfembalag.peso-embal,        /* PackagingWeight,      */
             INPUT bfembalag.volume,            /* Volume,               */
             INPUT bfembalag.ind-detemb,        /* VolumeDescription,    */
             INPUT bfembalag.largura,           /* Width,                */
             OUTPUT TABLE tt_log_erro).

END.

/* ******************************************* */
/* *************** BODY - END   ************** */
/* ******************************************* */

END PROCEDURE.

