PROCEDURE PITransDelete:

/*PARAMETERS - BEGIN*/
DEF INPUT  PARAM pRepresentativeID          AS INTEGER NO-UNDO.
DEF INPUT  PARAM pRepresentativeDescription AS CHAR    NO-UNDO.
DEF INPUT  PARAM pRepresentativeShortName   AS CHAR    NO-UNDO.
DEF OUTPUT PARAM TABLE FOR tt_log_erro.
/*PARAMETERS - END*/

/* ******************************************* */
/* *************** BODY - BEGIN ************** */
/* ******************************************* */

    EMPTY TEMP-TABLE tt_log_erro NO-ERROR.

    RUN PIDelete (INPUT  "":U,                       /*Event                     */
                  INPUT  "del":U,                    /*TranAction                */
                  INPUT  pRepresentativeID,          /*RepresentativeID          */
                  INPUT  pRepresentativeDescription, /*RepresentativeDescription */
                  INPUT  pRepresentativeShortName,   /*RepresentativeShortName   */
                  OUTPUT TABLE tt_log_erro ).        /*Mensagens de ERRO         */

/* ******************************************* */
/* *************** BODY - END   ************** */
/* ******************************************* */

END PROCEDURE.
