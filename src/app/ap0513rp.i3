/******************************************************************************
***
***  pi-contabiliza-resumido-periodo.
***
******************************************************************************/

for each estabelec 
    where estabelec.cod-estabel >= tt-param.estab-ini
    and   estabelec.cod-estabel <= tt-param.estab-fim no-lock:
    create w-estab.
    assign w-estab.w-estab = estabelec.cod-estabel.
end.

do  da-data = tt-param.dt-transac-ini to tt-param.dt-transac-fim:
    create w-data.
    assign w-data.w-data = da-data.
end.

if l-funcao = yes then do:
    run cdp/cdapi007a.p persistent set h-api.
end.    

if  param-ap.contabiliza = 1 then do:

    for each w-estab no-lock:

        assign l-criou = no.
        
        for each tt-diario-ap:
            delete tt-diario-ap.
        end.

        for each tt-lin-doc-pend exclusive-lock:
            delete tt-lin-doc-pend.
        end.

        for each tt-raw-lin-doc-pend exclusive-lock:
            delete tt-raw-lin-doc-pend.
        end.

        for each tt-doc-pendente exclusive-lock:
            delete tt-doc-pendente.
        end.

        for each tt-contabiliza exclusive-lock:
            delete tt-contabiliza.
        end.

        assign de-diferenca         = 0
               de-dif-fasb          = 0
               de-dif-cmi           = 0
               de-dif-presente      = 0
               l-possui             = no
               i-gera               = 0.

        if  l-funcao = yes then 
            assign v-num-seq-acum-db = 0
                   v-num-seq-acum-cr = 0.

        diario-block:
        for each w-data no-lock,
            each diario-ap no-lock
                 where diario-ap.ep-codigo     = tt-param.i-ep-codigo
                 and   diario-ap.cod-estabel   = w-estab.w-estab
                 and   diario-ap.dt-transacao  = w-data.w-data
                 and   diario-ap.cod-esp      >= tt-param.espec-ini
                 and   diario-ap.cod-esp      <= tt-param.espec-fim
                 and   diario-ap.referencia   >= tt-param.refer-ini
                 and   diario-ap.referencia   <= tt-param.refer-fim
                 break by diario-ap.ct-conta
                       by diario-ap.sc-conta:
                       
            assign de-diferenca = if  diario-ap.lancamento = 1
                                then de-diferenca + diario-ap.vl-debito
                                else de-diferenca - diario-ap.vl-credito
                   de-dif-fasb = if  diario-ap.lancamento = 1
                                then de-dif-fasb + diario-ap.vl-deb-fasb
                                else de-dif-fasb - diario-ap.vl-cred-fasb
                   de-dif-cmi = if  diario-ap.lancamento = 1
                                then de-dif-cmi + diario-ap.vl-deb-cmi
                                else de-dif-cmi - diario-ap.vl-cred-cmi
                   de-dif-presente = if  diario-ap.lancamento = 1
                                 then de-dif-presente + diario-ap.vl-deb-presente
                                 else de-dif-presente - diario-ap.vl-cred-presente.

            &IF "{&mgadm_dbtype}" = "PROGRESS" &THEN
                assign rw-mov-ap = to-rowid(diario-ap.titulo).
            &ELSE
                assign rw-mov-ap = to-rowid(diario-ap.char-1).
            &ENDIF

            assign da-data = w-data.w-data.
            
           /* A l¢gica abaixo ‚ para que o registro funcao nÆo seja lido a cada registro do diario-ap.
               se o registro funcao nao estiver disponivel ser  gerado assim mesmo a tt-funcao com os log's como NO
               devido que nos IF sao verficados se os logs estao como yes.

            */
            find tt-funcao 
                where tt-funcao.cd-funcao = "adm-fgl-ems-5.00" 
                no-lock no-error.
            if  not avail tt-funcao then do:
                find first funcao where funcao.cd-funcao = "adm-fgl-ems-5.00" 
                    no-lock no-error.
                if  avail funcao then do: 
                    create tt-funcao.
                    buffer-copy funcao to tt-funcao.
                end.
                else do:
                    create tt-funcao.
                    assign tt-funcao.cd-funcao = "adm-fgl-ems-5.00"
                           tt-funcao.log-1     = no
                           tt-funcao.ativo     = no.
                end.           
            end.

            if avail tt-funcao then do:
                if  tt-funcao.log-1 = yes
                and tt-funcao.ativo = yes then do:
                /*** Integra‡Æo EMS 2.0 ==> EMS 5.0 ***/
                   {app/ap0513rp.i9}
                   assign l-integra-app-fgl-ems5 = yes.
                end.
            end.

            assign l-possui  = yes
                   i-dia     = day(tt-param.dt-transac-fim)
                   i-mes     = month(tt-param.dt-transac-fim)
                   c-ano     = substr(string(year(tt-param.dt-transac-fim)),3,2)
                   c-referen = if  tt-param.espec-ini = tt-param.espec-fim then 
                                  substring({varinc/var00042.i 04 2},1,2) + tt-param.espec-ini + 
                                  string(i-dia,"99") + string(i-mes,"99") + c-ano
                               else 
                                  substring({varinc/var00042.i 04 2},1,2) + "AZ" + string(i-dia,"99") + 
                                  string(i-mes,"99") + c-ano.

            if  i-gera = 0 then do transaction:

                run pi-verificar-referencia-ct.
                if  return-value = 'NOK' then do:
                    assign de-diferenca     = 0
                           de-dif-fasb      = 0
                           de-dif-cmi       = 0
                           de-dif-presente  = 0
                           l-possui         = no.
                    undo diario-block, leave diario-block.
                end.
                
                assign i-gera = 1.

                create tt-doc-pendente.
                assign tt-doc-pendente.ep-codigo   = tt-param.i-ep-codigo
                       tt-doc-pendente.cod-estabel = diario-ap.cod-estabel
                       tt-doc-pendente.data-movto  = tt-param.dt-transac-fim
                       tt-doc-pendente.lp-codigo   = 0
                       tt-doc-pendente.referencia  = c-referen
                       i-emp-s                     = tt-param.i-ep-codigo
                       c-ref-s                     = c-referen
                       c-sis-s                     = "AP"
                       tt-doc-pendente.l-vid-rel   =  no
                       tt-doc-pendente.l-acompanha = yes
                       tt-doc-pendente.log-1       = no
                       l-criou = yes.
            end.

            if  avail param-fasb and param-fasb.moeda-cmi > 0
            and avail mov-ap
            and mov-ap.transacao = 9
            and diario-ap.vl-deb-cmi <> 0 and diario-ap.lancamento = 1 then
                run pi-tratar-traducao (input tt-param.dt-transac-fim).

            run pi-criar-tt-diario-ap.

            assign i-cont = i-cont + 1.

            if  diario-ap.lancamento = 1 then
                assign de-vl-debito    = de-vl-debito   + diario-ap.vl-debito
                       de-vl-deb-fasb  = de-vl-deb-fasb + diario-ap.vl-deb-fasb
                       de-vl-deb-cmi   = de-vl-deb-cmi  + diario-ap.vl-deb-cmi
                       de-vl-deb-pres  = de-vl-deb-pres + diario-ap.vl-deb-presente.
            else
                assign de-vl-credito   = de-vl-credito   + diario-ap.vl-credito
                       de-vl-cred-fasb = de-vl-cred-fasb + diario-ap.vl-cred-fasb
                       de-vl-cred-cmi  = de-vl-cred-cmi  + diario-ap.vl-cred-cmi
                       de-vl-cred-pres = de-vl-cred-pres + diario-ap.vl-cred-presente.

            run pi-prepara-execucao-orcamentaria (input "Realiza").

            if l-funcao = yes then do:
                &if defined(BF_FIN_203) &then
                    if  v-num-seq-acum-db = 0 
                    and diario-ap.lancamento = 1 then
                        assign v-num-seq-acum-db = i-seq-acum + 1.

                    if  v-num-seq-acum-cr = 0
                    and diario-ap.lancamento = 2 then
                        assign v-num-seq-acum-cr = i-seq-acum + 1.

                    assign i-seq-acum = i-seq-acum + 1.    


                    &IF "{&mgadm_dbtype}" = "PROGRESS" &THEN
                        assign rw-mov-ap = to-rowid(diario-ap.titulo).
                    &ELSE
                        assign rw-mov-ap = to-rowid(diario-ap.char-1).
                    &ENDIF

                    find mov-ap no-lock 
                        where rowid(mov-ap) = rw-mov-ap no-error.

                    if  avail mov-ap 
                    and mov-ap.ep-codigo    = tt-param.i-ep-codigo
                    and mov-ap.cod-estabel  = diario-ap.cod-estabel
                    and mov-ap.cod-esp      = diario-ap.cod-esp
                    and mov-ap.serie        = diario-ap.serie
                    and mov-ap.nr-docto     = diario-ap.nr-docto
                    and mov-ap.parcela      = diario-ap.parcela
                    and mov-ap.cod-fornec   = diario-ap.cod-fornec
                    and mov-ap.dt-transacao = diario-ap.dt-transacao then do:
                        create tt-relacto-ctbl.
                        assign tt-relacto-ctbl.ep-codigo         = tt-param.i-ep-codigo 
                               tt-relacto-ctbl.cod-estabel       = diario-ap.cod-estabel
                               tt-relacto-ctbl.referencia        = c-referen
                               tt-relacto-ctbl.sequencia         = if  diario-ap.lancamento = 1 then
                                                                       v-num-seq-acum-db
                                                                   else
                                                                       v-num-seq-acum-cr
                               tt-relacto-ctbl.cod-modul         = "AP"
                               tt-relacto-ctbl.num-id-origem     = mov-ap.num-id-mov-ap
                               tt-relacto-ctbl.tip-orig-modul    = 1
                               tt-relacto-ctbl.num-id-movto-ctbl = 0
                               tt-relacto-ctbl.vl-relacto        = if  diario-ap.lancamento = 1 then
                                                                       diario-ap.vl-debito
                                                                   else
                                                                       diario-ap.vl-credito
                               tt-relacto-ctbl.num-id-relacto    = 0.
                    end.
                    else do:
                        &IF "{&mgadm_dbtype}" = "PROGRESS" &THEN
                            assign rw-impto-ap = to-rowid(diario-ap.titulo).
                        &ELSE 
                            assign rw-impto-ap = to-rowid(diario-ap.char-1).
                        &ENDIF

                        find impto-tit-ap no-lock
                            where rowid(impto-tit-ap) = rw-impto-ap no-error.

                        if  avail impto-tit-ap then do:
                            create tt-relacto-ctbl.
                            assign tt-relacto-ctbl.ep-codigo         = tt-param.i-ep-codigo
                                   tt-relacto-ctbl.cod-estabel       = diario-ap.cod-estabel
                                   tt-relacto-ctbl.referencia        = c-referen
                                   tt-relacto-ctbl.sequencia         = if  diario-ap.lancamento = 1 then
                                                                           v-num-seq-acum-db
                                                                       else
                                                                           v-num-seq-acum-cr
                                   tt-relacto-ctbl.cod-modul         = "AP"
                                   tt-relacto-ctbl.num-id-origem     = impto-tit-ap.num-id-impto-tit-ap
                                   tt-relacto-ctbl.tip-orig-modul    = 2
                                   tt-relacto-ctbl.num-id-movto-ctbl = 0
                                   tt-relacto-ctbl.vl-relacto        = if  diario-ap.lancamento = 1 then
                                                                           diario-ap.vl-debito
                                                                       else
                                                                           diario-ap.vl-credito
                                   tt-relacto-ctbl.num-id-relacto    = 0.
                        end.
                    end.
                &endif        
            end.

            if  last-of(diario-ap.ct-conta)
            or  last-of(diario-ap.sc-conta) then do transaction:

                {utp/ut-liter.i Ref._Movto_Contas_Pagar_de MAP L}
                assign c-historico = trim(return-value) + " " + string(tt-param.dt-transac-fim, "99/99/9999").

                /*--- UPC Hist¢rico ---*/        
                {app/ap0513rp.i7}

                if  de-vl-debito <> 0  or de-vl-deb-fasb <> 0
                or  de-vl-deb-cmi <> 0 or de-vl-deb-pres <> 0 then do:
                    create tt-lin-doc-pend.
                    assign i-seq-acum                     = i-seq-acum + 1
                           tt-lin-doc-pend.ep-codigo      = tt-param.i-ep-codigo
                           tt-lin-doc-pend.referencia     = c-referen
                           tt-lin-doc-pend.cod-estabel    = w-estab.w-estab
                           tt-lin-doc-pend.ct-codigo      = diario-ap.ct-conta
                           tt-lin-doc-pend.sc-codigo      = diario-ap.sc-conta
                           tt-lin-doc-pend.conta-contabil = diario-ap.conta-contabil
                           tt-lin-doc-pend.reduzida       = 0
                           tt-lin-doc-pend.transacao      = 1
                           tt-lin-doc-pend.hp-codigo      = 0
                           tt-lin-doc-pend.complemento    = ""
                           tt-lin-doc-pend.historico      = c-historico
                           tt-lin-doc-pend.valor          = de-vl-debito
                           tt-lin-doc-pend.valor-fasb     = de-vl-deb-fasb
                           tt-lin-doc-pend.valor-cmi      = de-vl-deb-cmi
                           tt-lin-doc-pend.valor-presente = de-vl-deb-pres.
                    if l-funcao = yes then do:
                        &if defined(BF_FIN_203) &then
                            assign tt-lin-doc-pend.sequencia = v-num-seq-acum-db.
                        &endif                                
                    end.
                    else
                        assign tt-lin-doc-pend.sequencia = i-seq-acum.

                    if  tt-param.estab-ini = tt-param.estab-fim then do:
                        if  l-funcao-maeda then do:
                            assign tt-lin-doc-pend.cod-estabel = tt-param.estab-ini.
                        end.   
                    end.       

                    create tt-raw-lin-doc-pend.
                    raw-transfer tt-lin-doc-pend to tt-raw-lin-doc-pend.raw-lin-doc-pend.
                end.

                if  de-vl-credito <> 0  or de-vl-cred-fasb <> 0
                or  de-vl-cred-cmi <> 0 or de-vl-cred-pres <> 0 then do:
                    create tt-lin-doc-pend.
                    assign i-seq-acum                     = i-seq-acum + 1
                           tt-lin-doc-pend.ep-codigo      = tt-param.i-ep-codigo
                           tt-lin-doc-pend.referencia     = c-referen
                           tt-lin-doc-pend.cod-estabel    = w-estab.w-estab
                           tt-lin-doc-pend.ct-codigo      = diario-ap.ct-conta
                           tt-lin-doc-pend.sc-codigo      = diario-ap.sc-conta
                           tt-lin-doc-pend.conta-contabil = diario-ap.conta-contabil
                           tt-lin-doc-pend.reduzida       = 0
                           tt-lin-doc-pend.transacao      = 2
                           tt-lin-doc-pend.hp-codigo      = 0
                           tt-lin-doc-pend.complemento    = ""
                           tt-lin-doc-pend.historico      = c-historico
                           tt-lin-doc-pend.valor          = de-vl-credito
                           tt-lin-doc-pend.valor-fasb     = de-vl-cred-fasb
                           tt-lin-doc-pend.valor-cmi      = de-vl-cred-cmi
                           tt-lin-doc-pend.valor-presente = de-vl-cred-pres.
                    if l-funcao = yes then do:
                        &if defined(BF_FIN_203) &then
                            assign tt-lin-doc-pend.sequencia = v-num-seq-acum-cr.
                        &endif        
                    end.
                    else
                        assign tt-lin-doc-pend.sequencia = i-seq-acum.

                    if  tt-param.estab-ini = tt-param.estab-fim then do:
                        if  l-funcao-maeda then do:
                            assign tt-lin-doc-pend.cod-estabel = tt-param.estab-ini.
                        end.   
                    end.       

                    create tt-raw-lin-doc-pend.
                    raw-transfer tt-lin-doc-pend to tt-raw-lin-doc-pend.raw-lin-doc-pend.
                end.

                assign de-vl-debito         = 0
                       de-vl-deb-fasb       = 0
                       de-vl-deb-cmi        = 0
                       de-vl-deb-pres       = 0
                       de-vl-credito        = 0
                       de-vl-cred-fasb      = 0
                       de-vl-cred-cmi       = 0
                       de-vl-cred-pres      = 0.

                if l-funcao = yes then                        
                    assign v-num-seq-acum-db = 0
                           v-num-seq-acum-cr = 0.

            end.

        end.

        run pi-gera-movimento.  
        
        for each tt-erro exclusive-lock:
            delete tt-erro.
        end.

        find first tt-contabiliza where tt-contabiliza.log-contabiliza = no no-error.
        if  not avail tt-contabiliza then do:
            find first tt-doc-pendente no-error.
            if  avail tt-doc-pendente then do:
                if l-funcao = yes then do:
                    &if defined(BF_FIN_203) &then
                        run execute in h-api (input  table tt-doc-pendente,
                                              input  table tt-raw-lin-doc-pend,
                                              input  table tt-relacto-ctbl,
                                              output table tt-erro).
                    &endif                                                  
                end.
                else do:
                    run cdp/cdapi007.p (input  table tt-doc-pendente,
                                        input  table tt-raw-lin-doc-pend,
                                        output table tt-erro).
                end.                        
            end.
        end.

        find first tt-erro where tt-erro.l-contabilizou = no no-error.
        if  not avail tt-erro then do:
            RUN pi-efetua-execucao-orcamentaria.
            if return-value = "NOK" then do:
                for each tt_log_erros:            
                    run utp/ut-msgs.p(input "show",
                                      input 25997,
                                      input tt_log_erros.ttv_des_erro + '~~' +
                                            tt_log_erros.ttv_des_ajuda).
        
                    run pi-print-editor(return-value, 80).
        
                    for each tt-editor:
                        disp tt-editor.conteudo with frame f-msg-editor.
                        down with frame f-msg-editor.
                    end.
                    return error.
                end.
            end.   
            run pi-atualiza-data-inicio.
        end.
        
        for each tt_xml_input_1.
            delete tt_xml_input_1.
        end.

        for each tt-erro:

            assign  i-ep-codigo = int(entry(1, tt-erro.c-arquivo-erro, ","))
                    c-referencia  = entry(2, tt-erro.c-arquivo-erro, ",")
                    c-cod-estabel = entry(3, tt-erro.c-arquivo-erro, ",").

            if w-estab.w-estab <> c-cod-estabel then
               next. 

            display c-referencia
                    c-cod-estabel
                    tt-erro.c-desc-erro   @ c-mensagem-erro with frame f-mensagem.
            down with frame f-mensagem.

        end.    

        if  l-integra-app-fgl-ems5 then do:
            for each tt-erro no-lock
                where tt-erro.l-contabilizou = no:

                assign c-cod-estabel = entry(3, tt-erro.c-arquivo-erro, ",").

                for each w-data no-lock:
                    for each diario-ap no-lock
                        where diario-ap.ep-codigo     = tt-param.i-ep-codigo
                        and   diario-ap.dt-transacao  = w-data.w-data
                        and   diario-ap.cod-estabel   = c-cod-estabel
                        and   diario-ap.cod-esp      >= tt-param.espec-ini
                        and   diario-ap.cod-esp      <= tt-param.espec-fim
                        and   diario-ap.referencia   >= tt-param.refer-ini
                        and   diario-ap.referencia   <= tt-param.refer-fim:

                        for each mov-ap exclusive-lock
                            where mov-ap.ep-codigo    = tt-param.i-ep-codigo
                            and   mov-ap.cod-estabel  = diario-ap.cod-estabel
                            and   mov-ap.cod-esp      = diario-ap.cod-esp
                            and   mov-ap.serie        = diario-ap.serie
                            and   mov-ap.nr-docto     = diario-ap.nr-docto
                            and   mov-ap.parcela      = diario-ap.parcela
                            and   mov-ap.cod-fornec   = diario-ap.cod-fornec
                            and   mov-ap.dt-transacao = diario-ap.dt-transacao:
                            assign mov-ap.contabilizou = no.
                        end.

                        for each impto-tit-ap exclusive-lock
                            where impto-tit-ap.ep-codigo    = tt-param.i-ep-codigo
                            and   impto-tit-ap.cod-estabel  = diario-ap.cod-estabel
                            and   impto-tit-ap.cod-esp      = diario-ap.cod-esp
                            and   impto-tit-ap.serie        = diario-ap.serie
                            and   impto-tit-ap.nr-docto     = diario-ap.nr-docto
                            and   impto-tit-ap.parcela      = diario-ap.parcela
                            and   impto-tit-ap.cod-fornec   = diario-ap.cod-fornec
                            and   impto-tit-ap.dt-transacao = diario-ap.dt-transacao:
                            assign impto-tit-ap.contabilizou = no.
                        end.
                    end.
                end.
            end.
        end.

        do  da-data = tt-param.dt-transac-ini to tt-param.dt-transac-fim:

            find first diario-ap use-index ch-empresa
                where diario-ap.ep-codigo    = tt-param.i-ep-codigo
                and   diario-ap.dt-transacao = da-data no-lock no-error.
            if  not avail diario-ap then
                next.
            else do:

                assign i-dia     = day(tt-param.dt-transac-fim)
                       i-mes     = month(tt-param.dt-transac-fim)
                       c-ano     = substr(string(year(tt-param.dt-transac-fim)),3,2)        
                       c-referen = if  tt-param.espec-ini = tt-param.espec-fim then 
                                       substring({varinc/var00042.i 04 2},1,2) + tt-param.espec-ini + 
                                       string(i-dia,"99") + string(i-mes,"99") + c-ano
                                   else 
                                       substring({varinc/var00042.i 04 2},1,2) + "AZ" + string(i-dia,"99") + 
                                       string(i-mes,"99") + c-ano.

                assign l-referencia = yes.
                /* A l¢gica abaixo ‚ para que o registro funcao nÆo seja lido a cada registro do diario-ap.
                   se o registro funcao nao estiver disponivel ser  gerado assim mesmo a tt-funcao com os log's como NO
                   devido que nos IF sao verficados se os logs estao como yes.

                */
                find tt-funcao 
                    where tt-funcao.cd-funcao = "adm-fgl-ems-5.00" 
                    no-lock no-error.
                if  not avail tt-funcao then do:
                    find first funcao where funcao.cd-funcao = "adm-fgl-ems-5.00" 
                        no-lock no-error.
                    if  avail funcao then do: 
                        create tt-funcao.
                        buffer-copy funcao to tt-funcao.
                    end.
                    else do:
                        create tt-funcao.
                        assign tt-funcao.cd-funcao = "adm-fgl-ems-5.00"
                               tt-funcao.log-1     = no
                               tt-funcao.ativo     = no.
                    end.           
                end.

                if  avail tt-funcao then do:
                    if  tt-funcao.log-1 = yes and 
                        tt-funcao.ativo = no  then
                        assign l-referencia = no.
                end.

                assign c-cod-estab = w-estab.w-estab.
                
                if  l-referencia then do:
                    find first tt-doc-pendente
                         where tt-doc-pendente.ep-codigo   = tt-param.i-ep-codigo
                         and   tt-doc-pendente.cod-estabel = w-estab.w-estab
                         and   tt-doc-pendente.referencia  = c-referen no-lock no-error.
                    find first referencia-ct
                         where referencia-ct.ep-codigo   = tt-param.i-ep-codigo
                           and referencia-ct.cod-estabel = w-estab.w-estab
                           and referencia-ct.referencia  = c-referen no-lock no-error.
                    if  avail referencia-ct and avail tt-doc-pendente then do:
                        run pi-atualizar-movimentacoes.
                    end.
                end.
                else do:
                    run pi-atualizar-movimentacoes.
                end.     
            end.             
        end.  /* do data */
    end.
