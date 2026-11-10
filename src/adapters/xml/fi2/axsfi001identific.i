 /* ---   Operacional Textil - Exportacao Cliente ou fornecedor   --- */
PROCEDURE PIIdentificUpsert:

/*PARAMETERS - BEGIN*/
DEF INPUT PARAM p-identific AS INTEGER  NO-UNDO.
DEF INPUT PARAM p-acao      AS INTEGER  NO-UNDO.  /* --- op‡äes: ADD: 1 ou UPD: 2 ---- */
/*PARAMETERS - END*/

/*LOCAL VARIABLES - BEGIN*/
/*LOCAL VARIABLES - END*/

/* ******************************************* */
/* *************** BODY - BEGIN ************** */
/* ******************************************* */


    /* ---   Atribui os valores dos parametros nas variaveis   --- */
    ASSIGN v-identific = p-identific
           v-acao      = p-acao.


/* ******************************************* */
/* *************** BODY - END   ************** */
/* ******************************************* */

END PROCEDURE.

