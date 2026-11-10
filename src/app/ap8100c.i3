/********************************************************************************
***
*** app/ap8100c.i3 - Contabilizaá∆o PEF.
***
********************************************************************************/

if  mov-ap.cod-esp = " " then do:

    assign l-ok = yes.

    find first portador use-index codigo
         where portador.ep-codigo    = mov-ap.ep-codigo
         and   portador.cod-portador = mov-ap.portador
         and   portador.modalidade   = mov-ap.modalidade no-lock no-error.

    if  not avail portador then do:

        {utp/ut-liter.i Portador_do_Pagamento_Extra_Fornecedor_n∆o_Cadastrado}
        assign c-mensagem = return-value
               c-trans    = {adinc/i01ad165.i 04 mov-ap.transacao}
               c-docto    = fill(" ", 16 - length(mov-ap.nr-docto)) + mov-ap.nr-docto.
               l-ok       = no.

        disp mov-ap.cod-estabel
             mov-ap.cod-esp
             mov-ap.serie
             mov-ap.cod-fornec
             c-docto
             mov-ap.parcela
             c-trans
             c-mensagem
             with frame f-mensagem.
        down with frame f-mensagem.
    end.
    else do:
        if  portador.bancario = yes then do:

            find first cta-corrente use-index conta
                 where cta-corrente.cod-banco    = portador.cod-banco
                 and   cta-corrente.agencia      = portador.agencia
                 and   cta-corrente.conta-corren = portador.conta-corren
                 no-lock no-error.

            if  not avail cta-corrente then do:

                run utp/ut-msgs.p (input "help",
                                   input 928,
                                   input string(portador.cod-banco) + "~~" +
                                                portador.agencia    + "~~" +
                                                portador.conta-corren).

                assign c-mensagem = return-value
                       c-trans    = {adinc/i01ad165.i 04 mov-ap.transacao}
                       c-docto    = fill(" ", 16 - length(mov-ap.nr-docto)) + mov-ap.nr-docto
                       l-ok       = no.

                disp mov-ap.cod-estabel
                     mov-ap.cod-esp
                     mov-ap.serie
                     mov-ap.cod-fornec
                     c-docto
                     mov-ap.parcela
                     c-trans
                     c-mensagem
                     with frame f-mensagem.
                down with frame f-mensagem.
            end.
            else do:

                /*--- Valida Conta DÇbito do Portador ---*/
                find first b-conta-contab-deb use-index codigo
                     where b-conta-contab-deb.ep-codigo = mov-ap.ep-codigo
                     and   b-conta-contab-deb.ct-codigo = cta-corrente.ct-deb-princ
                     and   b-conta-contab-deb.sc-codigo = cta-corrente.sc-deb-princ
                     no-lock no-error.

                if  not avail b-conta-contab-deb then do:

                    {utp/ut-liter.i Conta_DÇbito_do_Portador_n∆o_Cadastrada}

                    assign c-mensagem = trim(return-value)
                           c-trans    = {adinc/i01ad165.i 04 mov-ap.transacao}
                           c-docto    = fill(" ", 16 - length(mov-ap.nr-docto)) + mov-ap.nr-docto
                           l-ok       = no.

                    disp mov-ap.cod-estabel
                         mov-ap.cod-esp
                         mov-ap.serie
                         mov-ap.cod-fornec
                         c-docto
                         mov-ap.parcela
                         c-trans
                         c-mensagem
                         with frame f-mensagem.
                    down with frame f-mensagem.
                end.
            end.
        end.
        else do:
            find first b-conta-contab-deb use-index ch-conta-contabil
                 where b-conta-contab-deb.ep-codigo      = portador.ep-codigo
                 and   b-conta-contab-deb.conta-contabil = portador.conta-contabil
                 no-lock no-error.

            if  not avail b-conta-contab-deb then do:
                run utp/ut-msgs.p (input "msg",
                                   input 8885,
                                   input portador.conta-contabil).

                assign c-mensagem = trim(return-value) + " (" + portador.conta-contabil + ")."
                       c-trans    = {adinc/i01ad165.i 04 mov-ap.transacao}
                       c-docto    = fill(" ", 16 - length(mov-ap.nr-docto)) + mov-ap.nr-docto
                       l-ok       = no.

                disp mov-ap.cod-estabel
                     mov-ap.cod-esp
                     mov-ap.serie
                     mov-ap.cod-fornec
                     c-docto
                     mov-ap.parcela
                     c-trans
                     c-mensagem
                     with frame f-mensagem.
                down with frame f-mensagem.
            end.
        end.    
    end.

    if  l-central = yes then do:
        find first estabelec where estabelec.cod-estabel = mov-ap.cod-estabel no-lock no-error.
        if  not avail estabelec then do:

            run utp/ut-msgs.p (input "msg",
                               input 13,
                               input caps(mov-ap.cod-estabel)).

            assign c-mensagem = return-value
                   c-trans    = {adinc/i01ad165.i 04 mov-ap.transacao}
                   c-docto    = fill(" ", 16 - length(mov-ap.nr-docto)) + mov-ap.nr-docto
                   l-ok       = no.

            disp mov-ap.cod-estabel
                 mov-ap.cod-esp
                 mov-ap.serie
                 mov-ap.cod-fornec
                 c-docto
                 mov-ap.parcela
                 c-trans
                 c-mensagem
                 with frame f-mensagem.
            down with frame f-mensagem.
        end.
        else do:

            /*--- Valida Conta Transit¢ria do Estabelecimento ---*/
            find first conta-contab no-lock use-index ch-conta-contabil
                 where conta-contab.ep-codigo      = mov-ap.ep-codigo
                 and   conta-contab.conta-contabil = estabelec.conta-desp-iof no-error.

            if  not avail conta-contab then do:

                run utp/ut-msgs.p (input "msg",
                                   input 16756,
                                   input estabelec.cod-estabel).

                assign c-mensagem = return-value
                       c-trans    = {adinc/i01ad165.i 04 mov-ap.transacao}
                       c-docto    = fill(" ", 16 - length(mov-ap.nr-docto)) + mov-ap.nr-docto
                       l-ok       = no.

                disp mov-ap.cod-estabel
                     mov-ap.cod-esp
                     mov-ap.serie
                     mov-ap.cod-fornec
                     c-docto
                     mov-ap.parcela
                     c-trans
                     c-mensagem
                     with frame f-mensagem.
                down with frame f-mensagem.
            end.
        end.
    end.
    else do:
        find first conta-contab use-index codigo
             where conta-contab.ep-codigo = mov-ap.ep-codigo
             and   conta-contab.ct-codigo = mov-ap.ct-conta
             and   conta-contab.sc-codigo = mov-ap.sc-conta
             no-lock no-error.

        if  not avail conta-contab then do:

            {utp/ut-liter.i Cta_Ctbl_Pagamento_Extra_Fornecedor_n∆o_Cadastrada}
            assign c-mensagem = return-value
                   c-trans    = {adinc/i01ad165.i 04 mov-ap.transacao}
                   c-docto    = fill(" ", 16 - length(mov-ap.nr-docto)) + mov-ap.nr-docto.
                   l-ok       = no.

            disp mov-ap.cod-estabel
                 mov-ap.cod-esp
                 mov-ap.serie
                 mov-ap.cod-fornec
                 c-docto
                 mov-ap.parcela
                 c-trans
                 c-mensagem
                 with frame f-mensagem.
            down with frame f-mensagem.
        end.
    end.

    if  l-ok = yes then do:

        if  c-programa-ap8100 <> "AP/0817" and
            c-programa-ap8100 <> "AP/0707" then
            run value(c-prog-hist-ap8100).
            
        assign vl-fasb = mov-ap.vl-mov-fasb.

        /************ GE - Rodrigo ************/
        IF  c-nom-prog-upc-mg97  <> "" OR  
            c-nom-prog-dpc-mg97  <> "" OR
            c-nom-prog-appc-mg97 <> "" THEN DO:
            for each tt-epc
                where tt-epc.cod-event = "MOEDA_ORIGEM":U exclusive-lock:
                delete tt-epc.
            end.

            create tt-epc.
            assign tt-epc.cod-event = "MOEDA_ORIGEM":U.

            {include/i-epc201.i MOEDA_ORIGEM}

            find tt-epc
                where tt-epc.cod-event   = "MOEDA_ORIGEM":U
                and tt-epc.cod-parameter = "RETURN":U no-error.

            if avail tt-epc and tt-epc.val-parameter = "yes":U then
                assign vl-fasb = mov-ap.valor-mov-me.
        END.
        /************ GE - Rodrigo ************/

        run pi-criar-movimento (input conta-contab.ct-codigo,
                                input conta-contab.sc-codigo, 
                                input 1,
                                input mov-ap.valor-mov,
                                input vl-fasb,
                                input conta-contab.titulo,
                                input mov-ap.vl-mov-cmi,
                                input mov-ap.valor-presente).

        run pi-criar-movimento (input b-conta-contab-deb.ct-codigo,
                                input b-conta-contab-deb.sc-codigo, 
                                input 2,
                                input mov-ap.valor-mov,
                                input vl-fasb,
                                input b-conta-contab-deb.titulo,
                                input mov-ap.vl-mov-cmi,
                                input mov-ap.valor-presente).

    end.
end.

/* Fim de Include */
