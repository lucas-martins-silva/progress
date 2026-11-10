find first estabelec no-lock
     where estabelec.ep-codigo = i-ep-codigo-usuario no-error.
if not avail estabelec then
    find first estabelec no-lock no-error.


if avail estabelec then
     assign c-estabel = estabelec.cod-estabel.
else assign c-estabel = "".



create tt-proj-inv.
assign tt-proj-inv.ind-transacao    = 3
       tt-proj-inv.ep-codigo        = &IF "{&mguni_version}" >= "2.071" &THEN String(CompanyCode_00) &ELSE CompanyCode_00 &ENDIF
       tt-proj-inv.num-projeto      = ProjectNumber_00
       tt-proj-inv.sigla            = ProjectId_00
       tt-proj-inv.cons-proj-modelo = no
       tt-proj-inv.cod-est-exec     = c-estabel.


IF(IDTask_00 <> ? AND IDTask_00 <> "") OR (OrderNumber_00 <> ? AND OrderNumber_00 <> 0 ) THEN DO:
    CREATE tt-sub-div-ordem.
    ASSIGN tt-sub-div-ordem.cod-id-solum = IF IDTask_00 = ? THEN "" ELSE IDTask_00
           tt-sub-div-ordem.num-ordem    = IF OrderNumber_00 = ? THEN 0 ELSE OrderNumber_00.
END.


run cdp/cdapi036.p (input table tt-proj-inv,
                    input table tt-sub-div-ordem,
                    output table tt-erro,
                    output table tt-retorno-efetiv).

if can-find(first tt-erro) then do:
    for each tt-erro:
        create tt_log_erro.
        assign tt_log_erro.ttv_num_cod_erro = tt-erro.cd-erro
               tt_log_erro.ttv_des_msg_ajuda = tt-erro.mensagem 
               tt_log_erro.ttv_des_msg_erro  = tt-erro.mensagem.
        RUN setError IN hMessageHandler (INPUT tt_log_erro.ttv_num_cod_erro,
                                         INPUT "enviroment_error":U,
                                         INPUT tt_log_erro.ttv_des_msg_erro).      
    end.
end.
