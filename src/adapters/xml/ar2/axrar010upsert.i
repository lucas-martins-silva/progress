IF tt-item.lote         = ? THEN
   ASSIGN  tt-item.lote = "".
     
IF tt-item.cod-refer    = ? THEN
   ASSIGN tt-item.cod-refer = "".

RUN cep/ceapi027.p  (INPUT TABLE tt-item,
                     OUTPUT TABLE tt-erro).


FOR EACH tt-erro:

    CREATE  tt_log_erro.
    ASSIGN  tt_log_erro.ttv_num_cod_erro  =  tt-erro.cd-erro
            tt_log_erro.ttv_des_msg_erro  = tt-erro.mensagem.
END.

