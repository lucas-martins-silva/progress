PROCEDURE PIUserUpsert:

/*PARAMETERS - BEGIN*/
DEFINE INPUT  PARAM cUserAction   AS CHAR  NO-UNDO . /* add/upd */
DEFINE INPUT  PARAM UserID_00     AS ROWID NO-UNDO  .  
DEFINE OUTPUT PARAM TABLE FOR tt_log_erro.
/*PARAMETERS - END*/


/*LOCAL VARIABLES - BEGIN*/
/*LOCAL VARIABLES - END*/


/* ******************************************* */
/* *************** BODY - BEGIN ************** */
/* ******************************************* */

    EMPTY TEMP-TABLE tt_log_erro NO-ERROR.

    FIND FIRST usuar_mestre WHERE ROWID(usuar_mestre) = UserID_00 NO-LOCK.

    IF AVAIL usuar_mestre THEN DO:

        RUN PIUpsert
          (
              INPUT "":U,
              INPUT cUserAction,
              OUTPUT TABLE tt_log_erro,
              INPUT usuar_mestre.cod_e_mail_local,
              INPUT usuar_mestre.cod_usuario,
              INPUT usuar_mestre.cod_idiom_orig,
              INPUT usuar_mestre.nom_usuario,
              INPUT trim(usuar_mestre.ind_tip_usuar),
              INPUT usuar_mestre.dat_fim_valid,
              INPUT usuar_mestre.dat_inic_valid
          ).
        RETURN RETURN-VALUE.
    END.


/* ******************************************* */
/* *************** BODY - END   ************** */
/* ******************************************* */

END PROCEDURE.



