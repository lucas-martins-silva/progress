/*LOCAL VARIABLES - BEGIN*/
DEFINE VAR cReturnValue         AS CHARACTER INITIAL ? NO-UNDO.
DEFINE VAR cTranAction          AS CHARACTER INITIAL ? NO-UNDO.
DEFINE VAR cTranEvent           AS CHARACTER INITIAL ? NO-UNDO.
DEFINE VAR cTranVersion         AS CHARACTER INITIAL ? NO-UNDO.
DEFINE VAR DateValidLot         AS DATE      INITIAL ? NO-UNDO.  /*Validade do Lote*/
DEFINE VAR hBusinessContent     AS HANDLE              NO-UNDO.
DEFINE VAR hGenXml              AS HANDLE              NO-UNDO.
DEFINE VAR hMessageHandler      AS HANDLE              NO-UNDO.
DEFINE VAR lSuccessProcess      AS LOGICAL   INITIAL ? NO-UNDO.
DEFINE VAR UpdateReferCode      AS LOGICAL   INITIAL ? NO-UNDO.  /*Uso Interno: Campo = item.alt-refer*/

DEFINE TEMP-TABLE tt_log_erro NO-UNDO
     FIELD ttv_num_cod_erro AS integer INITIAL ?
     FIELD ttv_des_msg_ajuda AS character INITIAL ?
     FIELD ttv_des_msg_erro AS character INITIAL ?
.

DEFINE TEMP-TABLE tt-item NO-UNDO LIKE ITEM
        FIELD lote AS CHAR
        FIELD dt-vali-lote AS DATE.


{cdp/cd0666.i} /*defini‡Æo temp-table de erro*/

