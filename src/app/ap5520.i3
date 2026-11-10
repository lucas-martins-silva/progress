/******************************************************************************
**
**     Programa: AP5520.I3
**
*******************************************************************************/

/*   Titulos com Instrucao Bancaria   */

    find tit-ap
        where tit-ap.ep-codigo   = w-ep-codigo
        and   tit-ap.cod-fornec  = w-fornecedor
        and   tit-ap.cod-estabel = w-cod-estabel
        and   tit-ap.cod-esp     = w-cod-esp
        and   tit-ap.serie       = w-serie
        and   tit-ap.nr-docto    = w-nr-docto
        and   tit-ap.parcela     = w-parcela    no-lock no-error.

    find emitente
         where emitente.cod-emitente = tit-ap.cod-fornec
         and   emitente.identific <> 1 no-lock no-error.
    if  not available emitente then next.

    /**** FORMATO DO CPF/CNPJ ***/
    {app/ap5520.i12}

    assign i-cod-banco = emitente.cod-banco.

    find banco where banco.cod-banco = i-cod-banco no-lock no-error.
    find agencia
        where agencia.cod-banco   = i-cod-banco
        and   agencia.agencia = emitente.agencia no-lock no-error.

    if  bord-rec.inf-banc then do:
        if bord-rec.hist-prev then do:                
                disp tit-ap.cod-estabel
                     tit-ap.cod-esp
                     tit-ap.serie
                     tit-ap.nr-docto
                     tit-ap.parcela
                     tit-ap.dt-emissao
                     tit-ap.dt-vencimen   
                     c-nome-agencia
                     emitente.agencia         format "999999-x"
                     emitente.nome-emit
                     banco.nome-banco when avail banco
                     agencia.endereco when avail agencia
                     emitente.conta-corren     format "9999999999-xx"
                     emitente.cidade
                     with frame f-bordero2.

                disp tit-ap.valor-saldo
                     tit-ap.vl-juros-dia @ tit-ap.jur-dia-fasb
                     tit-ap.vl-desconto  @ tit-ap.vl-desc-fasb
                     tit-ap.vl-var-monet
                     &if defined(BF_FIN_MULTA_ABATIMENTO) &then
                     mov-ap.vl-multa      @ mov-ap.vl-multa-fasb
                     mov-ap.vl-abatimento @ mov-ap.vl-abatimento-fasb
                     &endif
                     c-cgc-fornec
                     with frame f-bordero2.

                find first mov-ap
                     where mov-ap.ep-codigo  = tit-ap.ep-codigo
                       and mov-ap.cod-fornec = tit-ap.cod-fornec
                       and mov-ap.cod-estab  = tit-ap.cod-estab
                       and mov-ap.cod-esp    = tit-ap.cod-esp
                       and mov-ap.serie      = tit-ap.serie
                       and mov-ap.nr-docto   = tit-ap.nr-docto
                       and mov-ap.parcela    = tit-ap.parcela
                       and mov-ap.transacao  = 1 no-lock no-error.

                if avail mov-ap then
                        disp mov-ap.historico with frame f-bordero2.
        end.
        else do:
                disp tit-ap.cod-estabel
                     tit-ap.cod-esp
                     tit-ap.serie
                     tit-ap.nr-docto
                     tit-ap.parcela
                     tit-ap.dt-emissao
                     tit-ap.dt-vencimen   
                     c-nome-agencia
                     emitente.agencia         format "999999-x"
                     emitente.nome-emit
                     banco.nome-banco when avail banco
                     agencia.endereco when avail agencia
                     emitente.conta-corren     format "9999999999-xx"
                     emitente.cidade
                     with frame f-bordero2-sem-historico.
                disp tit-ap.valor-saldo
                     tit-ap.vl-juros-dia @ tit-ap.jur-dia-fasb
                     tit-ap.vl-desconto  @ tit-ap.vl-desc-fasb
                     tit-ap.vl-var-monet
                     &if defined(BF_FIN_MULTA_ABATIMENTO) &then
                     mov-ap.vl-multa      @ mov-ap.vl-multa-fasb
                     mov-ap.vl-abatimento @ mov-ap.vl-abatimento-fasb
                     &endif
                     c-cgc-fornec
                     with frame f-bordero2-sem-historico.
        end.            
    end.
    else do:
        if bord-rec.hist-prev then do:        
                disp tit-ap.cod-estabel
                     tit-ap.cod-esp
                     tit-ap.serie
                     tit-ap.nr-docto
                     tit-ap.parcela
                     tit-ap.dt-emissao
                     tit-ap.dt-vencimen
                     emitente.nome-emit
                     with frame f-bordero4.
                disp tit-ap.valor-saldo
                     tit-ap.vl-juros-dia @ tit-ap.jur-dia-fasb
                     tit-ap.vl-desconto  @ tit-ap.vl-desc-fasb
                     tit-ap.vl-var-monet 
                     &if defined(BF_FIN_MULTA_ABATIMENTO) &then
                     mov-ap.vl-multa      @ mov-ap.vl-multa-fasb
                     mov-ap.vl-abatimento @ mov-ap.vl-abatimento-fasb
                     &endif
                     c-cgc-fornec
                     with frame f-bordero4.

                find first mov-ap
                     where mov-ap.ep-codigo  = tit-ap.ep-codigo
                       and mov-ap.cod-fornec = tit-ap.cod-fornec
                       and mov-ap.cod-estab  = tit-ap.cod-estab
                       and mov-ap.cod-esp    = tit-ap.cod-esp
                       and mov-ap.serie      = tit-ap.serie
                       and mov-ap.nr-docto   = tit-ap.nr-docto
                       and mov-ap.parcela    = tit-ap.parcela
                       and mov-ap.transacao  = 1 no-lock no-error.

                if avail mov-ap then
                        disp mov-ap.historico with frame f-bordero4.
        end.
        else do:
                disp tit-ap.cod-estabel
                     tit-ap.cod-esp
                     tit-ap.serie
                     tit-ap.nr-docto
                     tit-ap.parcela
                     tit-ap.dt-emissao
                     tit-ap.dt-vencimen
                     emitente.nome-emit
                     with frame f-bordero4-sem-historico.
                disp tit-ap.valor-saldo
                     tit-ap.vl-juros-dia @ tit-ap.jur-dia-fasb
                     tit-ap.vl-desconto  @ tit-ap.vl-desc-fasb
                     tit-ap.vl-var-monet 
                     &if defined(BF_FIN_MULTA_ABATIMENTO) &then
                     mov-ap.vl-multa      @ mov-ap.vl-multa-fasb
                     mov-ap.vl-abatimento @ mov-ap.vl-abatimento-fasb
                     &endif
                     c-cgc-fornec
                     with frame f-bordero4-sem-historico.
        end.            
    end.

    assign c-instrucao = "Instrucao: " + tit-ap.inst-banc
           de-liquido  = tit-ap.valor-saldo
                       + tit-ap.jur-dia-fasb
                       - tit-ap.vl-desc-fasb
                       &if defined(BF_FIN_MULTA_ABATIMENTO) &then
                       + mov-ap.vl-multa-fasb
                       - mov-ap.vl-abatimento-fasb
                       &endif
                       + tit-ap.vl-var-monet.

    if  bord-rec.inf-banc = yes then do:
        if bord-rec.hist-prev then do:
                disp c-instrucao
                     de-liquido format "->>>,>>>,>>>,>>9.99"
                     with frame f-bordero2.
                down 1 with frame f-bordero2.                     
        end.
        else do:
                disp c-instrucao
                     de-liquido format "->>>,>>>,>>>,>>9.99"
                     with frame f-bordero2-sem-historico.
                down 1 with frame f-bordero2-sem-historico.
        end.        
    end.
    else do:
        if bord-rec.hist-prev then do:
                disp c-instrucao
                     de-liquido format "->>>,>>>,>>>,>>9.99"
                     with frame f-bordero4.
                down 1 with frame f-bordero4.
        end.
        else do:
                disp c-instrucao
                     de-liquido format "->>>,>>>,>>>,>>9.99"
                     with frame f-bordero4-sem-historico.
                down 1 with frame f-bordero4-sem-historico.
        end.
    end.

    if  bord-rec.pula-linha = yes then
        put " " skip.

    assign de-total-geral = de-total-geral + tit-ap.valor-saldo
           de-total-juros = de-total-juros + tit-ap.jur-dia-fasb
           de-total-desc  = de-total-desc + tit-ap.vl-desc-fasb
           &if defined(BF_FIN_MULTA_ABATIMENTO) &then
           de-total-multa = de-total-multa + mov-ap.vl-multa-fasb
           de-total-abat  = de-total-abat  + mov-ap.vl-abatimento-fasb
           de-tot-multa   = de-tot-multa   + mov-ap.vl-multa-fasb
           de-tot-abat    = de-tot-abat    + mov-ap.vl-abatimento-fasb
           &endif
           de-total-liq   = de-total-liq + de-liquido 
           de-total-tit   = de-total-tit + 1
           de-tot-ger     = de-tot-ger + tit-ap.valor-saldo
           de-tot-jur     = de-tot-jur + tit-ap.jur-dia-fasb
           de-tot-desc    = de-tot-desc + tit-ap.vl-desc-fasb
           de-tot-liq     = de-tot-liq + de-liquido
           de-tot-tit     = de-tot-tit + 1.

    /* Este IF e usado na classificacao 2  */
    if  bord-rec.quebra-dt-venc = yes then do:
        if (bord-rec.pula-linha = yes and line-counter > (PAGE-SIZE - 4)) /*56*/
        or  line-counter > PAGE-SIZE
            {1} then do:  /* {1} = or last-of(w-dt-vencimen) */

            assign c-total-geral = "TOTAL DE TITULOS..:"
                           + string(de-tot-tit,">>>>9")
                           + "      TOTAL DA PAGINA...:"
                           + string(de-tot-ger,">>>,>>>,>>>,>>>,>>9.99") + "  "
                           + string(de-tot-jur,">>>,>>>,>>9.99") + " "
                           + string(de-tot-desc, ">>>,>>>,>>>,>>9.99") + "        "
                           + string(de-tot-liq,  "->>>,>>>,>>>,>>9.99").
            disp c-total-geral
                 &if defined(BF_FIN_MULTA_ABATIMENTO) &then
                 de-tot-multa @ de-total-multa
                 de-tot-abat  @ de-total-abat
                 &endif
                 with frame f-total.
            view frame f-pagina.  
            {2} do:        /*  {2} = if  not last-of(w-dt-vencimen) then   */
                page.
                assign c-total-geral = ""
                       de-tot-tit    = 0
                       de-tot-jur    = 0
                       de-tot-desc   = 0
                       &if defined(BF_FIN_MULTA_ABATIMENTO) &then
                       de-tot-multa  = 0
                       de-tot-abat   = 0
                       &endif
                       de-tot-liq    = 0
                       de-tot-ger    = 0.
            end.
        end.
    end.
    else do:
         /*  Este IF e usado nas demais classificacoes  */
        if (bord-rec.pula-linha = yes and line-counter > (PAGE-SIZE - 4)) /*56*/
        or  line-counter > PAGE-SIZE then do:
            assign c-total-geral = "TOTAL DE TITULOS..:"
                    + string(de-tot-tit,">>>>9") + "      TOTAL DA PAGINA...:"
                    + string(de-tot-ger,">>>,>>>,>>>,>>>,>>9.99") + "  "
                    + string(de-tot-jur,">>>,>>>,>>9.99") + " "
                    + string(de-tot-desc, ">>>,>>>,>>>,>>9.99") + "        "
                    + string(de-tot-liq,  "->>>,>>>,>>>,>>9.99").
            disp c-total-geral
                 &if defined(BF_FIN_MULTA_ABATIMENTO) &then
                 de-tot-multa @ de-total-multa
                 de-tot-abat  @ de-total-abat
                 &endif
                 with frame f-total.

            view frame f-pagina.
            page.

            assign c-total-geral = ""
                   de-tot-tit    = 0
                   de-tot-jur    = 0
                   de-tot-desc   = 0
                   &if defined(BF_FIN_MULTA_ABATIMENTO) &then
                   de-tot-multa  = 0
                   de-tot-abat   = 0
                   &endif
                   de-tot-liq    = 0
                   de-tot-ger    = 0.
        end.
    end.

/* fim do include ap5520.i3*/
