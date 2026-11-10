

{cdg/cdg0666.i}   /* tt-erro */
{utp/ut-glob.i} 

DEF VAR de-val-refer-atualiz AS DEC           NO-UNDO.
def VAR iContErro            AS INT initial 0 NO-UNDO.
DEF VAR iContCalendar        AS INT INIT 0 NO-UNDO.
DEF VAR iContCalInfor        AS INT INIT 0 NO-UNDO.

/*** calen-gener -> calend-dbr ***/
DEFINE TEMP-TABLE tt-calend-dbr NO-UNDO
    FIELD cod-calend AS CHARACTER
    FIELD des-calend AS CHARACTER
    INDEX codigo IS PRIMARY UNIQUE
          cod-calend.

/*** calen-data -> dat-calend ***/
DEFINE TEMP-TABLE tt-dat-calend NO-UNDO
    FIELD cod-calend    AS CHARACTER
    FIELD data          AS DATE 
    FIELD log-dia-util  AS LOGICAL
    FIELD tipo-dia      AS INTEGER /*** 1- étil 2- Descanso 3- Feriado ***/
    INDEX id IS PRIMARY UNIQUE
          cod-calend data
    INDEX dia-util
          cod-calend
          data
          log-dia-util.
