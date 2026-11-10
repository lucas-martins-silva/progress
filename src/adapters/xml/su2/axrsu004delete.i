IF SEARCH("ccp/ccapi303.r":U) <> ? THEN DO:
	
    FIND FIRST tt-pedido-compr
         WHERE tt-pedido-compr.num-pedido = PONumber EXCLUSIVE-LOCK NO-ERROR.
    
    IF NOT AVAIL tt-pedido-compr THEN DO:
        CREATE tt-pedido-compr.
        ASSIGN tt-pedido-compr.num-pedido     = PONumber
               tt-pedido-compr.ind-tipo-movto = 3.
    END.
   
    {utp/ut-liter.i "ELIMINADO VIA INTEGRA€ÇO"}
    ASSIGN tt-pedido-compr.mot-elimina  = IF DeleteComment <> "" AND DeleteComment <> ? THEN DeleteComment ELSE RETURN-VALUE.
    
    CREATE tt-versao-integr.
    ASSIGN tt-versao-integr.cod-versao-integracao = 001
           tt-versao-integr.ind-origem-msg        = 01.

    run ccp/ccapi303.p (input  table tt-versao-integr,
                        output table tt-erros-geral,
                        input  table tt-pedido-compr,
                        input  table tt-cond-especif,
                        input  table tt-ordem-compra,
                        input  table tt-prazo-compra,
                        input  table tt-cotacao-item
                        &if defined(bf_mat_despesa_fase_II) &then
                             , input table tt-desp-cotacao-item
                        &endif).
END.
ELSE DO:
    CREATE tt_log_erro.
       /* Inicio -- Projeto Internacional */
       {utp/ut-liter.i "Erro_de_integra‡Æo._NÆo_foi_poss¡vel_localizar_o_programa_'ccp/ccapi303.p'_a_ser_executado_pelo_programa_adapters/xml/su2/axrsu002.p" *}
       ASSIGN tt_log_erro.ttv_num_cod_erro = 0
              tt_log_erro.ttv_des_msg_erro = RETURN-VALUE + '.'.

       /* Inicio -- Projeto Internacional */
       {utp/ut-liter.i "Erro_de_integra‡Æo._NÆo_foi_poss¡vel_localizar_o_programa_'ccp/ccapi303.p'_a_ser_executado_pelo_programa_adapters/xml/su2/axrsu002.p" *}
       RUN setError IN hMessageHandler (INPUT 0,
                                        INPUT "enviroment_error":U,
                                        INPUT RETURN-VALUE + '.').

END.


/* ---- Seta para o Adapter que a transacao contem Erro --- */
FOR EACH tt-erros-geral:
     RUN setError IN hMessageHandler (INPUT tt-erros-geral.cod-erro,
                                      INPUT "business_error":U,  /* Erro de neg¢cio */
                                      INPUT tt-erros-geral.des-erro).
     CREATE tt_log_erro.
     ASSIGN tt_log_erro.ttv_num_cod_erro = tt-erros-geral.cod-erro
            tt_log_erro.ttv_des_msg_erro = tt-erros-geral.des-erro.
END.

/* ---- Seta para o Adapter que a transacao contem Erro --- */
IF CAN-FIND(FIRST tt_log_erro) THEN 
   ASSIGN lSuccessProcess = NO
          cReturnValue    = "NOK".
