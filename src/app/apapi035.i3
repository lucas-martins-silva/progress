/********************************************************************************
***
*** app/apapi035.i3 - Validacao do AVA.
***
********************************************************************************/

    def buffer b-portador for portador.

    find first param-fasb where param-fasb.ep-codigo = tt-titulo.tt-ep-codigo no-lock no-error.
    if  avail param-fasb and (param-fasb.moeda-cmi <> 0 or param-fasb.moeda-fasb <> 0) then do:
        if  tit-ap.tipo = 2 and tt-titulo.tt-ind-tp-alter = 4 then do:
            /* Opcao invalida para antecipacoes */
            run utp/ut-msgs.p (input "help":U,
                               input 1069,
                               input "").
            create tt-retorna-erro.
            assign tt-retorna-erro.cod-erro  = 1069
                   tt-retorna-erro.desc-erro = trim(return-value)
                   tt-retorna-erro.l-erro    = yes
                   tt-retorna-erro.cod-chave = string(tt-titulo.tt-ep-codigo)  + ";" +
                                               string(tt-titulo.tt-cod-fornec) + ";" +
                                               tt-titulo.tt-cod-estabel + ";" +
                                               tt-titulo.tt-cod-esp     + ";" +
                                               tt-titulo.tt-serie       + ";" +
                                               tt-titulo.tt-nr-docto    + ";" +
                                               tt-titulo.tt-parcela.
            assign l-houve-erro = yes.                                   
        end.

        if  tt-titulo.tt-vl-saldo-me = 0 and tt-titulo.tt-ind-tp-alter = 3 then do:
            /* Opcao invalida quando for zerado o saldo do documento */
            run utp/ut-msgs.p (input "msg":U,
                               input 4111,
                               input "").
            create tt-retorna-erro.
            assign tt-retorna-erro.cod-erro  = 4111
                   tt-retorna-erro.desc-erro = trim(return-value)
                   tt-retorna-erro.l-erro    = yes
                   tt-retorna-erro.cod-chave = string(tt-titulo.tt-ep-codigo)  + ";" +
                                               string(tt-titulo.tt-cod-fornec) + ";" +
                                               tt-titulo.tt-cod-estabel + ";" +
                                               tt-titulo.tt-cod-esp     + ";" +
                                               tt-titulo.tt-serie       + ";" +
                                               tt-titulo.tt-nr-docto    + ";" +
                                               tt-titulo.tt-parcela.
            assign l-houve-erro = yes.                                               
        end.
    end.
    if  tt-titulo.tt-da-acerto < da-ini-validac
    or  tt-titulo.tt-da-acerto > da-fim-validac then do:
        run utp/ut-msgs.p (input "help":U,
                           input 26757,
                           input string(da-ini-validac, "99/99/9999") + "~~" + 
                                 string(da-fim-validac, "99/99/9999")).
        create tt-retorna-erro.
        assign tt-retorna-erro.cod-erro  = 26757
               tt-retorna-erro.desc-erro = trim(return-value)
               tt-retorna-erro.l-erro    = yes
               tt-retorna-erro.cod-chave = string(tt-titulo.tt-ep-codigo)  + ";" +
                                           string(tt-titulo.tt-cod-fornec) + ";" +
                                           tt-titulo.tt-cod-estabel + ";" +
                                           tt-titulo.tt-cod-esp     + ";" +
                                           tt-titulo.tt-serie       + ";" +
                                           tt-titulo.tt-nr-docto    + ";" +
                                           tt-titulo.tt-parcela.
        assign l-houve-erro = yes.                                           
    end.
    if  tt-titulo.tt-da-acerto < tit-ap.dt-transacao then do:
        /* Data acerto deve ser maior ou igual a data de transacao do titulo */
        run utp/ut-msgs.p (input "msg":U,
                           input 4105,
                           input "").
        create tt-retorna-erro.
        assign tt-retorna-erro.cod-erro  = 4105
               tt-retorna-erro.desc-erro = trim(return-value)
               tt-retorna-erro.l-erro    = yes
               tt-retorna-erro.cod-chave = string(tt-titulo.tt-ep-codigo)  + ";" +
                                           string(tt-titulo.tt-cod-fornec) + ";" +
                                           tt-titulo.tt-cod-estabel + ";" +
                                           tt-titulo.tt-cod-esp     + ";" +
                                           tt-titulo.tt-serie       + ";" +
                                           tt-titulo.tt-nr-docto    + ";" +
                                           tt-titulo.tt-parcela.
        assign l-houve-erro = yes.                                           
    end.
    if  tt-titulo.tt-referencia = "" then do:
        /* Referància n∆o pode ser branco */
        run utp/ut-msgs.p (input "help":U,
                           input 1399,
                           input "").
        create tt-retorna-erro.
        assign tt-retorna-erro.cod-erro  = 1399
               tt-retorna-erro.desc-erro = trim(return-value)
               tt-retorna-erro.l-erro    = yes
               tt-retorna-erro.cod-chave = string(tt-titulo.tt-ep-codigo)  + ";" +
                                           string(tt-titulo.tt-cod-fornec) + ";" +
                                           tt-titulo.tt-cod-estabel + ";" +
                                           tt-titulo.tt-cod-esp     + ";" +
                                           tt-titulo.tt-serie       + ";" +
                                           tt-titulo.tt-nr-docto    + ";" +
                                           tt-titulo.tt-parcela.
        assign l-houve-erro = yes.                                           
    end.

    if  tit-ap.tipo = 2 then do:    
        if  tt-titulo.tt-portador-acerto > 0 then do:
            find first portador
                 where portador.cod-portador = tt-titulo.tt-portador-acerto
                 and   portador.ep-codigo    = tit-ap.ep-codigo
                 and   portador.modalidade   = tt-titulo.tt-modalidade-acerto
                 no-lock no-error.
            if  not avail portador then do:
                run utp/ut-msgs.p (input "help":U,
                                   input 152,
                                   input string(tt-titulo.tt-portador-acerto)).
                create tt-retorna-erro.
                assign tt-retorna-erro.cod-erro  = 152
                       tt-retorna-erro.desc-erro = trim(return-value)
                       tt-retorna-erro.l-erro    = yes
                       tt-retorna-erro.cod-chave = string(tt-titulo.tt-ep-codigo)  + ";" +
                                                   string(tt-titulo.tt-cod-fornec) + ";" +
                                                   tt-titulo.tt-cod-estabel + ";" +
                                                   tt-titulo.tt-cod-esp     + ";" +
                                                   tt-titulo.tt-serie       + ";" +
                                                   tt-titulo.tt-nr-docto    + ";" +
                                                   tt-titulo.tt-parcela.
                assign l-houve-erro = yes.                                                   
            end.    
            if  portador.bancario = yes then do:
                find first b-portador
                     where b-portador.ep-codigo    = tit-ap.ep-codigo
                     and   b-portador.cod-portador = tit-ap.portador
                     and   b-portador.modalidade   = tit-ap.modalidade no-lock no-error.

                if  avail b-portador and b-portador.bancario <> yes then do:
                    {utp/ut-liter.i n∆o_banc†rio}
                    run utp/ut-msgs.p (input "help":U,
                                       input 18062,
                                       input string(return-value)).
                    create tt-retorna-erro.
                    assign tt-retorna-erro.cod-erro  = 18062
                           tt-retorna-erro.desc-erro = trim(return-value)
                           tt-retorna-erro.l-erro    = yes
                           tt-retorna-erro.cod-chave = string(tt-titulo.tt-ep-codigo)  + ";" +
                                                       string(tt-titulo.tt-cod-fornec) + ";" +
                                                       tt-titulo.tt-cod-estabel + ";" +
                                                       tt-titulo.tt-cod-esp     + ";" +
                                                       tt-titulo.tt-serie       + ";" +
                                                       tt-titulo.tt-nr-docto    + ";" +
                                                       tt-titulo.tt-parcela.
                    assign l-houve-erro = yes.                                                       
                end.             
                find first cta-corrente
                     where cta-corrente.cod-banco    = portador.cod-banco
                     and   cta-corrente.agencia      = portador.agencia
                     and   cta-corrente.conta-corren = portador.conta-corren
                     no-lock no-error.
                if  not avail cta-corrente then do:
                    /* Conta corrente do portador nao cadastrada */
                    run utp/ut-msgs.p (input "help":U,
                                       input 1057,
                                       input string(portador.cod-banco) + "~~" +
                                                    portador.agencia + "~~" +
                                                    portador.conta-corren).  
                    create tt-retorna-erro.
                    assign tt-retorna-erro.cod-erro  = 1057
                           tt-retorna-erro.desc-erro = trim(return-value)
                           tt-retorna-erro.l-erro    = yes
                           tt-retorna-erro.cod-chave = string(tt-titulo.tt-ep-codigo)  + ";" +
                                                       string(tt-titulo.tt-cod-fornec) + ";" +
                                                       tt-titulo.tt-cod-estabel + ";" +
                                                       tt-titulo.tt-cod-esp     + ";" +
                                                       tt-titulo.tt-serie       + ";" +
                                                       tt-titulo.tt-nr-docto    + ";" +
                                                       tt-titulo.tt-parcela.
                    assign l-houve-erro = yes.                                                       
                end.
                find first conta-contab
                     where conta-contab.ep-codigo      = tit-ap.ep-codigo
                     and   conta-contab.conta-contabil = cta-corren.conta-saldo
                     no-lock no-error.

                if  not avail conta-contab then do:
                    /* Conta Cont†bil N∆o Cadastrada */
                    run utp/ut-msgs.p (input "help":U,
                                       input 8884,
                                       input string(cta-corren.conta-saldo, param-global.formato-conta-contabil) + "~~" +
                                             string(tt-titulo.tt-portador-acerto)).
                    create tt-retorna-erro.
                    assign tt-retorna-erro.cod-erro  = 8884
                           tt-retorna-erro.desc-erro = trim(return-value)
                           tt-retorna-erro.l-erro    = yes
                           tt-retorna-erro.cod-chave = string(tt-titulo.tt-ep-codigo)  + ";" +
                                                       string(tt-titulo.tt-cod-fornec) + ";" +
                                                       tt-titulo.tt-cod-estabel + ";" +
                                                       tt-titulo.tt-cod-esp     + ";" +
                                                       tt-titulo.tt-serie       + ";" +
                                                       tt-titulo.tt-nr-docto    + ";" +
                                                       tt-titulo.tt-parcela.
                    assign l-houve-erro = yes.                                                       
                end.
            end.
            else do:
                find first b-portador
                     where b-portador.ep-codigo    = tit-ap.ep-codigo
                     and   b-portador.cod-portador = tit-ap.portador
                     and   b-portador.modalidade   = tit-ap.modalidade no-lock no-error.
                if  avail b-portador
                and b-portador.bancario <> no then do:
                    {utp/ut-liter.i banc†rio}
                    run utp/ut-msgs.p (input "help":U,
                                       input 18062,
                                       input string(return-value)).
                    create tt-retorna-erro.
                    assign tt-retorna-erro.cod-erro  = 18062
                           tt-retorna-erro.desc-erro = trim(return-value)
                           tt-retorna-erro.l-erro    = yes
                           tt-retorna-erro.cod-chave = string(tt-titulo.tt-ep-codigo)  + ";" +
                                                       string(tt-titulo.tt-cod-fornec) + ";" +
                                                       tt-titulo.tt-cod-estabel + ";" +
                                                       tt-titulo.tt-cod-esp     + ";" +
                                                       tt-titulo.tt-serie       + ";" +
                                                       tt-titulo.tt-nr-docto    + ";" +
                                                       tt-titulo.tt-parcela.
                    assign l-houve-erro = yes.                                                       
                end.             

                find first conta-contab
                     where conta-contab.ep-codigo      = tit-ap.ep-codigo
                     and   conta-contab.conta-contabil = portador.conta-contabil
                     no-lock no-error.

                if  not avail conta-contab then do:
                    /* Conta Cont†bil N∆o Cadastrada */
                    run utp/ut-msgs.p (input "help":U,
                                       input 8885,
                                       input string(portador.cod-portador)).
                    create tt-retorna-erro.
                    assign tt-retorna-erro.cod-erro  = 8885
                           tt-retorna-erro.desc-erro = trim(return-value)
                           tt-retorna-erro.l-erro    = yes
                           tt-retorna-erro.cod-chave = string(tt-titulo.tt-ep-codigo)  + ";" +
                                                       string(tt-titulo.tt-cod-fornec) + ";" +
                                                       tt-titulo.tt-cod-estabel + ";" +
                                                       tt-titulo.tt-cod-esp     + ";" +
                                                       tt-titulo.tt-serie       + ";" +
                                                       tt-titulo.tt-nr-docto    + ";" +
                                                       tt-titulo.tt-parcela.
                    assign l-houve-erro = yes.                                                       
                end.
            end.
            if  tt-titulo.tt-portador-acerto <> tit-ap.portador then do: 
                find first che-emit
                     where che-emit.ep-codigo = tit-ap.ep-codigo
                     and   che-emit.portador  = tit-ap.portador
                     and   che-emit.nr-cheque = tit-ap.nr-cheque
                     and   che-emit.cod-forn  = tit-ap.cod-forn
                     and   che-emit.cod-est   = tit-ap.cod-est
                     and   che-emit.cod-esp   = tit-ap.cod-esp
                     and   che-emit.serie     = tit-ap.serie
                     and   che-emit.nr-docto  = tit-ap.nr-docto
                     and   che-emit.parcela   = tit-ap.parcela
                     no-lock no-error.

                if  avail che-emit and che-emit.nr-cheque = 0 then do:
                    /* Cheque nao foi emitido. Portador deve ser o mesmo da implantacao */
                    run utp/ut-msgs.p (input "help":U,
                                       input 8893,
                                       input "").
                    create tt-retorna-erro.
                    assign tt-retorna-erro.cod-erro  = 8893
                           tt-retorna-erro.desc-erro = trim(return-value)
                           tt-retorna-erro.l-erro    = yes
                           tt-retorna-erro.cod-chave = string(tt-titulo.tt-ep-codigo)  + ";" +
                                                       string(tt-titulo.tt-cod-fornec) + ";" +
                                                       tt-titulo.tt-cod-estabel + ";" +
                                                       tt-titulo.tt-cod-esp     + ";" +
                                                       tt-titulo.tt-serie       + ";" +
                                                       tt-titulo.tt-nr-docto    + ";" +
                                                       tt-titulo.tt-parcela.
                    assign l-houve-erro = yes.                                                       
                end.
            end.
        end.
    end. 

    if  tit-ap.tipo <> 2 or tt-titulo.tt-portador-acerto = 0 then do:
        find first conta-contab
             where conta-contab.ep-codigo      = tit-ap.ep-codigo
             and   conta-contab.conta-contabil = tt-titulo.tt-conta-acerto
             no-lock no-error.

        if  not avail conta-contab then do:
            /* Conta Contabil nao cadastrada */
            run utp/ut-msgs.p (input "help",
                               input 177,
                               input tt-titulo.tt-conta-acerto).
            create tt-retorna-erro.
            assign tt-retorna-erro.cod-erro  = 177
                   tt-retorna-erro.desc-erro = trim(return-value)
                   tt-retorna-erro.l-erro    = yes
                   tt-retorna-erro.cod-chave = string(tt-titulo.tt-ep-codigo)  + ";" +
                                               string(tt-titulo.tt-cod-fornec) + ";" +
                                               tt-titulo.tt-cod-estabel + ";" +
                                               tt-titulo.tt-cod-esp     + ";" +
                                               tt-titulo.tt-serie       + ";" +
                                               tt-titulo.tt-nr-docto    + ";" +
                                               tt-titulo.tt-parcela.
            assign l-houve-erro = yes.                                               
        end.        
        else do:
            if  conta-contab.tipo = 6 then do:
                /* Conta de Titulo nao pode receber lancamento */
                run utp/ut-msgs.p (input "help",
                                   input 444,
                                   input " ").
                create tt-retorna-erro.
                assign tt-retorna-erro.cod-erro  = 444
                       tt-retorna-erro.desc-erro = trim(return-value)
                       tt-retorna-erro.l-erro    = yes
                       tt-retorna-erro.cod-chave = string(tt-titulo.tt-ep-codigo)  + ";" +
                                                   string(tt-titulo.tt-cod-fornec) + ";" +
                                                   tt-titulo.tt-cod-estabel + ";" +
                                                   tt-titulo.tt-cod-esp     + ";" +
                                                   tt-titulo.tt-serie       + ";" +
                                                   tt-titulo.tt-nr-docto    + ";" +
                                                   tt-titulo.tt-parcela.
                assign l-houve-erro = yes.                                               
            end.        
            if  conta-contab.estado <> 3 then do:
                /* Conta deve ser de sistema */
                run utp/ut-msgs.p (input "help",
                                   input 638,
                                   input string(tt-titulo.tt-conta-acerto, param-global.formato-conta-contabil)).
                create tt-retorna-erro.
                assign tt-retorna-erro.cod-erro  = 638
                       tt-retorna-erro.desc-erro = trim(return-value)
                       tt-retorna-erro.l-erro    = yes
                       tt-retorna-erro.cod-chave = string(tt-titulo.tt-ep-codigo)  + ";" +
                                                   string(tt-titulo.tt-cod-fornec) + ";" +
                                                   tt-titulo.tt-cod-estabel + ";" +
                                                   tt-titulo.tt-cod-esp     + ";" +
                                                   tt-titulo.tt-serie       + ";" +
                                                   tt-titulo.tt-nr-docto    + ";" +
                                                   tt-titulo.tt-parcela.
                assign l-houve-erro = yes.                                               
            end.        
            if  conta-contab.contas-pagar = 1 then do:
                /* Conta nao pode receber lancamento no contas a pagar */
                run utp/ut-msgs.p (input "help",
                                   input 460,
                                   input " ").
                create tt-retorna-erro.
                assign tt-retorna-erro.cod-erro  = 460
                       tt-retorna-erro.desc-erro = trim(return-value)
                       tt-retorna-erro.l-erro    = yes
                       tt-retorna-erro.cod-chave = string(tt-titulo.tt-ep-codigo)  + ";" +
                                                   string(tt-titulo.tt-cod-fornec) + ";" +
                                                   tt-titulo.tt-cod-estabel + ";" +
                                                   tt-titulo.tt-cod-esp     + ";" +
                                                   tt-titulo.tt-serie       + ";" +
                                                   tt-titulo.tt-nr-docto    + ";" +
                                                   tt-titulo.tt-parcela.
                assign l-houve-erro = yes.                                               
            end.        
            if  conta-contab.caixa-bancos = 3 and tt-titulo.tt-portador = 0 then do:
                /* Conta de banco (portador) nao pode ser utilizada */
                run utp/ut-msgs.p (input "help",
                                   input 810,
                                   input " ").
                create tt-retorna-erro.
                assign tt-retorna-erro.cod-erro  = 810
                       tt-retorna-erro.desc-erro = trim(return-value)
                       tt-retorna-erro.l-erro    = yes
                       tt-retorna-erro.cod-chave = string(tt-titulo.tt-ep-codigo)  + ";" +
                                                   string(tt-titulo.tt-cod-fornec) + ";" +
                                                   tt-titulo.tt-cod-estabel + ";" +
                                                   tt-titulo.tt-cod-esp     + ";" +
                                                   tt-titulo.tt-serie       + ";" +
                                                   tt-titulo.tt-nr-docto    + ";" +
                                                   tt-titulo.tt-parcela.
                assign l-houve-erro = yes.                                               
            end.
            find first conta-ap
                 where conta-ap.ep-codigo    = tit-ap.ep-codigo
                 and   conta-ap.conta-saldo  = conta-contab.conta-contabil
                 no-lock no-error.

            if  avail conta-ap then do:
                /* Conta do acerto nao pode ser uma conta de saldo */
                run utp/ut-msgs.p (input "help",
                                   input 1066,
                                   input " ").
                create tt-retorna-erro.
                assign tt-retorna-erro.cod-erro  = 1066
                       tt-retorna-erro.desc-erro = trim(return-value)
                       tt-retorna-erro.l-erro    = yes
                       tt-retorna-erro.cod-chave = string(tt-titulo.tt-ep-codigo)  + ";" +
                                                   string(tt-titulo.tt-cod-fornec) + ";" +
                                                   tt-titulo.tt-cod-estabel + ";" +
                                                   tt-titulo.tt-cod-esp     + ";" +
                                                   tt-titulo.tt-serie       + ";" +
                                                   tt-titulo.tt-nr-docto    + ";" +
                                                   tt-titulo.tt-parcela.
                assign l-houve-erro = yes.                                               
            end.
        end.            
    end.        

    if  tt-titulo.tt-dt-emissao <> tit-ap.dt-emissao then do:
        if  tt-titulo.tt-dt-emissao < da-ini-validac
        or  tt-titulo.tt-dt-emissao > da-fim-validac then do:
            run utp/ut-msgs.p (input "help":U,
                               input 26757,
                               input string(da-ini-validac, "99/99/9999") + "~~" + 
                                     string(da-fim-validac, "99/99/9999")).
            create tt-retorna-erro.
            assign tt-retorna-erro.cod-erro  = 26757
                   tt-retorna-erro.desc-erro = trim(return-value)
                   tt-retorna-erro.l-erro    = yes
                   tt-retorna-erro.cod-chave = string(tt-titulo.tt-ep-codigo)  + ";" +
                                               string(tt-titulo.tt-cod-fornec) + ";" +
                                               tt-titulo.tt-cod-estabel + ";" +
                                               tt-titulo.tt-cod-esp     + ";" +
                                               tt-titulo.tt-serie       + ";" +
                                               tt-titulo.tt-nr-docto    + ";" +
                                               tt-titulo.tt-parcela.
            assign l-houve-erro = yes.                                               
        end.
    end.
    if  tt-titulo.tt-dt-emissao > tit-ap.dt-transacao and tit-ap.tipo <> 2 then do:
        /* Data de emissao nao pode ser maior que data de transacao */
        run utp/ut-msgs.p (input "msg":U,
                           input 4038,
                           input "").
        create tt-retorna-erro.
        assign tt-retorna-erro.cod-erro  = 4038
               tt-retorna-erro.desc-erro = trim(return-value)
               tt-retorna-erro.l-erro    = yes
               tt-retorna-erro.cod-chave = string(tt-titulo.tt-ep-codigo)  + ";" +
                                           string(tt-titulo.tt-cod-fornec) + ";" +
                                           tt-titulo.tt-cod-estabel + ";" +
                                           tt-titulo.tt-cod-esp     + ";" +
                                           tt-titulo.tt-serie       + ";" +
                                           tt-titulo.tt-nr-docto    + ";" +
                                           tt-titulo.tt-parcela.
        assign l-houve-erro = yes.                                           
    end.
    if  tt-titulo.tt-dt-vencimen < tt-titulo.tt-dt-emissao and tit-ap.tipo <> 2 then do:
        run utp/ut-msgs.p (input "help":U,
                           input 1031,
                           input "").
        create tt-retorna-erro.
        assign tt-retorna-erro.cod-erro  = 1031
               tt-retorna-erro.desc-erro = trim(return-value)
               tt-retorna-erro.l-erro    = yes
               tt-retorna-erro.cod-chave = string(tt-titulo.tt-ep-codigo)  + ";" +
                                           string(tt-titulo.tt-cod-fornec) + ";" +
                                           tt-titulo.tt-cod-estabel + ";" +
                                           tt-titulo.tt-cod-esp     + ";" +
                                           tt-titulo.tt-serie       + ";" +
                                           tt-titulo.tt-nr-docto    + ";" +
                                           tt-titulo.tt-parcela.
        assign l-houve-erro = yes.                                           
    end.

    if  tt-titulo.tt-ind-tp-alter  = 0 
    or (tt-titulo.tt-ind-tp-alter <> 1 and
        tt-titulo.tt-ind-tp-alter <> 2 and
        tt-titulo.tt-ind-tp-alter <> 3 and
        tt-titulo.tt-ind-tp-alter <> 4) then do:
        run utp/ut-msgs.p (input "help",
                           input 25524,
                           input "").
        create tt-retorna-erro.
        assign tt-retorna-erro.cod-erro  = 25524
               tt-retorna-erro.desc-erro = trim(return-value)
               tt-retorna-erro.l-erro    = yes
               tt-retorna-erro.cod-chave = string(tt-titulo.tt-ep-codigo)  + ";" +
                                           string(tt-titulo.tt-cod-fornec) + ";" +
                                           tt-titulo.tt-cod-estabel + ";" +
                                           tt-titulo.tt-cod-esp     + ";" +
                                           tt-titulo.tt-serie       + ";" +
                                           tt-titulo.tt-nr-docto    + ";" +
                                           tt-titulo.tt-parcela.
        assign l-houve-erro = yes.                                           
    end. 


/*  Fim Include  */