end.
else do:

    {app/ap0513.i4}

    for each w-estab no-lock,
        each w-data no-lock,
        each diario-ap no-lock
            where diario-ap.ep-codigo     = tt-param.i-ep-codigo
            and   diario-ap.cod-estabel   = w-estab.w-estab
            and   diario-ap.dt-transacao  = w-data.w-data
            and   diario-ap.cod-esp      >= tt-param.espec-ini
            and   diario-ap.cod-esp      <= tt-param.espec-fim
            and   diario-ap.referencia   >= tt-param.refer-ini
            and   diario-ap.referencia   <= tt-param.refer-fim:

        for each mov-ap exclusive-lock
            where mov-ap.ep-codigo    = tt-param.i-ep-codigo
            and   mov-ap.cod-estabel  = diario-ap.cod-estabel
            and   mov-ap.cod-esp      = diario-ap.cod-esp
            and   mov-ap.serie        = diario-ap.serie
            and   mov-ap.nr-docto     = diario-ap.nr-docto
            and   mov-ap.parcela      = diario-ap.parcela
            and   mov-ap.cod-fornec   = diario-ap.cod-fornec
            and   mov-ap.dt-transacao = diario-ap.dt-transacao:
            assign mov-ap.contabilizou = yes.
        end.

        for each  impto-tit-ap exclusive-lock
            where impto-tit-ap.ep-codigo    = tt-param.i-ep-codigo
            and   impto-tit-ap.cod-estabel  = diario-ap.cod-estabel
            and   impto-tit-ap.cod-esp      = diario-ap.cod-esp
            and   impto-tit-ap.serie        = diario-ap.serie
            and   impto-tit-ap.nr-docto     = diario-ap.nr-docto
            and   impto-tit-ap.parcela      = diario-ap.parcela
            and   impto-tit-ap.cod-fornec   = diario-ap.cod-fornec
            and   impto-tit-ap.dt-transacao = diario-ap.dt-transacao:
            assign impto-tit-ap.contabilizou = yes.
        end.
    end.
    
    find first tt-erro 
        where tt-erro.l-contabilizou = no no-error.
    
    if  not avail tt-erro then 
        run pi-atualiza-data-inicio.

end.

if l-funcao = yes then
    delete procedure h-api.

/* Fim de Include */
