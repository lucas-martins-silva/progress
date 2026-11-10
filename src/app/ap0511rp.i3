/*******************************************************************************
***
***  app/ap0511rp.i3 - PI-EMISSAO-AUTOMATICA
***
*******************************************************************************/
    if  tt-param.gerar = yes then
        output stream s-copia to value(tt-param.copia) paged page-size 64 append.

    /* TESTE DE FORMULARIO */
    repeat:
        if  tt-param.formulario = yes then do:
            create w-cheque.
            assign w-valor   = 999999999.99
                   w-ext9100 = "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXX"
                             + "XXXXXXXXXXXXXXXXXXXXXXXXXXXXX"
                   w-nominal = "XXXXXXXXXXXXXXXXXXXX"
                   w-cidade  = "XXXXXXXXXXXXXXXXXXXXXXXXX"
                   w-dia     = 99
                   w-mes     = "XXXXXXXXXX"
                   w-ano1    = "9999".

            run pi-impres-cheque.

        end.
        else
            leave.

        assign l-imp-form   = yes
               i-formulario = i-formulario + 1.

        if  i-formulario = 2 then
            leave.

    end.

    assign i-cont   = 0
           r-cheque = ?
           de-valor = 0
           i-ind-e1 = 0.
           
    code-block:
    for each  che-emit use-index codigo
        where che-emit.ep-codigo   = tt-param.i-ep-codigo
        and   che-emit.portador    = tt-param.portador
        and   che-emit.cod-fornec >= tt-param.for-ini
        and   che-emit.cod-fornec <= tt-param.for-fim
        and   che-emit.dt-emissao >= tt-param.dat-ini
        and   che-emit.dt-emissao <= tt-param.dat-fim
        and   che-emit.nr-cheque  >= tt-param.cheque-ini
        and   che-emit.nr-cheque  <= tt-param.cheque-fim
        and   che-emit.nr-docto   >= tt-param.num-ini
        and   che-emit.nr-docto   <= tt-param.num-fim
        and   che-emit.nr-cheque   = 0
        and   che-emit.cancelado   = no
        and   che-emit.emitiu      = no
        and   che-emit.valor-docto > 0 exclusive-lock
        break by che-emit.portador
              by che-emit.literal
              by che-emit.dt-emissao
              by che-emit.nr-cheque:
        
                
                
        run pi-versao. /*-- Cria registro tit-ap (AN) --*/ 
        
        IF l-conf-favorec = YES 
            AND tt-param.conf-favorec = YES
            AND i-flag-last-doc = 0
            THEN DO:
        

            for each  b-che-emit use-index codigo exclusive-lock
                where b-che-emit.ep-codigo   = tt-param.i-ep-codigo
                and   b-che-emit.portador    = tt-param.portador
                and   b-che-emit.nr-cheque   = 0
                and   b-che-emit.cod-fornec >= tt-param.for-ini
                and   b-che-emit.cod-fornec <= tt-param.for-fim
                and   b-che-emit.dt-emissao >= tt-param.dat-ini
                and   b-che-emit.dt-emissao <= tt-param.dat-fim
                and   b-che-emit.nr-docto   >= tt-param.num-ini
                and   b-che-emit.nr-docto   <= tt-param.num-fim
                and   b-che-emit.cancelado   = no
                and   b-che-emit.emitiu      = no
                and   b-che-emit.valor-docto > 0
                break   by b-che-emit.portador
                        by b-che-emit.literal
                        by b-che-emit.dt-emissao
                        by b-che-emit.nr-cheque:

                ASSIGN i-val-cheque = i-val-cheque + b-che-emit.valor-docto.

                IF LAST-OF(b-che-emit.nr-cheque) THEN do:

                    ASSIGN p-literal = b-che-emit.literal
                           p-nominal = b-che-emit.nominal.

                    SESSION:SET-WAIT-STATE("":U).

                    run app/ap0511g.w(input talonario.prox-cheque,
                                      input i-val-cheque,
                                      input b-che-emit.dt-emissao,
                                      input-output p-literal,
                                      input-output p-nominal).

                    SESSION:SET-WAIT-STATE("GENERAL":U).

                    ASSIGN i-val-cheque = 0.
                    LEAVE.
                END.                        
            END.
            
            for each b-mov-ap EXCLUSIVE-LOCK                           
                where       b-mov-ap.nr-cheque   = b-che-emit.nr-cheque   
                and         b-mov-ap.ep-codigo   = b-che-emit.ep-codigo
                AND         b-mov-ap.portador    = b-che-emit.portador
                AND         b-mov-ap.cod-fornec  = b-che-emit.cod-fornec
                AND         b-mov-ap.cod-estabel = b-che-emit.cod-estabel: 

        
                assign      b-mov-ap.literal = p-literal               
                            b-mov-ap.nominal = p-nominal.              
            end.
        END.
        
        IF LAST-OF(che-emit.nr-cheque) THEN
             ASSIGN i-flag-last-doc = 0.  
        ELSE
             ASSIGN i-flag-last-doc = 1.  


        IF l-conf-favorec = YES 
            AND tt-param.conf-favorec = YES
            THEN 
                assign      che-emit.literal = p-literal
                            che-emit.nominal = p-nominal.
        /*end conf-favorec*/

        /************ MULTIPLANTA ************/
        {cdp/cd0006.i3 "che-emit.cod-estabel"}
        /*************************************/

        repeat : 
            RUN pi-valida-bancos-his.       
            if  RETURN-VALUE = "OK":U THEN
                leave.

           /**** Pr¢ximo cheque ****/
           run  pi-prox-cheque.
           if  RETURN-VALUE = "NOK":U THEN 
               leave code-block.

        end.
        assign r-cheque = rowid(che-emit).

        if  tt-param.list-tipo = 2 then do:
            find tt-estabelec
                where tt-estabelec.cod-estabel = che-emit.cod-estabel
                no-lock no-error.
            if  not avail tt-estabelec then do:
                find estabelec 
                    where estabelec.cod-estabel = che-emit.cod-estabel 
                    no-lock no-error.
                if  avail estabelec then do:
                    create tt-estabelec.
                    buffer-copy estabelec to tt-estabelec.
                end.
            end.            

            if  avail tt-estabelec then do:
                assign c-cidade = fill(" ",(25 - length(tt-estabelec.cidade))) + tt-estabelec.cidade.
            end.
        end.
        else do:
            if  avail empresa then do:
                assign c-cidade = fill(" ",(25 - length(empresa.cidade))) + empresa.cidade.
            end.
        end.

        assign de-valor = if  che-emit.transacao = 4 then
                              de-valor - che-emit.valor-docto
                          else
                              de-valor + che-emit.valor-docto.

        if  che-emit.transacao = 2 or 
            che-emit.transacao = 1 then do:

            find first b-mov-ap exclusive-lock
                 where b-mov-ap.num-id-mov-ap = int(che-emit.char-1) no-error.

            if  not avail b-mov-ap then do:
                find first b-mov-ap exclusive-lock
                     where b-mov-ap.ep-codigo    = che-emit.ep-codigo
                     and   b-mov-ap.cod-fornec   = che-emit.cod-fornec
                     and   b-mov-ap.cod-estabel  = che-emit.cod-estabel
                     and   b-mov-ap.cod-esp      = che-emit.cod-esp
                     and   b-mov-ap.serie        = che-emit.serie
                     and   b-mov-ap.nr-docto     = che-emit.nr-docto
                     and   b-mov-ap.parcela      = che-emit.parcela
                     and   b-mov-ap.transacao    = che-emit.transacao
                     and   b-mov-ap.portador     = che-emit.portador
                     and   b-mov-ap.dt-transacao = che-emit.dt-emissao
                     and   b-mov-ap.referencia   = che-emit.referencia
                     and   b-mov-ap.nr-cheque    = 0 no-error.
            end.

            if  avail b-mov-ap then do:

                assign b-mov-ap.nr-cheque    = talonario.prox-cheque
                       b-mov-ap.nr-docto-emp = string(talonario.prox-cheque).

                validate b-mov-ap.

                /************ MultiPlanta *************/
                run pi-cria-tt-dados-b-mov-ap (input 2).
                /**************************************/

                if   b-mov-ap.transacao = 1 then do:
                     find tit-ap exclusive-lock
                          where tit-ap.ep-codigo   = b-mov-ap.ep-codigo
                          and   tit-ap.cod-estabel = b-mov-ap.cod-estabel
                          and   tit-ap.cod-esp     = b-mov-ap.cod-esp
                          and   tit-ap.serie       = b-mov-ap.serie
                          and   tit-ap.nr-docto    = b-mov-ap.nr-docto
                          and   tit-ap.parcela     = b-mov-ap.parcela
                          and   tit-ap.cod-fornec  = b-mov-ap.cod-fornec
                          and   tit-ap.tipo        = 2 no-error.
                     if  avail tit-ap then do:
                         assign tit-ap.nr-cheque = talonario.prox-cheque
                                         c-hist1 = substring(tit-ap.observacao,1,40)
                                         c-hist2 = substring(tit-ap.observacao,41,80).

                         validate tit-ap.

                        /************ MultiPlanta *************/
                        run pi-cria-tt-dados-tit-ap (input 2).
                        /**************************************/
                     end.
                     else do:                        
                         assign c-hist1 = substring(b-mov-ap.historico,1,40)
                                c-hist2 = substring(b-mov-ap.historico,41,80).
                     end.
                end.
            end.
        end.

        if  che-emit.transacao = 3 or 
            che-emit.transacao = 4 then do:

            find tt-espec-ap
                where tt-espec-ap.cod-esp = che-emit.cod-esp
                no-lock no-error.
            if  not avail tt-espec-ap then do:
                find first espec-ap 
                    where espec-ap.cod-esp = che-emit.cod-esp 
                    no-lock no-error.
                if  avail espec-ap then do:
                    create tt-espec-ap.
                    buffer-copy espec-ap to tt-espec-ap.
                end.
            end.         
            if avail tt-espec-ap then do:
                if tt-espec-ap.tipo <> 10 then do:

                    find first b-mov-ap exclusive-lock
                         where b-mov-ap.num-id-mov-ap = int(che-emit.char-1) no-error.

                    if  not avail b-mov-ap then do:
                       find first b-mov-ap exclusive-lock
                            where b-mov-ap.ep-codigo    = che-emit.ep-codigo
                            and   b-mov-ap.portador     = che-emit.portador
                            and   b-mov-ap.cod-fornec   = che-emit.cod-fornec
                            and   b-mov-ap.cod-estabel  = che-emit.cod-estabel
                            and   b-mov-ap.cod-esp      = che-emit.cod-esp
                            and   b-mov-ap.serie        = che-emit.serie
                            and   b-mov-ap.nr-docto     = che-emit.nr-docto
                            and   b-mov-ap.parcela      = che-emit.parcela
                            and   b-mov-ap.dt-transacao = che-emit.dt-emissao
                            and   b-mov-ap.nr-cheque    = 0
                            and   b-mov-ap.ct-conta     = che-emit.ct-conta
                            and   b-mov-ap.sc-conta     = che-emit.sc-conta
                            and   b-mov-ap.valor-mov    = che-emit.valor-docto
                            and   b-mov-ap.transacao    = che-emit.transacao no-error.
                    end.                    
                    if  avail b-mov-ap then do:
                        IF l-tot-pgt-pef AND b-mov-ap.transacao = 4 THEN
                            RUN pi-elimina-integracao.

                        assign b-mov-ap.nr-cheque    = talonario.prox-cheque
                               b-mov-ap.nr-docto-emp = string(talonario.prox-cheque).

                        validate b-mov-ap.

                        /************ MultiPlanta *************/
                        run pi-cria-tt-dados-b-mov-ap (input 2).
                        /**************************************/

                    end.
                end.
                else do:

                    find first b-mov-ap exclusive-lock
                         where b-mov-ap.num-id-mov-ap = int(che-emit.char-1) no-error.

                    if  not avail b-mov-ap then do:
                        /* Atualizar os PEFÔs gerados na baixa com o nr.do cheque, para um eventual cancelamento */
                        Find First b-mov-ap exclusive-lock
                            where b-mov-ap.ep-codigo    = che-emit.ep-codigo
                            and   b-mov-ap.cod-estabel  = che-emit.cod-estabel
                            and   b-mov-ap.fornec-ant   = che-emit.cod-fornec
                            and   b-mov-ap.esp-ant      = che-emit.cod-esp
                            and   b-mov-ap.serie-ant    = che-emit.serie
                            and   b-mov-ap.docto-ant    = che-emit.nr-docto
                            and   b-mov-ap.parc-ant     = che-emit.parcela
                            and   b-mov-ap.portador     = che-emit.portador
                            and   b-mov-ap.dt-transacao = che-emit.dt-emissao
                            and   b-mov-ap.referencia   = che-emit.referencia
                            and  (b-mov-ap.transacao    = 3
                            or   (l-tot-pgt-pef         = yes 
                            and   b-mov-ap.transacao    = 4))
                            and   b-mov-ap.nr-cheque    = 0 no-error.
                    end.        
                    if avail b-mov-ap then do:
                        IF l-tot-pgt-pef AND b-mov-ap.transacao = 4 THEN
                            RUN pi-elimina-integracao.

                        assign b-mov-ap.nr-cheque    = talonario.prox-cheque
                               b-mov-ap.nr-docto-emp = string(talonario.prox-cheque).

                        validate b-mov-ap.

                       /************ MultiPlanta *************/
                        run pi-cria-tt-dados-b-mov-ap (input 2).
                       /**************************************/
                    end.
                end.
            end.
            else do:
                 find first b-mov-ap exclusive-lock
                      where b-mov-ap.num-id-mov-ap = int(che-emit.char-1) no-error.
                 if  not avail b-mov-ap then do:
                     find first b-mov-ap exclusive-lock
                          where b-mov-ap.ep-codigo    = che-emit.ep-codigo
                          and   b-mov-ap.portador     = che-emit.portador
                          and   b-mov-ap.cod-fornec   = che-emit.cod-fornec
                          and   b-mov-ap.cod-estabel  = che-emit.cod-estabel
                          and   b-mov-ap.cod-esp      = che-emit.cod-esp
                          and   b-mov-ap.serie        = che-emit.serie
                          and   b-mov-ap.nr-docto     = che-emit.nr-docto
                          and   b-mov-ap.parcela      = che-emit.parcela
                          and   b-mov-ap.dt-transacao = che-emit.dt-emissao
                          and   b-mov-ap.nr-cheque    = 0
                          and   b-mov-ap.ct-conta     = che-emit.ct-conta
                          and   b-mov-ap.sc-conta     = che-emit.sc-conta
                          and   b-mov-ap.valor-mov    = che-emit.valor-docto
                          and   b-mov-ap.transacao    = che-emit.transacao no-error.
                end.            
                if  avail b-mov-ap then do:
                    IF l-tot-pgt-pef AND b-mov-ap.transacao = 4 THEN
                        RUN pi-elimina-integracao.

                    assign b-mov-ap.nr-cheque    = talonario.prox-cheque
                           b-mov-ap.nr-docto-emp = string(talonario.prox-cheque).

                    validate b-mov-ap.

                    /************ MultiPlanta *************/
                    run pi-cria-tt-dados-b-mov-ap (input 2).
                    /**************************************/

                end.
            End.  
        end.

        find b-che-emit where rowid(b-che-emit) = r-cheque 
                exclusive-lock no-error.
        if  avail b-che-emit then do:
            assign b-che-emit.nr-cheque    = talonario.prox-cheque
                   b-che-emit.nr-talonario = talonario.nr-talonario    
                   b-che-emit.emitiu       = yes.         

            validate b-che-emit.

            /************ MultiPlanta *************/
            run pi-cria-tt-dados-b-che-emit (input 2).
            /**************************************/
        end.

        create tt-integra-cb.
        assign tt-integra-cb.raw-b-mov-ap = rowid(b-mov-ap)
               tt-integra-cb.transacao    = che-emit.transacao.

        if  last-of(che-emit.literal) or last-of(che-emit.dt-emissao) then do:

            assign de-val9100 = de-valor
                   i-num9100  = 2
                   i-tam9100  = (if  tt-param.imp = 2 then 55
                                 else if  tt-param.banco = 1
                                      or  tt-param.banco = 3
                                      or  tt-param.banco = 6 then 59
                                      else if  tt-param.banco = 2 then 55
                                           else if  tt-param.banco = 4
                                                or  tt-param.banco = 5
                                                or  tt-param.banco = 7
                                                or  tt-param.banco = 10 then 57
                                                else 53)
                   i-aux1 = i-tam9100
                   i-aux2 = (if  tt-param.imp = 2 then 64
                                 else if  tt-param.banco = 1
                                      or  tt-param.banco = 2
                                      or  tt-param.banco = 3
                                      or  tt-param.banco = 8
                                      or  tt-param.banco = 9 then 66
                                      else if  tt-param.banco = 6
                                           or  tt-param.banco = 7 then 67
                                           else 68)
                   i-dia      = day(che-emit.dt-emissao)
                   c-mes      = c-tab-mes[month(che-emit.dt-emissao)]
                   c-nominal  = che-emit.literal
                   c-ano1     = substring(string(che-emit.dt-emissao,"99/99/9999"),07,4).

            if  avail b-mov-ap then do:
                find tit-ap no-lock
                     where tit-ap.ep-codigo   = b-mov-ap.ep-codigo
                     and   tit-ap.cod-estabel = b-mov-ap.cod-estabel
                     and   tit-ap.cod-esp     = b-mov-ap.cod-esp
                     and   tit-ap.serie       = b-mov-ap.serie
                     and   tit-ap.nr-docto    = b-mov-ap.nr-docto
                     and   tit-ap.parcela     = b-mov-ap.parcela
                     and   tit-ap.cod-fornec  = b-mov-ap.cod-fornec no-error.  

                if  avail tit-ap then do: 
                    assign  c-hist1 = substring(tit-ap.observacao,1,40)
                            c-hist2 = substring(tit-ap.observacao,41,80).
                end.
                else do:
                    assign  c-hist1 = substring(b-mov-ap.historico,1,40)
                            c-hist2 = substring(b-mov-ap.historico,41,80).
                end.
            end.

            if  de-val9100 > 0 then             
                run cdp/cd9100.p.

            assign i-ind-e1 = i-ind-e1 + 1.

            if  i-ind-e1 = 1 then 
                create w-cheque.
            else
                find first w-cheque exclusive-lock no-error.  

            assign i-port = che-emit.portador.

            if  avail w-cheque then do:
                assign w-valor[i-ind-e1]             = de-valor
                       w-ext9100[(i-ind-e1 * 2) - 1] = c-ext9100[1]
                       w-ext9100[i-ind-e1 * 2]       = c-ext9100[2]
                       w-nominal[i-ind-e1]           = c-nominal
                       w-dia[i-ind-e1]               = i-dia
                       w-mes[i-ind-e1]               = c-mes
                       w-ano1[i-ind-e1]              = c-ano1
                       w-cidade[i-ind-e1]            = c-cidade
                       w-hist1[i-ind-e1]             = c-hist1
                       w-hist2[i-ind-e1]             = c-hist2
                       w-data[i-ind-e1]              = che-emit.dt-emissao.
            end.            

            if  tt-param.imp = 1 then do:
                assign i-ind-e1 = 2.
            end.

            if  i-ind-e1 = 2 then do:
                run pi-impres-cheque.
                assign i-ind-e1 = 0.
            end.

            if  param-global.modulo-cb = yes then do: /* Caixa e Bancos implantado */

                find first cheque exclusive-lock
                     where cheque.cod-banco    = portador.cod-banco
                     and   cheque.agencia      = portador.agencia
                     and   cheque.conta-corren = portador.conta-corren
                     and   cheque.nr-cheque    = talonario.prox-cheque no-error.

                if  not avail cheque then do:
                    create cheque.
                    assign cheque.cod-banco       = portador.cod-banco
                           cheque.agencia         = portador.agencia
                           cheque.conta-corren    = portador.conta-corren
                           cheque.nr-cheque       = talonario.prox-cheque
                           cheque.vl-cheque       = 0.

                    /************ MultiPlanta *************/
                    run pi-cria-tt-dados-cheque (input 1).
                    /**************************************/

                end.
                if avail b-mov-ap then do:    
                   assign cheque.ep-codigo-mvto  = che-emit.ep-codigo
                          cheque.cod-emitente    = che-emit.cod-fornec
                          cheque.cod-portador    = che-emit.portador
                          cheque.dt-vencimento   = che-emit.dt-vencto
                          cheque.dt-emissao      = che-emit.dt-emissao
                          cheque.tp-codigo       = b-mov-ap.tp-codigo
                          cheque.vl-cheque       = cheque.vl-cheque + de-valor
                          cheque.tipo-cheque     = 1  /* Pr¢prio */
                          cheque.situacao-cheque = 1  /* Pendente */
                          cheque.origem-cheque   = 5. /* AP */
                end.       

                if  avail b-mov-ap then do:
                    if  b-mov-ap.data-1 = b-mov-ap.dt-transacao 
                    or  b-mov-ap.data-1 = ? then do:
                        if  param-ap.log-2 = yes then do:
                            assign cheque.dt-liberacao = ?.
                        end.
                        else do:
                            assign cheque.dt-liberacao = b-mov-ap.dt-transacao.
                        end.
                    end.   

                    validate cheque.

                    for each tt-integra-cb exclusive-lock
                        by tt-integra-cb.transacao:
                        if  tt-integra-cb.transacao = 3 or 
                            tt-integra-cb.transacao = 4 then do:
                            {app/ap9100.i2}
                            assign tt-integ-ap.tt-row-tit-ap  = ?
                                   tt-integ-ap.tt-row-mov-ap  = tt-integra-cb.raw-b-mov-ap
                                   tt-integ-ap.tt-cb0201a     = yes
                                   tt-integ-ap.tt-op-cb0201a  = 16. /*Inclus∆o*/                                               
                            raw-transfer tt-integ-ap to raw-integracao.
                            run app/ap9100.p (Input raw-integracao, input-output table tt-erro).

                         end.

                         if  tt-integra-cb.transacao = 2 or 
                             tt-integra-cb.transacao = 1 then do:
                            /*--- INTEGRAÄÂES ---*/
                            {app/ap9100.i2}
                            assign tt-integ-ap.tt-row-mov-ap  = tt-integra-cb.raw-b-mov-ap
                                   tt-integ-ap.tt-cb0201a     = yes
                                   tt-integ-ap.tt-op-cb0201a  = 16. /*Inclus∆o*/                                               
                            raw-transfer tt-integ-ap to raw-integracao.
                            run app/ap9100.p (Input raw-integracao, input-output table tt-erro).

                        end.
                        delete tt-integra-cb.
                    end.   
                 End.
                /************ MultiPlanta *************/
                run pi-cria-tt-dados-cheque (input 2).
                /**************************************/

            end.
            if  de-valor <= 0 then do:
                run utp/ut-msgs.p (input "show",
                                   input 15659,
                                   input string(cheque.nr-cheque)).
            end.
            else do:                                
                if  tt-param.gerar = yes then do:
                    {app/ap0511.i}
                end.
            end.


            assign de-valor = 0.

            /**** Pr¢ximo cheque ****/
            run  pi-prox-cheque.
            if  RETURN-VALUE = "NOK":U THEN 
                leave code-block.

            /************ MultiPlanta *************/
            run pi-cria-tt-dados-talonario (input 2).
            /**************************************/

        end.

        /************ MULTIPLANTA ************/
        run pi-encerramento.
        /*************************************/

        assign i-cont = i-cont + 1.
{utp/ut-liter.i Emiss∆o:_ *}


        IF l-conf-favorec = NO OR tt-param.conf-favorec = no THEN
                run pi-acompanhar in h-acomp(input  Return-value  + string(i-cont)).

    end.

    find first w-cheque no-lock no-error.
    if  avail w-cheque then do:
        run pi-impres-cheque.
        assign i-ind-e1 = 0.
    end.

    if  tt-param.gerar = yes then
        output stream s-copia close.

/* Fim de Include */
