PROCEDURE PITransUpsert:

/*PARAMETERS - BEGIN*/
    DEFINE INPUT PARAM cTranAction AS CHARACTER INITIAL ? NO-UNDO.
    DEFINE INPUT PARAM p-cod-moeda AS integer INITIAL ? NO-UNDO.  /*Código da Moeda da cotação (Uso Interno: emsuni.moeda.mo-codigo)*/
    DEFINE INPUT PARAM p-ano-periodo AS CHAR INITIAL ? NO-UNDO.  
    DEFINE INPUT PARAM p-cotacao-mensal AS decimal INITIAL ? NO-UNDO.  /*Cotação Mensal (Uso Interno: mguni.cotacao.cota-mensal)*/
    DEFINE INPUT PARAM p-cotacao-media AS decimal INITIAL ? NO-UNDO.  /*Cotação Média (Uso Interno: mguni.cotacao.cota-media)*/
    DEFINE INPUT PARAM p-cotacoes AS CHAR NO-UNDO.
    DEFINE OUTPUT PARAM TABLE FOR tt_log_erro.
/*PARAMETERS - END*/


/*LOCAL VARIABLES - BEGIN*/
    DEF VAR i-num AS INT INITIAL 1 NO-UNDO.
    DEF VAR i-ano AS INT NO-UNDO.
    DEF VAR i-mes AS INT NO-UNDO.
    DEF VAR i-cont AS INT INITIAL 0 NO-UNDO.

/*LOCAL VARIABLES - END*/


/* ******************************************* */
/* *************** BODY - BEGIN ************** */
/* ******************************************* */

ASSIGN i-ano = int(SUBSTR(p-ano-periodo, 1, 4))
       i-mes = int(SUBSTR(p-ano-periodo, 6, 2)).

DO i-cont = 1 TO 31:
    CREATE ttRate.
    ASSIGN ttRate.Day = i-cont
           ttRate.Rate = dec(ENTRY(i-cont, p-cotacoes, ';'))
           ttRate.ttRateID = i-num
           i-num = i-num + 1.
END.
FOR EACH tt_log_erro:
    DELETE tt_log_erro.
END.
RUN PIUpsert (INPUT p-cotacao-media,
              INPUT '',
              INPUT cTranAction,
              INPUT p-cod-moeda,
              INPUT i-mes,
              INPUT p-cotacao-mensal,
              OUTPUT TABLE tt_log_erro,
              INPUT TABLE ttRate,
              INPUT i-ano).

FOR EACH ttRate:
    DELETE ttRate.
END.


/* ******************************************* */
/* *************** BODY - END   ************** */
/* ******************************************* */

END PROCEDURE.



