/*******************************************************************************
**
**  Include.: AP0598.I
**  Objetivo: Complemento Emiss∆o de Cheques - Internacional
**
*******************************************************************************/

find emitente
    where emitente.cod-emitente = che-emit.cod-fornec
    and   emitente.identific <> 1 no-lock no-error.

if  tt-param.l-reemissao = yes then do:
    create b-che-emit.
    assign b-che-emit.ep-codigo     = che-emit.ep-codigo
           b-che-emit.portador      = che-emit.portador
           b-che-emit.nr-cheque     = che-emit.nr-cheque
           b-che-emit.cod-estabel   = che-emit.cod-estabel
           b-che-emit.cod-fornec    = che-emit.cod-fornec
           b-che-emit.cod-esp       = che-emit.cod-esp
           b-che-emit.serie         = che-emit.serie
           b-che-emit.nr-docto      = che-emit.nr-docto
           b-che-emit.parcela       = che-emit.parcela
           b-che-emit.dt-emissao    = che-emit.dt-emissao
           b-che-emit.dt-vencto     = che-emit.dt-vencto
           b-che-emit.transacao     = che-emit.transacao
           b-che-emit.referencia    = che-emit.referencia
           b-che-emit.nominal       = che-emit.nominal
           b-che-emit.literal       = che-emit.literal
           b-che-emit.valor-docto   = che-emit.valor-docto
           b-che-emit.ct-conta      = che-emit.ct-conta
           b-che-emit.sc-conta      = che-emit.sc-conta
           b-che-emit.conta-debito  = che-emit.conta-debito
           b-che-emit.historico     = che-emit.historico
           b-che-emit.nr-talonario  = che-emit.nr-talonario
           b-che-emit.emitiu        = yes
           b-che-emit.cancelado     = yes.

    if  param-global.modulo-cb = yes then do: /* Caixa e Bancos implantado */
        find first cheque exclusive-lock
            where cheque.cod-banco    = portador.cod-banco
            and   cheque.agencia      = portador.agencia
            and   cheque.conta-corren = portador.conta-corren
            and   cheque.nr-cheque    = che-emit.nr-cheque no-error.
        if  avail cheque then do:
            assign cheque.vl-cheque = cheque.vl-cheque - che-emit.valor-docto.
            if  cheque.vl-cheque <= 0 then
                delete cheque.
        end.
    end.
end.

assign mov-ap.nr-cheque      = talonario.prox-cheque
       mov-ap.nr-docto-emp   = trim(string(talonario.prox-cheque))
       de-valor              = de-valor + che-emit.valor-docto
       che-emit.nr-cheque    = talonario.prox-cheque
       che-emit.nr-talonario = talonario.nr-talonario
       che-emit.emitiu       = yes.

if  last-of(che-emit.cod-fornec) or last-of(che-emit.literal) then do:
    assign c-nome = if  che-emit.nominal = 2
                    and avail emitente then emitente.nome-emit
                    else if  che-emit.nominal = 1 then portador.nome
                         else che-emit.literal.

    assign c-valor[1] = c-numero[int(substr(string(de-valor,'999999999.99'),1,3)) + 1]
           c-valor[2] = c-numero[int(substr(string(de-valor,'999999999.99'),4,1)) + 1]
           c-valor[3] = c-numero[int(substr(string(de-valor,'999999999.99'),5,1)) + 1]
           c-valor[4] = c-numero[int(substr(string(de-valor,'999999999.99'),6,1)) + 1]
           c-valor[5] = c-numero[int(substr(string(de-valor,'999999999.99'),7,1)) + 1]
           c-valor[6] = c-numero[int(substr(string(de-valor,'999999999.99'),8,1)) + 1]
           c-valor[7] = c-numero[int(substr(string(de-valor,'999999999.99'),9,1)) + 1].

    {utp/ut-liter.i Data * R}

    /** c-valor[1] n∆o Ç necess†rio **/
    put skip(3)
        trim(return-value) format "x(06)" at 40
        c-data                at 46
        c-nome format "x(33)" at 12 skip(3)
        c-valor[2]            at 05
        c-valor[3]            at 12
        c-valor[4]            at 19
        c-valor[5]            at 26
        c-valor[6]            at 33
        c-valor[7]            at 40
        substr(string(de-valor,'999999999.99'),11,2) format '99' at 47
        de-valor              at 50
        skip(6).

    if  tt-param.l-copia = yes then do:
        put stream s-copia
            skip(3)
            trim(return-value) format "x(06)" at 40
            c-data                at 46
            c-nome format "x(33)" at 12 skip(3)
            c-valor[2]            at 05
            c-valor[3]            at 12
            c-valor[4]            at 19
            c-valor[5]            at 26
            c-valor[6]            at 33
            c-valor[7]            at 40
            substr(string(de-valor,'999999999.99'),11,2) format '99' at 47
            de-valor              at 50
            skip(6).

        assign i-nr-copia = talonario.prox-copia no-error.
        if  error-status:error = no then
            assign talonario.prox-copia = i-nr-copia + 1.
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
        end.

        assign cheque.ep-codigo-mvto  = che-emit.ep-codigo
               cheque.cod-emitente    = che-emit.cod-fornec
               cheque.cod-portador    = che-emit.portador
               cheque.dt-vencimento   = che-emit.dt-vencto
               cheque.dt-emissao      = che-emit.dt-emissao
               cheque.tp-codigo       = mov-ap.tp-codigo
               cheque.vl-cheque       = cheque.vl-cheque + de-valor
               cheque.tipo-cheque     = 1  /* Pr¢prio */
               cheque.situacao-cheque = 1  /* Pendente */
               cheque.origem-cheque   = 5. /* AP */
    end.

    assign de-valor = 0
           talonario.ult-cheque = talonario.prox-cheque.

    if  talonario.ult-cheque = talonario.nr-cheque-fin then do:
        assign talonario.situacao = 3. /* Utilizado */
        leave code-block.
    end.
    else do:
        assign i-nr-cheque = talonario.prox-cheque no-error.
        if  error-status:error = no then
            assign talonario.prox-cheque = i-nr-cheque + 1.
    end.
end.

/* AP0598.I */
