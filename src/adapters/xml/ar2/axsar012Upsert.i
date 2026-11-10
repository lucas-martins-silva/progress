PROCEDURE PITransUpsert:

/*PARAMETERS - BEGIN*/
    DEFINE INPUT PARAM pCodEstabel LIKE movto-estoq.cod-estabel NO-UNDO.
    DEFINE INPUT PARAM pItCodigo   LIKE movto-estoq.it-codigo   NO-UNDO.
    DEFINE INPUT PARAM pLote       LIKE movto-estoq.lote        NO-UNDO.
    DEFINE OUTPUT PARAM TABLE FOR tt_log_erro.
/*PARAMETERS - END*/


/*LOCAL VARIABLES - BEGIN*/
    DEFINE VARIABLE i-status    AS INTEGER             NO-UNDO.
/*LOCAL VARIABLES - END*/


/* ******************************************* */
/* *************** BODY - BEGIN ************** */
/* ******************************************* */

   assign i-status = 1. /*1-liberado, 2-Rejeitado e 3-CQ*/

    FIND FIRST saldo-estoq
     WHERE saldo-estoq.cod-estabel  = pCodEstabel
       AND saldo-estoq.it-codigo    = pItCodigo
       AND saldo-estoq.lote         = pLote NO-LOCK NO-ERROR.

    IF NOT AVAIL saldo-estoq THEN DO:
        {utp/ut-liter.i Saldo_estoque * r}
        CREATE TT_LOG_ERRO.
        ASSIGN TT_LOG_ERRO.TTV_NUM_COD_ERRO = 5561
               TT_LOG_ERRO.TTV_DES_MSG_ERRO = TRIM(RETURN-VALUE).
        
        RETURN "NOK":U.
    END.

    &IF '{&bf_mat_versao_ems}' >= '2.08'        AND
        '{&bf_lote_avancado_liberado}' = 'yes'  &THEN 

        IF CAN-FIND(funcao WHERE funcao.cd-funcao = "lote-avancado":u 
                             AND funcao.ativo     = yes) THEN DO:
        
            FIND FIRST fda-lote-avancad
                 WHERE fda-lote-avancad.it-codigo = pItCodigo
                   AND fda-lote-avancad.nr-lote   = pLote NO-LOCK NO-ERROR.
        
            IF NOT AVAIL fda-lote-avancad THEN DO:
                {utp/ut-liter.i Lote_avan‡ado * r}
                CREATE TT_LOG_ERRO.
                ASSIGN TT_LOG_ERRO.TTV_NUM_COD_ERRO = 5561
                       TT_LOG_ERRO.TTV_DES_MSG_ERRO = TRIM(RETURN-VALUE).
                RETURN "NOK":U.
            END.
        
            FIND FIRST fda-lote-estado
                 WHERE fda-lote-estado.cod-status = fda-lote-avancad.cod-status NO-LOCK NO-ERROR.
        
            IF NOT AVAIL fda-lote-estado THEN DO:
                {utp/ut-liter.i Estado_do_lote * r}
                CREATE TT_LOG_ERRO.
                ASSIGN TT_LOG_ERRO.TTV_NUM_COD_ERRO = 5561
                       TT_LOG_ERRO.TTV_DES_MSG_ERRO = TRIM(RETURN-VALUE).
                RETURN "NOK":U.
            END.
            ASSIGN i-status = fda-lote-estado.idi-tip-estado.
        END.
    
    &ELSE 
        FIND FIRST deposito
             WHERE deposito.cod-depos = saldo-estoq.cod-depos NO-LOCK NO-ERROR.

        IF NOT AVAIL deposito THEN DO:
            {utp/ut-liter.i Dep¢sito * r}
            CREATE TT_LOG_ERRO.
            ASSIGN TT_LOG_ERRO.TTV_NUM_COD_ERRO = 5561
                   TT_LOG_ERRO.TTV_DES_MSG_ERRO = TRIM(RETURN-VALUE).
            RETURN "NOK":U.
        END.
    
        IF deposito.ind-dep-cq = YES THEN
            assign i-status = 3.
            ELSE IF deposito.ind-dep-rej = YES THEN
                assign i-status = 2.
                ELSE
                    assign i-status = 1.
    &ENDIF



     RUN PIUpsert
     (
          INPUT "ItemLote",
          INPUT "add",
          INPUT saldo-estoq.dt-vali-lote,
          INPUT i-status,
          INPUT pItCodigo,
          INPUT pLote,
          INPUT pCodEstabel,
          OUTPUT TABLE tt_log_erro
      ).



/* ******************************************* */
/* *************** BODY - END   ************** */
/* ******************************************* */

END PROCEDURE.



