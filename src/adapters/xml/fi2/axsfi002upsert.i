PROCEDURE PITransUpsert:

/*PARAMETERS - BEGIN*/
DEF INPUT PARAM p-cod-moeda AS INT NO-UNDO.
DEF INPUT PARAM p-qtd-dec AS DEC NO-UNDO.
DEF INPUT PARAM p-des-moeda AS CHAR NO-UNDO.
DEF INPUT PARAM p-cod-reajuste AS INT NO-UNDO.
DEF INPUT PARAM p-des-sigla AS CHAR NO-UNDO.
DEF INPUT PARAM p-id AS INT NO-UNDO.
DEF INPUT PARAM p-cod-variacao AS INT NO-UNDO.
DEF INPUT PARAM cTranAction AS CHARACTER INITIAL ? NO-UNDO.
DEF OUTPUT PARAM TABLE FOR tt_log_erro.
/*PARAMETERS - END*/

/*LOCAL VARIABLES - BEGIN*/
/*LOCAL VARIABLES - END*/


/* ******************************************* */
/* *************** BODY - BEGIN ************** */
/* ******************************************* */
CREATE ttCurrency.
ASSIGN ttCurrency.CODE = p-cod-moeda
       ttCurrency.DecimalPlaces = p-qtd-dec
       ttCurrency.DESCRIPTION = p-des-moeda
       ttCurrency.Readjust = p-cod-reajuste
       ttCurrency.ShortName = p-des-sigla
       ttCurrency.ttCurrencyID = p-id
       ttCurrency.Variance = p-cod-variacao.

FOR EACH tt_log_erro:
    DELETE tt_log_erro.
END.
RUN PIUpsert (INPUT '',
              INPUT cTranAction,
              OUTPUT TABLE tt_log_erro,
              INPUT TABLE ttCurrency).

FOR EACH ttCurrency:
    DELETE ttCurrency.
END.
/* ******************************************* */
/* *************** BODY - END   ************** */
/* ******************************************* */

END PROCEDURE.



